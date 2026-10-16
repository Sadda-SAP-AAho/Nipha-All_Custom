@AbapCatalog.sqlViewName: 'ZGSTR2_CRCGST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_CR_CGST'
define view ZGSTR2_CR_CGST 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TaxItemGroup,
TaxCode, 
TaxItemAcctgDocItemRef,
NonDcblTaxAmountInCoCodeCrcy ,

( cast( case when NonDcblTaxAbsltAmtInCoCodeCrcy is not null then NonDcblTaxAbsltAmtInCoCodeCrcy  else 0 end as abap.dec( 23, 2 ) ) )  as AMOUNT_CRCGST, 
( cast ( 2 as abap.decfloat16 ) ) as TWO,
( cast ( NonDcblTaxAmountInCoCodeCrcy as abap.decfloat34 ) ) as AMOUNT_CR_CGST

   
}
where ( TaxCode = 'BA' or TaxCode = 'BB' or  TaxCode = 'BC' or  TaxCode = 'BD'  )
  and TaxItemAcctgDocItemRef is not initial 
  and ( TransactionTypeDetermination = '' or TransactionTypeDetermination = 'WRX' )
