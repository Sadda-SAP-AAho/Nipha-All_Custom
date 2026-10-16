@AbapCatalog.sqlViewName: 'ZPUR_REG_AMT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_REG_INV_AMT'
define view ZPUR_REG_INV_AMT as select distinct from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
    a.AccountingDocumentItemType,
    a.TransactionTypeDetermination,
    a.AmountInCompanyCodeCurrency,
    a.OriglTaxBaseAmountInCoCodeCrcy,
    a.TaxDeterminationDate,
    a.TaxCode,
    a.GLAccount,
    a.TaxItemGroup
} where (a.TaxItemAcctgDocItemRef = '000001' or a.TaxItemAcctgDocItemRef = '000002') and  a.TransactionTypeDetermination is initial and a.TaxCode is not initial and a.TaxDeterminationDate is not initial 
