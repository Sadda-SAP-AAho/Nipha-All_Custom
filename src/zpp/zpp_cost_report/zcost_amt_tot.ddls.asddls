@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Report Total Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcost_amt_tot 
as select from Zcost_amt
{
    GLAccount,
    FiscalYear,
    FiscalPeriod,
    PostingDate,
    CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum(AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency
}
group by
    GLAccount,
    FiscalYear,
    FiscalPeriod,
    PostingDate,
    CompanyCodeCurrency
