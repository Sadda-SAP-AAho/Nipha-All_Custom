@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION ENTITY FOR ZC_ERRORLOG'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_ERRORLOG provider contract transactional_query
  as projection on ZC_ERROLOG
  association [1..1] to ZC_ERROLOG as _BaseEntity on $projection.Plant = _BaseEntity.Plant and $projection.Manufacturingorder = _BaseEntity.Manufacturingorder and $projection.Errortimestamp = _BaseEntity.Errortimestamp
{
  key Plant,
  key Manufacturingorder,
  key Errortimestamp,
  Yieldquantity,
  Errormessage,
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
