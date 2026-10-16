@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber reg base view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOBBER_REG_BASE1_V1 as select from I_PurchaseOrderItemAPI01 as a
left outer join I_PurchaseOrderAPI01 as B on a.PurchaseOrder = B.PurchaseOrder
  left outer join I_POSubcontractingCompAPI01 as c on c.PurchaseOrder = a.PurchaseOrder
   and c.PurchaseOrderItem = a.PurchaseOrderItem
  left outer join I_MaterialDocumentItem_2 as d on d.PurchaseOrder = c.PurchaseOrder
      and d.PurchaseOrderItem = c.PurchaseOrderItem 
      and d.Material = c.Material and d.InventorySpecialStockType = 'O'
      and ( d.GoodsMovementType = '541' or d.GoodsMovementType = '542' )
 
   left outer join I_MaterialDocumentItem_2 as m on m.PurchaseOrder = c.PurchaseOrder
      and m.PurchaseOrderItem = c.PurchaseOrderItem 
      and m.Material = c.Material 
      and  m.GoodsMovementType = '101' 
      
   left outer join I_ProductDescription as e on  e.Product = c.Material  and e.Language = 'E'
   
   left outer join I_BillingDocumentItem as f on f.ReferenceSDDocument =  d.MaterialDocument 
   and  d.MaterialDocumentItem = right(f.ReferenceSDDocumentItem,4 ) and f.CreationDate = d.PostingDate
   left outer join I_PurchaseOrderHistoryAPI01 as g on g.PurchaseOrder = m.PurchaseOrder 
   and g.PurchaseOrderItem = m.PurchaseOrderItem and g.PurchasingHistoryCategory = 'E'
   and g.ReferenceDocument = m.MaterialDocument
   
   left outer join I_Supplier as h on h.Supplier = B.Supplier  
   left outer join I_Plant as i on i.Plant = a.Plant
   left outer join ZMAT_STOCK as J on J.Product = a.Material and J.Plant = a.Plant
   left outer join ZMAT_STOCK as k on k.Product = c.Material and k.Plant = c.Plant
   left outer join I_MaterialDocumentItem_2 as l on l.PurchaseOrder = g.PurchaseOrder
      and l.PurchaseOrderItem = g.PurchaseOrderItem and l.GoodsMovementType = '101'
      and l.MaterialDocument = g.PurchasingHistoryDocument

   left outer join I_PurchaseOrderHistoryAPI01 as n on n.PurchaseOrder = a.PurchaseOrder 
   and n.PurchaseOrderItem = a.PurchaseOrderItem //and g.PurchasingHistoryCategory = 'E'
   and n.Material = a.Material and n.GoodsMovementType = '101'      
//   left outer join I_IN_SUBCONTRGDOCDET as j on j.IN_SubcontrgDocNmbr = f.BillingDocument
/*   left outer join I_StockQuantityCurrentValue_2 
   (P_DisplayCurrency : 'INR') as j on j.Plant = a.Plant
   and j.StorageLocation = a.StorageLocation 
   left outer join I_StockQuantityCurrentValue_2
   (P_DisplayCurrency : 'INR') as k on k.Plant = d.Plant
   and j.StorageLocation = d.StorageLocation*/
   


    


{
B.Supplier as jobber_code,
h.SupplierName as jobber_Name,
a.PurchaseOrder as jobber_order,
a.PurchaseOrderItem as jobber_order_item,
J.MaterialBaseUnit,
@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
J.stock as Stock_in_Hand,
B.PurchaseOrderDate as order_date,
B.PurchaseOrderType,
ltrim(a.Material,'0') as order_material_code,
a.PurchaseOrderItemText as Material_Desc,
a.MaterialType,
a.BR_NCM as HSN_Code,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
a.OrderQuantity as order_qty_pc,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
cast( (division(a.OrderPriceUnitToOrderUnitNmrtr,a.OrdPriceUnitToOrderUnitDnmntr,3)*a.OrderQuantity ) 
as abap.quan( 10, 3 ) ) as order_qty_KG,
a.PurchaseOrderQuantityUnit,

d.Plant as issue_plant,
d.StorageLocation as st_loc,
f.BillingDocument as issue_challan_no,
f.BillingDocumentDate as issue_challan_dt,
d.MaterialDocument as issue_doc,
d.MaterialDocumentItem as issue_doc_item,
d.MaterialDocumentYear as issue_doc_year,
d.GoodsMovementType as issue_Movement_Type ,
 ltrim(c.Material,'0') as issue_material,
@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
k.stock as grn_stock_in_hand,
e.ProductDescription as issue_material_desc,

///@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
///j.MatlWrhsStkQtyInMatlBaseUnit as mat_stock,
///@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
///k.MatlWrhsStkQtyInMatlBaseUnit as issue_mat_stock,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
d.QuantityInEntryUnit as issue_qty_pc,
d.EntryUnit as issue_entry_unit,
c.BaseUnit as issue_unit,

n.PurchasingHistoryDocument as jobber_GRN_no,
n.PurchasingHistoryDocumentItem as jobber_GRN_item,
n.PurchasingHistoryDocumentYear as jobber_GRN_year,
//m.MaterialDocument as jobber_GRN_no,
//m.MaterialDocumentItem as jobber_GRN_item,
//m.MaterialDocumentYear as jobber_GRN_year,

ltrim(a.Material,'0') as GRN_material_Code,
a.PurchaseOrderItemText as GRN_Material_Desc,

f.BillingDocument as challan_no,
g.PostingDate as jobber_grn_date,
g.DocumentReferenceID as jobber_challan_no,
g.DocumentDate as jobber_challan_dt,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
g.QuantityInDeliveryQtyUnit as jobber_challan_qty,
g.DeliveryQuantityUnit,
a.StorageLocation, // added on 15.07.2024
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
g.Quantity as GRN_qty_pc,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
g.QtyInPurchaseOrderPriceUnit as GRN_Qty_KG,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
(c.RequiredQuantity - d.QuantityInEntryUnit ) as pending_issue_comp_qty,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
(a.OrderQuantity - g.Quantity ) as pending_balance_recipit_qty_pc,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
cast( ( (division(a.OrderPriceUnitToOrderUnitNmrtr,a.OrdPriceUnitToOrderUnitDnmntr,3)*a.OrderQuantity ) - 
g.QtyInPurchaseOrderPriceUnit ) as abap.quan(10,3) ) as pending_balance_recipit_qty_kg,


a.OrderPriceUnitToOrderUnitNmrtr,
a.OrdPriceUnitToOrderUnitDnmntr,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
c.RequiredQuantity,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
c.WithdrawnQuantity,
case when m.GoodsMovementType is not initial then
          m.GoodsMovementType
     when d.GoodsMovementType is not initial then
          d.GoodsMovementType
     else 'XYZ' end as receipt_mvt_type,
a.Plant,
i.PlantName,
l.YY1_ReferenceChallanno_MMI




}
where B.PurchaseOrderType = 'ZSUB'
