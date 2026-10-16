@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZI_CUSTOMERVH 
as select from I_Customer as a
left outer join ZI_GROUPED_DOC as b on a.Customer = b.RefObjectKey and b.RefObjectType = 'CT'
{



  key a.Customer,
  
  @Search.defaultSearchElement: true
a.CustomerName,
a.CustomerFullName,
a.CustomerAccountGroup,
a.CityName,
a.PostalCode,
a.StreetName,
a.Region,
a.TelephoneNumber1,
b.DocCount,
a.CreationDate,
a.CreatedByUser

}
