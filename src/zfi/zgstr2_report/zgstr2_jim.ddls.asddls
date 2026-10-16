@AbapCatalog.sqlViewName: 'ZGSTR2JIM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_JIM'
define view ZGSTR2_JIM as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TransactionTypeDetermination,
TaxItemGroup,
AmountInCompanyCodeCurrency as AMOUNT_JIM    
}
where AccountingDocumentItemType = 'T' and TransactionTypeDetermination = 'JIM'
