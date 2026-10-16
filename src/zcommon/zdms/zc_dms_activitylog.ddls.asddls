@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_DMS_ACTIVITYLOG
  provider contract transactional_query
  as projection on ZR_DMS_ACTIVITYLOG

{
  key LogUUID,
  Entity,
  Action,
  OldPath,
  NewPath,
  @Semantics: {
    user.createdBy: true
  }
  ActionBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  ActionAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LocalLastChangedAt
 
}
