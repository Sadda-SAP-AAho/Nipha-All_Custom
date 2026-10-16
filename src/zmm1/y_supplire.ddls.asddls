@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Y_SUPPLIRE as select from I_Supplier 
as a left outer join I_Address_2 as b on a.AddressID = b.AddressID
left outer join I_RegionText as c on c.Region = a.Region and c.Language = 'E'
and c.Country = 'IN'
{
  key a.Supplier,
  a.OrganizationBPName1,
//  a.BPCustomerFullName ,
  a.AddressID,
//  a.CustomerFullName,
  b.OrganizationName1,
  b.OrganizationName2,
  b.OrganizationName3,
  b.OrganizationName4,
  a.CityName,
  a.Region,
  c.RegionName,
  a.PostalCode,
  a.TaxNumber3 as gstin_no,
  b.Country,
  b.DistrictName,
  b.HouseNumber,
  b.Street,
  b.StreetName,
  b.StreetPrefixName1,
  b.StreetPrefixName2,
  b.StreetSuffixName1,
  b.StreetSuffixName2,
  a.SortField,
  //a.TelephoneNumber2,
 // a.FaxNumber,
  a.SupplierAccountGroup,
  a.SupplierAgentProcedureGroup,
  a.TrainStationName,
  a.BusinessPartnerPanNumber as pan_no
  
  

  
  
  
}
