@AbapCatalog.sqlViewName: 'ZGSTR2JII'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_JII'
define view ZGSTR2_JII 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TaxItemGroup,
AmountInCompanyCodeCurrency as AMOUNT_JII    
}
where AccountingDocumentItemType = 'T' 
and TransactionTypeDetermination = 'JII'  
