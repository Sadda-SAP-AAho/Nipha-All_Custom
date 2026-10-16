@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber to Manufacturer basic 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOBBER_TO_MFG1 as select from ZJOBBER_TO_MGF as a
{
     a.PurchasingHistoryDocumentYear,
    a.PurchasingHistoryDocument,
    a.PurchasingHistoryDocumentItem,
    a.PostingDate,
    a.DocumentReferenceID,
    a.DocumentDate,
    a.GoodsMovementType,
    a.PurchaseOrder,
    a.PurchaseOrderItem,
    a.ReferenceDocument,
    a.ReferenceDocumentItem,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.issue_qty,
    a.issue_movement,
    a.return_doc_no,
    a.return_doc_item,
    a.return_mov_type,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.return_qty,
    a.return_po_no,
    a.return_po_item,
    a.PurchaseOrderDate,
    a.Supplier,
    a.SupplierFullName,
    a.TaxNumber3,
    a.Region,
    a.RegionName,
    a.Material,
    a.PurchaseOrderItemText,
    a.hsn_code,
    a.StorageLocation,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.qty_in_pc,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.order_qty_KG,
    a.po_uom,
    a.ManufacturerPartNmbr,
    a.OrderPriceUnitToOrderUnitNmrtr,
    a.OrdPriceUnitToOrderUnitDnmntr,
    a.Plant,
    a.PlantName,
    a.BaseUnit,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.Quantity,
    a.PurchaseOrderQuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.QtyInPurchaseOrderPriceUnit,
    a.OrderPriceUnit,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.QuantityInDeliveryQtyUnit,
    a.DeliveryQuantityUnit,
    a.DocumentCurrency,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.PurchaseOrderAmount,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.pending_balance_recipit_qty_pc,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.pending_balance_recipit_qty_kg,
    a.YY1_ReferenceChallanno_MMI,
    a.YY1_ReferenceChallanDa_MMI,
    case when a.ReferenceDocument = a.return_doc_no and a.ReferenceDocumentItem =  a.return_doc_item and a.PurchaseOrder = a.return_po_no
     and a.PurchaseOrderItem = a.return_po_item and a.GoodsMovementType = '101' then
    cast('X' as abap.char( 1 ))
    when a.issue_movement = '102' then
    cast('X' as abap.char( 1 ))
    else
    cast(' ' as abap.char( 1 ))
    end as issue_item,
    a.org_goods,
    a.org_goods_text,
//    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    cast( (division(a.mat_denom,a.mat_numer,3)*a.QtyInPurchaseOrderPriceUnit) as abap.dec(10,3 ) ) as Receipt_Qty_In_KG,
//    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    cast( (division(a.mat_denom1,a.mat_numer1,3)*a.qty_in_pc) as abap.dec(10,3 ) ) as ord_Qty_In_KG
    
    
//       case when a.ReferenceDocument = a.return_doc_no and a.ReferenceDocumentItem =  a.return_doc_item and a.PurchaseOrder = a.return_po_no
//     and a.PurchaseOrderItem = a.return_po_item and a.GoodsMovementType = '102' then
//    cast('X' as abap.char( 1 ))
//    else
//    cast(' ' as abap.char( 1 ))
//    end as return_item
}
