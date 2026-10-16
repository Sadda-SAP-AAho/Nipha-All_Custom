@EndUserText.label: 'ZPRODUCTION_COST_CENTRE'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZPRODUCTION_COST_CAL
  with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date


  as select from ZPRODUCTION_COST_TOTAL_NEW   ( Fromto : $parameters.Fromto , endto : $parameters.endto ) as A
  //left outer join ZPRODUCTION_COST_CAL22(Fromto:  $parameters.Fromto)  as b on ( b.Order_No = A.Order_No and b.PostingDate = A.PostingDate )

{

  A.Order_No,
  A.GoodsMovement,
  A.Plant,
  A.header_material,
  A.Component,
  A.Withdraw_qty,
  A.Confirm_qty,
  A.PostingDate,
  A.Header__Unit_Price_standard,
  A.Header_Unit_Price_moving,
  A.Currency,
  A.Component__Unit_Price_standard,
  A.Component_Unit_Price_moving,
  case when A.Component_Unit_Price_moving is not initial then
  A.Withdraw_qty * A.Component_Unit_Price_moving
  when A.Component__Unit_Price_standard is not initial then A.Withdraw_qty * A.Component__Unit_Price_standard end as Component_Amount,
  A.Activity_Quantity1,
  A.Activity_Unit1,
  A.Activity_Name1,
  A.Activity1_Unit_Price,
  A.Activity_Quantity1 * A.Activity1_Unit_Price                                                                   as Activity1_Amount,
  A.Activity_Quantity2,
  A.Activity_Unit2,
  A.Activity_Name2,
  A.Activity2_Unit_Price,
  A.Activity_Quantity2 * A.Activity2_Unit_Price                                                                   as Activity2_Amount,
  A.Activity_Quantity3,
  A.Activity_Unit3,
  A.Activity_Name3,
  A.Activity3_Unit_Price,
  A.Activity_Quantity3 * A.Activity3_Unit_Price                                                                   as Activity3_Amount,
  A.Activity_Quantity4,
  A.Activity_Unit4,
  A.Activity_Name4,
  A.Activity4_Unit_Price,
  A.Activity_Quantity4 * A.Activity4_Unit_Price                                                                   as Activity4_Amount,
  A.Activity_Quantity5,
  A.Activity_Unit5,
  A.Activity_Name5,
  A.Activity5_Unit_Price,
  A.Activity_Quantity5 * A.Activity5_Unit_Price                                                                   as Activity5_Amount,
  A.Activity_Quantity6,
  A.Activity_Unit6,
  A.Activity_Name6,
  A.Activity6_Unit_Price,
  A.Activity_Quantity6 * A.Activity6_Unit_Price                                                                   as Activity6_Amount,
  A.Confirm_qty * A.Header__Unit_Price_standard                                                                   as Header_Amount
  //    A.Component_Unit_Price_moving + A.Activity1_Unit_Price + A.Activity2_Unit_Price + A.Activity3_Unit_Price +
  //    A.Activity4_Unit_Price + A.Activity5_Unit_Price + A.Activity6_Unit_Price as Total_Amt

  //    ( cast( case when Component_Unit_Price_moving is not null then Component_Unit_Price_moving  else 0 end as abap.dec( 16, 3 ) ) ) +
  //    ( cast( case when M.AMOUNT_PAYCGST is not null then M.AMOUNT_PAYCGST  else 0 end as abap.dec( 16, 3 ) ) ) +
  //    ( cast( case when N.AMOUNT_PAYIGST is not null then N.AMOUNT_PAYIGST  else 0 end as abap.dec( 16, 3 ) ) ) as TOTAL_RCM_PAYABLE

}
where
      A.PostingDate >= $parameters.Fromto
  and A.PostingDate <= $parameters.endto
