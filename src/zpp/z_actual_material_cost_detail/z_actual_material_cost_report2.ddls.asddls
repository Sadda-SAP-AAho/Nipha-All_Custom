@AbapCatalog.sqlViewName: 'YACRE2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_ACTUAL_MATERIAL_COST_REPORT2'
define view Z_ACTUAL_MATERIAL_COST_REPORT2 as select from Z_ACTUAL_MATERIAL_COST_REPORT as A
     inner join  I_ManufacturingOrderOperation as B on B.ManufacturingOrder = A.ManufacturingOrder
   
{
    A.ManufacturingOrder,
    A.PostingDate,
//    A.AMAT,
//    A.Material,
    A.QuantityInEntryUnit,
    A.EntryUnit,
    A.CompanyCodeCurrency,
    A.CostCtrActivityType1,
    A.OpConfirmedWorkQuantity1,
    B.CostCtrActivityType2,
    B.OpConfirmedWorkQuantity2,
    A.CostCenter
}
