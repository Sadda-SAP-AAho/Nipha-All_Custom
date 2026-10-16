@EndUserText.label: 'TMG For Material Code'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForMaterialCode
  as select from ZDT_MATERIALCODE
  association to parent ZI_TmgForMaterialCode_S as _TmgForMaterialCoAll on $projection.SingletonID = _TmgForMaterialCoAll.SingletonID
{
  key MATERIAL_CODE as MaterialCode,
  MATERIAL_DESC as MaterialDesc,
  DIVISION_ATTR1 as DivisionAttr1,
  DIVISION_ATTR2 as DivisionAttr2,
  DIVISION_ATTR3 as DivisionAttr3,
  PRODUCT_FAMILY_CODE as ProductFamilyCode,
  MODEL_NAME as ModelName,
  SIDE_TRANSMISSION_TYPE as SideTransmissionType,
  MACHINE_SIZE as MachineSize,
  CHANGE_GEAR as ChangeGear,
  BLADE_TYPE as BladeType,
  NO_OF_BLADES as NoOfBlades,
  GEAR_BOX_TYPE as GearBoxType,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForMaterialCoAll
}
