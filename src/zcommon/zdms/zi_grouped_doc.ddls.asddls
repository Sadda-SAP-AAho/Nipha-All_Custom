@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Grouped Documents in By Key'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_GROUPED_DOC as select from ZR_DMS
{
   key RefObjectKey,
   key RefObjectType,
   count ( distinct DocUUID ) as DocCount
    
}
group by RefObjectKey, RefObjectType
