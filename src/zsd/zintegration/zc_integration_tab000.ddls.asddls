@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
//@ObjectModel: {
//  sapObjectNodeType.name: 'ZINTEGRATION_TAB000'
//}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_INTEGRATION_TAB000
  provider contract transactional_query
  as projection on ZR_INTEGRATION_TAB000
  association [1..1] to ZR_INTEGRATION_TAB000 as _BaseEntity on $projection.Intgmodule = _BaseEntity.Intgmodule
{
  key Intgmodule,
  Intgpath,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
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
  LocalLastChangedAt,
  _BaseEntity
}
