@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Payer to party'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZINVOICE_PAYER_TO_PARTY as select from I_BillingDocumentPartner as a
inner join ZCUSTOMER as C on C.Customer = a.Customer and a.PartnerFunction = 'RG'
{
  key a.BillingDocument,
  
  C.Customer as Payer_to_customer ,
  C.CustomerFullName as Payer_to_full_name,
  C.OrganizationName1 as Payer_to_name1,
  C.OrganizationName2 as Payer_to_name2,
  C.OrganizationName3 as Payer_to_name3,
  C.OrganizationName4 as Payer_to_name4,
  C.CityCode as Payer_to_citycode,
  C.CityName as Payer_to_cityname,
  C.Region as Payer_to_region,
  C.RegionName as Payer_to_region_name,
  C.PostalCode as Payer_to_pin,
  C.gstin_no as Payer_to_gstin,
  C.Country as Payer_to_country,
  C.DistrictName as Payer_to_dictrict,
  C.HouseNumber as Payer_to_house_no,
  C.Street as Payer_to_street,
  C.StreetName as Payer_to_street_name,
  C.StreetPrefixName2 as Payer_to_street_pre1,
  C.StreetPrefixName2 as Payer_to_street_pre2,
  C.StreetSuffixName1 as Payer_to_street_suf1,
  C.StreetSuffixName2 as Payer_to_street_suf2,
  C.SortField as Payer_to_SortField,
  C.TelephoneNumber1 as Payer_to_tel1,
  C.TelephoneNumber2 as Payer_to_tel2,
  C.FaxNumber as Payer_to_fix
}
 