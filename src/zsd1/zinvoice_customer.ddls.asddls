@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Customer Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZINVOICE_CUSTOMER as  select from I_BillingDocumentPartner as a
inner join ZCUSTOMER as C on C.Customer = a.Customer and a.PartnerFunction = 'AG'
{
  key a.BillingDocument ,
  
  C.Customer as sold_to_customer,
  C.CustomerFullName as sold_to_full_name,
  C.OrganizationName1 as sold_to_name1,
  C.OrganizationName2 as sold_to_name2,
  C.OrganizationName3 as sold_to_name3,
  C.OrganizationName4 as sold_to_name4,
  C.CityCode as sold_to_citycode,
  C.CityName as sold_to_cityname,
  C.Region as sold_to_region,
  C.RegionName as sold_to_region_name,
  C.PostalCode as sold_to_pin,
  C.gstin_no as sold_to_gstin,
  C.Country as sold_to_country,
  C.DistrictName as sold_to_dictrict,
  C.HouseNumber as sold_to_house_no,
  C.Street as sold_to_street,
  C.StreetName as sold_to_street_name,
  C.StreetPrefixName2 as sold_to_street_pre1,
  C.StreetPrefixName2 as sold_to_street_pre2,
  C.StreetSuffixName1 as sold_to_street_suf1,
  C.StreetSuffixName2 as sold_to_street_suf2,
  C.SortField as sold_to_SortField,
  C.TelephoneNumber1 as sold_to_tel1,
  C.TelephoneNumber2 as sold_to_tel2,
  C.FaxNumber as sold_to_fix,
  C.CustomerAccountGroup as SOLD_TO_AC_GROUP
}
