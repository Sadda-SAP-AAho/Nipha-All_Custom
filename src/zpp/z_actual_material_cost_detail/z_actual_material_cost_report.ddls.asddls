@AbapCatalog.sqlViewName: 'YAMCR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z_ACTUAL_MATERIAL_COST_REPORT'
define view Z_ACTUAL_MATERIAL_COST_REPORT as select from  I_MfgOrderDocdGoodsMovement as A
//left outer join  I_MfgOrderDocdGoodsMovement  as A on A.ManufacturingOrder = AA.ManufacturingOrder and A.GoodsMovementType = '101'
left outer join  I_MfgOrderDocdGoodsMovement  as B on B.ManufacturingOrder = A.ManufacturingOrder and  B.GoodsMovementType = '261' //and B.Material = A.Material
left outer join  I_OperationalAcctgDocItem  as e on e.Material = A.Material and e.OrderID = A.ManufacturingOrder 

//left outer join  I_MfgOrderDocdGoodsMovement  as BB on BB.ManufacturingOrder = A.ManufacturingOrder and  BB.GoodsMovementType = '261' 

  left outer join  I_ManufacturingOrderOperation  as c on  c.ManufacturingOrder = A.ManufacturingOrder
  left outer join  I_WorkCenterCostCenter  as d on d.WorkCenterInternalID = c.WorkCenterInternalID and d.CostCenterAllocation = '0001'
//  left outer join  I_PlanCostRateTP as f on e.CostCenter = d.CostCenter
  
{
    key B.ManufacturingOrder ,
    key B.PostingDate,
    key A.Material as MAT101,
    key  B.Material as MAT261,
   e.FiscalPeriod as FiscalPeriod ,
    e.FiscalYear as FiscalYear ,
     
    A.EntryUnit,
  // cast( B.QuantityInEntryUnit as abap.dec( 13, 3 ) ) as QuantityInEntryUnit,
    cast( 'KG' as abap.unit( 3 ) ) as EntryUnitNEW,
    
  @Semantics.quantity.unitOfMeasure: 'EntryUnitNEW'
  B.QuantityInEntryUnit ,
   B.TotalGoodsMvtAmtInCCCrcy , 
    B.CompanyCodeCurrency,
//    A.GoodsMovementType,  
//    B.GoodsMovementType as g1,
    c.CostCtrActivityType1,
    @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    c.OpConfirmedWorkQuantity1,
    c.OpWorkQuantityUnit1,
    
    
    
    c.CostCtrActivityType2,
    @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    c.OpConfirmedWorkQuantity2,
    c.OpWorkQuantityUnit2,
    
    c.CostCtrActivityType3,
    @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    c.OpConfirmedWorkQuantity3,
    c.OpWorkQuantityUnit3,
    
    c.CostCtrActivityType4,
    @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    c.OpConfirmedWorkQuantity4 ,
    c.OpWorkQuantityUnit4,
    
     c.CostCtrActivityType5,
     c.OpConfirmedWorkQuantity5,
     c.OpWorkQuantityUnit5,
     
    
    c.CostCtrActivityType6, 
    @Semantics.quantity.unitOfMeasure: 'EntryUnit'
    c.OpConfirmedWorkQuantity6,
    c.OpWorkQuantityUnit6 ,
    
    d.CostCenter 
    
//    e.CostRateVarblAmount
//    case c.CostCtrActivityType1
//       when  '' then ( c2.CostCtrActivityType2 )
//      else
//      ( c.CostCtrActivityType1 ) end                  as BANNASA

    }
//    where B.GoodsMovementType = '101'
