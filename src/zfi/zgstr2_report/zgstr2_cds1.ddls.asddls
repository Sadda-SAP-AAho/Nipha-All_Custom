@AbapCatalog.sqlViewName: 'ZGSTR2CDS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_CDS1'
define view ZGSTR2_CDS1  
// with parameters
//     P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
as select from I_OperationalAcctgDocItem
{
AccountingDocument,
FiscalYear,
CompanyCode,
ProfitCenter,
BusinessPlace,
Segment,
TaxItemGroup,
Material,
Quantity,
IN_HSNOrSACCode,
GoodsMovementEntryUnit   
}
where ProfitCenter <> '' 

group by
AccountingDocument,
FiscalYear,
CompanyCode,
ProfitCenter,
BusinessPlace,
Segment,
TaxItemGroup,
Material,
Quantity,
IN_HSNOrSACCode,
GoodsMovementEntryUnit  
