@AbapCatalog.sqlViewName: 'YCONREPP262'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REPP262 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  I_MfgOrderDocdGoodsMovement as A

{

ManufacturingOrder,
Material,
GoodsMovementType,
//GoodsMovement,
//GoodsMovementItem ,
PostingDate,
QuantityInEntryUnit 

}

where GoodsMovementType = '262'


