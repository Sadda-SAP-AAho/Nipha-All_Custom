@AbapCatalog.sqlViewName: 'ZGSTR2_NOCRTBA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_NOCR_TBA'
define view ZGSTR2_NOCR_TBA 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem ,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
OriglTaxBaseAmountInCoCodeCrcy as AMLOUNT_NOCR_TBA,
TaxCode,
TaxItemGroup,
TaxItemAcctgDocItemRef
    
}
 
  where ( TaxCode = 'BA' or TaxCode = 'BB' or TaxCode = 'BC' or TaxCode = 'BD' or TaxCode = 'BI' or TaxCode = 'BJ' or TaxCode = 'BK' or TaxCode = 'BL' or TaxCode = 'V0'  )
