@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'User Setup Master - Header'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_USER_HEADER
  provider contract transactional_query
  as projection on ZR_USER_HEADER
{
  key Userid,
  Username,
  Pastdays,
  Futuredays,
  Remarks,
  AllowView,
  AllowCreate,
  AllowDownload,
  AllowDelete,
  @Semantics: {
    user.createdBy: true
  }
  LocalCreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  LocalCreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  _zuseritems : redirected to composition child ZC_USER_ITEM000
}
