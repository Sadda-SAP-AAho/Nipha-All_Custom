@EndUserText.label: 'Copy DATABASE FOR BANK DETAILS'
define abstract entity ZD_CopyDatabaseForBankDetaP
{
  @EndUserText.label: 'New ZDE_AC'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Accountno' )
  Accountno : ZDE_AC;
  @EndUserText.label: 'New ZDE_IFSC'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Ifsc' )
  Ifsc : ZDE_IFSC;
}
