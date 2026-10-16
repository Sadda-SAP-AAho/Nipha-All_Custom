@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help : GSTR2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsh_gstr2 as select distinct from zcds_gstr2_ddl3
{
  key AccountingDocument as acdoc,  
  key CompanyCode as ccode,
  key FiscalYear as fyear,
  Supplier   
}
//where TOT_TAX is not null
