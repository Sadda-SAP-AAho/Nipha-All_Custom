@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Puchase oder history API 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPURCHASE_ORDER_HIS_API as select from I_PurchaseOrderHistoryAPI01 as a left outer join I_PurchaseOrderAPI01 as b
  on a.PurchaseOrder = b.PurchaseOrder
{
    key a.PurchasingHistoryDocument,
    key a.PurchasingHistoryDocumentYear,
        a.ReferenceDocumentFiscalYear,
        a.DocumentReferenceID,
        b.Supplier,
        concat(a.PurchasingHistoryDocument,a.PurchasingHistoryDocumentYear) as OriginalReferenceDocument
        
}
   group by
       a.PurchasingHistoryDocument,
       a.PurchasingHistoryDocumentYear,
       a.ReferenceDocumentFiscalYear,
       a.DocumentReferenceID,
       b.Supplier
