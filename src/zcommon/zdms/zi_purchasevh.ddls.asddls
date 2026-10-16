@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_PURCHASEVH as select from I_PurchaseOrderAPI01 as a
inner join I_PurchaseOrderItemAPI01 as item on a.PurchaseOrder = item.PurchaseOrder
left outer join ZI_GROUPED_DOC as b on a.PurchaseOrder = b.RefObjectKey and b.RefObjectType = 'PO'
left outer join ZR_USER_ITEM000 as _user on item.Plant = _user.Plant 
{
  key a.PurchaseOrder,
  a.PurchaseOrderType,
  a.PurchaseOrderDate,
  
  @ObjectModel.text.element: [ 'SupplierName' ]
  case when a.Supplier is not initial then a.Supplier else a.SupplyingPlant end as Supplier,
  case when a.Supplier is not initial then a._Supplier.SupplierName else a._SupplyingPlant.PlantName end as SupplierName,
  a.CompanyCode,
  a.PurchasingOrganization,
  a.PurchasingGroup,
  a.CreatedByUser,
  b.DocCount
  
}
where _user.Userid = $session.user
group by a.PurchaseOrder, a.PurchaseOrderType, a.PurchaseOrderDate, a.Supplier, a.SupplyingPlant, a.CompanyCode, a.PurchasingOrganization, a.PurchasingGroup, a.CreatedByUser,
 a._Supplier.SupplierName ,a._SupplyingPlant.PlantName , b.DocCount
