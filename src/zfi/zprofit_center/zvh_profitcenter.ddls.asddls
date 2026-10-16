@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for Profit Center Search help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVH_Profitcenter 
as select from I_ProfitCenter as a
left outer join I_ProfitCenterText as b on b.ProfitCenter = a.ProfitCenter
{
  key a.ProfitCenter,
      b.ProfitCenterLongName  
}
