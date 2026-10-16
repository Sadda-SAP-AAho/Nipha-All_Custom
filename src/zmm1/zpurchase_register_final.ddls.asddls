@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurchase_Register_final as select from ZPurchase_Register_BASE3 as a
{
    @UI.identification: [{position:10}]
    @EndUserText.label: 'Purchase Order'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 10 }]
    key PurchaseOrder,
    @UI.lineItem: [{position:15}]
    @EndUserText.label: 'Purchase order item'
    key PurchaseOrderItem,
    @EndUserText.label: 'Invoice No'
    @UI.lineItem: [{position:25}]    
    key SupplierInvoice,
    @EndUserText.label: 'Invoice Item'
    @UI.lineItem: [{position:30}]
    key SupplierInvoiceItem,
    @EndUserText.label: 'Inv Doc Yr'
    @UI.lineItem: [{position:35}]
    key FiscalYear,
    @UI.lineItem: [{position:40}]
    @EndUserText.label: 'Company Code'
    CompanyCode,   
    @UI.lineItem: [{position:45}]
    @EndUserText.label: 'Purchase Organization'
    PurchasingOrganization,    
    @UI.lineItem: [{position:50}]
    @EndUserText.label: 'Plant'
    Plant,
    @UI.lineItem: [{position:60}]
    @EndUserText.label: 'Purchase order date'
    PurchaseOrderDate,    
    @UI.lineItem: [{position:75}]
    @EndUserText.label: 'Created By User'    
    CreatedByUser,    
    @UI.lineItem: [{position:80}]
    @EndUserText.label: 'Purchase group'   
    PurchasingGroup,    
    @EndUserText.label: 'GRR/ServSheet'
    @UI.lineItem: [{position:90}]
    GRR_Service_enteysheet,
    @EndUserText.label: 'Accounting Documnent No.'
    @UI.lineItem: [{position:100}]
//    @Semantics.amount.currencyCode: 'DocumentCurrency'       
    FI_DOCUMNET_NO,
    @EndUserText.label: 'Accounting Documnent Posting Date'
    @UI.lineItem: [{position:120}]
//    @Semantics.amount.currencyCode: 'DocumentCurrency'
    FI_DOCUMENT_POST_DATE,     
    @EndUserText.label: 'Inv Ref Doc No'
    @UI.lineItem: [{position:130}]
    SupplierInvoiceIDByInvcgParty,
    @EndUserText.label: 'Inv Date'
    @UI.lineItem: [{position:140}]
    suplier_invoice_posting_dt, 
    @UI.lineItem: [{position:150}]
    @EndUserText.label: 'Supplier'
    Supplier,
    @EndUserText.label: 'Vendor Name'
    @UI.lineItem: [{position:165}]
    SupplierName,
    @EndUserText.label: 'Vendor City'
    @UI.lineItem: [{position:175}]
    CityName,
    @EndUserText.label: 'Vendor Region'
    @UI.lineItem: [{position:185}]
    Region,
    @EndUserText.label: 'Gross Invoice Amount'
    @UI.lineItem: [{position:200}]
    (coalesce(get_numeric_value(frd_amount ),0)) +
    (coalesce(get_numeric_value(SupplierInvoiceItemAmount ),0)) +
    (coalesce(get_numeric_value(cgst ),0)) +
    (coalesce(get_numeric_value(sgst ),0)) +
    (coalesce(get_numeric_value(igst ),0)) +
    (coalesce(get_numeric_value(CESS),0))     
     as gross_inv_amount,    
    @EndUserText.label: 'Invoice Net Qty.'
    @UI.lineItem: [{position:215}]
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    QtyInPurchaseOrderPriceUnit,
    @UI.lineItem: [{position:235}]
    @EndUserText.label: 'Material' 
    Material,    
    @UI.lineItem: [{position:260}]
    @EndUserText.label: 'Material Description'     
    PurchaseOrderItemText,            
    @EndUserText.label: 'Product Group Name'
    @UI.lineItem: [{position:275}]
    ProductGroupName,           
    @UI.lineItem: [{position:280}]
    @EndUserText.label: 'Base Unit'
    BaseUnit,             
    @UI.lineItem: [{position:285}]
    @EndUserText.label: 'Purchase order type'    
    PurchaseOrderType,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    @UI.lineItem: [{position:300}]
    @EndUserText.label: 'Order Quantity'
    OrderQuantity,
    @UI.lineItem: [{position:310}]
    @EndUserText.label: 'Material Group'
    MaterialGroup, 
    @EndUserText.label: 'FI Documnent year'
    @UI.lineItem: [{position:315}]
//    @Semantics.amount.currencyCode: 'DocumentCurrency'
    FI_DOCUMENT_YEAR,
    @EndUserText.label: 'GR No'
    @UI.lineItem: [{position:325}]
    PurchasingHistoryDocument,
    @EndUserText.label: 'DOC Yr'
    @UI.lineItem: [{position:330}]
    PurchasingHistoryDocumentYear, 
    @EndUserText.label: 'GR Date'
    @UI.lineItem: [{position:340}]    
    PostingDate,  
    @EndUserText.label: 'GR Qty'
    @UI.lineItem: [{position:355}]
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'     
    Quantity, 
    @EndUserText.label: 'GR Amount'
    @UI.lineItem: [{position:365}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    case when PurchaseOrderType = 'ZINC' then
     cast( ZGR_AMT as abap.dec( 15, 3 )) 
    else
     cast( PurOrdAmountInCompanyCodeCrcy as abap.dec( 15, 3 )) 
     end as GR_AMOUNT,      
    @EndUserText.label: 'Delivery Note No'
    @UI.lineItem: [{position:375}]        
    gr_reference_doc,   
    @EndUserText.label: 'GR Header Text'
    @UI.lineItem: [{position:390}]   
    gr_header_text,
    @EndUserText.label: 'Movemen type'
    @UI.lineItem: [{position:395}]  
    GoodsMovementType,
    @EndUserText.label: 'GRR/ServSheet Dt'
    @UI.lineItem: [{position:405}]
    GRR_Service_enteysheet_DT,
    @EndUserText.label: 'GRR/ServSheet YY'
    @UI.lineItem: [{position:410}]
    GRR_Service_enteysheet_YY,
    @UI.lineItem: [{position:415}]
    @EndUserText.label: 'Material Type'
    MaterialType,
    @EndUserText.label: 'Tax code'
    @UI.lineItem: [{position:420}]
    sup_tax_code,
    @UI.lineItem: [{position:425}]
//    @EndUserText.label: 'Net Price'
 //   @Semantics.amount.currencyCode: 'DocumentCurrency'
 //   @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    @EndUserText.label: 'Rate'
//    rate,   
    case when PurchaseOrderType = 'ZINC' then
     cast(zrate as abap.char( 20 )) 
    else
     cast(rate as abap.char( 20 )) 
     end as rate,     
    
    @EndUserText.label: 'Invoice Value'
    @UI.lineItem: [{position:440}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    SupplierInvoiceItemAmount,
    @UI.lineItem: [{position:445}]
    @EndUserText.label: 'Documnet Currency'    
    DocumentCurrency,
    @EndUserText.label: 'Freight Amount'
    @UI.lineItem: [{position:460}]
    frd_amount,
    @EndUserText.label: 'Net Amount'
    @UI.lineItem: [{position:180}]
    (coalesce(get_numeric_value(frd_amount ),0)) +
    (coalesce(get_numeric_value(SupplierInvoiceItemAmount ),0)) as net_amount,
    @EndUserText.label: 'Form name.'
    @UI.lineItem: [{position:475}]
    form_name,
    @EndUserText.label: 'Cgst Rate'
    @UI.lineItem: [{position:480}]  
    CGST_RATE,
    @EndUserText.label: 'Cgst Value'
    @UI.lineItem: [{position:495}]   
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    cgst as CGST_VALUE,
    @EndUserText.label: 'Sgst Rate'
    @UI.lineItem: [{position:500}]
//    @Semantics.amount.currencyCode: 'DocumentCurrency'
    CGST_RATE as SGST_RATE,
    @EndUserText.label: 'Sgst Value'
    @UI.lineItem: [{position:515}]    
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    sgst as SGST_VALUE,
    @EndUserText.label: 'Igst Rate'
    @UI.lineItem: [{position:520}]
    IGST_RATE,
    @EndUserText.label: 'Igst Value'
    @UI.lineItem: [{position:535}]
//    @Semantics.amount.currencyCode: 'DocumentCurrency'
//    round( cast(IGST_value as abap.dec( 12, 3 )),2) as ISGT_VALUE,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    igst as ISGT_VALUE,
    @EndUserText.label: 'Cess Value'
    @UI.lineItem: [{position:550}]
//    @Semantics.amount.currencyCode: 'DocumentCurrency'
//    round( cast(IGST_value as abap.dec( 12, 3 )),2) as ISGT_VALUE,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    CESS as CESS_VALUE,    
    
    //NetPriceAmount,
    @UI.lineItem: [{position:565}]
    @EndUserText.label: 'Total Value'
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    NetAmount,
    @UI.lineItem: [{position:575}]
    @EndUserText.label: 'Business Place'
    BusinessPlace,
    @UI.lineItem: [{position:590}]
    @EndUserText.label: 'Business Place'
    gstin_no,
    @UI.lineItem: [{position:600}]
    @EndUserText.label: 'Business Place'
    pan_no,
    @UI.lineItem: [{position:630}]
    @EndUserText.label: 'Business Place'
    StreetName,
    @UI.lineItem: [{position:640}]
    @EndUserText.label: 'Business Place'
    RegionName,
    @UI.lineItem: [{position:670}]
    @EndUserText.label: 'Service Item Description'
    service_desc,
    @UI.lineItem: [{position:680}]
    @EndUserText.label: 'Service Item qty'    
    service_qty,
    @UI.lineItem: [{position:680}]
    @EndUserText.label: 'Tax Cod Name'  
    TaxCodeName







    
    
   
    


 //   ------------------------------
/*    @EndUserText.label: 'Dom Freight'
    @UI.lineItem: [{position:420}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    Dom_Freight,
    @EndUserText.label: 'Dom Pack/Ford'
   @UI.lineItem: [{position:435}]
   @Semantics.amount.currencyCode: 'DocumentCurrency'
   Dom_Pack_Ford,
    @EndUserText.label: 'Dom Insurance'
    @UI.lineItem: [{position:450}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    Dom_Insurance,
    @EndUserText.label: 'Dom Handling'
    @UI.lineItem: [{position:465}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    Dom_Handling,
    @EndUserText.label: 'Dom Load/Unload'
    @UI.lineItem: [{position:480}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    Dom_Load_Unload,
    @EndUserText.label: 'Dom Other'
    @UI.lineItem: [{position:495}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    Dom_Other,
    @EndUserText.label: 'IMP AirportAuth'
    @UI.lineItem: [{position:510}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    IMP_AirportAuth,
    @EndUserText.label: 'IMP Clearing'
    @UI.lineItem: [{position:525}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    IMP_Clearing,
    @EndUserText.label: 'IMP Freight'
    @UI.lineItem: [{position:540}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    IMP_Freight,
    @EndUserText.label: 'IMP Insurance'
    @UI.lineItem: [{position:555}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    IMP_Insurance,
    @EndUserText.label: 'IMP Loc Destina'
    @UI.lineItem: [{position:570}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    IMP_Loc_Destina,
    @EndUserText.label: 'IMP Loc Trans'
    @UI.lineItem: [{position:555}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    IMP_Loc_Trans,
    @EndUserText.label: 'IMP Inspection'
    @UI.lineItem: [{position:570}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    IMP_Inspection, 
    @EndUserText.label: 'Basic Custom duty'
    @UI.lineItem: [{position:585}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    Basic_Custom_duty, 
 
    @EndUserText.label: 'Social Welfare Cess'
    @UI.lineItem: [{position:600}]
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    Social_welfare_cess,*/
   
    






 

//    cast( ((get_numeric_value(a.NetAmount) / 5 ) * 100) as abap.dec( 12, 2 ) ) END as CGST_RATE,   
//    @EndUserText.label: 'new rate'
//    @UI.lineItem: [{position:425}]
//    cast(rate as abap.char( 20 )) as rate1
}
