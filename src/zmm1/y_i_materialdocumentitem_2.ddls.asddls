@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Doc Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity y_I_MATERIALDOCUMENTITEM_2 as select from I_MaterialDocumentItem_2 as a left outer join I_Supplier as b on a.YY1_Transporter_MMI = b.Supplier
{
    key a.MaterialDocument,
    key a.MaterialDocumentItem,
    key a.MaterialDocumentYear,
        a.PurchaseOrder,
        a.PurchaseOrderItem,
        a.YY1_EWayBillNo_MMI,
        a.YY1_ReferenceChallanDa_MMI,
        a.YY1_ReferenceChallanno_MMI,
        a.YY1_Transporter_MMI,
        a.YY1_VehicleNo_MMI,
        b.SupplierName as transporter_name,
        a.YY1_GatePassNo_MMI,
        a.YY1_GateInOutDate_MMI,
        a.YY1_GateInOutTime_MMI
        
    
}
