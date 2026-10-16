@AbapCatalog.sqlViewName: 'ZPUR_CDS12'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_CDS1'
define view ZPUR_CDS1 as select from I_OperationalAcctgDocItem
{
key AccountingDocument,
key FiscalYear,
key CompanyCode,
ProfitCenter,
CostCenter 
}where AccountingDocumentItemType is initial  and  TransactionTypeDetermination is initial   
                               and TaxDeterminationDate is not initial  and TaxCode is not initial 
group by
AccountingDocument,
FiscalYear,
CompanyCode,
ProfitCenter,
CostCenter;
