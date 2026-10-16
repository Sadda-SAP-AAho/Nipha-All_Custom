@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Req. item data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Y_I_PURCHASEREQUISITIONITEM as select from I_PurchaseRequisitionItemAPI01 as a
{
    key a.PurchaseRequisition,
    a.PurReqCreationDate
    
}  
group by
 a.PurchaseRequisition,
 a.PurReqCreationDate
 
 