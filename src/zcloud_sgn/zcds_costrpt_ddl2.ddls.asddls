@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity 2 - Cost Report(Costing Data)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_costrpt_ddl2 as select distinct from I_WorkCenterCostCenter as a
left outer join I_WorkCenter as b on a.WorkCenterInternalID = b.WorkCenterInternalID and a.Plant = b.Plant
left outer join I_WorkCenterTextBySemanticKey as c on b.WorkCenter = c.WorkCenter and b.Plant = c.Plant and c.Language = 'E'
left outer join I_MfgOrderConfirmation as d on a.WorkCenterInternalID = d.WorkCenterInternalID and a.Plant = d.Plant and d.MfgOrderConfirmation = '00000001'
{
  a.CostCenter,
  a.WorkCenterInternalID,
  b.WorkCenter,
  c.WorkCenterText,
  d.ManufacturingOrder, 
  d.ProfitCenter, 
  d.PostingDate,
  d.OpWorkQuantityUnit1 as OpWorkQuantityUnit1,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit1'
  sum(d.OpConfirmedWorkQuantity1) as act1,
  d.OpWorkQuantityUnit2 as OpWorkQuantityUnit2,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit2'
  sum(d.OpConfirmedWorkQuantity2) as act2,
  d.OpWorkQuantityUnit3 as OpWorkQuantityUnit3,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit3'
  sum(d.OpConfirmedWorkQuantity3) as act3,
  d.OpWorkQuantityUnit4 as OpWorkQuantityUnit4,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit4'
  sum(d.OpConfirmedWorkQuantity4) as act4, 
  d.OpWorkQuantityUnit5 as OpWorkQuantityUnit5,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit5'
  sum(d.OpConfirmedWorkQuantity5) as act5,
  d.OpWorkQuantityUnit6 as OpWorkQuantityUnit6,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit6'
  sum(d.OpConfirmedWorkQuantity6) as act6
}
where a.CostCenterAllocation = '0001'
group by a.CostCenter,a.WorkCenterInternalID,b.WorkCenter,c.WorkCenterText,d.ManufacturingOrder,d.OpWorkQuantityUnit1,
         d.OpWorkQuantityUnit2,d.OpWorkQuantityUnit3,d.OpWorkQuantityUnit4,d.OpWorkQuantityUnit5,d.OpWorkQuantityUnit6,
         d.ProfitCenter,d.PostingDate



