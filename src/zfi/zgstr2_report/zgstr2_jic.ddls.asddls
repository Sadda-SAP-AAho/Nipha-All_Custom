@AbapCatalog.sqlViewName: 'ZGSTR2JIC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_JIC'
define view ZGSTR2_JIC 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TransactionTypeDetermination,
TaxItemGroup,
AmountInCompanyCodeCurrency as AMOUNT_JIC    
}
where AccountingDocumentItemType = 'T' and TransactionTypeDetermination = 'JIC'
