@AbapCatalog.sqlViewName: 'ZPUR_TEXT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_TEXT'
define view ZPUR_TEXT as select distinct from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
DocumentItemText 
}where TransactionTypeDetermination = 'EGK'  
