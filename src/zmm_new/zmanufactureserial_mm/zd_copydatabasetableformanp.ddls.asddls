@EndUserText.label: 'Copy DATABASE TABLE FOR MANUFACTURE SERIES MM'
define abstract entity ZD_CopyDatabaseTableForManP
{
  @EndUserText.label: 'New ZD_SERIALNO'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: SerialNo' )
  SerialNo : ZDE_SERIALNO;
}
