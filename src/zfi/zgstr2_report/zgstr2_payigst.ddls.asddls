@AbapCatalog.sqlViewName: 'ZGSTR2PAYIGST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_PAYIGST'
define view ZGSTR2_PAYIGST 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TaxItemGroup,
AmountInCompanyCodeCurrency as AMOUNT_PAYIGST    
}
where AccountingDocumentItemType = 'T' 
  and ( TransactionTypeDetermination = 'JRI' or TransactionTypeDetermination = 'JIN' )
