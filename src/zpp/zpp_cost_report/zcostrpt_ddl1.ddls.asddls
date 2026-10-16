@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Report DDL1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcostrpt_ddl1
with parameters
     P_StartDate : vdm_v_start_date ,
     P_EndDate   : vdm_v_end_date 
//     period      : abap.numc( 3 )   
 as select distinct from I_OperationalAcctgDocItem as a
left outer join I_GLAccountText as b on a.GLAccount = b.GLAccount and a.ChartOfAccounts = b.ChartOfAccounts and b.Language = 'E'
left outer join I_CostCenterText as c on a.CostCenter = c.CostCenter and a.ControllingArea = c.ControllingArea and c.Language = 'E'
inner join zfippmap as d on (a.CostCenter = d.commcc1 and a.GLAccount = d.gl) 
or (a.CostCenter = d.commcc2 and a.GLAccount = d.gl) or (a.CostCenter = d.deptcc and a.GLAccount = d.gl)
inner join zcostrpt_ddl2( P_StartDate: $parameters.P_StartDate , P_EndDate: $parameters.P_EndDate )  as e on
                                d.prdcc = e.CostCenter  and e.ManufacturingOrder <> '' 
left outer join I_CostCenterActivityTypeText as f on d.act_type = f.CostCtrActivityType and f.Language = 'E'
//Check activity type 
inner join I_WorkCenterCostCenter as g on e.WorkCenterInternalID = g.WorkCenterInternalID and d.prdcc = g.CostCenter
and g.CostCtrActivityType = d.act_type
left outer join I_MfgOrderConfirmation as H on H.ManufacturingOrder = e.ManufacturingOrder 

left outer join Zcost_amt_tot as amt on amt.GLAccount = a.GLAccount and amt.FiscalYear = a.FiscalYear and amt.FiscalPeriod = a.FiscalPeriod
                                            
//left outer join ZCost_Reverse as cos on a.AccountingDocument = cos.AccountingDocument and  a.PostingDate = cos.PostingDate 
//                                and a.FiscalYear = cos.FiscalYear and a.FiscalPeriod = cos.FiscalPeriod
//Check activity type 
{
  a.GLAccount,
  b.GLAccountName,
  a.CostCenter,
  c.CostCenterName,
  a.AccountingDocument,
  a.FiscalYear,
  a.FiscalPeriod,
  a.PostingDate,
  a.CompanyCodeCurrency as CompanyCodeCurrency,  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  a.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,
//  amt.CompanyCodeCurrency,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  amt.AmountInCompanyCodeCurrency as totAmountInCompanyCodeCurrency,
//  cos.ReverseDocument,
  d.prdcc,
  d.act_type as ActType,
  f.CostCtrActivityTypeName,
  d.act_cat as ActCat, 
  e.WorkCenterInternalID,
  e.WorkCenter,
  e.WorkCenterText,
  e.ManufacturingOrder,
  e.ProfitCenter,
//  H.PostingDate as MO_POSTINGDATE,
  e.MO_POSTINGDATE,
  case d.act_cat
  when 'ACT1' then e.OpWorkQuantityUnit1
  when 'ACT2' then e.OpWorkQuantityUnit2
  when 'ACT3' then e.OpWorkQuantityUnit3
  when 'ACT4' then e.OpWorkQuantityUnit4
  when 'ACT5' then e.OpWorkQuantityUnit5
  when 'ACT6' then e.OpWorkQuantityUnit6
  end as OpWorkQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
  case d.act_cat
  when 'ACT1' then e.act1
  when 'ACT2' then e.act2
  when 'ACT3' then e.act3
  when 'ACT4' then e.act4
  when 'ACT5' then e.act5
  when 'ACT6' then e.act6
  end as act

}
where a.CostCenter <> ''
and e.MO_POSTINGDATE >= $parameters.P_StartDate
and e.MO_POSTINGDATE <= $parameters.P_EndDate

//and a.FiscalPeriod = $parameters.period

        
