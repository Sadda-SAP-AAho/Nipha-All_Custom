@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION BASE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCONSUMPTION_BASE as select from I_MfgOrderForExtraction as A left outer join I_BillOfMaterialItemDEX_3 as B on
A.BillOfMaterialVariant = B.BillOfMaterialVariant and A.BillOfMaterial = B.BillOfMaterial
{
  A.BillOfMaterialVariant,
  A.BillOfMaterial,
  A.ManufacturingOrder,
  A.ProductionPlant as PLANT,
  B.BillOfMaterialComponent
  
}
