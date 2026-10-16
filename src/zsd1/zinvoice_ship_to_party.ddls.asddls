@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Ship to party'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZINVOICE_SHIP_TO_PARTY as select from I_BillingDocument as a
right outer join I_BillingDocItemPartner as b on a.BillingDocument = b.BillingDocument
right outer join ZCUSTOMER as D on b.Customer = D.Customer
{
    key a.BillingDocument,
    key b.Customer as ship_to_customer,
//      d.Customer as ship_to_customer,
      D.CustomerFullName as ship_to_full_name,
      D.OrganizationName1 as ship_to_name1,
      D.OrganizationName2 as ship_to_name2,
      D.OrganizationName3 as ship_to_name3,
      D.OrganizationName4 as ship_to_name4,
      D.CityCode as ship_to_citycode,
      D.CityName as ship_to_cityname,
      D.Region as ship_to_region,
      D.RegionName as ship_to_region_name,
      D.PostalCode as ship_to_pin,
      D.gstin_no as ship_to_gstin,
      D.Country as ship_to_country,
      D.DistrictName as ship_to_dictrict,
      D.HouseNumber as ship_to_house_no,
      D.Street as ship_to_street,
      D.StreetName as ship_to_street_name,
      D.StreetPrefixName2 as ship_to_street_pre1,
      D.StreetPrefixName2 as ship_to_street_pre2,
      D.StreetSuffixName1 as ship_to_street_suf1,
      D.StreetSuffixName2 as ship_to_street_suf2,
      D.SortField as ship_to_SortField,
      D.TelephoneNumber1 as ship_to_tel1,
      D.TelephoneNumber2 as ship_to_tel2,
      D.FaxNumber as ship_to_fix
}
where a.BillingDocument <> ''
  group by a.BillingDocument,
           b.Customer,
           D.CustomerFullName,
           D.OrganizationName1,
           D.OrganizationName2,
           D.OrganizationName3,
           D.OrganizationName4,
           D.CityCode,
           D.CityName,
           D.Region,
           D.RegionName,
           D.PostalCode,
           D.gstin_no,
           D.Country,
           D.DistrictName,
           D.HouseNumber,
           D.Street,
           D.StreetName,
           D.StreetPrefixName1,
           D.StreetPrefixName2,
           D.StreetSuffixName1,
           D.StreetSuffixName2,
           D.SortField,
           D.TelephoneNumber1,
           D.TelephoneNumber2,
           D.FaxNumber
