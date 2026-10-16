@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for ACT Value Total'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Ztot_actvalue 
with parameters
     P_StartDate : vdm_v_start_date ,
     P_EndDate   : vdm_v_end_date                                                                            
  as select distinct from zcostrpt_ddl21( P_StartDate:$parameters.P_StartDate , P_EndDate: $parameters.P_EndDate )  as a                                    

{
  a.GLAccount,
  a.FiscalYear,
  a.FiscalPeriod,
//  a.MO_POSTINGDATE,
  a.ActCat,
  a.ActType,
  a.OpWorkQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
//  sum(cast(a.act as abap.dec(23,3))) as act
   sum(a.act) as act
  
}
where a.MO_POSTINGDATE >= $parameters.P_StartDate
and a.MO_POSTINGDATE <= $parameters.P_EndDate
//and FiscalPeriod = $parameters.period
group by
a.ActCat,
a.ActType,
//a.WorkCenterInternalID,
a.OpWorkQuantityUnit,
//    a.MO_POSTINGDATE,
    a.GLAccount,
    a.FiscalYear,
    a.FiscalPeriod
