@AbapCatalog.sqlViewName: 'ZPUR_IGST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_IGST'
define view ZPUR_IGST as select from I_OperationalAcctgDocItem
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
where AccountingDocumentItemType = 'T' and TransactionTypeDetermination = 'JII'
