@AbapCatalog.sqlViewName: 'ZGSTRGLSA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_GLSA'
define view ZGSTR2_GLSA as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem,
AccountingDocumentType,
FiscalYear,
CompanyCode,
PurchasingDocument,
PurchasingDocumentItem,
GLAccount as GLACCOUNT_SA
}
where AccountingDocumentType = 'SA'
  and TransactionTypeDetermination = '' 
  and PostingKey = '40'
