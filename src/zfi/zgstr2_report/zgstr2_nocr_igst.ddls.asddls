@AbapCatalog.sqlViewName: 'ZGSTRNOCRIGST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_NOCR_IGST'
define view ZGSTR2_NOCR_IGST as select from I_OperationalAcctgDocTaxItem
{
 AccountingDocument,
 TaxItem,
 FiscalYear,
 CompanyCode,
 TaxAmountInCoCodeCrcy as AMOUNT_CRRE_IGST  
}
where ( TaxCode = 'BI' or TaxCode = 'BJ' or  TaxCode = 'BK' or  TaxCode = 'BL'  )
