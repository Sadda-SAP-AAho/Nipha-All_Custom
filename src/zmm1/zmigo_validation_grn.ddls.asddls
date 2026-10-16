@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MIGO validation GRN check'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMIGO_VALIDATION_GRN as select from I_PurchaseOrderHistoryAPI01 as A
{
    key A.PurchaseOrder,
    key A.PurchaseOrderItem,
    key A.Material,
    A.PurchasingHistoryCategory
}
where PurchasingHistoryCategory = 'E'
    group by
    A.PurchaseOrder,
    A.PurchaseOrderItem,
    A.Material,
    A.PurchasingHistoryCategory
    
