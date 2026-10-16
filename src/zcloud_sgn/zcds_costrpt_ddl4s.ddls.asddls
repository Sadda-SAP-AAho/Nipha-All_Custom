@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - FI PP GL Bal. Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_costrpt_ddl4s  as select from zcds_costrpt_ddl4  
{
  GLAccount,
  FiscalPeriod,
  CompanyCodeCurrency,
  ActType,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  sum(AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency
}
group by GLAccount,FiscalPeriod,CompanyCodeCurrency,ActType
