@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Cost Center Base View'
define view entity ZPRODUCTION_Cost_CenterNew
  with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date
  as select from zcostrpt_ddl3(P_StartDate : $parameters.Fromto , P_EndDate : $parameters.endto ) as a
{
  key a.ManufacturingOrder,
  key a.WorkCenterInternalID,
//      a.ManufacturingOrder,
      a.ActType  as CostCtrActivityType,
      a.FiscalPeriod,
      a.PostingDate,
      a.act_rate as AmountInCompanyCodeCurrency
}
where
      a.ActType        <> ''
  and a.PostingDate >= $parameters.Fromto
  and a.PostingDate <= $parameters.endto
