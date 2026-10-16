@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help : GSTR1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsh_gstr1 as select distinct from zcds_gstr1_ddl2
{
  key AccountingDocument as acdoc,  
  key CompanyCode as ccode,
  key FiscalYear as fyear,
  TaxNumber3,
  Customer,
  CustomerName,
//  Region,
  region_code,
  PostingDate,
  DocumentDate,
  Plant,
  DocumentReferenceID     
}
where TOT_TAX is not null

