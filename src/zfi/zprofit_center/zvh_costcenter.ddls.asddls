@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for Cost Center Search help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVH_COSTCENTER 
as select from I_CostCenter as a
left outer join I_CostCenterText as b on b.CostCenter = a.CostCenter
{
  key a.CostCenter,
     b.CostCenterDescription    
}
