@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - FI PP GL Bal.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_costrpt_ddl4   as select distinct from zcds_costrpt_ddl1
{
  GLAccount,
  FiscalPeriod,
  CompanyCodeCurrency,
  PostingDate,
  ActType,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  AmountInCompanyCodeCurrency 
}

