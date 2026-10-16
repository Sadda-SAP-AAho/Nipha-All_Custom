@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Import Po Data for purchase reg.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZIMPORT_PO_DATA1 as select from I_PurchaseOrderItemAPI01  as a
                                   left outer join I_PurchaseOrderAPI01 as b on a.PurchaseOrder = b.PurchaseOrder
                                   left outer join I_SuplrInvcItemPurOrdRefAPI01 as C on C.PurchaseOrder = a.PurchaseOrder
                                                   and C.PurchaseOrderItem = a.PurchaseOrderItem and 
                                                   (C.SuplrInvcDeliveryCostCndnType = 'ZBCD' or C.SuplrInvcDeliveryCostCndnType = 'ZCDB' )
{
   key a.PurchaseOrder,
   key a.PurchaseOrderItem,
       b.PurchaseOrderType,
       C.SupplierInvoice,
       C.FiscalYear,
       C.SupplierInvoiceItem,
       C.SuplrInvcDeliveryCostCndnType
   
}
where (b.PurchaseOrderType = 'ZIMP' or b.PurchaseOrderType = 'ZIAS')
