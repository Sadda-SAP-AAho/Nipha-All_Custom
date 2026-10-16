@EndUserText.label: 'Copy DATABASE TABLE FOR SALES TEAMS'
define abstract entity ZD_CopyDatabaseTableForSalP
{
  @EndUserText.label: 'New Customer'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Customerid' )
  Customerid : KUNNR;
  @EndUserText.label: 'New ZVLIDFRM'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Validfrom' )
  Validfrom : ZVLIDFRM;
  @EndUserText.label: 'New ZVLIDTO'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Validto' )
  Validto : ZVLIDTO;
}
