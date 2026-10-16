@EndUserText.label: 'DATABASE TABLE FOR MANUFACTURE SERIES PP'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DatabaseTableForManPP
  as select from ZDBMANUSRSPP
  association to parent ZI_DatabaseTableForManPP_S as _DatabaseTableForAll on $projection.SingletonID = _DatabaseTableForAll.SingletonID
{
  key SERIALNO as Serialno,
  PLACE as Place,
  MODEL as Model,
  MAKE as Make,
  YERS as Yers,
  MACHINENO as Machineno,
  STATE as State,
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
