@AbapCatalog.sqlViewName: 'YTEST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REP_TEST101'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REP_TEST101 as select from I_MfgOrderDocdGoodsMovement
{

ManufacturingOrder,
Material,
//GoodsMovement,
//GoodsMovementItem,
GoodsMovementType,
PostingDate,
//sum(QuantityInEntryUnit) as QuantityInEntryUnit 
QuantityInEntryUnit 

}
where GoodsMovementType = '101'
