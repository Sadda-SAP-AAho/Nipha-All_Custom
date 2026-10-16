@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DMS_ACTIVITYLOG
  as select from zdms_activitylog
{
  key log_uuid              as LogUUID,
      entity                as Entity,
      action                as Action,
      old_path              as OldPath,
      new_path              as NewPath,
      @Semantics.user.createdBy: true
      action_by             as ActionBy,
      @Semantics.systemDateTime.createdAt: true
      action_at             as ActionAt,
      @Semantics.user.localInstanceLastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
