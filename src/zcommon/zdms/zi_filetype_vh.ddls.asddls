@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'File Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_FILETYPE_VH as select from ZR_DMS
{
    key DocType
}
group by DocType
