@AbapCatalog.sqlViewName: 'ZGSTRNOCREDIT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_NOCREDIT_TBA'
define view ZGSTR2_NOCREDIT_TBA as select from I_OperationalAcctgDocTaxItem
{
AccountingDocument,
TaxItem,
FiscalYear,
CompanyCode,
TaxCode,
TaxBaseAmountInCoCodeCrcy as AMLOUNT_NOCRRE_TBA
    
}
  where ( TaxCode = 'BA' or TaxCode = 'BB' or TaxCode = 'BC' or TaxCode = 'BD'  or TaxCode = 'V0' )
