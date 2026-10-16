@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Report ( Search Help )'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcostrpt_sh 
with parameters
     P_StartDate : vdm_v_start_date ,
     P_EndDate   : vdm_v_end_date 
//as select from zcostrpt_ddl1( P_StartDate:$parameters.P_StartDate ,
//                              P_EndDate:$parameters.P_EndDate  )
as select from ZCOSTRPT_DDL11( P_StartDate:$parameters.P_StartDate ,
                              P_EndDate:$parameters.P_EndDate  )
{
  key GLAccount,
  key CostCenter,
  key FiscalPeriod,
  key PostingDate,
  key MO_POSTINGDATE,
  GLAccountName,
  CostCenterName
  
}
