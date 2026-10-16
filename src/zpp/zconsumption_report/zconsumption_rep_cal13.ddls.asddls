@EndUserText.label: 'ZCONSUMPTION_REP13'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REP_CAL13 as select from  I_MfgOrderOperationComponent as b
                                          left outer join ZCONSUMPTION_REP as a on ( a.Order_No = b.ManufacturingOrder  //and a.Reservation = b.Reservation
                                          and a.ReservationItem = b.ReservationItem ) 
           left outer join I_BillOfMaterialItemDEX_3 as h on h.BillOfMaterial = b.BillOfMaterial and h.BillOfMaterialVariant = b.BillOfMaterialVariant 
           and h.BillOfMaterialComponent = b.Material
           left outer join I_BillOfMaterialHeaderDEX_2 as I on I.BillOfMaterial = b.BillOfMaterial and I.BillOfMaterialVariant = b.BillOfMaterialVariant
    

{
  
  key b.ManufacturingOrder as Order_No,
  b.Plant,
  a.MfgOrderPlannedStartDate as StartDate ,
  a.MfgOrderPlannedEndDate as EndDate,
  b.Material as Material_Number,
  a.Reservation,
  a.ReservationItem,
  a.GoodsMovement,
//  a.GoodsMovementItem,
  a.QuantityInEntryUnit as Quantity_withdrawn,
  a.BillOfOperationsMaterial as Header_Material,
  a.Delivery_Quantity,
  a.PostingDate,
//  b.ProductDescription as Header_Product_Description,
  a.ProductDescription as Description,
  a.UserID as User_Name,
//  a.Base_Qty,
//  a.Component_Base_Qty,
//  ( a.Component_Base_Qty * a.Delivery_Quantity ) / a.Base_Qty   as Requirment_Qty ,
//  '' as Requirment_Qty ,
//  a.QuantityInEntryUnit - (( a.Component_Base_Qty * a.Delivery_Quantity ) / a.Base_Qty )  as Difference ,
//  b.ManufacturingOrder,
//  b.ReservationItem as ReservationItem1,
//  b.Material,
//  a.BillOfMaterial,
//  a.BillOfMaterialVariant,
  cast( I.BOMHeaderQuantityInBaseUnit as abap.dec( 13,3 ) ) as Base_Qty,
  cast( h.BillOfMaterialItemQuantity as abap.dec( 13,3 ) ) as Component_Base_Qty
//  '' as Difference
  
  
  
    
}
