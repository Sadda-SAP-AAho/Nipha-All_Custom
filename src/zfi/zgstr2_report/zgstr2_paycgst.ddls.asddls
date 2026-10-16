@AbapCatalog.sqlViewName: 'ZGSTR2PAYCGST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_PAYCGST'
define view ZGSTR2_PAYCGST  
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TaxItemGroup,
AmountInCompanyCodeCurrency as AMOUNT_PAYCGST    
}
where AccountingDocumentItemType = 'T' 
  and ( TransactionTypeDetermination = 'JRC' or TransactionTypeDetermination = 'JCN' )
