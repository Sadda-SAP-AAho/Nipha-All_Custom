@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SAFETY STOCK QUANTITY WITH CURRENT STOCK'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_CURR_STK_WTH_SFTY_STK as select from z_I_MaterialStock as a left outer join I_ProductPlantBasic as b
on a.Material = b.Product and a.Plant = b.Plant
{
    a.Material,
    a.Plant,
    a.MaterialBaseUnit,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
    a.curr_stock,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
    b.SafetyStockQuantity,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
    ( b.SafetyStockQuantity - a.curr_stock ) as sfty_stok
}
where a.curr_stock > 0
