from datetime import datetime, timedelta
import time

import pandas as pd
from airflow import DAG
from airflow.models import DagRun
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import get_current_context, BranchPythonOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.microsoft.mssql.hooks.mssql import MsSqlHook
from airflow.sensors.python import PythonSensor
from airflow.utils.state import DagRunState
from airflow.utils.task_group import TaskGroup
from airflow.utils.log.logging_mixin import LoggingMixin
from airflow.utils.trigger_rule import TriggerRule

from odpp.coredev.module.flag_utils import FlagUtils
from odpp.coredev.module.flags import Flags


default_args = {
    'owner': 'rb068198',
    'depends_on_past': False,
    'email': ['Sergey.Mayzinger@rosbank.ru'],
    'email_error': True,
    'email_success': True,
    'retries': 0,
    'queue': 'odpp',
    # 'context': params,
}

dag_params = {
    'default_args': default_args,
    'start_date': datetime(2022, 2, 14),
    'schedule_interval': '*/10 21-23,0-15 * * *',
    'tags': ['odpp', 'celd', 'flags', 'hist'],
    'catchup': False,
    'max_active_runs': 1,
}


def save_flags_unit(project, business_date):
    context = get_current_context()
    flag_id = f"{project}.{context['ti'].dag_id[:-4]}_etl.eod"
    sql_select_bdate = "select max(bdate) bdate FROM flags_new.flag_log fl WHERE (FL.flag_id in (SELECT flag_id " \
                       f" FROM flags_new.flag_order_loading WHERE parent_flag_id IN ('{flag_id}') " \
                       " AND  extra ->> 'delete' = 'true'))"
    print(f'sql_select_bdate: {sql_select_bdate}')
    bdate = Flags.flag_select(sql_select_bdate).get('bdate', '1900-01-01').to_string(index=False)
    if bdate == 'None':
        bdate = '1900-01-01'
    print(f'bdate: {bdate}')
    print(f"flag: {flag_id}")
    print(f"business_date: {business_date}")

    sql_delete = f"""
    WITH del_flag_id AS
    (
      SELECT flag_id,
             bdate
      FROM flags_new.flag_log fl
        INNER JOIN (SELECT flag_id || '%' AS fl_id
                    FROM flags_new.flag_order_loading
                    WHERE parent_flag_id IN ('{flag_id}')
                    AND   extra ->> 'delete' = 'true') fol ON fl.flag_id LIKE fl_id
      WHERE fl.bdate IN ('{bdate}')
    )
    DELETE FROM flags_new.flag_log f
    WHERE (f.flag_id, f.bdate) IN (SELECT *
                                   FROM del_flag_id)
    """
    print(f"sql_delete: {sql_delete}")
    # Проверяем что предыдущий запуск завершен
    flag_id = 'hist.hist_celd_etl'
    sql = f"SELECT count(1) cnt FROM flags_new.flag_log where flag_id = '{flag_id}' and bdate='{bdate}' and flag_status in ('ERR','RUN','END')"
    cnt = Flags.flag_select(sql)['cnt'].to_string(index=False)
    print(f'cnt: {cnt}')
    if cnt in ['0', '2', '3']:
        Flags.flag_exec(sql_delete)
        Flags.set_flag(flag, 'END', business_date)
        return True
    return False


def countdown(context, in_time=60 * 30, sleep=30):
    v_time = context.get('t', in_time)
    v_sleep = context.get('sleep', sleep)
    LoggingMixin().log.info("Countdown start.")
    while v_time:
        mins, secs = divmod(v_time, 60)
        timer = f'{mins:02d}:{secs:02d}'
        LoggingMixin().log.info(timer)
        time.sleep(v_sleep)
        v_time -= v_sleep
    print('Сountdown OK')


def select_flag_filial(filials, project):
    t_sql = []
    for filial in filials:
        t_sql.append(f"""
                    WITH flag(ID, UNIT, DateTimeEnd, BranchBrief, OperDate) as (
                        select RB_ODPP_AccrualDetailID ID,
                               CASE
                                   WHEN BranchBrief IN ('R26') THEN 'CNL'
                                   WHEN BranchBrief IN ('R87') THEN 'CNL'
                                   WHEN BranchBrief IN ('R73') THEN 'DTL'
                                   WHEN BranchBrief IN ('R62') THEN 'SBL'
                                   WHEN BranchBrief IN ('R19') THEN 'STL'
                                   WHEN BranchBrief IN ('R70') THEN 'STL'
                                   WHEN BranchBrief IN ('R24') THEN 'ZSL'
                                   WHEN BranchBrief IN ('R38') THEN 'ZSL'
                                   END as              UNIT,
                               DateTimeEnd,
                               BranchBrief,
                               OperDate
                        from dbo.tRB_ODPP_AccrualDetail ad
                        WHERE --CorrectionStatus = 0 AND
                            Type = 0
                          and CorrectionDate <= (select min(adt.DateTimeStart) -- дата/время запуска обновления витрины
                                                 from dbo.tRB_ODPP_AccrualDetail adt
                                                 where adt.DateTimeStart > ad.CorrectionDate -- Дата запуска обновления витрины больше даты завершения исправлений
                                                   and adt.DateTimeEnd <> '19000101'-- Заполнена дата окончания обновления витрины
                                                   and adt.Type = 1 -- Тип записи "Обновление витрины"
                        )
                    ),
                         fl(ID, DateTimeEnd, UNIT, BranchBrief, OperDate) as
                             (
                                 select FIRST_VALUE(ID) over (PARTITION BY BranchBrief order by DateTimeEnd desc)       id,
                                        max(DateTimeEnd) over (partition by BranchBrief ),
                                        unit,
                                        BranchBrief,
                                        FIRST_VALUE(OperDate) over (PARTITION BY BranchBrief order by DateTimeEnd desc) OperDate
                                 from flag)
                    select distinct *
                    from fl where BranchBrief = '{filial}'
            """)
        print(f'{filial}, t_sql: {t_sql}')

    hook = MsSqlHook(mssql_conn_id='mssql_celd')
    #Получаем список флагов и источника
    df = [hook.get_pandas_df(sql) for sql in t_sql]

    df = pd.concat(df) if len(df) > 1 else df[0]
    # Проверяем, что все значения в поле OperDate одинаковые
    if len(df['OperDate'].unique())>1:
        #Если значения не уникальны, выводим пары BranchBrief и OperDate и выходим
        unique_pairs = df[['BranchBrief' , 'OperDate']].drop_duplicates()
        print(f'unique_pairs')
        print('Выставлены не оба флага')
        return False

    #Получаем список флагов
    context = get_current_context()
    flags = [f"{project}.{context['ti'].dag_id}.load_flags_celd_{filial.upper()}.filial_eod" for filial in filials]
    #Проверяем дату флага в источнике и в базе флагов
    for flag_id in flags:
        OperDate = str(df['OperDate'].unique()[0])[0:10]
        print(f'OperDate: {OperDate}')
        sql = f"SELECT max(bdate) bdate FROM flags_new.flag_log x WHERE x.flag_id IN ('{flag_id}')"
        print(f'sql: {sql}')
        bdate = Flags.flag_select(sql)['bdate'].to_string(index=False)
        print(f'bdate: {bdate}')
        if bdate not in 'None':
            bdate = datetime.fromisoformat(bdate)
        else:
            bdate = datetime.fromisoformat(OperDate) - timedelta(days=1)
        print(f'bdate: {bdate}')
        trunc_date_time_end = datetime.fromisoformat(OperDate).replace(hour=0, minute=0, second=0, microsecond=0)
        print(f'trunc_date_time_end: {trunc_date_time_end}')

        result = trunc_date_time_end > bdate
        print(f'result: {result}')
        if not result:
            return False

    for flag_id in flags:
        Flags.set_flag(flag_id, 'END', OperDate[0:10])
    return True


units = {'CNL': ['R26', 'R87'], 'DTL': ['R73'], 'SBL': ['R62'], 'STL': ['R19', 'R70'], 'ZSL': ['R24', 'R38']}
for unit in units.keys():
    dag_id = f'odpp_load_flags_celd_{unit}'
    with DAG(dag_id=dag_id, **dag_params) as dag:
        dag.doc_md = """
        DAG загрузки флагов eod по филиалам из источника CELD.
        Филиалы объединины в логические юниты, по аналогии с БИС. 
        После загрузки всех флагов по юниту инициируется зависимых дагов, зависимость определяется по условию:
        SELECT flag_id || '%' FROM flags_new.flag_order_loading WHERE parent_flag_id IN 
        ('hist.odpp_load_flags_celd_etl.eod') AND extra IN ('{"delete": true}')))  AND fl.bdate IN ('{business_date}')
        """
        project = 'hist'
        with FlagUtils(project=project, dag_id=dag.dag_id, run_unlimit=True, lag=0) as flag:
            def skip_dag_run(find_dag_id, **kwargs):
                list_dag_run = DagRun.find(dag_id=find_dag_id, state=DagRunState.QUEUED)
                print(f"list_dag_run: {list_dag_run} ")
                if len(list_dag_run) > 1:
                    #Пропускае загрузку
                    return 'success'
                return 'run_dag_hist_celd_etl'

            task_id = f'run_dag_hist_celd_etl'
            trigger_dag_id = 'hist_celd_etl'
            skip = EmptyOperator(task_id="skip_soft_fail", trigger_rule=TriggerRule.NONE_FAILED)

            success = EmptyOperator(task_id="success", trigger_rule=TriggerRule.ONE_SUCCESS)
            check = BranchPythonOperator(task_id='check_count_run_hist_celd_etl',
                                         python_callable=skip_dag_run, op_args=[trigger_dag_id])

            hist_celd_etl = TriggerDagRunOperator(task_id=task_id,
                                                  trigger_dag_id=trigger_dag_id,
                                                  # pre_execute=countdown,  # Задержка старта 30 минут
                                                  trigger_rule=TriggerRule.ALL_SUCCESS,

                                                  )


            task_id = f'load_flags_celd_{unit}'
            task = PythonSensor(task_id=task_id,
                                    op_args=[units[unit], project],
                                    mode='reschedule',
                                    soft_fail=True,  # В случае окончании времени ошибки не будет
                                    timeout=60 * 60 * 1,  # Время работы 1 час
                                    retries=3,
                                    retry_exponential_backoff=True,
                                    python_callable=select_flag_filial)


            flag.start_load >> task >> check >> hist_celd_etl >> flag.all_error
            task >> skip >> success
            check >> success >> flag.all_success
            hist_celd_etl >> success
            [flag.all_success,flag.all_error] >> flag.end
    globals()[dag_id] = dag

