@EndUserText.label: 'ZCONSUMPTION_REP'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REP 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  I_MfgOrderForExtraction as A
    left outer join ZCONSUMPTION_REP_VS  as B on ( B.ManufacturingOrder = A.ManufacturingOrder )                                                  
                                                                                                           
    left outer join I_ProductDescription as d on d.Product = B.Material_Number
    left outer join I_ReservationDocumentHeader as e on e.OrderID = A.ManufacturingOrder
    left outer join I_BillOfMaterialHeaderDEX_2 as g on g.BillOfMaterial = A.BillOfMaterial and g.BillOfMaterialVariant = A.BillOfMaterialVariant
    left outer join I_BillOfMaterialItemDEX_3 as h on h.BillOfMaterial = A.BillOfMaterial and h.BillOfMaterialVariant = A.BillOfMaterialVariant 
    and h.BillOfMaterialComponent = B.Material_Number //B.BillOfMaterialItemNumber_2
//    inner join I_MfgOrderOperationComponent as I on I.ManufacturingOrder = A.ManufacturingOrder
    

{
    A.ManufacturingOrder as Order_No,
    A.PlanningPlant as Plant,
    A.MfgOrderPlannedStartDate,
    A.MfgOrderPlannedEndDate,
    

     A.Material as BillOfOperationsMaterial ,
     B.YY1_Shift_No_CFM,
     B.Reservation,
     B.ReservationItem,
     B.GoodsMovement,
     B.Delivery_Quantity,
//     '' as Delivery_Quantity ,
     B.Material_Number ,
//     I.Material as Material_Number ,
     B.QuantityInEntryUnit,
//     '' as QuantityInEntryUnit,

    B.PostingDate  ,
//    '' as PostingDate ,
    d.ProductDescription  ,
//    '' as ProductDescription ,
    e.UserID ,
//    '' as UserID ,
    cast( g.BOMHeaderQuantityInBaseUnit as abap.dec( 13,3 ) ) as Base_Qty,
//      '' as Base_Qty ,
    h.BillOfMaterialComponent,
//    '' as BillOfMaterialComponent ,
     A.BillOfMaterial,
     A.BillOfMaterialVariant,
     B.IsReversal,
     B.IsReversed,
        
    cast( h.BillOfMaterialItemQuantity as abap.dec( 13,3 ) ) as Component_Base_Qty
//    '' as Component_Base_Qty


    
}

where A.ManufacturingOrderCategory = '40' or A.ManufacturingOrderCategory = '10' 
//      and A.MfgOrderPlannedStartDate <= $parameters.P_StartDate and A.MfgOrderPlannedEndDate >= $parameters.P_EndDate
