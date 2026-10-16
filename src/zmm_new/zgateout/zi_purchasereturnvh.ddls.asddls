@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order ValueHelp'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURCHASERETURNVH
  as select from I_PurchaseOrderAPI01       as Header
    inner join I_PurchaseOrderItemAPI01     as Item
      on Header.PurchaseOrder = Item.PurchaseOrder

    left outer join ZR_GATEPASSLINEITM as GatePassLine
      on GatePassLine.DocumentNo = Header.PurchaseOrder

    left outer join ZR_GATEPASSHEADER  as GatePass
      on GatePassLine.GatePass = GatePass.GatePass

{
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key Header.PurchaseOrder,
  key Item.PurchaseOrderItem,
      Header.PurchaseOrderDate,
      Header.Supplier,
      Header.PurchasingOrganization,
      Header.PurchasingGroup,
      Header.CompanyCode,

      concat(
          concat(
              Header._Supplier.SupplierName,
              '   -   '
          ),
          Header._Supplier.CityName
      ) as SupplierName,

      'PURR' as DocumentType,

      Item.Material,
      Item.Plant,
      Item.StorageLocation,

      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      Item.OrderQuantity as OrderQuantity,

      Item.PurchaseOrderQuantityUnit,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      Item.NetAmount as Amount,

      Header.DocumentCurrency
}
where
  (
      ( GatePassLine.DocumentNo is null
    or GatePass.Cancelled = 'X' ) and
    Item.IsReturnsItem is not initial
  )

