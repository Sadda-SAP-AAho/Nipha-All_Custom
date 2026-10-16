@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Jobber Register Base View 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOBBER_REG_BASE1_V2 as select from ZJOBBER_REG_BASE1_V1 as a 
//left outer join I_PurchaseOrderHistoryAPI01 as b on b.PurchaseOrder = a.PurchaseOrder 
//   and b.PurchaseOrderItem = a.PurchaseOrderItem //and g.PurchasingHistoryCategory = 'E'
//   and b.Material = a.Material and b.GoodsMovementType = '101'
//   and b.PurchasingHistoryDocument =  
{
    a.jobber_code,
    a.jobber_Name,
    a.jobber_order,
    a.jobber_order_item,
    a.MaterialBaseUnit,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
    a.Stock_in_Hand,
    a.order_date,
    a.PurchaseOrderType,
    a.order_material_code,
    a.Material_Desc,
    a.MaterialType,
    a.HSN_Code,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.order_qty_pc,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.order_qty_KG,
    a.PurchaseOrderQuantityUnit,
    a.issue_plant,
    a.st_loc,
    a.issue_challan_no,
    a.issue_challan_dt,
    a.issue_doc,
    a.issue_doc_item,
    a.issue_doc_year,
    a.issue_Movement_Type,
    a.issue_material,
    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
    a.grn_stock_in_hand,
    a.issue_material_desc,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.issue_qty_pc,
    a.issue_entry_unit,
    a.issue_unit,
    a.jobber_GRN_no,
    a.jobber_GRN_item,
    a.jobber_GRN_year,
    a.GRN_material_Code,
    a.GRN_Material_Desc,
    a.challan_no,
    a.jobber_grn_date,
    a.jobber_challan_no,
    a.jobber_challan_dt,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.jobber_challan_qty,
    a.DeliveryQuantityUnit,
    a.StorageLocation,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
    a.GRN_qty_pc,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'    
    a.GRN_Qty_KG,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'    
    a.pending_issue_comp_qty,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'    
    a.pending_balance_recipit_qty_pc,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'    
    a.pending_balance_recipit_qty_kg,
    a.OrderPriceUnitToOrderUnitNmrtr,
    a.OrdPriceUnitToOrderUnitDnmntr,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'    
    a.RequiredQuantity,
    @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'    
    a.WithdrawnQuantity,
    a.receipt_mvt_type,
    a.Plant,
    a.PlantName,
    a.YY1_ReferenceChallanno_MMI
}
group by 
    a.jobber_code,
    a.jobber_Name,
    a.jobber_order,
    a.jobber_order_item,
    a.MaterialBaseUnit,
    a.Stock_in_Hand,
    a.order_date,
    a.PurchaseOrderType,
    a.order_material_code,
    a.Material_Desc,
    a.MaterialType,
    a.HSN_Code,
    a.order_qty_pc,
    a.order_qty_KG,
    a.PurchaseOrderQuantityUnit,
    a.issue_plant,
    a.st_loc,
    a.issue_challan_no,
    a.issue_challan_dt,
    a.issue_doc,
    a.issue_doc_item,
    a.issue_doc_year,
    a.issue_Movement_Type,
    a.issue_material,
    a.grn_stock_in_hand,
    a.issue_material_desc,
    a.issue_qty_pc,
    a.issue_entry_unit,
    a.issue_unit,
    a.jobber_GRN_no,
    a.jobber_GRN_item,
    a.jobber_GRN_year,
    a.GRN_material_Code,
    a.GRN_Material_Desc,
    a.challan_no,
    a.jobber_grn_date,
    a.jobber_challan_no,
    a.jobber_challan_dt,
    a.jobber_challan_qty,
    a.DeliveryQuantityUnit,
    a.StorageLocation,
    a.GRN_qty_pc,   
    a.GRN_Qty_KG,   
    a.pending_issue_comp_qty,   
    a.pending_balance_recipit_qty_pc,   
    a.pending_balance_recipit_qty_kg,
    a.OrderPriceUnitToOrderUnitNmrtr,
    a.OrdPriceUnitToOrderUnitDnmntr,  
    a.RequiredQuantity,   
    a.WithdrawnQuantity,
    a.receipt_mvt_type,
    a.Plant,
    a.PlantName,
    a.YY1_ReferenceChallanno_MMI
