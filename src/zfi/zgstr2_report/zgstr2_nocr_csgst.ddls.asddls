@AbapCatalog.sqlViewName: 'ZGSTRNOCRCSGST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_NOCR_CSGST'
define view ZGSTR2_NOCR_CSGST as select from I_OperationalAcctgDocTaxItem
{
AccountingDocument,
TaxItem,
FiscalYear,
CompanyCode,
TaxAmountInCoCodeCrcy as AMOUNT_CRRE_CGST ,

( cast( case when TaxAmountInCoCodeCrcy is not null then TaxAmountInCoCodeCrcy  else 0 end as abap.dec( 23, 2 ) ) )  as AMOUNT_CRCGST 
  
}
where ( TaxCode = 'BA' or TaxCode = 'BB' or  TaxCode = 'BC' or  TaxCode = 'BD'  )

