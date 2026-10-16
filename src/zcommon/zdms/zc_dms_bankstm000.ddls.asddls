@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_DMS_BANKSTM000
  provider contract transactional_query
  as projection on ZR_DMS_BANKSTM000
{
  key CompCode,
  key ActDoc,
  key Fiscalyear,
  HeaderText,
  ActDocType,
  DocCount,
  PostDate,
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
//  _BaseEntity
}
