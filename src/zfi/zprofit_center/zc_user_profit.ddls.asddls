@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Profit Center Maintain'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_USER_PROFIT 
as projection on ZI_USER_Profit
{
    key UserName,
    key Plant,
    key ProfitCenter,
    GLAccount,
    CostCenter
  }
