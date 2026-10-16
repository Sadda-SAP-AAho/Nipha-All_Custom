@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Revesal Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCost_Reverse 
//with parameters  P_StartDate : vdm_v_start_date ,
//                 P_EndDate   : vdm_v_end_date 
as select from I_JournalEntry as a
//left outer join zcostrpt_ddl1(P_StartDate :$parameters.P_StartDate , P_EndDate : $parameters.P_EndDate ) as b on  
//                              (a.AccountingDocument <> b.AccountingDocument and a.PostingDate = b.PostingDate 
//                               and a.FiscalYear = b.FiscalYear and a.FiscalPeriod = b.FiscalPeriod )
{
    a.AccountingDocument ,
    a.PostingDate ,
    a.FiscalYear ,
    a.FiscalPeriod ,
    a.ReverseDocument,
    a.IsReversal,
    a.IsReversed

}
where a.ReverseDocument is not initial
// and b.MO_POSTINGDATE >= $parameters.P_StartDate
//and  b.MO_POSTINGDATE <= $parameters.P_EndDate
