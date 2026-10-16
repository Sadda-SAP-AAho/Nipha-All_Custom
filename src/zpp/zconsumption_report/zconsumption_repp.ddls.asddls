@AbapCatalog.sqlViewName: 'YCONREPP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REPP 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  I_MfgOrderDocdGoodsMovement as A

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

//group by
//
//ManufacturingOrder,
//Material,
////GoodsMovement,
////GoodsMovementItem,
//GoodsMovementType,
//PostingDate
////QuantityInEntryUnit
