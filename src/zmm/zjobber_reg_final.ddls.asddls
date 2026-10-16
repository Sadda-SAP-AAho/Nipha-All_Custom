@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber register final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo:{
  typeName: 'Jobber Register',
  typeNamePlural: 'Jobber Register',
  title: { label: 'Jobber Register'
//           value: 'DocumentTitle' 
         }
               }
@UI.presentationVariant: [{ sortOrder: [{ by: 'jobber_code', direction: #ASC }] }]
define view entity ZJOBBER_REG_FINAL as select from ZJOBBER_REG_BASE_V as a
{
    @UI.identification: [{position:10}]
    @EndUserText.label: 'Jobber Order'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 10 }]
  key a.jobber_order,
    @UI.lineItem: [{position:15}]
    @EndUserText.label: 'Jobber order item'
  key a.jobber_order_item,      
    @UI.lineItem: [{position:25}]
    @EndUserText.label: 'Jobber code'
    a.jobber_code,        
    @UI.identification: [{position:60}]
    @EndUserText.label: 'jobber_Name'
    @UI.selectionField: [{ position: 60 }]
    a.jobber_Name,
    @UI.lineItem: [{position:70}]
    @EndUserText.label: 'Order Date'
    a.order_date,
    @UI.lineItem: [{position:105}]
    @EndUserText.label: 'Order Material Code'
    a.order_material_code,
    @UI.lineItem: [{position:145}]
    @EndUserText.label: 'Material Description'
    a.Material_Desc,
    @UI.lineItem: [{position:155}]
    @EndUserText.label: 'Order Qty(PC)'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.order_qty_pc,
    @UI.lineItem: [{position:165}]
    @EndUserText.label: 'Order Qty(KG)'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.order_qty_KG,
    @UI.lineItem: [{position:175}]
    @EndUserText.label: 'Jobber issue Challan No' 
    a.issue_challan_no,
    @UI.lineItem: [{position:185}]
    @EndUserText.label: 'Jobber issue Challan Date' 
    a.issue_challan_dt,
    @UI.lineItem: [{position:215}]
    @EndUserText.label: 'Jobber issue Material code'  
    a.issue_material,
     @UI.lineItem: [{position:265}]
    @EndUserText.label: 'Jobber issue Material Description'
    a.issue_material_desc,





    @UI.lineItem: [{position:280}]
    @EndUserText.label: 'Jobber issue Qty(PC)'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.issue_qty_pc,
    //@UI.lineItem: [{position:290}]
    //@EndUserText.label: 'Jobber Issue Qty(KG)'
    //@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    //a.issue_qty_pc
    @UI.lineItem: [{position:290}]
    @EndUserText.label: 'Jobber GRN No'
    a.jobber_GRN_no,
    @UI.lineItem: [{position:300}]
    @EndUserText.label: 'Jobber GRN Date)'
    a.jobber_grn_date,
    @UI.lineItem: [{position:310}]
    @EndUserText.label: 'Jobber Challan date' 
    a.jobber_challan_dt,
    @UI.lineItem: [{position:320}]
    @EndUserText.label: 'Jobber Challan No'
    a.jobber_challan_no, 
    @UI.lineItem: [{position:335}]
    @EndUserText.label: 'Jobber  Challan Qty'  
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.jobber_challan_qty,
    @UI.lineItem: [{position:350}]
    @EndUserText.label: 'GRN Qty(PC)'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit' 
    a.GRN_qty_pc,
    @UI.lineItem: [{position:365}]
    @EndUserText.label: 'GRN Qty(KG)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.GRN_Qty_KG,
    @UI.lineItem: [{position:380}]
    @EndUserText.label: 'Pending Issue Componant Qty(PC)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'  
    a.pending_issue_comp_qty,
    @UI.lineItem: [{position:395}]
    @EndUserText.label: 'Pending Balance Recived Qty As per Order(PC)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.pending_balance_recipit_qty_pc,
    @UI.lineItem: [{position:410}]
    @EndUserText.label: 'Balance Recived Qty As per Order(KG)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.pending_balance_recipit_qty_kg,
    
    @UI.lineItem: [{position:420}]
    @EndUserText.label: 'HSN Code' 
    a.HSN_Code,
    @UI.lineItem: [{position:425}]
    @EndUserText.label: 'Purchase Order Quantity Unit'         
    a.PurchaseOrderQuantityUnit

    
}
