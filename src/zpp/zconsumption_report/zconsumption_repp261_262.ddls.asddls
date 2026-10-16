@AbapCatalog.sqlViewName: 'YCONREPFNL2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUMPTION_REPP261_262 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  ZCONSUMPTION_REP261 as A
    left outer join ZCONSUMPTION_REPP262 as B on ( B.ManufacturingOrder = A.ManufacturingOrder and B.Material = A.Material
                                                   and B.PostingDate = A.PostingDate
                                                    and B.QuantityInEntryUnit = A.QuantityInEntryUnit ) 
                                                   
//                                                   and B.GoodsMovementType <> A.GoodsMovementType )
    

{

A.ManufacturingOrder,
A.Material,
A.GoodsMovementType,
//A.GoodsMovement,
//A.GoodsMovementItem ,
A.PostingDate,
A.QuantityInEntryUnit,
B.ManufacturingOrder as ManufacturingOrder2,
B.Material as Material2,
B.GoodsMovementType as GoodsMovementType2,
//A.GoodsMovement as GoodsMovement2,
//A.GoodsMovementItem as GoodsMovementItem2 ,
B.PostingDate as PostingDate2,
//case when b.GoodsMovementType
B.QuantityInEntryUnit as QuantityInEntryUnit2

}

//where B.ManufacturingOrder is null


