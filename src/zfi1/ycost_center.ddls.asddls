@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YCOST_CENTER as select from I_CostCenter as a
{
    key a.CostCenter,
        a.ProfitCenter,
        substring(a.CostCenter,1,4) as plant
        

}
 group by
      a.CostCenter,
      a.ProfitCenter
      
