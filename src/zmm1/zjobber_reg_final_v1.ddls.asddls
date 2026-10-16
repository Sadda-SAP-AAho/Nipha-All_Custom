@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber register final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOBBER_REG_FINAL_V1 as select from ZJOBBER_REG_BASE1_V1 as a 
{
  
      @UI.identification: [{position:10}]
    @EndUserText.label: 'Jobber Order'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 10 }]
  key a.jobber_order,
    @UI.lineItem: [{position:15}]
    @EndUserText.label: 'Jobber order item'
  key a.jobber_order_item ,     
 
    @UI.lineItem: [{position:20}]
    @EndUserText.label: 'GRN Year'
    a.jobber_GRN_year,  
    @UI.lineItem: [{position:30}]
    @EndUserText.label: 'GRN No'
    a.jobber_GRN_no,
    @UI.lineItem: [{position:35}]
    @EndUserText.label: 'GRN item'
    a.jobber_GRN_item,         
    @UI.lineItem: [{position:45}]
    @EndUserText.label: 'Jobber code'
    a.jobber_code,        
    @UI.identification: [{position:65}]
    @EndUserText.label: 'jobber Name'
    @UI.selectionField: [{ position: 80 }]
    a.jobber_Name,
    @UI.lineItem: [{position:90}]
    @EndUserText.label: 'Order Date'
    a.order_date,
    @UI.lineItem: [{position:120}]
    @EndUserText.label: 'Order Material Code'
    a.order_material_code,
    @UI.lineItem: [{position:155}]
    @EndUserText.label: 'Material Description'
    a.Material_Desc,
    @UI.lineItem: [{position:165}]
    @EndUserText.label: 'Order Qty.'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.order_qty_pc,
//    @UI.lineItem: [{position:180}]
//    @EndUserText.label: 'Order Qty(KG)'
//    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
//    a.order_qty_KG,
    @UI.lineItem: [{position:185}]
    @EndUserText.label: 'Srock in Hand'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.Stock_in_Hand,
    @UI.lineItem: [{position:190}]
    @EndUserText.label: 'Jobber issue Challan No' 
    a.issue_challan_no,
    @UI.lineItem: [{position:200}]
    @EndUserText.label: 'Jobber issue Challan Date' 
    a.issue_challan_dt,
    @UI.lineItem: [{position:230}]
    @EndUserText.label: 'Jobber issue Material code'  
    a.issue_material,
     @UI.lineItem: [{position:265}]
    @EndUserText.label: 'Jobber issue Material Description'
    a.issue_material_desc,
    @UI.lineItem: [{position:280}]
    @EndUserText.label: 'Jobber issue Qty(PC)'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.issue_qty_pc,
    @UI.lineItem: [{position:290}]
    @EndUserText.label: 'Component stock in hand)'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.grn_stock_in_hand,  
    
    //@UI.lineItem: [{position:290}]
    //@EndUserText.label: 'Jobber Issue Qty(KG)'
    //@Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    //a.issue_qty_pc
    @UI.lineItem: [{position:290}]
    @EndUserText.label: 'Jobber GRN Date)'
    a.jobber_grn_date,
        @UI.lineItem: [{position:293}]
    @EndUserText.label: 'GRN Material Code)'
    a.GRN_material_Code,
        @UI.lineItem: [{position:295}]
    @EndUserText.label: 'GRN Material Desc. )'
    a.GRN_Material_Desc,
    @UI.lineItem: [{position:300}]
    @EndUserText.label: 'Jobber Challan date' 
    a.jobber_challan_dt,
    @UI.lineItem: [{position:310}]
    @EndUserText.label: 'Jobber Challan No'
    a.jobber_challan_no, 
    @UI.lineItem: [{position:325}]
    @EndUserText.label: 'Jobber  Challan Qty'  
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.jobber_challan_qty,
    @UI.lineItem: [{position:230}]
    @EndUserText.label: 'Referance Challan No.)'
    a.YY1_ReferenceChallanno_MMI,
//    a.challan_no,
    @UI.lineItem: [{position:340}]
    @EndUserText.label: 'GRN Qty(PC)'
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit' 
    a.GRN_qty_pc,
    @UI.lineItem: [{position:355}]
    @EndUserText.label: 'GRN Qty(KG)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.GRN_Qty_KG,
    @UI.lineItem: [{position:370}]
    @EndUserText.label: 'Pending Issue Componant Qty(PC)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'  
    a.pending_issue_comp_qty,
    @UI.lineItem: [{position:385}]
    @EndUserText.label: 'Pending Balance Recived Qty As per Order(PC)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.pending_balance_recipit_qty_pc,
    @UI.lineItem: [{position:400}]
    @EndUserText.label: 'Balance Recived Qty As per Order(KG)' 
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.pending_balance_recipit_qty_kg,
    
    @UI.lineItem: [{position:410}]
    @EndUserText.label: 'HSN Code' 
    a.HSN_Code,
    @UI.lineItem: [{position:415}]
    @EndUserText.label: 'Purchase Order Quantity Unit'         
    a.PurchaseOrderQuantityUnit,
    @UI.lineItem: [{position:420}]
    @EndUserText.label: 'Plant '
    a.Plant,
    @UI.lineItem: [{position:455}]
    @EndUserText.label: 'Plant Name'
    a.PlantName  

      
}
where a.receipt_mvt_type <> '102'
//where a.receipt_mvt_type <> '102'
