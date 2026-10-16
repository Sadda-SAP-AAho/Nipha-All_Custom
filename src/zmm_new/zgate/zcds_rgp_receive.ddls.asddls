@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINATION FOR RGP FOR RECEIVE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_RGP_RECEIVE as select from zgate_rgpreceive
{
    key document_no as DocumentNo,
    key reference_document as ReferenceDocument,
    ship_reference_document as ShipReferenceDocument,
    line_no as Line_No,
    rgp_no as RgpNo,
    rgp_line_no as RgpLineNo,
    reference_doc_item as ReferenceDocItem,
    reference_doc_year as ReferenceDocYear,
    rgp_date as RgpDate,
    reference_doc_date as ReferenceDocDate,
    batch as Batch,
    weight as Weight,
    item_code as ItemCode,
    item_name as ItemName,
    description as Description,
    qty as Qty,
    unit as Unit,
    rate as Rate,
    item_amount as ItemAmount,
    tax_code as TaxCode,
    tax_percent as TaxPercent,
    tax_amount as TaxAmount,
    net_amount as NetAmount,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt
}
