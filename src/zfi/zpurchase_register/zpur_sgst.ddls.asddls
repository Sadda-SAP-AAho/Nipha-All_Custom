@AbapCatalog.sqlViewName: 'ZPUR_SGST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_SGST'
define view ZPUR_SGST as select from I_OperationalAcctgDocItem
{
key AccountingDocument,
key AccountingDocumentItem,
key FiscalYear,
key CompanyCode,
TaxDeterminationDate,
TransactionTypeDetermination,
TaxItemGroup,
AmountInTransactionCurrency,
AmountInCompanyCodeCurrency  
}
where AccountingDocumentItemType = 'T' and TransactionTypeDetermination = 'JIS'
