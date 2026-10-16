@AbapCatalog.sqlViewName: 'ZPUR_WIT_AMT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_WIT_AMT'
define view ZPUR_WIT_AMT as select distinct from I_OperationalAcctgDocItem as a
{
  key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
    key a.AccountingDocumentItem,
        a.AmountInCompanyCodeCurrency,
        a.TaxSection,
        a.IN_GSTPlaceOfSupply,
         a.WithholdingTaxBaseAmount 
}where a.TransactionTypeDetermination = 'EGK'
group by CompanyCode,
         AccountingDocument,
         FiscalYear,
         AccountingDocumentItem,
         AmountInCompanyCodeCurrency,
         TaxSection,
         IN_GSTPlaceOfSupply,
         WithholdingTaxBaseAmount;
         
