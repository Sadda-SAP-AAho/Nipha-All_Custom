@AbapCatalog.sqlViewName: 'ZPUR_SUPP1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_SUPP'
define view ZPUR_SUPP as select from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
Supplier
}where Supplier is not initial  
