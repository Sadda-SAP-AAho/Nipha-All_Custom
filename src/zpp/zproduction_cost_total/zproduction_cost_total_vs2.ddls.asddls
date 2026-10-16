@EndUserText.label: 'ZPRODUCTION_COST_TOTALv2'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPRODUCTION_COST_TOTAL_VS2 

    as select from  I_MfgOrderForExtraction as A
    left outer join ZPRODUCTION_COST_TOTAL_VS  as B on ( B.ManufacturingOrder = A.ManufacturingOrder ) // and B.Plant = A.PlanningPlant)                                                  
                                                                                                           
//    left outer join I_ProductDescription as d on d.Product = B.Material_Number
//    left outer join I_ReservationDocumentHeader as e on e.OrderID = A.ManufacturingOrder
//    left outer join I_BillOfMaterialHeaderDEX_2 as g on g.BillOfMaterial = A.BillOfMaterial and g.BillOfMaterialVariant = A.BillOfMaterialVariant
//    left outer join I_BillOfMaterialItemDEX_3 as h on h.BillOfMaterial = A.BillOfMaterial and h.BillOfMaterialVariant = A.BillOfMaterialVariant 
//    and h.BillOfMaterialComponent = B.Material_Number //B.BillOfMaterialItemNumber_2
////    inner join I_MfgOrderOperationComponent as I on I.ManufacturingOrder = A.ManufacturingOrder
    

{
    A.ManufacturingOrder as Order_No,
    A.PlanningPlant as Plant,

     A.Material as header_material ,
     B.Reservation,
     B.ReservationItem,
     B.GoodsMovement,
     B.GoodsMovementItem,
     
     B.Delivery_Quantity,
//     '' as Delivery_Quantity ,
     B.Material_Number ,
//     I.Material as Material_Number ,
     B.QuantityInEntryUnit,
//     '' as QuantityInEntryUnit,

    B.PostingDate  ,
//    '' as PostingDate ,

//    '' as BillOfMaterialComponent ,
     A.BillOfMaterial,
     A.BillOfMaterialVariant,
        
//    '' as Component_Base_Qty
     B.OpConfirmedWorkQuantity1,
     B.OpConfirmedWorkQuantity2,
     B.OpConfirmedWorkQuantity3,
     B.OpConfirmedWorkQuantity4,
     B.OpConfirmedWorkQuantity5,
     B.OpConfirmedWorkQuantity6,
     
     B.OpWorkQuantityUnit1,
     B.OpWorkQuantityUnit2,
     B.OpWorkQuantityUnit3,
     B.OpWorkQuantityUnit4,
     B.OpWorkQuantityUnit5,
     B.OpWorkQuantityUnit6


    
}

where A.ManufacturingOrderCategory = '40' or A.ManufacturingOrderCategory = '10' 
//      and A.MfgOrderPlannedStartDate <= $parameters.P_StartDate and A.MfgOrderPlannedEndDate >= $parameters.P_EndDate
