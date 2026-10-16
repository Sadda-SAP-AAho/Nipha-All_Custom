@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINITION FOR GATE NRGP ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_GATE_NRGP_ITEM
  as select from zgate_nrgp_item
{
  key document_no           as DocumentNo,
  key line_no               as LineNum,
      nrgp_no               as NrgpNo,
      reference_document    as ReferenceDocument,
      reference_doc_item    as ReferenceDocItem,
      reference_doc_year    as ReferenceDocYear,
      nrgp_date             as NrgpDate,
      reference_doc_date    as ReferenceDocDate,
      product               as ItemCode,
      productname           as ItemName,
      item_text             as Description,
      quantity              as Qty,
      unit                  as Unit,
      storagelocation       as StorageLocation,
      plant                 as Plant,
      rate                  as Rate,
      item_amount           as ItemAmount,
      tax_code              as TaxCode,
      tax_percent           as TaxPercent,
      tax_amount            as TaxAmount,
      net_amount            as NetAmount,
      net_weight            as NetWeight,
      batch                 as Batch,
      cost_center           as CostCenter,
      iscompleted           as IsCompleted,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
