@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Cost Report zcostrpt_ddl21'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcostrpt_ddl21 
with parameters  
    P_StartDate : vdm_v_start_date,
    P_EndDate   : vdm_v_end_date
 as select distinct from zcostrpt_ddl2( P_StartDate:$parameters.P_StartDate , P_EndDate:$parameters.P_EndDate  ) as a
 left outer join ZCOSTRPT_DDL11( P_StartDate:$parameters.P_StartDate , P_EndDate:$parameters.P_EndDate  ) as b on
                                ( a.WorkCenterInternalID = b.WorkCenterInternalID and a.ManufacturingOrder = b.ManufacturingOrder )
{
   a.CostCenter,
   a.WorkCenterInternalID,
   a.WorkCenter,
   a.WorkCenterText,
   a.ManufacturingOrder,
   a.ProfitCenter,
   a.MO_POSTINGDATE,
   a.mfgorder,
   b.GLAccount,
   b.FiscalPeriod,
   b.FiscalYear,
   b.ActType,
   b.ActCat,
   case b.ActCat
  when 'ACT1' then a.OpWorkQuantityUnit1
  when 'ACT2' then a.OpWorkQuantityUnit2
  when 'ACT3' then a.OpWorkQuantityUnit3
  when 'ACT4' then a.OpWorkQuantityUnit4
  when 'ACT5' then a.OpWorkQuantityUnit5
  when 'ACT6' then a.OpWorkQuantityUnit6
  end as OpWorkQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
  case b.ActCat
  when 'ACT1' then a.act1
  when 'ACT2' then a.act2
  when 'ACT3' then a.act3
  when 'ACT4' then a.act4
  when 'ACT5' then a.act5
  when 'ACT6' then a.act6
  end as act
  }
where 
 a.MO_POSTINGDATE >= $parameters.P_StartDate
and a.MO_POSTINGDATE  <= $parameters.P_EndDate
and b.WorkCenterInternalID is not null

