@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZI_SUPPLIERVH
  as select from I_Supplier as a
  left outer join I_BusinessPartner as c on a.Supplier = c.BusinessPartner 
  left outer join ZI_GROUPED_DOC as b on a.Supplier = b.RefObjectKey and b.RefObjectType = 'VD'
{
  key a.Supplier,

  @Search.defaultSearchElement: true
  a.SupplierName,
  a.SupplierFullName,
  a.CreationDate,
  a.CreatedByUser,
  a.SupplierAccountGroup,
  a.CityName,
  a.PostalCode,
  a.StreetName,
  a.Region,
  a.PhoneNumber1,
  c.BusinessPartnerType,
  b.DocCount
}
