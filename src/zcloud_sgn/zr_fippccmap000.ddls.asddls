@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZFIPPCCMAP'
define root view entity ZR_FIPPCCMAP000
  as select from zfippccmap
{
  key uuid as UUID,
  commcc as Commcc,
  deptcc as Deptcc,
  prdcc as Prdcc,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
