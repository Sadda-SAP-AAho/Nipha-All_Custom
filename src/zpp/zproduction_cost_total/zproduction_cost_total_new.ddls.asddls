//@AbapCatalog.sqlViewName: 'YCO_REPN'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPRD_COST_REP'
define view entity ZPRODUCTION_COST_TOTAL_NEW
  with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date

  as select from    ZPRODUCTION_COST_TOTAL_VS2     as A
    left outer join I_ProductValuationBasic        as b  on( b.Product            = A.header_material and b.ValuationArea  = A.Plant )
    left outer join I_ProductValuationBasic        as bb on( bb.Product           = A.Material_Number and bb.ValuationArea = A.Plant )
    left outer join I_ManufacturingOrderOperation  as c  on  c.ManufacturingOrder = A.Order_No        and c.Plant          = A.Plant

//        left outer join ZPRODUCTION_COST_CENTRE //( Fromto : $parameters.Fromto , endto : $parameters.endto )
//                                                      as d  on  d.WorkCenterInternalID = c.WorkCenterInternalID
//                                                            and d.CostCtrActivityType  = c.CostCtrActivityType1
//                                                            and d.ManufacturingOrder   = A.Order_No
//  
//        left outer join ZPRODUCTION_COST_CENTRE //( Fromto : $parameters.Fromto , endto : $parameters.endto )
//                                                      as e  on  e.WorkCenterInternalID = c.WorkCenterInternalID
//                                                            and e.CostCtrActivityType  = c.CostCtrActivityType2
//                                                            and e.ManufacturingOrder   = A.Order_No
//  
//        left outer join ZPRODUCTION_COST_CENTRE //( Fromto : $parameters.Fromto , endto : $parameters.endto )
//                                                      as f  on  f.WorkCenterInternalID = c.WorkCenterInternalID
//                                                            and f.CostCtrActivityType  = c.CostCtrActivityType3
//                                                            and f.ManufacturingOrder   = A.Order_No
//  
//        left outer join ZPRODUCTION_COST_CENTRE //( Fromto : $parameters.Fromto , endto : $parameters.endto )
//                                                      as g  on  g.WorkCenterInternalID = c.WorkCenterInternalID
//                                                            and g.CostCtrActivityType  = c.CostCtrActivityType4
//                                                            and g.ManufacturingOrder   = A.Order_No
//  
//        left outer join ZPRODUCTION_COST_CENTRE //( Fromto : $parameters.Fromto , endto : $parameters.endto )
//                                                      as h  on  h.WorkCenterInternalID = c.WorkCenterInternalID
//                                                            and h.CostCtrActivityType  = c.CostCtrActivityType5
//                                                            and h.ManufacturingOrder   = A.Order_No
//  
//        left outer join ZPRODUCTION_COST_CENTRE //( Fromto : $parameters.Fromto , endto : $parameters.endto )
//                                                      as i  on  i.WorkCenterInternalID = c.WorkCenterInternalID
//                                                            and i.CostCtrActivityType  = c.CostCtrActivityType6
//                                                            and i.ManufacturingOrder   = A.Order_No

    left outer join ZPRODUCTION_COST_center_new( Fromto : $parameters.Fromto , endto : $parameters.endto ) as d  on  d.Activity_Name1       = c.CostCtrActivityType1
                                                                                                                 and d.ManufacturingOrder   = A.Order_No
//                                                                                                                 and d.WorkCenterInternalID = c.WorkCenterInternalID
                                                                                                                 

    left outer join ZPRODUCTION_COST_center_new( Fromto : $parameters.Fromto , endto : $parameters.endto ) as e  on  e.Activity_Name2       = c.CostCtrActivityType2
                                                                                                                 and e.ManufacturingOrder   = A.Order_No
//                                                                                                                 and e.WorkCenterInternalID = c.WorkCenterInternalID
                                                                                                                 

    left outer join ZPRODUCTION_COST_center_new( Fromto : $parameters.Fromto , endto : $parameters.endto ) as f  on  f.Activity_Name3       = c.CostCtrActivityType3
                                                                                                                 and f.ManufacturingOrder   = A.Order_No
//                                                                                                                 and f.WorkCenterInternalID = c.WorkCenterInternalID
                                                                                                                 

    left outer join ZPRODUCTION_COST_center_new( Fromto : $parameters.Fromto , endto : $parameters.endto ) as g  on  g.Activity_Name4       = c.CostCtrActivityType4
                                                                                                                 and g.ManufacturingOrder   = A.Order_No
//                                                                                                                 and g.WorkCenterInternalID = c.WorkCenterInternalID
                                                                                                                 

    left outer join ZPRODUCTION_COST_center_new( Fromto : $parameters.Fromto , endto : $parameters.endto ) as h  on  h.Activity_Name5       = c.CostCtrActivityType5
                                                                                                                 and h.ManufacturingOrder   = A.Order_No
//                                                                                                                 and h.WorkCenterInternalID = c.WorkCenterInternalID
                                                                                                                 

    left outer join ZPRODUCTION_COST_center_new( Fromto : $parameters.Fromto , endto : $parameters.endto ) as i  on  i.Activity_Name6       = c.CostCtrActivityType6
                                                                                                                 and i.ManufacturingOrder   = A.Order_No
//                                                                                                                 and i.WorkCenterInternalID = c.WorkCenterInternalID
                                                                                                                 
{

  A.Order_No,
  A.GoodsMovement,
  A.Plant,
  A.header_material,
  A.Material_Number                                        as Component,
  A.QuantityInEntryUnit                                    as Withdraw_qty,
  A.Delivery_Quantity                                      as Confirm_qty,
  A.PostingDate,
  //A.ProductDescription,
  case when
  b.InventoryValuationProcedure = 'S'
  then cast(b.StandardPrice as abap.dec( 13,3 )) end       as Header__Unit_Price_standard,
  case when
  b.InventoryValuationProcedure = 'V'
  then cast(b.MovingAveragePrice as abap.dec( 13,3 )) end  as Header_Unit_Price_moving,
  b.Currency,
  case when
  bb.InventoryValuationProcedure = 'S'
  then cast(bb.StandardPrice as abap.dec( 13,3 )) end      as Component__Unit_Price_standard,
  case when
  bb.InventoryValuationProcedure = 'V'
  then cast(bb.MovingAveragePrice as abap.dec( 13,3 )) end as Component_Unit_Price_moving,

  A.OpConfirmedWorkQuantity1                               as Activity_Quantity1,
  A.OpWorkQuantityUnit1                                    as Activity_Unit1,
//      d.AmountInCompanyCodeCurrency                            as Activity1_Unit_Price,
  c.CostCtrActivityType1                                   as Activity_Name1,
  d.Activity1_Unit_Price,

  A.OpConfirmedWorkQuantity2                               as Activity_Quantity2,
  A.OpWorkQuantityUnit2                                    as Activity_Unit2,
//      e.AmountInCompanyCodeCurrency                            as Activity2_Unit_Price,
  c.CostCtrActivityType2                                   as Activity_Name2,
  e.Activity2_Unit_Price,

  A.OpConfirmedWorkQuantity3                               as Activity_Quantity3,
  A.OpWorkQuantityUnit3                                    as Activity_Unit3,
//      f.AmountInCompanyCodeCurrency                            as Activity3_Unit_Price,
  c.CostCtrActivityType3                                   as Activity_Name3,
  f.Activity3_Unit_Price,

  A.OpConfirmedWorkQuantity4                               as Activity_Quantity4,
  A.OpWorkQuantityUnit4                                    as Activity_Unit4,
//      g.AmountInCompanyCodeCurrency                            as Activity4_Unit_Price,
  c.CostCtrActivityType4                                   as Activity_Name4,
  g.Activity4_Unit_Price,

  A.OpConfirmedWorkQuantity5                               as Activity_Quantity5,
  A.OpWorkQuantityUnit5                                    as Activity_Unit5,
//      h.AmountInCompanyCodeCurrency                            as Activity5_Unit_Price,
  c.CostCtrActivityType5                                   as Activity_Name5,
  h.Activity5_Unit_Price,

  A.OpConfirmedWorkQuantity6                               as Activity_Quantity6,
  A.OpWorkQuantityUnit6                                    as Activity_Unit6,
//      i.AmountInCompanyCodeCurrency                            as Activity6_Unit_Price,
  c.CostCtrActivityType6                                   as Activity_Name6,
  i.Activity6_Unit_Price

}
where
      A.PostingDate >= $parameters.Fromto
  and A.PostingDate <= $parameters.endto


group by
  A.Order_No,
  A.Plant,
  A.header_material,
  A.Material_Number,
  A.GoodsMovement,
  A.QuantityInEntryUnit,
  A.Delivery_Quantity,
  A.PostingDate,
  b.InventoryValuationProcedure,
  b.StandardPrice,
  b.MovingAveragePrice,
  bb.InventoryValuationProcedure,
  b.MovingAveragePrice,
  b.Currency,
  bb.StandardPrice,
  bb.MovingAveragePrice,
  A.OpConfirmedWorkQuantity1,
  A.OpWorkQuantityUnit1,
  c.CostCtrActivityType1,
  d.Activity1_Unit_Price,
  A.OpConfirmedWorkQuantity2,
  A.OpWorkQuantityUnit2,
  c.CostCtrActivityType2,
  e.Activity2_Unit_Price,
  A.OpConfirmedWorkQuantity3,
  A.OpWorkQuantityUnit3,
  c.CostCtrActivityType3,
  f.Activity3_Unit_Price,
  A.OpConfirmedWorkQuantity4,
  A.OpWorkQuantityUnit4,
  c.CostCtrActivityType4,
  g.Activity4_Unit_Price,
  A.OpConfirmedWorkQuantity5,
  A.OpWorkQuantityUnit5,
  c.CostCtrActivityType5,
  h.Activity5_Unit_Price,
  A.OpConfirmedWorkQuantity6,
  A.OpWorkQuantityUnit6,
  c.CostCtrActivityType6,
  i.Activity6_Unit_Price

