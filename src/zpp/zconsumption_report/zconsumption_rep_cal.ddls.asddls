@EndUserText.label: 'ZCONSUMPTION_REP'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REP_CAL as select from  ZCONSUMPTION_REPORT_FINAL as a
                                          left outer join I_ProductDescription as b on ( b.Product = a.BillOfOperationsMaterial ) 
                                          left outer join I_ProductDescription as C on ( C.Product = a.Material_Number )
//                    left outer join I_MfgOrderOperationComponent as c on c.ManufacturingOrder = a.Order_No 
//                    and c.Reservation = a.Reservation and  c.ReservationItem = a.ReservationItem
    

{
  
  key a.Order_No,
//  a.SHIFT,
  a.Plant,
  a.MfgOrderPlannedStartDate as StartDate ,
  a.MfgOrderPlannedEndDate as EndDate,
  a.Material_Number,
//  a.Reservation,
//  a.ReservationItem,
//  a.GoodsMovement,
//  case when 
//  a.GoodsMovement is null
//  then
//  cast( 'X' as abap.char( 3 )) end as IsReversa_or_IsReversed,
//  a.GoodsMovementItem,
  a.QuantityInEntryUnit as Quantity_withdrawn,
  a.BillOfOperationsMaterial as Header_Material,
  a.Delivery_Quantity,
//  a.PostingDate,
  b.ProductDescription as Header_Product_Description,
  C.ProductDescription as Description,
  a.UserID as User_Name,
  a.Base_Qty,
  a.Component_Base_Qty,
  cast(( a.Component_Base_Qty * a.Delivery_Quantity ) / a.Base_Qty as abap.dec(13,3))   as Requirment_Qty ,
//  cast(Requirment_Qty as abap.dec(13,3)) as Requirment_Qty_new ,
//  '' as Requirment_Qty ,
//  case when a.QuantityInEntryUnit is not initial  then a.QuantityInEntryUnit
//  else 0 - 
  (( a.Component_Base_Qty * a.Delivery_Quantity ) / a.Base_Qty )  as Difference,
  (( a.Component_Base_Qty * a.Delivery_Quantity ) / a.Base_Qty )  as Difference_new  
//  '' as Difference
  
  
  
    
}


