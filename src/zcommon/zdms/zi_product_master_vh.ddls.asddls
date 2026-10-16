@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Master'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZI_PRODUCT_MASTER_VH as select from I_Product as a
left outer join ZI_GROUPED_DOC as b on a.Product = b.RefObjectKey and b.RefObjectType = 'PR'
{

  key a.Product,

  @Search.defaultSearchElement: true
  a.ProductExternalID,

  a.ProductType,

  @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  a.GrossWeight,

a.WeightUnit,

  a.ProductGroup,
  a.BaseUnit,
  a.ProductCategory,
  a.Division,
  a.CreationDate,
  a.LastChangeDate,
  a.ProductOldID,
  a.ProductManufacturerNumber,
  a.CountryOfOrigin,
  a.Brand,
  a.CrossPlantStatus,
  a.IsMarkedForDeletion,
  b.DocCount

}
