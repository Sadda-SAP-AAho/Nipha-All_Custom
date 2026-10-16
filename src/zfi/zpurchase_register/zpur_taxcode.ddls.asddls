@AbapCatalog.sqlViewName: 'ZPUR_TAXCODE1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_Taxcode'
define view ZPUR_Taxcode as select distinct from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
    a.GLAccount,
    a.TaxCode
}where (a.AccountingDocumentType = 'KR' or a.AccountingDocumentType = 'SA' or a.AccountingDocumentType = 'KG') and a.AccountingDocumentItemType is initial  and  a.TransactionTypeDetermination is initial
