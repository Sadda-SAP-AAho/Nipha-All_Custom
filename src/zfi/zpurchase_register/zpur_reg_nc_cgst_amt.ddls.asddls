@AbapCatalog.sqlViewName: 'ZPR_NC_CGST_AMT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_REG_NC_CGST_AMT'
define view ZPUR_REG_NC_CGST_AMT as select from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.AccountingDocumentItem,
    key a.FiscalYear,
    a.TaxItemGroup,
    a.AccountingDocumentItemType,
    a.TransactionTypeDetermination,
    a.NonDcblTaxAbsltAmtInCoCodeCrcy
} where (a.TaxItemAcctgDocItemRef = '000001' or a.TaxItemAcctgDocItemRef = '000002') and (a.TaxCode = 'BA' or a.TaxCode = 'BB' 
   or a.TaxCode = 'BC' or a.TaxCode = 'BD' or a.TaxCode = 'BE' or a.TaxCode = 'BF'
   or a.TaxCode = 'BG' or a.TaxCode = 'BH' ) and a.AccountingDocumentItemType is initial  and  a.TransactionTypeDetermination is initial
