@AbapCatalog.sqlViewName: 'ZPUR_RCM_CGST1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_RCM_CGST'
define view ZPUR_RCM_CGST as select from I_OperationalAcctgDocItem
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
  and ( TransactionTypeDetermination = 'JRC' or TransactionTypeDetermination = 'JCN')
