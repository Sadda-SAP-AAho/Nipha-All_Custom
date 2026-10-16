@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber reg base view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOBBER_REG_BASE_V as select from I_PurchaseOrderItemAPI01 as A
  left outer join I_PurchaseOrderAPI01 as B on A.PurchaseOrder = B.PurchaseOrder
  left outer join I_POSubcontractingCompAPI01 as c on A.PurchaseOrder = c.PurchaseOrder
   and A.PurchaseOrderItem = c.PurchaseOrderItem
  left outer join I_MaterialDocumentItem_2 as d on c.PurchaseOrder = d.PurchaseOrder
      and c.Material = d.Material and d.InventorySpecialStockType = 'O'
      and ( d.GoodsMovementType = '541' or d.GoodsMovementType = '542' )
   left outer join I_ProductDescription as e on c.Material = e.Product and e.Language = 'E'
   left outer join I_BillingDocumentItem as f on d.MaterialDocument = f.ReferenceSDDocument
   left outer join I_PurchaseOrderHistoryAPI01 as g on A.PurchaseOrder = g.PurchaseOrder
   and A.PurchaseOrderItem = g.PurchaseOrderItem and g.PurchasingHistoryCategory = 'E'
   left outer join I_Supplier as h on B.Supplier = h.Supplier 

    
   //and d.MaterialDocumentItem = f.ReferenceSDDocumentItem
  // left outer join I_IN_SubcontrgDocDet as f on d.MaterialDocument = f.MaterialDocument
   //  and d.MaterialDocumentItem = f.MaterialDocumentItem and d.MaterialDocumentYear = f.MaterialDocumentYear
   //  and f.GoodsMovementType = '541'

{
B.Supplier as jobber_code,
h.SupplierName as jobber_Name,
A.PurchaseOrder as jobber_order,
A.PurchaseOrderItem as jobber_order_item,
B.PurchaseOrderDate as order_date,
B.PurchaseOrderType,
ltrim(A.Material,'0') as order_material_code,
A.PurchaseOrderItemText as Material_Desc,
A.MaterialType,
A.BR_NCM as HSN_Code,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
A.OrderQuantity as order_qty_pc,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
cast( (division(A.OrderPriceUnitToOrderUnitNmrtr,A.OrdPriceUnitToOrderUnitDnmntr,3)*A.OrderQuantity ) 
as abap.quan( 10, 3 ) ) as order_qty_KG,
A.PurchaseOrderQuantityUnit,
f.BillingDocument as issue_challan_no,
f.BillingDocumentDate as issue_challan_dt,
d.MaterialDocument as issue_doc,
d.MaterialDocumentItem as issue_doc_item,
d.MaterialDocumentYear as issue_doc_year,
d.GoodsMovementType as issue_Movement_Type ,
ltrim(c.Material,'0') as issue_material,
e.ProductDescription as issue_material_desc,
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
(A.OrderQuantity - g.Quantity ) as pending_balance_recipit_qty_pc,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
cast( ( (division(A.OrderPriceUnitToOrderUnitNmrtr,A.OrdPriceUnitToOrderUnitDnmntr,3)*A.OrderQuantity ) - 
g.QtyInPurchaseOrderPriceUnit ) as abap.quan(10,3) ) as pending_balance_recipit_qty_kg,


A.OrderPriceUnitToOrderUnitNmrtr,
A.OrdPriceUnitToOrderUnitDnmntr,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
c.RequiredQuantity,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
c.WithdrawnQuantity,

g.GoodsMovementType as receipt_mvt_type














 
 
}
where B.PurchaseOrderType = 'ZSUB' 



