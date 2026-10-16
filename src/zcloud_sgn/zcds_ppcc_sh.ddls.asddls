@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help : PP CostCentre/Act. Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_ppcc_sh as select distinct from I_WorkCenterCostCenter as a
left outer join I_CostCenterText as c on a.CostCenter = c.CostCenter and a.ControllingArea = c.ControllingArea and c.Language = 'E'
left outer join I_CostCenterActivityTypeText as h on a.CostCtrActivityType = h.CostCtrActivityType and h.Language = 'E'
{
 key a.CostCenter,
 key a.CostCtrActivityType,
     c.CostCenterName,
     h.CostCtrActivityTypeName
       
}
