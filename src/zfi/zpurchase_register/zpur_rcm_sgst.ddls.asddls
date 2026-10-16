@AbapCatalog.sqlViewName: 'ZPUR_RCM_SGST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_RCM_SGST'
define view ZPUR_RCM_SGST as select from I_OperationalAcctgDocItem
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
  and ( TransactionTypeDetermination = 'JRS' or TransactionTypeDetermination = 'JSN')
