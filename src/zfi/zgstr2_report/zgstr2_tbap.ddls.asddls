@AbapCatalog.sqlViewName: 'ZGSTR2TBAP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_TBAP'
define view ZGSTR2_TBAP as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem ,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TaxCode,
TaxItemGroup,
TaxItemAcctgDocItemRef,
//cast(sum(AmountInCompanyCodeCurrency) as  abap.dec( 16,3 ) ) as TAX_BASE_AMOUNT
AmountInCompanyCodeCurrency as TBA_P

    
}
where   AccountingDocumentItemType = 'P' 
