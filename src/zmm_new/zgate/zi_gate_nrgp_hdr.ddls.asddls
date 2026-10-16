@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'View Entity for gate header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_GATE_NRGP_HDR
  as select from ZC_GATE_NRGP_HDR
{
  key DocumentNo,
      NrgpNo,
      Plant,
      PartnerType,
      PartnerCode,
      DocumentDate,
      NrgpDate,
      PartnerName,
      FromStorageLoc,
      Addr1,
      Addr2,
      StateCode,
      Pin,
      Status,
      Description1,
      Description2,
      ReferenceDocument
}
