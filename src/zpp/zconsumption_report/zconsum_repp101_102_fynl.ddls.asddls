@AbapCatalog.sqlViewName: 'YCONREPFYNL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUM_REPP101_102_FYNL 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  ZCONSUMPTION_REPP101_102 as A
    
    

{

ManufacturingOrder,
Material,
GoodsMovementType,
//GoodsMovement,
//GoodsMovementItem,
PostingDate,
sum(QuantityInEntryUnit) as QuantityInEntryUnit

}

where ManufacturingOrder2 is null

group by

ManufacturingOrder,
Material,
GoodsMovementType,
//GoodsMovement,
//GoodsMovementItem,
PostingDate




