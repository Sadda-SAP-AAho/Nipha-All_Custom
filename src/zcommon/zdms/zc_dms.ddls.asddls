@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_DMS
  provider contract transactional_query
  as projection on ZR_DMS
{
  key DocUUID,
  DocNumber,
  DocType,
  DocVersion,
  Title,
  Description,
  Status,
  Priority,
  Category,
  Tags,
  RefObjectType,
  RefObjectKey,
  Owner,
  DueDate,
  MimeType,
  DocLink,
  DocSize,
  IsConfidential,
  ReviewedBy,
  ReviewedAt,
  ApprovedBy,
  ApprovedAt,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
  @Semantics: {
    user.lastChangedBy: true
  }
  ChangedBy,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  ChangedAt,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalChangedAt
}
