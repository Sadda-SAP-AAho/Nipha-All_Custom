@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test14'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ztest14 as select from I_SalesDocumentItem as a 
{
    a.SalesDocument ,
    a.SalesDocumentItem ,
    a.Material ,
    cast('E' as abap.char( 1 )) as SHIFT
    
 }
