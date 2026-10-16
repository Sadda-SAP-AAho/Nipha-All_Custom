@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant Detatils'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zplant as select from I_Plant as a
left outer join I_Address_2  as b on a.AddressID = b.AddressID
left outer join I_RegionText as c on c.Region = b.Region and c.Language = 'E'
and c.Country = 'IN'
left outer join I_KR_BusinessPlace as D on a.BusinessPlace = D.Branch
{
  a.Plant,
  a.PlantName,                  //1st
  a.AddressID,
  b.OrganizationName1,
  b.OrganizationName2,
  b.OrganizationName3,
  b.OrganizationName4,
  b.CityName,
  b.PostalCode,
  b.StreetName,                 //3rd
  b.Region,
  c.RegionName,
  D.VATRegistration as PLANT_PAN_NO,
  D.TaxNumber1 as plant_gstin_no,
  b.AddressSearchTerm1,
  b.AddressSearchTerm2,
  b.CityNumber,
  b.DistrictName,
  b.VillageName,
  b.CompanyPostalCode,
  b.Street,
  b.StreetPrefixName1,          
  b.StreetPrefixName2,
  b.StreetSuffixName1,          //4th
  b.StreetSuffixName2,          //5th
  b.HouseNumber,                //2nd 
  b.Country     
}
