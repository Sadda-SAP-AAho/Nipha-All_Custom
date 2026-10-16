@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accounting Document for po'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZACCOUNTING_DOC_PO as select from I_OperationalAcctgDocItem as a
{
   key a.PurchasingDocument,
   key a.PurchasingDocumentItem,
   key a.OriginalReferenceDocument, 
   key    a.AccountingDocument,
   key    a.CompanyCode,
   key    a.FiscalYear
}
where a.PurchasingDocument <> ''
group by
       a.PurchasingDocument,
       a.PurchasingDocumentItem,
       a.OriginalReferenceDocument, 
       a.AccountingDocument,
       a.CompanyCode,
       a.FiscalYear

     
