@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VIEW ENTITY FOR ERROR LOG'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_ERROLOG as select from zpoc_errorlog
{
    key plant as Plant,
    key manufacturingorder as Manufacturingorder,
    key errortimestamp as Errortimestamp,
    yieldquantity as Yieldquantity,
    errormessage as Errormessage,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt
}
