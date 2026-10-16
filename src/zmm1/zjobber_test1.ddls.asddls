@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber reg test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOBBER_TEST1 as select from I_PurchaseOrderItemAPI01 as a
left outer join I_PurchaseOrderAPI01 as B on a.PurchaseOrder = B.PurchaseOrder
  left outer join I_POSubcontractingCompAPI01 as c on c.PurchaseOrder = a.PurchaseOrder
   and c.PurchaseOrderItem = a.PurchaseOrderItem
  left outer join I_MaterialDocumentItem_2 as d on d.PurchaseOrder = c.PurchaseOrder
      and d.Material = c.Material and d.InventorySpecialStockType = 'O'
      and ( d.GoodsMovementType = '541' or d.GoodsMovementType = '542' )
   left outer join I_ProductDescription as e on  e.Product = c.Material  and e.Language = 'E'
   left outer join I_BillingDocumentItem as f on f.ReferenceSDDocument =  d.MaterialDocument 
   and  d.MaterialDocumentItem = right(f.ReferenceSDDocumentItem,4 ) and f.CreationDate = d.PostingDate
   left outer join I_PurchaseOrderHistoryAPI01 as g on g.PurchaseOrder = a.PurchaseOrder 
   and g.PurchaseOrderItem = a.PurchaseOrderItem and g.PurchasingHistoryCategory = 'E'
   left outer join I_Supplier as h on h.Supplier = B.Supplier  
   left outer join I_Plant as i on i.Plant = a.Plant 

    


{
B.Supplier as jobber_code,
h.SupplierName as jobber_Name,
a.PurchaseOrder as jobber_order,
a.PurchaseOrderItem as jobber_order_item,
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
f.BillingDocument as issue_challan_no,
f.BillingDocumentDate as issue_challan_dt,
d.MaterialDocument as issue_doc,
d.MaterialDocumentItem as issue_doc_item,
d.MaterialDocumentYear as issue_doc_year,
d.GoodsMovementType as issue_Movement_Type ,
ltrim(c.Material,'0') as issue_material,
//e.ProductDescription as issue_material_desc,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
d.QuantityInEntryUnit as issue_qty_pc,
d.EntryUnit as issue_entry_unit,
//c.BaseUnit as issue_unit,
g.PurchasingHistoryDocument as jobber_GRN_no,
g.PurchasingHistoryDocumentItem as jobber_GRN_item,
g.PurchasingHistoryDocumentYear as jobber_GRN_year,
g.PostingDate as jobber_grn_date,
g.DocumentReferenceID as jobber_challan_no,
g.DocumentDate as jobber_challan_dt,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
g.QuantityInDeliveryQtyUnit as jobber_challan_qty,
g.DeliveryQuantityUnit,

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

//g.GoodsMovementType as receipt_mvt_type,
a.Plant,
i.PlantName,
case when a.Plant is not initial 
  then a.Plant
  else
   ' '
  end as plant_nm
   
   


}
where B.PurchaseOrderType = 'ZSUB'
