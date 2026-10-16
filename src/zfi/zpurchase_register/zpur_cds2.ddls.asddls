@AbapCatalog.sqlViewName: 'ZPUR_CDS21'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_CDS2'
define view ZPUR_CDS2 as select from I_OperationalAcctgDocItem
{
key AccountingDocument,
key FiscalYear,
key CompanyCode,
Segment 
}where AccountingDocumentItemType is initial  and  TransactionTypeDetermination is initial  and  Segment is not initial
group by
AccountingDocument,
FiscalYear,
CompanyCode,
Segment;
