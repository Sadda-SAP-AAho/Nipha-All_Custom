@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OPERATIONAL ACCOUNTING DOC ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_OPERATIONALACCTGDOCITEM1 as select from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
        a.Supplier,
        a.OriginalReferenceDocument
 
}
where a.ReferenceDocumentType = 'MKPF'
group by 
        a.CompanyCode,
        a.AccountingDocument,
        a.FiscalYear,
        a.Supplier,
        a.OriginalReferenceDocument
