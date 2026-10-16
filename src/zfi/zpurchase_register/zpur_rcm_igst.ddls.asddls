@AbapCatalog.sqlViewName: 'ZPUR_RCM_IGST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_RCM_IGST'
define view ZPUR_RCM_IGST as select from I_OperationalAcctgDocItem
{
key AccountingDocument,
key FiscalYear,
key CompanyCode,
key AccountingDocumentItem,
TaxDeterminationDate,
TaxItemGroup,
AmountInTransactionCurrency,
AmountInCompanyCodeCurrency   
}
where AccountingDocumentItemType = 'T' 
  and ( TransactionTypeDetermination = 'JRI' or TransactionTypeDetermination = 'JIN')
