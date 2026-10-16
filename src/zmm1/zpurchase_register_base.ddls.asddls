@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase register basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurchase_Register_Base as select from I_PurchaseOrderItemAPI01  as a
left outer join I_PurchaseOrderAPI01 as b on a.PurchaseOrder = b.PurchaseOrder
left outer join I_PurchaseOrderHistoryAPI01 as c on a.PurchaseOrder = c.PurchaseOrder
and a.PurchaseOrderItem = c.PurchaseOrderItem and c.PurchasingHistoryCategory = 'E'
left outer join C_SupplierInvoiceItemDEX  as D on c.PurchaseOrder = D.PurchaseOrder
and c.PurchaseOrderItem = D.PurchaseOrderItem and 
//c.PurchasingHistoryDocument = D.PrmtHbReferenceDocument
c.ReferenceDocument = D.PrmtHbReferenceDocument and
c.ReferenceDocumentItem = D.PrmtHbReferenceDocumentItem and
c.ReferenceDocumentFiscalYear = D.PrmtHbReferenceDocumentFsclYr 
//c.PurchasingHistoryDocumentItem = D.PrmtHbReferenceDocumentItem 
//and c.PurchasingHistoryDocumentYear = D.PrmtHbReferenceDocumentFsclYr
left outer join I_MaterialDocumentHeader_2 as E 
on c.PurchasingHistoryDocument = E.MaterialDocument
and c.PurchasingHistoryDocumentYear = E.MaterialDocumentYear
left outer join I_Supplier as f on f.Supplier = b.Supplier
left outer join I_RegionText as g on g.Region = f.Region and g.Language = 'E' and g.Country = 'IN'
left outer join I_Withholdingtaxitem as h on h.AccountingDocument = D.PrmtHbReferenceDocument 
         and h.CompanyCode = D.CompanyCode and h.FiscalYear = D.PrmtHbReferenceDocumentFsclYr 
         and h.WithholdingTaxCode = '4Q' 
//left outer join YY1_PURCHASEREGISTERCDS2 as h on h.IRPurchaseOrder = a.PurchaseOrder



{
  a.PurchaseOrder,
  b.PurchaseOrderType,
  b.PurchaseOrderDate,
  b.PurchasingOrganization,
  b.CompanyCode,
  b.Supplier,
  b.CreatedByUser,
  b.PurchasingGroup,
  b.PricingDocument,
  b.DocumentCurrency,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  b.PurgReleaseTimeTotalAmount,
  a.PurchaseOrderItem,
  a.Material,
  a.PurchaseOrderItemText,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  a.OrderQuantity,
  a.MaterialType,
  a.MaterialGroup,
  a.Plant,
  a.BaseUnit,
  a.TaxCode,
  //@Semantics.amount.currencyCode: 'DocumentCurrency'
  //@Semantics.quantity.unitOfMeasure: 'BaseUnit'
  a.PurchaseOrderQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  cast( a.NetPriceAmount as abap.quan( 15, 3 )) as netprice,
  //a.PurchaseOrderQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  cast( a.NetPriceQuantity  as abap.quan( 15, 3 )) as netqty,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  a.GrossAmount,
  case when a.GrossAmount >0 then
//      a.GrossAmount / a.OrderQuantity
      cast( ((get_numeric_value(a.GrossAmount) / a.OrderQuantity )) as abap.dec( 15, 3 ) )
      else
      cast( a.GrossAmount as abap.dec( 15, 3 )) 
      end  as zrate,
      
   
 // @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
  //cast( (division(a.OrderPriceUnitToOrderUnitNmrtr,a.OrdPriceUnitToOrderUnitDnmntr,3)*a.OrderQuantity ) 
 // as abap.quan( 10, 3 ) ) as order_qty_KG,
  
  // @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
  //cast( a.netpriceamount / a.OrdPriceUnitToOrderUnitDnmntr  
 // as abap.quan( 10, 3 ) ) as rate,
  
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  a.NetPriceQuantity,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  a.NetAmount,
  c.PurchasingHistoryDocument,
  c.PurchasingHistoryDocumentYear,
  c.PurchasingHistoryDocumentItem,
  c.PostingDate,
  c.GoodsMovementType,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  c.Quantity,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  c.PurOrdAmountInCompanyCodeCrcy,
  D.SupplierInvoice,
  D.SupplierInvoiceItem,
  D.FiscalYear,
  D.PostingDate as suplier_invoice_posting_dt,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  D.SupplierInvoiceItemAmount,
  D.SupplierInvoiceIDByInvcgParty,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  D.QtyInPurchaseOrderPriceUnit,
  concat(D.SupplierInvoice,D.FiscalYear) as org_ref_inv_no,
  E.ReferenceDocument as gr_reference_doc,
  E.MaterialDocumentHeaderText as gr_header_text,
  //--------------------------------------------------------------------------
  concat(concat(D.PrmtHbReferenceDocumentFsclYr,D.PrmtHbReferenceDocument),D.PrmtHbReferenceDocumentItem) as REFERENCE3IDBYBUSINESSPARTNER,
  f.SupplierName,
  f.CityName,
  f.Region,
  f.TaxNumber3 as gstin_no,
  f.BusinessPartnerPanNumber as pan_no,
  f.StreetName,
  g.RegionName,
  a.PurchaseOrderItemText as service_desc,
  a.OrderPriceUnitToOrderUnitNmrtr as service_qty,
  D.PrmtHbReferenceDocument as acc_doc_no,
  D.PrmtHbReferenceDocumentItem as acc_doc_item,
  D.PrmtHbReferenceDocumentFsclYr as acc_doc_year
  
  }






