@AbapCatalog.sqlViewName: 'YTEST262'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REP_TEST101'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REP_TEST262 as select from I_MfgOrderDocdGoodsMovement
{

ManufacturingOrder,
Material,
//GoodsMovement,
//GoodsMovementItem,
GoodsMovementType,
//PostingDate,
'' as PostingDate ,
sum(QuantityInEntryUnit) as QuantityInEntryUnit 
//QuantityInEntryUnit 

}
where GoodsMovementType = '262'
group by
ManufacturingOrder,
Material,
//GoodsMovement,
//GoodsMovementItem,
GoodsMovementType

//PostingDate
