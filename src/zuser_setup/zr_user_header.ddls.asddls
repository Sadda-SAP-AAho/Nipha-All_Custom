@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_USER_HEADER
  as select from zuser_header as UserSetup
  composition [0..*] of ZR_USER_ITEM000 as _zuseritems
{
  key userid as Userid,
  username as Username,
  pastdays as Pastdays,
  futuredays as Futuredays,
  remarks as Remarks,
  allow_view as AllowView,
  allow_create as AllowCreate,
  allow_download as AllowDownload,
  allow_delete as AllowDelete,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  _zuseritems
}
