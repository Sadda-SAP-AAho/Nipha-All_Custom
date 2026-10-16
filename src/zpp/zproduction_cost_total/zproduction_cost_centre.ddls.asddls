@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPRODUCTION_COST_CENTRE'
define view entity ZPRODUCTION_COST_CENTRE
  // with parameters
  //    Fromto  : vdm_v_start_date ,
  //    endto    : vdm_v_end_date
  
      as select from  I_WorkCenterCostCenter as A
      left outer join zfippmap as b on b.prdcc = A.CostCenter and b.act_type = A.CostCtrActivityType
               left outer join zcds_costrpt_ddl3
  
                                    as c on c.GLAccount = b.gl and c.ActType = b.act_type
      //zcds_costrpt_ddl4s
      {
  
      key A.CostCtrActivityType,
      key A.WorkCenterInternalID,
      A.CostCenter,
      c.ManufacturingOrder,
  //    cast(sum(c.act_rate) as abap.dec( 13,3 )) as AmountInCompanyCodeCurrency
      c.act_rate as AmountInCompanyCodeCurrency
      //cast( cast(b.AmountInCompanyCodeCurrency as abap.dec(23,3)) / c.act as abap.dec( 23, 3 )) as act_rate,
  
  
  
      }
      where A.CostCtrActivityType <> ''
      
      
      
      
      
  //    and c.PostingDate <= $parameters.Fromto
  //    and c.PostingDate >= $parameters.endto
  
  //    group by
  //    A.WorkCenterInternalID,
  //    A.CostCenter,
  //    A.CostCtrActivityType
//  with parameters
//    Fromto : vdm_v_start_date,
//    endto  : vdm_v_end_date
//
//  as select from zcostrpt_ddl3(P_StartDate : $parameters.Fromto , P_EndDate : $parameters.endto ) as a 
//{
//
//  key a.ActType  as CostCtrActivityType,
//  key a.WorkCenterInternalID,
//      a.CostCenter,
//      a.ManufacturingOrder,
//      a.FiscalPeriod,
//      //    cast(sum(c.act_rate) as abap.dec( 13,3 )) as AmountInCompanyCodeCurrency
//      a.act_rate as AmountInCompanyCodeCurrency
//      //cast( cast(b.AmountInCompanyCodeCurrency as abap.dec(23,3)) / c.act as abap.dec( 23, 3 )) as act_rate,
//
//}
//where
//      a.ActType        <> '' 
//  and a.MO_POSTINGDATE >= $parameters.Fromto
//  and a.MO_POSTINGDATE <= $parameters.endto
