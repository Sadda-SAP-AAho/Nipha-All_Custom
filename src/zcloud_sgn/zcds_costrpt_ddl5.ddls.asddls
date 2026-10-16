@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - Order wise Activity Val.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_costrpt_ddl5   as select distinct from zcds_costrpt_ddl1
{
  GLAccount,
  FiscalPeriod,
  ManufacturingOrder,
  ActType,
  OpWorkQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
  //sum(act) as act  
  act
}
//group by GLAccount,FiscalPeriod,ActType,OpWorkQuantityUnit,ManufacturingOrder
