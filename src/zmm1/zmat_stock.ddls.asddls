@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stcok plant wise'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMAT_STOCK as select from I_StockQuantityCurrentValue_2
(P_DisplayCurrency : 'INR') as a
{
 key a.Product,
 key a.Plant,
     a.MaterialBaseUnit,
     a.ValuationAreaType,
     @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'  
     sum(a.MatlWrhsStkQtyInMatlBaseUnit) as stock
   
   
}
where ( a.ValuationAreaType = '1' and a.Supplier = '' ) 
group by
 a.Product,
 a.Plant,
 a.MaterialBaseUnit,
 a.ValuationAreaType

