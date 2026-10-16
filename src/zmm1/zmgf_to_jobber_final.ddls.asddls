@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manufacturer to Jobber'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'ITC-04 MFG TO JOB WORK' ,
                  typeNamePlural: 'ITC-04 MFG TO JOB WORK'
                  }
define view entity ZMGF_TO_JOBBER_FINAL as select from ZMFG_JOBBER
{
        @UI.lineItem: [{position:10}]
    @EndUserText.label: 'Challan Document Number'
    key BillingDocument,
        @UI.lineItem: [{position:15}]
    @EndUserText.label: 'Challan Document Item'
    key BillingDocumentItem,
         @UI.lineItem: [{position:30}]
    @EndUserText.label: 'Vender GSTIN No.'
    TaxNumber3,
         @UI.lineItem: [{position:40}]
    @EndUserText.label: 'Jobber State'
    RegionName,   
            @UI.lineItem: [{position:50}]
    @EndUserText.label: 'Challan Date'
    BillingDocumentDate,
        @UI.lineItem: [{position:60}]
    @EndUserText.label: 'Jobber Code'
    Supplier,
        @UI.lineItem: [{position:70}]
    @EndUserText.label: 'Jobber Name'
    SupplierFullName,       
    @UI.lineItem: [{position:75}]
    @EndUserText.label: 'Issue Document Year'
    MaterialDocumentYear,
        @UI.lineItem: [{position:85}]
    @EndUserText.label: 'Issue Document Number'
    MaterialDocument,
        @UI.lineItem: [{position:90}]
    @EndUserText.label: 'Issue Document Item'
    MaterialDocumentItem,
        @UI.lineItem: [{position:100}]
    @EndUserText.label: 'Job Order Number'
    PurchaseOrder,
        @UI.lineItem: [{position:110}]
    @EndUserText.label: 'Job Order Date'
    PurchaseOrderDate,
         @UI.lineItem: [{position:120}]
    @EndUserText.label: 'Plant'
   Plant,
        @UI.lineItem: [{position:135}]
    @EndUserText.label: 'Plant Name'
    PlantName,
        @UI.lineItem: [{position:155}]
    @EndUserText.label: 'Material'
    Material,
        @UI.lineItem: [{position:180}]
    @EndUserText.label: 'Material Description'
    
    ProductDescription,
    
    
        @UI.lineItem: [{position:195}]
    @EndUserText.label: 'Required Qty'
     @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    RequiredQuantity,
        @UI.lineItem: [{position:200}]
    @EndUserText.label: 'Base Unit'
    BaseUnit,
        @UI.lineItem: [{position:215}]
    @EndUserText.label: 'Transfer quantity'
     @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    QuantityInEntryUnit,
        @UI.lineItem: [{position:220}]
    @EndUserText.label: 'Issue Unit'
    ISSUE_UNIT,
             @UI.lineItem: [{position:240}]
    @EndUserText.label: 'Challan Item Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    challan_item_value,   
    
            @UI.lineItem: [{position:245}]
    @EndUserText.label: 'Transaction Currency'
    TransactionCurrency,

            @UI.lineItem: [{position:250}]
    @EndUserText.label: 'SGST Rate'
    sgst_rate,
            @UI.lineItem: [{position:265}]
    @EndUserText.label: 'SGST Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sgst_value,
            @UI.lineItem: [{position:275}]
    @EndUserText.label: 'CGST Rate'
    cgst_rate,
            @UI.lineItem: [{position:290}]
    @EndUserText.label: 'CGST Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    cgst_value,
            @UI.lineItem: [{position:300}]
    @EndUserText.label: 'IGST Rate'
    igst_rate,
            @UI.lineItem: [{position:315}]
    @EndUserText.label: 'IGST Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    igst_value,
                @UI.lineItem: [{position:330}]
    @EndUserText.label: 'Total GST Rate'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    total_GST_rate,
                @UI.lineItem: [{position:345}]
    @EndUserText.label: 'Total GST Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    total_GST_value,
    
            @UI.lineItem: [{position:360}]
    @EndUserText.label: 'Pending Qty'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    pending_qty,
            @UI.lineItem: [{position:375}]
    @EndUserText.label: 'Panding UOM'
    pending_uom
}
where rev_ind <> 'X'
