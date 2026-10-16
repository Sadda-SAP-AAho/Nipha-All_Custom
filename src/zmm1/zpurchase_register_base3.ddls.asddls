@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Basic 3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurchase_Register_BASE3 as select from zpurchase_base1 as a
   left outer join C_PurchaseOrderHistoryDEX as b on b.PurchaseOrder = a.PurchaseOrder
        and b.PurchaseOrderItem = a.PurchaseOrderItem and b.PurchasingHistoryCategory = '0'
   left outer join I_CnsldtnProductGroupT  as c on c.ProductGroup = a.MaterialGroup
     and c.Language = 'E'
{
    a.PurchaseOrder,
    a.PurchaseOrderType,
    a.PurchaseOrderDate,
    a.PurchasingOrganization,
    a.CompanyCode,
    a.Supplier,
    a.CreatedByUser,
    a.PurchasingGroup,
    a.DocumentCurrency,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.PurgReleaseTimeTotalAmount,
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
    a.PurchaseOrderQuantityUnit,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.NetAmount,
    a.PurchasingHistoryDocument,
    a.PurchasingHistoryDocumentYear,
    a.PostingDate,
    a.GoodsMovementType,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.Quantity,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.PurOrdAmountInCompanyCodeCrcy,
    a.SupplierInvoice,
    a.SupplierInvoiceItem,
    a.FiscalYear,
    a.suplier_invoice_posting_dt,
    a.gr_header_text,
    a.gr_reference_doc,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.SupplierInvoiceItemAmount,
    a.SupplierInvoiceIDByInvcgParty,
    a.org_ref_inv_no,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.cgst,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.sgst,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.igst,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.CESS,
    a.sup_tax_code,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.rate,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Dom_Freight,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Dom_Pack_Ford,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Dom_Insurance,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Dom_Handling,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Dom_Load_Unload,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Dom_Other,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.IMP_AirportAuth,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.IMP_Clearing,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.IMP_Freight,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.IMP_Insurance,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.IMP_Loc_Destina,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.IMP_Loc_Trans,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.IMP_Inspection,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Basic_Custom_duty,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.Social_welfare_cess,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    a.CGST_value,
    a.IGST_value,
    a.CGST_RATE,
    a.IGST_RATE,
    a.zrate,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.ZGR_AMT,
    a.FI_DOCUMNET_NO,
    a.FI_DOCUMENT_YEAR,
    a.FI_DOCUMENT_POST_DATE,
    a.TAXITEMREF,
    a.CompanyCodeCurrency,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.QtyInPurchaseOrderPriceUnit,
    a.form_name,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    a.net_amount,
    a.frd_amt,
    a.GoodsMovementEntryUnit,
    @Semantics: { quantity : {unitOfMeasure: 'GoodsMovementEntryUnit'} }
    a.QuantityInEntryUnit,
    a.qty_ety_unt,
    a.miro_qty,
    case when a.frd_amt > 0 then
//    cast( (frd_amt / qty_ety_unt
    cast( ((get_numeric_value(a.frd_amt) / a.qty_ety_unt) * a.miro_qty) as abap.dec( 12, 2 ) )
    else
    a.frd_amt
    end as frd_amount,
    a.SupplierName,
    a.CityName,
    a.Region,
    b.PurchasingHistoryDocument as GRR_Service_enteysheet,
    b.PostingDate as GRR_Service_enteysheet_DT,
    b.ReferenceDocumentFiscalYear as GRR_Service_enteysheet_YY,
    c.ProductGroupName,
    a.BusinessPlace,
    a.gstin_no,
    a.pan_no,
    a.StreetName,
    a.RegionName,
    a.service_desc,
    a.service_qty,
    a.TaxCodeName
}
