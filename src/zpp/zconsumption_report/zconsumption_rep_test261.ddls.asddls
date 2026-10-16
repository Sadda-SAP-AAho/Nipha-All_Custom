@AbapCatalog.sqlViewName: 'YTEST261'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REP_TEST101'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REP_TEST261 as select from I_MfgOrderDocdGoodsMovement
{

ManufacturingOrder,
Material,
//GoodsMovement,
//GoodsMovementItem,
GoodsMovementType,
'' as PostingDate ,
//PostingDate,

sum(QuantityInEntryUnit) as QuantityInEntryUnit 
//QuantityInEntryUnit 

}
where GoodsMovementType = '261'
group by
ManufacturingOrder,
Material,
//GoodsMovement,
//GoodsMovementItem,
GoodsMovementType
//PostingDate
