@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manufacturer to Jobber Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMFG_JOBBER as select from I_POSubcontractingCompAPI01 as 
a left outer join I_MaterialDocumentItem_2 as b on a.PurchaseOrder = b.PurchaseOrder
and b.PurchaseOrderItem = a.PurchaseOrderItem and a.Material = b.Material
and b.InventorySpecialStockType = 'O' and ( b.GoodsMovementType = '541' or b.GoodsMovementType = '542' )
left outer join I_BillingDocumentItem as c on c.ReferenceSDDocument = b.MaterialDocument
and b.MaterialDocumentItem = right(c.ReferenceSDDocumentItem,4)
left outer join I_PurchaseOrderAPI01 as d on d.PurchaseOrder = a.PurchaseOrder
left outer join I_Supplier as e on e.Supplier = d.Supplier
left outer join I_Product as f on f.Product = b.Material
left outer join I_Plant as g on g.Plant = b.Plant
left outer join I_ProductDescription as i on i.Product = b.Material
and i.Language = 'E'
left outer join I_BillingDocItemPrcgElmntBasic as j on j.BillingDocument = c.BillingDocument
and j.BillingDocumentItem = c.BillingDocumentItem and j.ConditionType = 'ZPR0'
left outer join I_BillingDocItemPrcgElmntBasic as k on k.BillingDocument = c.BillingDocument
and k.BillingDocumentItem = c.BillingDocumentItem and k.ConditionType = 'JOSG'
left outer join I_BillingDocItemPrcgElmntBasic as l on l.BillingDocument = c.BillingDocument
and l.BillingDocumentItem = c.BillingDocumentItem and l.ConditionType = 'JOCG'
left outer join I_BillingDocItemPrcgElmntBasic as m on m.BillingDocument = c.BillingDocument
and m.BillingDocumentItem = c.BillingDocumentItem and m.ConditionType = 'JOIG'
left outer join ZI_MATERIALDOCUMENTITEM_2 as n on n.MaterialDocument = b.MaterialDocument
  and n.MaterialDocumentItem = b.MaterialDocumentItem and n.MaterialDocumentYear = b.MaterialDocumentYear
left outer join I_RegionText as h on h.Country = e.Country and h.Region = e.Region and h.Language = 'E'

{
  b.MaterialDocumentYear,
  b.MaterialDocument,
  b.MaterialDocumentItem,
  b.PurchaseOrder,
  b.GoodsMovementType,
  d.PurchaseOrderDate,
  d.Supplier,
  e.SupplierFullName,
  e.TaxNumber3,
  e.Region,
  h.RegionName,
  c.BillingDocument,
  c.BillingDocumentItem,
  c.BillingDocumentDate,
  c.Plant,
  g.PlantName,
  b.Material,
  i.ProductDescription,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  a.RequiredQuantity,
  a.BaseUnit,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  b.QuantityInEntryUnit,
  b.EntryUnit as ISSUE_UNIT,
  j.TransactionCurrency,
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  j.ConditionAmount as challan_item_value,
  k.ConditionRateValue as sgst_rate,
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  k.ConditionAmount as sgst_value,
  l.ConditionRateValue as cgst_rate,
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  l.ConditionAmount as cgst_value,
  m.ConditionRateValue as igst_rate,
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  m.ConditionAmount as igst_value,
   @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  (a.RequiredQuantity - b.QuantityInEntryUnit ) as pending_qty,
  a.BaseUnit as pending_uom,
  case when k.ConditionRateValue is not initial
    then 
      k.ConditionRateValue + l.ConditionRateValue 
    else   m.ConditionRateValue
    end  
    as total_GST_rate,
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  case when k.ConditionAmount is not initial
    then
      k.ConditionAmount + l.ConditionAmount 
    else 
     m.ConditionAmount
    end as total_GST_value, 
   n.rev_ind
  
  
  
  
  
  
  
  
  
}
where b.MaterialDocument <> '' and b.MaterialDocumentYear <> '0000' 
and b.MaterialDocumentItem <> '0000' 
//right(f.ReferenceSDDocumentItem,4 )
