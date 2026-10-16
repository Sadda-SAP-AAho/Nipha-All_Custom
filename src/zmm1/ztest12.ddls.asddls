@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test12'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ztest12 as select from I_SalesDocumentItem as a 
{
    a.SalesDocument ,
    a.SalesDocumentItem ,
    a.Material ,
    cast('M' as abap.char( 1 )) as SHIFT
    
 }
