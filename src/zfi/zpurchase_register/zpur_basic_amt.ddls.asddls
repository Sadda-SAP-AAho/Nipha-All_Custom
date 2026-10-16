@AbapCatalog.sqlViewName: 'ZPUR_BASIC_AMT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_BASIC_AMT'
define view ZPUR_BASIC_AMT as select distinct from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
    a.AccountingDocumentItemType,
    a.TransactionTypeDetermination,
    a.OriglTaxBaseAmountInCoCodeCrcy,
    a.TaxDeterminationDate,
    a.TaxCode
} where (a.TaxItemAcctgDocItemRef = '000001' or a.TaxItemAcctgDocItemRef = '000002') and (a.TaxCode = 'DA' or a.TaxCode = 'DB'
 or a.TaxCode = 'DC' or a.TaxCode = 'DD' or a.TaxCode = 'DI' or a.TaxCode = 'DJ' or a.TaxCode = 'DK' or a.TaxCode = 'DL')
