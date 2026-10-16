@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test11'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ztest11 as select from ztest12 as a 
{
    a.SalesDocument ,
    a.SalesDocumentItem ,
    a.Material,
    cast('M' as abap.char( 1 )) as SHIFT
}
union all select from ztest13 as C 
   {
    C.SalesDocument,
    C.SalesDocumentItem,
    C.Material,
    cast('A' as abap.char( 1 )) as SHIFT
    }
union all select from ztest14 as d 
   {
    d.SalesDocument,
    d.SalesDocumentItem,
    d.Material,
    cast('E' as abap.char( 1 )) as SHIFT
    }
/*left outer join ztest13 as C on a.SalesDocument 
= C.SalesDocument and a.SalesDocumentItem = C.SalesDocumentItem left outer join ztest14 as D on a.SalesDocument 
= D.SalesDocument and a.SalesDocumentItem = D.SalesDocumentItem
{
    a.SalesDocument as SalesDocument_M,
    a.SalesDocumentItem as SalesDocumentItem_M,
    a.Material as Material_M,
    a.SHIFT,
    case when a.SalesDocument = c.SalesDocument and a.SalesDocumentItem = c.SalesDocumentItem then 
    

}*/
