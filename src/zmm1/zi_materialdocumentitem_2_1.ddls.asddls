@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manufacture to jobber report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATERIALDOCUMENTITEM_2_1 as select from ZI_MATERIALDOCUMENTITEM_2 as a
{
    key a.MaterialDocument,
    key a.MaterialDocumentItem,
    key a.MaterialDocumentYear,
    a.PurchaseOrder,
    a.PurchaseOrderItem,
    a.GoodsMovementType,
    a.org_mat_doc,
    a.org_mat_doc_item,
    a.org_mat_doc_year,
    a.ReversedMaterialDocument,
    a.ReversedMaterialDocumentItem,
    a.ReversedMaterialDocumentYear,
    a.rev_ind
}
where a.rev_ind <> 'X'
