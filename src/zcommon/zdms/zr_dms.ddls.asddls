@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DMS
  as select from zdms
{
  key doc_uuid as DocUUID,
  doc_number as DocNumber,
  doc_type as DocType,
  doc_version as DocVersion,
  title as Title,
  description as Description,
  status as Status,
  priority as Priority,
  category as Category,
  tags as Tags,
  mime_type as MimeType,
  doc_link as DocLink,
  doc_size as DocSize,
  ref_object_type as RefObjectType,
  ref_object_key as RefObjectKey,
  owner as Owner,
  due_date as DueDate,
  is_confidential as IsConfidential,
  reviewed_by as ReviewedBy,
  reviewed_at as ReviewedAt,
  approved_by as ApprovedBy,
  approved_at as ApprovedAt,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  changed_by as ChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  changed_at as ChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_changed_at as LocalChangedAt
}
