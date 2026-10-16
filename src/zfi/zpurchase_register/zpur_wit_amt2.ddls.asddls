@AbapCatalog.sqlViewName: 'ZPUR_WIT_AMT21'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_WIT_AMT2'
define view ZPUR_WIT_AMT2 as select distinct from I_OperationalAcctgDocItem 
{
  key CompanyCode,
    key AccountingDocument,
    key FiscalYear,
    key AccountingDocumentItem,
        AmountInCompanyCodeCurrency,
        WithholdingTaxAmount,
        AmountInTransactionCurrency,
        WithholdingTaxCode        
}where TransactionTypeDetermination = 'WIT'
group by CompanyCode,
         AccountingDocument,
         FiscalYear,
         AccountingDocumentItem,
         AmountInCompanyCodeCurrency,
         WithholdingTaxAmount,
         AmountInTransactionCurrency,
         WithholdingTaxCode;
