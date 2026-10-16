@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Cost Center Base View new'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPRODUCTION_COST_center_new
  with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date

  as select from    ZPRODUCTION_Cost_CenterNew ( Fromto : $parameters.Fromto , endto : $parameters.endto ) as b

    left outer join zfippmap as c on c.act_type = b.CostCtrActivityType
{
  key    b.WorkCenterInternalID,
  key    b.ManufacturingOrder,
         b.CostCtrActivityType,
         b.FiscalPeriod,
         c.act_cat,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT1'
         then b.CostCtrActivityType
         else null end as Activity_Name1,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT1'
         then b.AmountInCompanyCodeCurrency
         else null end as Activity1_Unit_Price,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT2'
         then b.CostCtrActivityType
         else null end as Activity_Name2,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT2'
         then b.AmountInCompanyCodeCurrency
         else null end as Activity2_Unit_Price,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT3'
         then b.CostCtrActivityType
         else null end as Activity_Name3,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT3'
         then b.AmountInCompanyCodeCurrency
         else null end as Activity3_Unit_Price,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT4'
         then b.CostCtrActivityType
         else null end as Activity_Name4,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT4'
         then b.AmountInCompanyCodeCurrency
         else null end as Activity4_Unit_Price,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT5'
         then b.CostCtrActivityType
         else null end as Activity_Name5,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT5'
         then b.AmountInCompanyCodeCurrency
         else null end as Activity5_Unit_Price,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT6'
         then b.CostCtrActivityType
         else null end as Activity_Name6,

         case when b.CostCtrActivityType = c.act_type and c.act_cat = 'ACT6'
         then b.AmountInCompanyCodeCurrency
         else null end as Activity6_Unit_Price
}
where b.PostingDate >= $parameters.Fromto
  and b.PostingDate <= $parameters.endto
group by
  b.CostCtrActivityType,
  b.ManufacturingOrder,
  b.FiscalPeriod,
  b.AmountInCompanyCodeCurrency,
  c.act_type,
  c.act_cat,b.WorkCenterInternalID
