@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Data Maintain'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_USER_Profit 
as select from zprofit_center
{
    key syuser as UserName,
    key plant as Plant,
    key  profitcenter as ProfitCenter,
   glaccount as GLAccount,
  costcenter as CostCenter 
}
