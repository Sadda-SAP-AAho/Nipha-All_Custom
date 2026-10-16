@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - Cost Report ( Search Help )'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_costrpt_sh  as select distinct from zcds_costrpt_ddl1
{
  key GLAccount,
  key CostCenter,
  key FiscalPeriod,
  key PostingDate,
  key MO_POSTINGDATE,
  GLAccountName,
  CostCenterName
}
