@AbapCatalog.sqlViewName: 'ZGSTR_TBAS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR_TBAS'
define view ZGSTR2_TBAS as select from I_OperationalAcctgDocItem
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
AmountInCompanyCodeCurrency as TBA_S 

    
}
where   AccountingDocumentItemType = 'S' 
