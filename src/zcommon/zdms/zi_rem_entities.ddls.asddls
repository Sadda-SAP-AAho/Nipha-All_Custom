@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS to Remaining Entity To Add'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_REM_ENTITIES as select from ZI_ENTITYTYPE_VH as a
left outer join ZR_DMS_CONFIG as b on a.Value = b.Entity
{
    key a.Value,
    a.Description   
}
where b.Entity is null
