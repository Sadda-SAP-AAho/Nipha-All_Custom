@EndUserText.label: 'DATABASE TABLE FOR SALES TEAMS'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DatabaseTableForSal
  as select from zdt_salestm
  association to parent ZI_DatabaseTableForSal_S as _DatabaseTableForAll on $projection.SingletonID = _DatabaseTableForAll.SingletonID
{
  key customerid as Customerid,
  key validfrom as Validfrom,
  key validto as Validto,
  customername as Customername,
  state as State,
  field as Field,
  degination as Degination,
  rm as Rm,
  zm as Zm,
  sales_head as SalesHead,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  @Consumption.hidden: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _DatabaseTableForAll
}
