@EndUserText.label: 'ZCONSUMPTION_REP12'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REP_CAL12 as select from  ZCONSUMPTION_BASE1 as b
                                          left outer join ZCONSUMPTION_REP as a on ( a.Order_No = b.ManufacturingOrder  and a.Material_Number = b.BillOfMaterialComponent 
                                          and a.YY1_Shift_No_CFM = b.SHIFT ) 
           left outer join I_BillOfMaterialItemDEX_3 as h on h.BillOfMaterial = b.BillOfMaterial and h.BillOfMaterialVariant = b.BillOfMaterialVariant 
           and h.BillOfMaterialComponent = b.BillOfMaterialComponent
           left outer join I_BillOfMaterialHeaderDEX_2 as I on I.BillOfMaterial = b.BillOfMaterial and I.BillOfMaterialVariant = b.BillOfMaterialVariant
    

{
  
  key b.ManufacturingOrder as Order_No,
  b.PLANT,
  b.SHIFT ,
  a.MfgOrderPlannedStartDate as StartDate ,
  a.MfgOrderPlannedEndDate as EndDate,
  b.BillOfMaterialComponent as Material_Number,
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



