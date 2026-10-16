@EndUserText.label: 'ZPRODUCTION_COST_TOTALv'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPRODUCTION_COST_TOTAL_VS 

    as select from  I_MfgOrderConfirmation as A
    left outer join I_MfgOrderDocdGoodsMovement as B on B.ManufacturingOrder = A.ManufacturingOrder and B.GoodsMovement = A.MaterialDocument
                                                        and B.GoodsMovementType = '261'
{
     A.ManufacturingOrder,
     A.Plant,
     B.Reservation,
     B.ReservationItem,
     B.GoodsMovement,
     B.GoodsMovementItem ,
     B.GoodsMovementType,
     cast( A.ConfYieldQtyInProductionUnit as abap.dec( 13,3 ) ) as Delivery_Quantity,
     B.Material as Material_Number ,
     cast( B.QuantityInEntryUnit as abap.dec( 13,3 ) ) as QuantityInEntryUnit,
    A.PostingDate  ,
    
//    for cost report fields --<
     cast( A.OpConfirmedWorkQuantity1 as abap.dec( 13,3 )) as OpConfirmedWorkQuantity1,
     cast( A.OpConfirmedWorkQuantity2 as abap.dec( 13,3 )) as OpConfirmedWorkQuantity2,
     cast( A.OpConfirmedWorkQuantity3 as abap.dec( 13,3 )) as OpConfirmedWorkQuantity3,
     cast( A.OpConfirmedWorkQuantity4 as abap.dec( 13,3 )) as OpConfirmedWorkQuantity4,
     cast( A.OpConfirmedWorkQuantity5 as abap.dec( 13,3 )) as OpConfirmedWorkQuantity5,
     cast( A.OpConfirmedWorkQuantity6 as abap.dec( 13,3 )) as OpConfirmedWorkQuantity6,
     
     A.OpWorkQuantityUnit1,
     A.OpWorkQuantityUnit2,
     A.OpWorkQuantityUnit3,
     A.OpWorkQuantityUnit4,
     A.OpWorkQuantityUnit5,
     A.OpWorkQuantityUnit6
     
//    for cost report fields >--  
}

where A.IsReversal = '' and A.IsReversed = ''
