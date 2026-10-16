@AbapCatalog.sqlViewName: 'YFNL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMP_REP_101_261 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  ZCONSUM_REPP101_102_FYNL as A
    inner join ZCONSUM_REPP261_262_FYNL2 as B on ( B.ManufacturingOrder = A.ManufacturingOrder //and B.GoodsMovement = A.GoodsMovement 
//                                                   and B.GoodsMovementItem = A.GoodsMovementItem //and B.Material = A.Material )
                                                   and B.PostingDate = A.PostingDate  ) 
                                                       

{

A.ManufacturingOrder,
A.Material,
A.GoodsMovementType,
//A.GoodsMovement,
//A.GoodsMovementItem,
A.PostingDate,
A.QuantityInEntryUnit,
B.ManufacturingOrder as ManufacturingOrder2,
B.Material as Material2,
B.GoodsMovementType as GoodsMovementType2,
//B.GoodsMovement2,
//B.GoodsMovementItem2,
B.PostingDate as PostingDate2,
//case when b.GoodsMovementType
B.QuantityInEntryUnit as QuantityInEntryUnit2

}

