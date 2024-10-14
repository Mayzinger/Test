SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
--КРЕДИТ
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521

--Карточные операции ТС
--Операции ТС
SELECT DISTINCT                                                    
'ТС Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
--ТС ДЕБЕТ
UNION 
SELECT DISTINCT                                                    
'ТС Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'
UNION 
SELECT DISTINCT                                                    
'ТС Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
AND NTTRTY = 'TC'



SELECT * FROM QSYS2.SYSTABLES S WHERE S.TABLE_NAME = 'NBAPF'



--СБП
--1 тип Отбор платежей по приходу
SELECT                                                     
'СБП по приходу'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAD IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdalluni_nbapf_eod AS NBAPF --отбор платежей по приходу//ZJBPPF .JBPAD= NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день
                   WHERE NBAPF.NCAAN IN (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47423','SBP_47422')))
AND SUBSTRING(JBPAC,1,5)<>'30301'  
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по приходу'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAD IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_sbl_nbapf_eod AS NBAPF --отбор платежей по приходу//ZJBPPF .JBPAD= NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день
                   WHERE NBAPF.NCAAN IN (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47423','SBP_47422')))
AND SUBSTRING(JBPAC,1,5)<>'30301'  
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по приходу'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAD IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_cnl_nbapf_eod AS NBAPF --отбор платежей по приходу//ZJBPPF .JBPAD= NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день
                   WHERE NBAPF.NCAAN IN (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47423','SBP_47422')))
AND SUBSTRING(JBPAC,1,5)<>'30301'  
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по приходу'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAD IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_dtl_nbapf_eod AS NBAPF --отбор платежей по приходу//ZJBPPF .JBPAD= NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день
                   WHERE NBAPF.NCAAN IN (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47423','SBP_47422')))
AND SUBSTRING(JBPAC,1,5)<>'30301'  
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по приходу'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAD IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_zsl_nbapf_eod AS NBAPF --отбор платежей по приходу//ZJBPPF .JBPAD= NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день
                   WHERE NBAPF.NCAAN IN (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47423','SBP_47422')))
AND SUBSTRING(JBPAC,1,5)<>'30301'  
AND JBPDU = 1240521
--2 тип Отбор платежей по списанию
--------------
--------------
UNION 
SELECT                                                     
'СБП по спианию'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN`ID клиента плательщика в КО` --D_NEFP.NEAN
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAC IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdalluni_nbapf_eod AS NBAPF --отбор платежей по списанию //ZJBPPF.JBPAC = NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день. 
                   WHERE NBAPF.NCAAN = (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47422')))
AND JBPDU = 1240521
AND SUBSTRING(JBPAD,1,5) <>'30302'
UNION 
SELECT                                                     
'СБП по спианию'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN`ID клиента плательщика в КО` --D_NEFP.NEAN
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAC IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_sbl_nbapf_eod AS NBAPF --отбор платежей по списанию //ZJBPPF.JBPAC = NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день. 
                   WHERE NBAPF.NCAAN = (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47422')))
AND JBPDU = 1240521
AND SUBSTRING(JBPAD,1,5) <>'30302'
UNION 
SELECT                                                     
'СБП по спианию'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN`ID клиента плательщика в КО` --D_NEFP.NEAN
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAC IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_cnl_nbapf_eod AS NBAPF --отбор платежей по списанию //ZJBPPF.JBPAC = NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день. 
                   WHERE NBAPF.NCAAN = (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47422')))
AND JBPDU = 1240521
AND SUBSTRING(JBPAD,1,5) <>'30302'
UNION 
SELECT                                                     
'СБП по спианию'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN`ID клиента плательщика в КО` --D_NEFP.NEAN
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAC IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_dtl_nbapf_eod AS NBAPF --отбор платежей по списанию //ZJBPPF.JBPAC = NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день. 
                   WHERE NBAPF.NCAAN = (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47422')))
AND JBPDU = 1240521
AND SUBSTRING(JBPAD,1,5) <>'30302'
UNION 
SELECT                                                     
'СБП по спианию'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN`ID клиента плательщика в КО` --D_NEFP.NEAN
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND JBPAC IN (SELECT NBAPF.NCASYN FROM hist_bis_etl.sdal_zsl_nbapf_eod AS NBAPF --отбор платежей по списанию //ZJBPPF.JBPAC = NBAPF.NCASYN  и JBPDU=<бизнес дата > - 1 день. 
                   WHERE NBAPF.NCAAN = (SELECT SPAC.PATEXT FROM hist_bis_stl_etl.sdat_spac AS SPAC WHERE PAKEY IN('SBP_47422')))
AND JBPDU = 1240521
AND SUBSTRING(JBPAD,1,5) <>'30302'
UNION 
--3 тип внутри
---------------
------------
SELECT                                                     
'СБП по внутри'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,DJAF `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`--DJAF --JBPAD
,DJAT `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`--DJAT --JBPAC
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN  AS `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN  AS `ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND SUBSTRING( JBPAD, 1, 5 ) NOT IN ( '47423', '47422' )
AND SUBSTRING( JBPAC, 1, 5 ) NOT IN ( '47423', '47422' )
AND DJINPS = 'b'      --новое условие
AND DJBAC = JBPFIL   --новое условие
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по внутри'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,DJAF `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`--DJAF --JBPAD
,DJAT `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`--DJAT --JBPAC
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN  AS `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN  AS `ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND SUBSTRING( JBPAD, 1, 5 ) NOT IN ( '47423', '47422' )
AND SUBSTRING( JBPAC, 1, 5 ) NOT IN ( '47423', '47422' )
AND DJINPS = 'b'      --новое условие
AND DJBAC = JBPFIL   --новое условие
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по внутри'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,DJAF `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`--DJAF --JBPAD
,DJAT `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`--DJAT --JBPAC
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN  AS `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN  AS `ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND SUBSTRING( JBPAD, 1, 5 ) NOT IN ( '47423', '47422' )
AND SUBSTRING( JBPAC, 1, 5 ) NOT IN ( '47423', '47422' )
AND DJINPS = 'b'      --новое условие
AND DJBAC = JBPFIL   --новое условие
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по внутри'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,DJAF `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`--DJAF --JBPAD
,DJAT `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`--DJAT --JBPAC
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN  AS `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN  AS `ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND SUBSTRING( JBPAD, 1, 5 ) NOT IN ( '47423', '47422' )
AND SUBSTRING( JBPAC, 1, 5 ) NOT IN ( '47423', '47422' )
AND DJINPS = 'b'      --новое условие
AND DJBAC = JBPFIL   --новое условие
AND JBPDU = 1240521
UNION 
SELECT                                                     
'СБП по внутри'
,NTTRTY AS `инф.поле`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN 'Перевод СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN 'Выплата СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN 'Покупка СБП'     
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN 'Возврат пок'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN 'Отмена возв'     
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN 'Отмена выпл'    
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN 'B2B СБП' 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN 'Отмена B2B '    
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN 'Отмена кешбэка по СБП'    
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN 'Выплата кешбэка СБП'
ELSE ' '
END AS `Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END  AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN  END AS `Наименование / ФИО получателя`--DJNMT
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`--DJINN
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,DJAF `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`--DJAF --JBPAD
,DJAT `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`--DJAT --JBPAC
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN  AS `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN  AS `ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 1=1
AND SUBSTRING( JBPAD, 1, 5 ) NOT IN ( '47423', '47422' )
AND SUBSTRING( JBPAC, 1, 5 ) NOT IN ( '47423', '47422' )
AND DJINPS = 'b'      --новое условие
AND DJBAC = JBPFIL   --новое условие
AND JBPDU = 1240521


--Все остальные операции
----------
----------
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION ALL
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION ALL
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION ALL
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION ALL 
SELECT  DISTINCT                                                
'Дебет'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
--,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
--,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN END AS  `ИНН плательщика`
,CASE WHEN DJNMT  IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN  IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,C_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
--,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО получателя`
--,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,D_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,D_NEFP.NEAN `ID клиента плательщика в КО`
,'' `ID клиента получателя в КО` --C_NEFP.NEAN
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAD, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAC, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521


--КРЕДИТ
UNION 

SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdalluni_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatstl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilstl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilstl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdalluni_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilstl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdalluni_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_zsl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatzsl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilzsl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilzsl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_zsl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilzsl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_zsl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_sbl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatsbl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilsbl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilsbl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_sbl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilsbl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_sbl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_cnl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatchl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfilcnl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfilcnl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_cnl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfilcnl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_cnl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
UNION 
SELECT DISTINCT                                                    
'Кредит'
,NTTRTY AS `инф.поле`
,SUBSTRING(NTTDAT,6,2)||SUBSTRING(NTTDAT,4,2)||'20'||SUBSTRING(NTTDAT,2,2)||' '||NTTTIM AS `Дата и время транзакции`
,'Проведена' `Статус транзакции`
,'' `Номер транзакции плательщика`
,CASE 
WHEN NTRREF IS NOT NULL THEN NTRREF 
ELSE JBPREF END `RRN транзакции`
,'' `ARN транзакции`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Перевод СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Выплата СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 109, 32)      
WHEN SUBSTRING(DJNR1,1,11)='Возврат пок' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 143, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена возв'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 138, 32)      
WHEN SUBSTRING(DJNR1,1,11) ='Отмена выпл' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 105, 32)      
WHEN SUBSTRING(DJNR1,1,7) ='B2B СБП' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,11) ='Отмена B2B ' THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 16, 32) 
WHEN SUBSTRING(DJNR1,1,21) ='Отмена кешбэка по СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32) 
WHEN SUBSTRING(DJNR1,1,19) ='Выплата кешбэка СБП'THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 163,32)
ELSE SUBSTR(DJNR1, 109, 32)
END AS `ID операции СБП`
,'' `Номер транзакции получателя`
,NTSTAN `Внутренний идентификатор операции (ID)`
,NTCAID `ID Мерчанта / ТСП`
,NTCATA `Наименование Мерчанта / ТСП`
,'' `ИНН Мерчанта / ТСП`
,NTCATI `ID терминала`
,'' `Тип терминала`
,CASE WHEN NTTRN_ IS NOT NULL THEN NTTRN_ ELSE JBPSR END AS `Сумма операции в копейках` --NTTRN_
,CASE WHEN NTTCCY IS NOT NULL THEN NTTCCY ELSE JBPCCY  END  AS `Код валюты операции`
,JBPSR AS `Сумма операции в руб. эквиваленте`
,SUBSTRING(NTCATA,39,2)`Тип перевода`
,'' `Наименование платежного посредника / партнера-плательщика`
,'' `ИНН / КИО  платежного посредника / партнера-плательщика`
--CASE WHEN NTDBCR = 'D' THEN DJNMF
,CASE WHEN DJNMT IS NOT NULL THEN DJNMT ELSE D_GFPF.GFCUN END AS `Наименование / ФИО плательщика`
,CASE WHEN DJINN IS NOT NULL THEN DJINN ELSE D_ANKETA.CUINN END AS  `ИНН плательщика`
,'' `Адрес Web-сайта плательщика`
,D_GFPF.GFCNAL  `Код страны плательщика`
,SUBSTRING(C_SCPF.SCCTP,1,1) `Тип плательщика`
,CASE 
WHEN SUBSTRING(NTCRD_,1,1) = '4' THEN 'Visa'
WHEN SUBSTRING(NTCRD_,1,1) = '5' THEN 'Mastercard'
WHEN SUBSTRING(NTCRD_,1,1) = '2' THEN 'МИР'
ELSE '' END 
AS  `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора плательщика`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,'' `Наименование платежного посредника / партнера-получателя`
,'' `ИНН / КИО  платежного посредника / партнера-получателя`
,CASE WHEN DJNMF IS NOT NULL THEN DJNMF ELSE C_GFPF.GFCUN  END AS `Наименование / ФИО получателя`
,CASE WHEN DJPIN IS NOT NULL THEN DJPIN ELSE C_ANKETA.CUINN  END AS  `ИНН получателя`
,'' `Адрес Web-сайта получателя`
,C_GFPF.GFCNAL `Код страны получателя`
,SUBSTRING(D_SCPF.SCCTP,1,1)`Тип получателя`
,NTMCAT`MCC-код`
,''AS `Платежная система / мобильный оператор`
,CASE 
WHEN NTCRD_ IS NOT NULL THEN 'Карта'
WHEN DJINPS = 'b' THEN 'Номер телефона'
ELSE 'Счёт' END AS `Тип идентификатора получателя`
,CASE 
WHEN SUBSTRING(DJNR1,1,11)='Покупка СБП' AND NTCRD_ IS NULL THEN SUBSTRING(DJNR1||DJNR2||DJNR3, 162, 32)      
ELSE NTCRD_
END AS `Номер карты (PAN) / номер счета / номер эл. кошелька / номер мобильного телефона`
,'' `Эмитент`
,CASE WHEN (DJNR1||DJNR2||DJNR3) IS NOT NULL THEN DJNR1||DJNR2||DJNR3 ELSE JBPNR1||JBPNR2||JBPNR3 END AS `Комментарий к платежу`
,SUBSTRING(JBPDU,6,2)||SUBSTRING(JBPDU,4,2)||'20'||SUBSTRING(JBPDU,2,2) `Дата включения операции в баланс Банка`
,'' `Поле UKEY/O_ID из УОИ`
,JBPAD `Поле DT_ACCOUNT/DB_A из УОИ (номер лицевого счета плательщика в КО)`
,JBPAC `Поле KT_ACCOUNT/CR_A из УОИ (номер лицевого счета получателя в КО)`
,'' `Номер аналитического счета плательщика, в том числе по учету ЭДС и незавершенных расчетов`
,'' `Номер аналитического счета получателя, в том числе по учету ЭДС и незавершенных расчетов`
,'' `ID клиента плательщика в КО` --D_NEFP.NEAN
,C_NEFP.NEAN`ID клиента получателя в КО` --
,'' `Аббревиатура товара`
FROM hist_bis_etl.sdal_dtl_zjbppf_eod AS ZJBPPF 
LEFT JOIN hist_bis_etl.sdatdtl_zjbpdoc_eod AS ZJBPDOC ON ZJBPPF.JBPDU= ZJBPDOC.DJDU and ZJBPPF.JBPNUM= ZJBPDOC.DJNUM and ZJBPPF.JBPFIL= ZJBPDOC.DJFIL 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS D_NEFP ON D_NEFP.NEEAN = JBPAD-- 
LEFT JOIN hist_bis_etl.kfildtl_nepf AS C_NEFP ON C_NEFP.NEEAN = JBPAC--
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS D_GFPF ON D_NEFP.NEAN = D_GFPF.GFCUS
LEFT JOIN hist_bis_etl.kfildtl_gfpf_eod AS C_GFPF ON C_NEFP.NEAN = C_GFPF.GFCUS
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS D_ANKETA ON D_NEFP.NEAN = D_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.sdal_dtl_anketa_eod AS C_ANKETA ON C_NEFP.NEAN = C_ANKETA.CUSTN
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS D_SCPF ON  C_NEFP.NEAB=D_SCPF.SCAB and C_NEFP.NEAN=D_SCPF.SCAN and C_NEFP.NEAS=D_SCPF.SCAS
LEFT JOIN hist_bis_etl.kfildtl_scpf_eod AS C_SCPF ON  C_NEFP.NEAB=C_SCPF.SCAB and C_NEFP.NEAN=C_SCPF.SCAN and C_NEFP.NEAS=C_SCPF.SCAS
LEFT JOIN hist_bis_etl.sdal_dtl_pitmnt0p_eod AS PITMNT0P ON PITMNT0P.NTPREF = JBPREF
WHERE 
SUBSTRING(ZJBPPF.JBPAC, 1, 5) in ('40817', '40820') 
and SUBSTRING (ZJBPPF.JBPAD, 1, 5) <> ('20202')                                          
and JBPPBR NOT like '%ITM%' 
AND NTTRTY NOT IN ('01','04','61','05')
AND JBPDU = 1240521
