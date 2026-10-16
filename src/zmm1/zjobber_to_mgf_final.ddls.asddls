@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber To Manufacturer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'ITC-04 JOB WORK TO MFG' ,
                  typeNamePlural: 'ITC-04 JOB WORK TO MFG'
                   }
define view entity ZJOBBER_TO_MGF_FINAL as select from ZJOBBER_TO_MFG1
{


    @UI.lineItem: [{position:4}]
    @EndUserText.label: 'Jobber GRN Year'
    key PurchasingHistoryDocumentYear,
    @UI.lineItem: [{position:10}]
    @EndUserText.label: 'Jobber GRN No.'
    key PurchasingHistoryDocument,
    @UI.lineItem: [{position:19}]
    @EndUserText.label: 'Jobber GRN Item'
    key PurchasingHistoryDocumentItem,
    @UI.lineItem: [{position:29}]
    @EndUserText.label: 'Po No.'
    key PurchaseOrder,
        @UI.lineItem: [{position:35}]
    @EndUserText.label: 'Po Item'
    key PurchaseOrderItem,
    @UI.lineItem: [{position:60}]
    @EndUserText.label: 'Material No.'
    key Material,
    @UI.lineItem: [{position:90}]
    @EndUserText.label: 'Original goods' 
    key org_goods,
    @UI.lineItem: [{position:120}]
    @EndUserText.label: 'Original description of goods' 
    org_goods_text,  
    @UI.lineItem: [{position:130}]
    @EndUserText.label: 'Nature of Job Work'
    PurchaseOrderItemText, 
    @UI.lineItem: [{position:140}]
    @EndUserText.label: 'Jobber GSTIN No.'
    
    TaxNumber3,
    
    @UI.lineItem: [{position:170}]
    @EndUserText.label: 'Jobber State'
    RegionName,
//    Region,
   
    @UI.lineItem: [{position:180}]
    @EndUserText.label: 'Posting Date'
    PostingDate,
                     
    @UI.lineItem: [{position:190}]
    @EndUserText.label: 'Jobber Code'
    Supplier,
        @UI.lineItem: [{position:220}]
    @EndUserText.label: 'Jobber Name'
    SupplierFullName,
      
          @UI.lineItem: [{position:230}]
    @EndUserText.label: 'Jobber Invoice No.'
    DocumentReferenceID,    
   
           @UI.lineItem: [{position:240}]
    @EndUserText.label: 'Jobber invoice Date'
    DocumentDate,
         @UI.lineItem: [{position:245}]
    @EndUserText.label: 'Mov. Type'
    GoodsMovementType,
    @UI.lineItem: [{position:255}]
    @EndUserText.label: 'Original Challan Dt.)'    
    YY1_ReferenceChallanDa_MMI,     
    @UI.lineItem: [{position:265}]
    @EndUserText.label: 'Original Challan No.)'
    YY1_ReferenceChallanno_MMI,
 //          @UI.lineItem: [{position:140}]
 //   @EndUserText.label: 'Material No.'
//    Material,

        @UI.lineItem: [{position:300}]
    @EndUserText.label: 'HSN Code'
    hsn_code,
//    @UI.lineItem: [{position:185}]
//    @EndUserText.label: 'Original goods' 
//    org_goods,
//     @UI.lineItem: [{position:185}]
//    @EndUserText.label: 'Original description of goods' 
//    org_goods_text,   
        @UI.lineItem: [{position:310}]
    @EndUserText.label: 'Manufacturer Part Nmbr'
    ManufacturerPartNmbr,
//        @UI.lineItem: [{position:200}]
//    @EndUserText.label: 'Po No.'
//    PurchaseOrder,
//        @UI.lineItem: [{position:206}]
//    @EndUserText.label: 'Po Item'
//    PurchaseOrderItem,
        @UI.lineItem: [{position:320}]
    @EndUserText.label: 'Po Date'
    PurchaseOrderDate,
        @UI.lineItem: [{position:315}]
    @EndUserText.label: 'Plant'
    Plant,
        @UI.lineItem: [{position:335}]
    @EndUserText.label: 'Plant Name'
    PlantName,
        @UI.lineItem: [{position:345}]
    @EndUserText.label: 'Storage Location'
    StorageLocation,
         @UI.lineItem: [{position:365}]
    @EndUserText.label: 'Receipt Qty In PC'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    Quantity,   
             @UI.lineItem: [{position:395}]
    @EndUserText.label: 'Receipt Qty In KG'
//    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    Receipt_Qty_In_KG,
//    QtyInPurchaseOrderPriceUnit,   
    @UI.lineItem: [{position:400}]
    @EndUserText.label: 'Delivery Qty Unit'
    DeliveryQuantityUnit,
        @UI.lineItem: [{position:415}]
    @EndUserText.label: 'Purchase Order Qty In PC'
     @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    qty_in_pc,    
        @UI.lineItem: [{position:430}]
    @EndUserText.label: 'Purchase Order Qty In KG'
//     @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    ord_Qty_In_KG,    
              @UI.lineItem: [{position:445}]
    @EndUserText.label: 'Purchase Order Amount'
     @Semantics.amount.currencyCode: 'DocumentCurrency'
    PurchaseOrderAmount,
            @UI.lineItem: [{position:460}]
    @EndUserText.label: 'Pending Balance Recipit Qty in PC'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    pending_balance_recipit_qty_pc,
            @UI.lineItem: [{position:475}]
    @EndUserText.label: 'Pending Balance Recipit Qty in KG'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    pending_balance_recipit_qty_kg,    
  
    @UI.lineItem: [{position:500}]
    @EndUserText.label: 'Base Unit'
    BaseUnit, 
                @UI.lineItem: [{position:510}]
    @EndUserText.label: 'Doc Currency'
    DocumentCurrency

/*
        @UI.lineItem: [{position:245}]
    @EndUserText.label: 'PO UOM'
    po_uom,

        @UI.lineItem: [{position:260}]
    @EndUserText.label: 'Order Price Unit To Order Unit Nmrtr'
    OrderPriceUnitToOrderUnitNmrtr,
        @UI.lineItem: [{position:265}]
    @EndUserText.label: 'Ord Price Unit To Order Unit Dnmntr'
    OrdPriceUnitToOrderUnitDnmntr,



            @UI.lineItem: [{position:215}]
    @EndUserText.label: 'Purchase Order Price Unit'
    PurchaseOrderQuantityUnit,

            @UI.lineItem: [{position:335}]
    @EndUserText.label: 'Order Price Unit'
    OrderPriceUnit,
            @UI.lineItem: [{position:350}]
    @EndUserText.label: 'Qty in Delivery Qty Unit'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    QuantityInDeliveryQtyUnit,*/



}
where issue_item <> 'X' 

