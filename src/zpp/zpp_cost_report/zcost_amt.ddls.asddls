@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Cost Report Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcost_amt 
as select from I_OperationalAcctgDocItem as a
left outer join ZCost_Reverse as b
        on a.AccountingDocument = b.AccountingDocument
{
   a.GLAccount,
   a.CostCenter,
  a.AccountingDocument,
   a.FiscalYear,
  a.FiscalPeriod,
  a.PostingDate,
    a.CompanyCodeCurrency as CompanyCodeCurrency,  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   a.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency 
}

where b.AccountingDocument is  null


