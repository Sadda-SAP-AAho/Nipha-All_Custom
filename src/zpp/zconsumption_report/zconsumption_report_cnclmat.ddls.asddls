//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPORT_cnclmat'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_REPORT_cnclmat as select from ZCONSUMPTION_REP_CAL as a
//             inner join I_MfgOrderOperationComponent as b on b.ManufacturingOrder = a.Order_No 
//             and b.Reservation = a.Reservation 
//                                                                  and b.ReservationItem <> a.ReservationItem //and b.Material = a.Material_Number                                                  
                                        
{

   key a.Order_No,
   a.Plant,
   a.StartDate,
   a.EndDate,
   a.Material_Number
//   a.Reservation,
//   a.ReservationItem,
//   '' as GoodsMovement,
//   a.Quantity_withdrawn,
//   a.Header_Material,
//   a.Delivery_Quantity,
//   a.PostingDate,
//   a.Header_Product_Description,
//   a.Description,
//   a.User_Name,
//   a.Base_Qty,
//   a.Component_Base_Qty,
//   a.Requirment_Qty,
//   a.Difference
//   b.Material

}

//where b.Material <> a.Material_Number
