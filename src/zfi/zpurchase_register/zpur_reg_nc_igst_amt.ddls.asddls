@AbapCatalog.sqlViewName: 'ZPR_NC_IGST_AMT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_REG_NC_IGST_AMT'
define view ZPUR_REG_NC_IGST_AMT as select from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.AccountingDocumentItem,
    key a.FiscalYear,
    a.TaxItemGroup,
    a.AccountingDocumentItemType,
    a.TransactionTypeDetermination,
    a.NonDcblTaxAbsltAmtInCoCodeCrcy
} where (a.TaxItemAcctgDocItemRef = '000001' or a.TaxItemAcctgDocItemRef = '000002') and (a.TaxCode = 'BI' or a.TaxCode = 'BJ' 
   or a.TaxCode = 'BK' or a.TaxCode = 'BL') and a.AccountingDocumentItemType is initial  and  a.TransactionTypeDetermination is initial
