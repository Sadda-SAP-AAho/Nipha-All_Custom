@AbapCatalog.sqlViewName: 'ZGSTR2_CRIG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_NOCREDIT_TBA2'
define view ZGSTR2_NOCREDIT_TBA2 as select from I_OperationalAcctgDocTaxItem
{
AccountingDocument,
TaxItem,
FiscalYear,
CompanyCode,
TaxCode,
TaxBaseAmountInCoCodeCrcy as AMLOUNT_NOCRRE_TBAIG
    
}
  where (  TaxCode = 'BD' or TaxCode = 'BI' or TaxCode = 'BJ' or TaxCode = 'BK' or TaxCode = 'BL'  )
