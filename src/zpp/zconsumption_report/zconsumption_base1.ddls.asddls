@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONSUMPTION BASE1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCONSUMPTION_BASE1 as select from ZCONSUMPTION_BASE as A
{
    A.BillOfMaterialVariant,
    A.BillOfMaterial,
    A.ManufacturingOrder,
    A.BillOfMaterialComponent,
    A.PLANT,
    cast('Shift_A' as abap.char( 7 )) as SHIFT
}
union all select from ZCONSUMPTION_BASE as B
{
    B.BillOfMaterialVariant,
    B.BillOfMaterial,
    B.ManufacturingOrder,
    B.BillOfMaterialComponent,
    B.PLANT,
    cast('Shift_B' as abap.char( 7 )) as SHIFT
 }
union all select from ZCONSUMPTION_BASE as C
{
    C.BillOfMaterialVariant,
    C.BillOfMaterial,
    C.ManufacturingOrder,
    C.BillOfMaterialComponent,
    C.PLANT,
    cast('Shift_C' as abap.char( 7 )) as SHIFT
 }
