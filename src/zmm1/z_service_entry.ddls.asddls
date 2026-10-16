@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Entry Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_SERVICE_ENTRY as select from I_PurchaseOrderHistoryAPI01 as a
{
    key a.PurchasingHistoryDocument,
    a.PostingDate
    
}
where a.PurchasingHistoryCategory = '0'
 group by
    a.PurchasingHistoryDocument,
    a.PostingDate  
