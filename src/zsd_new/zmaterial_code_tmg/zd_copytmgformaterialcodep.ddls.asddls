@EndUserText.label: 'Copy TMG For Material Code'
define abstract entity ZD_CopyTmgForMaterialCodeP
{
  @EndUserText.label: 'New MaterialCode'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: MaterialCode' )
  MaterialCode : ZDE_MATERIAL_CODE;
}
