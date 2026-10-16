@EndUserText.label: 'Copy DATABASE TABLE FOR MANUFACTURE SERIES PP'
define abstract entity ZD_CopyDatabaseTableForManPPP
{
  @EndUserText.label: 'New ZDE_SRSNO'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Serialno' )
  Serialno : ZDE_SRSNO;
}
