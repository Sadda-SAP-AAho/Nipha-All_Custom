@AbapCatalog.sqlViewName: 'YREPP261'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REP261 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  ZCONSUMPTION_REP_TEST261_262 as A

{

ManufacturingOrder,
Material,
GoodsMovementType,
//GoodsMovement,
//GoodsMovementItem ,
PostingDate,
sum(QuantityInEntryUnit) as QuantityInEntryUnit
//QuantityInEntryUnit

}

where GoodsMovementType = '261'  

group by
ManufacturingOrder,
Material,
//GoodsMovement,
//GoodsMovementItem,
GoodsMovementType,
PostingDate
