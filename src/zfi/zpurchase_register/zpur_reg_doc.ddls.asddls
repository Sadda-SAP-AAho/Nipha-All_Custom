@AbapCatalog.sqlViewName: 'ZPUR_REG_DOC1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_REG_DOC'
define view ZPUR_REG_DOC as select distinct from I_OperationalAcctgDocItem as a
{
    key a.CompanyCode,
    key a.FiscalYear,
    key a.AccountingDocument,
    key a.AccountingDocumentItem,
    a.BusinessPlace,
    a.TaxSection,
    a.TaxCode,
    a.DocumentDate,
    a.PostingDate,
    a.AccountingDocumentType,
    a.Supplier,
    a.IN_GSTPlaceOfSupply,
    a.TaxItemGroup
} where (a.AccountingDocumentType = 'KR' or a.AccountingDocumentType = 'SA' or a.AccountingDocumentType = 'KG' )
  and a.TransactionTypeDetermination = ' ' and (a.TaxItemAcctgDocItemRef = '000001' or a.TaxItemAcctgDocItemRef = '000002' )
  and a.AccountingDocumentItemType = ' '
