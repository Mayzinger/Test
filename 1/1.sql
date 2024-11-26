select * from hist_celd_etl.dbo_trb_tran_businesspartner dttb 
left join hist_celd_etl.dbo_trb_tran_businesspartcode dttbc on dttb.businesspartnerid =dttbc.businesspartnerid 
left join hist_celd_etl.dbo_trb_tran_contract dttc on dttb.businesspartnerid =dttc.businesspartnerid 
left join hist_celd_etl.dbo_trb_tran_contractattribute dttca on dttc.contractid =dttca.contractid  
left join hist_celd_etl.dbo_trb_tran_contractrestructure dttcr on dttc.contractid =dttcr.contractid 
left join hist_celd_etl.dbo_trb_tran_creditaim dttcam on dttc.contractid=dttcam.contractid 
left join hist_celd_etl.dbo_trb_tran_contractlinkaccount dttcla on dttc.contractid =dttcla.contractid 
left join hist_celd_etl.dbo_trb_tran_currency dttcur on dttcla.currencyid =dttcur.currencyid 
left join hist_celd_etl.dbo_trb_tran_contractdebtmvmnt dttcdm on dttc.contractid =dttcdm.contractid 
left join hist_celd_etl.dbo_trb_tran_contractdebtrest dttcdr on dttc.contractid =dttcdr.contractid 
left join hist_celd_etl.dbo_trb_tran_ccoverrelation dttccr on dttc.contractid=dttccr.contractid and dttccr.reltype =64
left join hist_celd_etl.dbo_trb_tran_contractcover dttccover on dttccr.contractcoverid =dttccover.contractcoverid 
left join hist_celd_etl.dbo_trb_tran_cessionctrrelation dttccrel on dttc.contractid =dttccrel.contractid 
left join hist_celd_etl.dbo_trb_tran_contractcession dttcces on dttccrel.cessionid =dttcces.cessionid 
left join hist_celd_etl.dbo_trb_tran_contractstate dttcs on dttc.contractid =dttcs.contractid
left join hist_celd_etl.dbo_trb_tran_paymentschedule dttps on dttc.contractid =dttps.contractid 
left join hist_celd_etl.dbo_trb_tran_underwriting dttuw on dttc.contractid =dttuw.objectid 
left join hist_celd_etl.dbo_trb_tran_contractctrrelation dttcctrr on (dttc.contractid =dttcctrr.parentcontractid or dttc.contractid =dttcctrr.childcontractid)
left join hist_celd_etl.dbo_trb_tran_extraattr dttext on dttc.contractid =dttext.objectid 
