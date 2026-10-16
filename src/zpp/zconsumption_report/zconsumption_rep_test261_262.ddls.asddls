@AbapCatalog.sqlViewName: 'YTEST612'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REP_TEST101'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REP_TEST261_262 as select from ZCONSUMPTION_REP_TEST261 as a
                                         left outer join ZCONSUMPTION_REP_TEST262 as b on ( b.ManufacturingOrder = a.ManufacturingOrder 
                                         and b.Material = a.Material and b.PostingDate = a.PostingDate and b.QuantityInEntryUnit = a.QuantityInEntryUnit  )
{

a.ManufacturingOrder,
a.Material,
a.GoodsMovementType,
a.PostingDate,
a.QuantityInEntryUnit,
b.ManufacturingOrder as ManufacturingOrder12,
b.Material as Material12,
b.GoodsMovementType as GoodsMovementType12,
b.PostingDate as PostingDate12,
b.QuantityInEntryUnit as QuantityInEntryUnit12

}
//where b.ManufacturingOrder is null
