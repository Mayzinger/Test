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
    # Ваш код функции
    pass


def countdown(context, in_time=60 * 30, sleep=30):
    # Ваш код функции
    pass


def select_flag_filial(filials, project):
    # Ваш код функции
    pass


def skip_dag_run(find_dag_id, **kwargs):
    list_dag_run = DagRun.find(dag_id=find_dag_id, state=DagRunState.QUEUED)
    print(f"list_dag_run: {list_dag_run} ")
    if len(list_dag_run) > 1:
        # Пропускаем загрузку
        return 'skip_soft_fail'
    return 'run_dag_hist_celd_etl'


units = {'CNL': ['R26', 'R87'], 'DTL': ['R73'], 'SBL': ['R62'], 'STL': ['R19', 'R70'], 'ZSL': ['R24', 'R38']}

dag_id = 'odpp_load_flags_celd'
with DAG(dag_id=dag_id, **dag_params) as dag:
    dag.doc_md = """
    DAG загрузки флагов eod по филиалам из источника CELD.
    Филиалы объединены в логические юниты, по аналогии с БИС.
    После загрузки всех флагов по юниту инициируется зависимый DAG.
    """
    project = 'hist'
    with FlagUtils(project=project, dag_id=dag.dag_id, run_unlimit=True, lag=0) as flag:
        # Определяем задачи для каждого юнита
        unit_tasks = []

        for unit in units.keys():
            task_id = f'load_flags_celd_{unit}'
            task = PythonSensor(
                task_id=task_id,
                op_args=[units[unit], project],
                mode='reschedule',
                soft_fail=True,  # В случае окончания времени ошибки не будет
                timeout=60 * 60 * 1,  # Время работы 1 час
                retries=3,
                retry_exponential_backoff=True,
                python_callable=select_flag_filial
            )
            unit_tasks.append(task)

        # Зависимости задач
        flag.start_load >> unit_tasks

        # Задача, ожидающая завершения всех юнитов
        all_units_success = EmptyOperator(task_id='all_units_success', trigger_rule=TriggerRule.ALL_SUCCESS)
        unit_tasks >> all_units_success

        # Проверяем, нужно ли запускать зависимый DAG
        check = BranchPythonOperator(
            task_id='check_count_run_hist_celd_etl',
            python_callable=skip_dag_run,
            op_args=['hist_celd_etl']
        )

        skip = EmptyOperator(task_id="skip_soft_fail", trigger_rule=TriggerRule.NONE_FAILED)
        success = EmptyOperator(task_id="success", trigger_rule=TriggerRule.ONE_SUCCESS)

        # Задача запуска зависимого DAG
        hist_celd_etl = TriggerDagRunOperator(
            task_id='run_dag_hist_celd_etl',
            trigger_dag_id='hist_celd_etl',
            # pre_execute=countdown,  # Задержка старта 30 минут
            trigger_rule=TriggerRule.ALL_SUCCESS,
        )

        # Зависимости после проверки
        all_units_success >> check
        check >> hist_celd_etl
        check >> skip >> success
        hist_celd_etl >> success
        success >> flag.all_success
        flag.all_success >> flag.end

globals()[dag_id] = dag