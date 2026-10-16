@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'JOURNALENTRY PURCHASE REGISTER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Y_JOURNALENTRY as select from I_OperationalAcctgDocItem as a
{
    a.AccountingDocument,
    a.CompanyCode,
    a.FiscalYear,
    case when a.DebitCreditCode = 'H' then 
     cast('Credit Memo' as abap.char( 15 ))
     else
     cast('Invoice' as abap.char( 15 ))
     end as inv_type,
     a.DebitCreditCode
     
      
}
where a.AccountingDocumentItemType = 'W' or a.AccountingDocumentItemType = 'F'
group by 
a.AccountingDocument,
a.CompanyCode,
a.FiscalYear,
a.DebitCreditCode //." and a.AccountingDocumentType = 'RE'

 