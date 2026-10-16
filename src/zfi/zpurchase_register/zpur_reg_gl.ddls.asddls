@AbapCatalog.sqlViewName: 'ZPUR_REG_GL1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_REG_GL'
define view ZPUR_REG_GL as select distinct from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
    key a.AccountingDocumentItem,
    a.AccountingDocumentItemType,
    a.TransactionTypeDetermination,
    a.GLAccount,
    a.TaxCode
} where (a.AccountingDocumentType = 'KR' or a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'SA') and a.AccountingDocumentItemType is initial  and  a.TransactionTypeDetermination is initial
