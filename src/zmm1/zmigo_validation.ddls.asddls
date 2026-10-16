@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MIGO validation until miro Done'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIGO_VALIDATION as select from I_PurchaseOrderHistoryAPI01 as A
{
    key A.PurchaseOrder,
    key A.PurchaseOrderItem,
    key A.Material,
    A.PurchasingHistoryCategory
}
where PurchasingHistoryCategory = 'Q'
    group by
    A.PurchaseOrder,
    A.PurchaseOrderItem,
    A.Material,
    A.PurchasingHistoryCategory
    
