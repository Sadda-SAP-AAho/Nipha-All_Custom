@AbapCatalog.sqlViewName: 'ZGSTR2_CRIGST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_CR_IGST'
define view ZGSTR2_CR_IGST 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TaxItemGroup,
TaxCode, 
TaxItemAcctgDocItemRef,
NonDcblTaxAmountInCoCodeCrcy as AMOUNT_CR_IGST    
}
where ( TaxCode = 'BI' or TaxCode = 'BJ' or  TaxCode = 'BK' or  TaxCode = 'BL'  )
  and TaxItemAcctgDocItemRef is not initial
