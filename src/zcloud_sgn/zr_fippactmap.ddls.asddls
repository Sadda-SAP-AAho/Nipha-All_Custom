@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZFIPPACTMAP'
define root view entity ZR_FIPPACTMAP
  as select from zfippactmap
{
  key uuid as UUID,
  gl as Gl,
  prdcc as Prdcc,
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
