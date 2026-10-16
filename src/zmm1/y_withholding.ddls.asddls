@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'With Holding tax data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Y_WITHHOLDING as select from I_Withholdingtaxitem as a left outer join  zwithholdtaxdesc as b
 on b.tax_type = a.WithholdingTaxCode and b.tax_code =  a.WithholdingTaxType
{
    a.CompanyCode,
    a.AccountingDocument,
    a.FiscalYear,
    a.WithholdingTaxType,
    a.WithholdingTaxCode,
    a.WithholdingTaxPercent,
    a.DocumentCurrency,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.WhldgTaxAmtInCoCodeCrcy,
    b.type_desc
    
}
  where a.WithholdingTaxPercent > 0 and a.WhldgTaxAmtInCoCodeCrcy <> 0
  
 