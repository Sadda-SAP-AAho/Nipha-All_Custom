@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber to MFG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOBBER_TO_MGF as select from I_PurchaseOrderItemAPI01 as a left outer join    
I_PurchaseOrderAPI01 as b on b.PurchaseOrder = a.PurchaseOrder 
left outer join I_PurchaseOrderHistoryAPI01 as c on c.PurchaseOrder = a.PurchaseOrder
and c.PurchaseOrderItem = a.PurchaseOrderItem and c.PurchasingHistoryCategory = 'E'
left outer join I_Supplier as d on d.Supplier = b.Supplier
left outer join I_MaterialDocumentItem_2 as e on e.MaterialDocument = c.PurchasingHistoryDocument
and e.MaterialDocumentYear = c.PurchasingHistoryDocumentYear
and e.MaterialDocumentItem = c.PurchasingHistoryDocumentItem
left outer join I_Plant as f on f.Plant = c.Plant
left outer join I_PurchaseOrderHistoryAPI01 as g on g.PurchaseOrder = c.PurchaseOrder and g.PurchaseOrderItem = c.PurchaseOrderItem
    and g.ReferenceDocument = c.PurchasingHistoryDocument and g.ReferenceDocumentItem = c.PurchasingHistoryDocumentItem
    and g.GoodsMovementType = '102' and g.DebitCreditCode = 'H'
left outer join I_RegionText as h on h.Country = d.Country and h.Region = d.Region and h.Language = 'E'
left outer join I_PurchaseOrderHistoryAPI01 as j on j.PurchaseOrder = c.PurchaseOrder and j.PurchaseOrderItem = c.PurchaseOrderItem and j.GoodsMovementType = '543'
and j.ReferenceDocument = c.ReferenceDocument and j.ReferenceDocumentItem = c.ReferenceDocumentItem and j.ReferenceDocumentFiscalYear = c.ReferenceDocumentFiscalYear
left outer join I_ProductDescription as K on K.Product = j.Material and K.Language = 'E'
left outer join I_ProductUnitsOfMeasure as l on l.Product = c.Material and l.AlternativeUnit = 'KG'
left outer join I_ProductUnitsOfMeasure as m on m.Product = a.Material and m.AlternativeUnit = 'KG'
{
 c.PurchasingHistoryDocumentYear,
 c.PurchasingHistoryDocument,
 c.PurchasingHistoryDocumentItem,
 c.PostingDate,
 c.DocumentReferenceID,   //
 c.DocumentDate,
 c.GoodsMovementType,
 c.PurchaseOrder,
 c.PurchaseOrderItem,
 //=====================================25-10-2024==================
 c.ReferenceDocument , // 
 c.ReferenceDocumentItem,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 c.QtyInPurchaseOrderPriceUnit as issue_qty,
 c.GoodsMovementType as issue_movement,
 g.ReferenceDocument as return_doc_no,
 g.ReferenceDocumentItem  as return_doc_item,
 g.GoodsMovementType as return_mov_type,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 g.QtyInPurchaseOrderPriceUnit  as  return_qty,
 g.PurchaseOrder as return_po_no,
 g.PurchaseOrderItem as  return_po_item,
 
 //=====================================25-10-2024================== 
 
 b.PurchaseOrderDate,
 b.Supplier,
 d.SupplierFullName,
 d.TaxNumber3,
 d.Region,
 h.RegionName,
 c.Material,
 a.PurchaseOrderItemText,
 a.BR_NCM as hsn_code,
 e.StorageLocation,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 a.OrderQuantity as qty_in_pc,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 cast( (division(a.OrderPriceUnitToOrderUnitNmrtr,a.OrdPriceUnitToOrderUnitDnmntr,3)*a.OrderQuantity ) 
 as abap.quan( 10, 3 ) ) as order_qty_KG,
 a.PurchaseOrderQuantityUnit as po_uom,
 
 

 a.ManufacturerPartNmbr,
 a.OrderPriceUnitToOrderUnitNmrtr,
 a.OrdPriceUnitToOrderUnitDnmntr,
 c.Plant,
 f.PlantName,
 c.BaseUnit,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 c.Quantity,
 c.PurchaseOrderQuantityUnit,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 c.QtyInPurchaseOrderPriceUnit,
 c.OrderPriceUnit,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 c.QuantityInDeliveryQtyUnit,
 c.DeliveryQuantityUnit,
 b.DocumentCurrency,
 @Semantics.amount.currencyCode: 'DocumentCurrency'
 c.PurchaseOrderAmount,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
 (a.OrderQuantity - c.Quantity ) as pending_balance_recipit_qty_pc,
@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
cast( ( (division(a.OrderPriceUnitToOrderUnitNmrtr,a.OrdPriceUnitToOrderUnitDnmntr,3)*a.OrderQuantity ) - 
c.QtyInPurchaseOrderPriceUnit ) as abap.quan(10,3) ) as pending_balance_recipit_qty_kg,
e.YY1_ReferenceChallanno_MMI,
e.YY1_ReferenceChallanDa_MMI,
j.Material as org_goods,
K.ProductDescription as org_goods_text,
l.QuantityDenominator as mat_denom,
l.QuantityNumerator as mat_numer,
m.QuantityDenominator as mat_denom1,
m.QuantityNumerator as mat_numer1 
}
where b.PurchaseOrderType = 'ZSUB' and c.PurchasingHistoryDocument <> ' '
//and c.PurchasingHistoryDocumentItem <> '0000' and c.PurchasingHistoryDocumentYear = '0000'
