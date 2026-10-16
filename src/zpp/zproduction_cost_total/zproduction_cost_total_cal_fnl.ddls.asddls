@EndUserText.label: 'ZPRODUCTION_COST_CENTRE_N'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZPRODUCTION_COST_TOTAL_CAL_FNL
  with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date

  as select from    ZPRODUCTION_COST_CAL  ( Fromto : $parameters.Fromto , endto : $parameters.endto )   as A       
    left outer join ZPRODUCTION_COST_TOTAL_CAL_NEW ( Fromto : $parameters.Fromto , endto : $parameters.endto ) 
    as b on( b.Order_No        = A.Order_No
      and b.PostingDate = A.PostingDate
    ) //( Fromto : $parameters.Fromto , endto : $parameters.endto ) 
      

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
  A.Component_Amount,
  A.Activity_Quantity1,
  A.Activity_Unit1,
  A.Activity_Name1,
  A.Activity1_Unit_Price,
  A.Activity1_Amount,
  A.Activity_Quantity2,
  A.Activity_Unit2,
  A.Activity_Name2,
  A.Activity2_Unit_Price,
  A.Activity2_Amount,
  A.Activity_Quantity3,
  A.Activity_Unit3,
  A.Activity_Name3,
  A.Activity3_Unit_Price,
  A.Activity3_Amount,
  A.Activity_Quantity4,
  A.Activity_Unit4,
  A.Activity_Name4,
  A.Activity4_Unit_Price,
  A.Activity4_Amount,
  A.Activity_Quantity5,
  A.Activity_Unit5,
  A.Activity_Name5,
  A.Activity5_Unit_Price,
  A.Activity5_Amount,
  A.Activity_Quantity6,
  A.Activity_Unit6,
  A.Activity_Name6,
  A.Activity6_Unit_Price,
  A.Activity6_Amount,
  A.Header_Amount,
  //    A.Total_Amt,

  cast(( ( cast( case when b.Component_Amount_TOTAL is not null then b.Component_Amount_TOTAL  else 0 end as abap.dec( 13, 3 ) ) ) +
   ( cast( case when b.Activity1_Amount is not null then b.Activity1_Amount  else 0 end as abap.dec( 13, 3 ) ) ) +
   ( cast( case when b.Activity2_Amount is not null then b.Activity2_Amount  else 0 end as abap.dec( 13, 3 ) ) ) +
   ( cast( case when b.Activity3_Amount is not null then b.Activity3_Amount  else 0 end as abap.dec( 13, 3 ) ) ) +
   ( cast( case when b.Activity4_Amount is not null then b.Activity4_Amount  else 0 end as abap.dec( 13, 3 ) ) ) +
   ( cast( case when b.Activity5_Amount is not null then b.Activity5_Amount  else 0 end as abap.dec( 13, 3 ) ) ) +
   ( cast( case when b.Activity6_Amount is not null then b.Activity6_Amount  else 0 end as abap.dec( 13, 3 ) ) ) ) / b.Confirm_qty as abap.dec( 13, 3 ) ) as Total_Amt


}
where A.PostingDate >= $parameters.Fromto and 
A.PostingDate <= $parameters.endto
