@EndUserText.label: 'ZCONSUMPTION_REP_FNL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REPORT_FINAL as select from I_MfgOrderForExtraction as A
                   left outer join I_MfgOrderOperationComponent as vs on vs.ManufacturingOrder = A.ManufacturingOrder //and vs.Material = a.Material
                   left outer join I_BillOfMaterialHeaderDEX_2 as BB on BB.BillOfMaterial = A.BillOfMaterial and BB.BillOfMaterialVariant = A.BillOfMaterialVariant
                   left outer join I_BillOfMaterialItemDEX_3 as B on B.BillOfMaterial = A.BillOfMaterial and B.BillOfMaterialVariant = A.BillOfMaterialVariant 
                                                                     and B.BillOfMaterialComponent = vs.Material 
                   left outer join ZCONSUM_REPP261_262_FYNL2 as C on C.ManufacturingOrder = A.ManufacturingOrder and C.Material = vs.Material
                                                        and C.GoodsMovementType = '261'
                   left outer join ZCONSUMPTION_DEL_QTY as d on d.ManufacturingOrder = A.ManufacturingOrder //and d.PostingDate = C.PostingDate 
                   left outer join I_ReservationDocumentHeader as e on e.OrderID = A.ManufacturingOrder                                     


{
    A.ManufacturingOrder as Order_No,
    A.Material as BillOfOperationsMaterial,
    A.PlanningPlant as Plant,
    A.MfgOrderPlannedStartDate,
    A.MfgOrderPlannedEndDate,
    vs.Material as Material_Number,
    cast( BB.BOMHeaderQuantityInBaseUnit as abap.dec( 13,3 ) ) as Base_Qty,
    cast( B.BillOfMaterialItemQuantity as abap.dec( 13,3 ) ) as Component_Base_Qty,
//    C.PostingDate,
    cast(C.QuantityInEntryUnit as abap.dec( 13,3 ) ) as QuantityInEntryUnit,
    d.Delivery_Quantity,
    e.UserID 
    
    
}
where A.ManufacturingOrderCategory = '40' or A.ManufacturingOrderCategory = '10' 
