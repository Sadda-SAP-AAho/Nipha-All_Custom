@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Current Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity z_I_MaterialStock as select from I_MaterialStock as a
{
    a.Material,
    a.Plant,
    a.MaterialBaseUnit,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    sum( a.MatlWrhsStkQtyInMatlBaseUnit ) as curr_stock
}
group by
    a.Material,
    a.Plant,
    a.MaterialBaseUnit
