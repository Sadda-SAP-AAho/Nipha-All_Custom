@AbapCatalog.sqlViewName: 'ZGSTR2GLKR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_GLKR'
define view ZGSTR2_GLKR as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem,
FiscalYear,
CompanyCode,
PurchasingDocument,
PurchasingDocumentItem,
AccountingDocumentType,
GLAccount as GLACCOUNT_KR

}
where AccountingDocumentType = 'KR'
  and TransactionTypeDetermination = ''

  
