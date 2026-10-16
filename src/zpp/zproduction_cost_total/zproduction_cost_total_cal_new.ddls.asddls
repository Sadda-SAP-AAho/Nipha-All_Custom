@EndUserText.label: 'ZPRODUCTION_COST_CENTRE_NES'
@Metadata.ignorePropagatedAnnotations: true

define view entity  ZPRODUCTION_COST_TOTAL_CAL_NEW 
with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date

    as select from  ZPRODUCTION_COST_Total_CAL  ( Fromto : $parameters.Fromto , endto : $parameters.endto ) as A
    //left outer join ZPRODUCTION_COST_CAL22(Fromto:  $parameters.Fromto)  as b on ( b.Order_No = A.Order_No and b.PostingDate = A.PostingDate )

   {
   
    A.Order_No,
    A.PostingDate,

    sum(A.Confirm_qty) as Confirm_qty,
    sum(A.Activity1_Amount) as Activity1_Amount,
    sum(A.Activity2_Amount) as Activity2_Amount,
    sum(A.Activity3_Amount) as Activity3_Amount,
    sum(A.Activity4_Amount) as Activity4_Amount,
    sum(A.Activity5_Amount) as Activity5_Amount,
    sum(A.Activity6_Amount) as Activity6_Amount,
    
    sum(A.Component_Amount_TOTAL) as Component_Amount_TOTAL 
   } 
   where
      A.PostingDate >= $parameters.Fromto
  and A.PostingDate <= $parameters.endto
   group by
   A.Order_No,
   A.PostingDate
