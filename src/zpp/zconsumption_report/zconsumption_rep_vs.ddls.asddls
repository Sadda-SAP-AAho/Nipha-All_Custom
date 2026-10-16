@EndUserText.label: 'ZCONSUMPTION_REPv'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REP_VS 

    as select from  I_MfgOrderConfirmation as A
    left outer join I_MfgOrderDocdGoodsMovement as B on B.ManufacturingOrder = A.ManufacturingOrder and B.GoodsMovement = A.MaterialDocument
                                                        and B.GoodsMovementType = '261'
//    inner join I_MfgOrderOperationComponent as c on c.ManufacturingOrder = A.ManufacturingOrder and c.Reservation = B.Reservation and c.Material <> B.GoodsMovement                                                   
{
     A.ManufacturingOrder,
     A.Plant,
     A.YY1_Shift_No_CFM,
     B.Reservation,
     B.ReservationItem,
     B.GoodsMovement,
     B.GoodsMovementType,
     cast( A.ConfYieldQtyInProductionUnit as abap.dec( 13,3 ) ) as Delivery_Quantity,
     B.Material as Material_Number ,
     cast( B.QuantityInEntryUnit as abap.dec( 13,3 ) ) as QuantityInEntryUnit,
    A.PostingDate  ,
    A.IsReversal,
     A.IsReversed 
    

}

where A.IsReversal = '' and A.IsReversed = ''
