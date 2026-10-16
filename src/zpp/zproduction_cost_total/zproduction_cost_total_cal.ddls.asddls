@EndUserText.label: 'ZPRODUCTION_COST_CENTRE_N'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZPRODUCTION_COST_Total_CAL
  with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date

  as select from ZPRODUCTION_COST_CAL  ( Fromto : $parameters.Fromto , endto : $parameters.endto ) as A
  //left outer join ZPRODUCTION_COST_CAL22(Fromto:  $parameters.Fromto)  as b on ( b.Order_No = A.Order_No and b.PostingDate = A.PostingDate )

{

  A.Order_No,
  A.PostingDate,
  Confirm_qty,
  Activity1_Amount,
  Activity2_Amount,
  Activity3_Amount,
  Activity4_Amount,
  Activity5_Amount,
  Activity6_Amount,

  sum(A.Component_Amount) as Component_Amount_TOTAL


}

where
      A.PostingDate >= $parameters.Fromto
  and A.PostingDate <= $parameters.endto

group by
  A.Order_No,
  A.Confirm_qty,
  A.Activity1_Amount,
  A.Activity2_Amount,
  A.Activity3_Amount,
  A.Activity4_Amount,
  A.Activity5_Amount,
  A.Activity6_Amount,
  A.PostingDate
