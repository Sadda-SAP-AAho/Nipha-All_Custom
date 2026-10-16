@AbapCatalog.sqlViewName: 'YCONREPP102'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REPP102 
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
//sum(QuantityInEntryUnit) as 
QuantityInEntryUnit

}

where GoodsMovementType = '102'  

//group by
//ManufacturingOrder,
//Material,
////GoodsMovement,
////GoodsMovementItem,
//GoodsMovementType,
//PostingDate
