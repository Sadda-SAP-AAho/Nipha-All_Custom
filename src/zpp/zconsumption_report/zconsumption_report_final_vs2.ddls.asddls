@EndUserText.label: 'ZCONSUMPTION_REP_FNLSV'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REPORT_FINAL_VS2 as select from I_MfgOrderOperationComponent as a                                 
                                      left outer join ZCONSUMPTION_REPORT_FINAL as b on b.Order_No = a.ManufacturingOrder and b.Material_Number = a.Material
                                      left outer join ZCONSUM_REPP261_262_FYNL2 as C on C.ManufacturingOrder = a.ManufacturingOrder and C.Material = a.Material
                                                        and C.GoodsMovementType = '261'                                    
                   

{
  
    
    a.ManufacturingOrder,
    b.BillOfOperationsMaterial,
    a.Plant,
    b.MfgOrderPlannedStartDate,
    b.MfgOrderPlannedEndDate,
    a.Material as Material_Number,
    b.Base_Qty,
    b.Component_Base_Qty,
    cast(C.QuantityInEntryUnit as abap.dec( 13,3 ) ) as QuantityInEntryUnit,
    b.Delivery_Quantity,
    b.UserID
}
