@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - Order wise Activity Val Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_costrpt_ddl5s   as select from zcds_costrpt_ddl5
{
  GLAccount,
  FiscalPeriod,
  ActType,
  //OpWorkQuantityUnit,
  //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
  sum(cast(act as abap.dec( 23, 3 ))) as act    
}
group by GLAccount,FiscalPeriod,ActType
