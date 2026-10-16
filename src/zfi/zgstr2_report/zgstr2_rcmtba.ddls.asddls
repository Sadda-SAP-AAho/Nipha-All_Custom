@AbapCatalog.sqlViewName: 'ZGSTR2RCMTBA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_RCMTBA'
define view ZGSTR2_RCMTBA 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem ,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
OriglTaxBaseAmountInCoCodeCrcy as AMLOUNT_RCM_TBA,
TaxCode,
TaxItemGroup,
TaxItemAcctgDocItemRef
    
}

  where ( TaxCode = 'DA' or TaxCode = 'DB' or TaxCode = 'DC' or TaxCode = 'DD' or TaxCode = 'DI' or TaxCode = 'DJ' or TaxCode = 'DK' or TaxCode = 'DL' or TaxCode = 'V0' )
