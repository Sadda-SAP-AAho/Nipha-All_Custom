@EndUserText.label: 'DATABASE TABLE FOR MANUFACTURE SERIES MM'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DatabaseTableForMan
  as select from ZMNUFCTRESERMM
  association to parent ZI_DatabaseTableForMan_S as _DatabaseTableForAll on $projection.SingletonID = _DatabaseTableForAll.SingletonID
{
  key SERIAL_NO as SerialNo,
  MATERIAL_CODE as MaterialCode,
  DESCRIPTION as Description,
  MFR_SERIALNO as MfrSerialno,
  @Semantics.user.createdBy: true
  CREATED_BY as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CREATED_AT as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  @Consumption.hidden: true
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _DatabaseTableForAll
}
