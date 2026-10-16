@AbapCatalog.sqlViewName: 'ZGSTR2NOCRRE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_NOCRRE'
define view ZGSTR2_NOCRRE as select from ZGSTR2_NOCR_TBA as A
left outer join ZGSTR2_NOCREDIT_TBA as B on ( B.AccountingDocument = A.AccountingDocument and B.TaxItem = A.TaxItemGroup )

{
A.AccountingDocument,
A.AccountingDocumentItem,
A.FiscalYear,
A.CompanyCode,
A.AMLOUNT_NOCR_TBA,
A.TaxCode,
A.TaxItemGroup,
//B.AMLOUNT_NOCR_TBA as NOCRRE_TBA,
B.TaxItem    
}
