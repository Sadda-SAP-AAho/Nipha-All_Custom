@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry for Purchase register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Y_JOURNALENTRY_N as select from I_OperationalAcctgDocItem as a
{
    a.AccountingDocument,
    a.CompanyCode,
    a.FiscalYear,
    case when a.UnadjustedDebitCreditCode = 'H' then 
     cast('Invoice' as abap.char( 16 ))
     else
     cast('Invoice Reversal ' as abap.char( 16 ))
     end as inv_type,
     a.UnadjustedDebitCreditCode
     
      
}
where a.FinancialAccountType = 'K'
group by 
a.AccountingDocument,
a.CompanyCode,
a.FiscalYear,
a.UnadjustedDebitCreditCode
