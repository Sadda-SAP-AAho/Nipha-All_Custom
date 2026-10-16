@AbapCatalog.sqlViewName: 'ZPUR_CGST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_CGST'
define view ZPUR_CGST as select from I_OperationalAcctgDocItem
{
key AccountingDocument,
key AccountingDocumentItem,
key FiscalYear,
key CompanyCode,
TaxDeterminationDate,
TransactionTypeDetermination,
TaxItemGroup,
AmountInTransactionCurrency
//AmountInCompanyCodeCurrency  
}
where AccountingDocumentItemType = 'T' and TransactionTypeDetermination = 'JIC'
