@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZFIPPMAP'
define root view entity ZR_FIPPMAP
  as select from zfippmap
{
  key uuid as UUID,
  commcc1 as Commcc1,
  commcc2 as Commcc2,
  deptcc as Deptcc,
  prdcc as Prdcc,
  gl as Gl,
  act_type as ActType,
  act_cat as ActCat,
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
