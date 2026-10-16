@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Manufacture to jobber report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATERIALDOCUMENTITEM_2 as select from I_MaterialDocumentItem_2 as a 
left outer join I_MaterialDocumentItem_2 as b on a.MaterialDocument = b.ReversedMaterialDocument
     and a.MaterialDocumentItem = b.ReversedMaterialDocumentItem and
     a.MaterialDocumentYear = b.ReversedMaterialDocumentYear
                 
{
    key a.MaterialDocument,
    key a.MaterialDocumentItem,
    key a.MaterialDocumentYear,
        a.PurchaseOrder,
        a.PurchaseOrderItem,
        a.GoodsMovementType,
        b.MaterialDocument as org_mat_doc,
        b.MaterialDocumentItem as org_mat_doc_item,
        b.MaterialDocumentYear as org_mat_doc_year,
        b.ReversedMaterialDocument,
        b.ReversedMaterialDocumentItem,
        b.ReversedMaterialDocumentYear,
        case when a.MaterialDocument = b.ReversedMaterialDocument and 
                  a.MaterialDocumentItem = b.ReversedMaterialDocumentItem and
                  a.MaterialDocumentYear = b.ReversedMaterialDocumentYear then 
        cast('X' as abap.char( 1 ))
        when a.GoodsMovementType = '542' then
        cast('X' as abap.char( 1 ))
        else
        cast(' ' as abap.char( 1 ))
        end as rev_ind          
                  
                          
}
where a.InventorySpecialStockType = 'O' and (a.GoodsMovementType = '541' or a.GoodsMovementType = '542')

