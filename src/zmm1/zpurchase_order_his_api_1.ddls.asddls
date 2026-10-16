@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PURCHASE_ORDER_HIS_API_1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPURCHASE_ORDER_HIS_API_1 as select from ZPURCHASE_ORDER_HIS_API as A left outer join Z_I_OPERATIONALACCTGDOCITEM1 as b
on A.OriginalReferenceDocument = b.OriginalReferenceDocument
{
    key A.PurchasingHistoryDocument,
    key A.PurchasingHistoryDocumentYear,
    key b.AccountingDocument,
    key b.CompanyCode,
    key b.FiscalYear,
    A.ReferenceDocumentFiscalYear,
    A.DocumentReferenceID,
    A.Supplier,
    A.OriginalReferenceDocument

    
}
