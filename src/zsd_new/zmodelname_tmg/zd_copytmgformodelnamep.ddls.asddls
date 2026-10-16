@EndUserText.label: 'Copy TMG FOR MODEL NAME'
define abstract entity ZD_CopyTmgForModelNameP
{
  @EndUserText.label: 'New Code'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Code' )
  Code : ZDE_CODE;
  @EndUserText.label: 'New Language'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: Language' )
  Language : ZDE_LANGUAGE;
}
