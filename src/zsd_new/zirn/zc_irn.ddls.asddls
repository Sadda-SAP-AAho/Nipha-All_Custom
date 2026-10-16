@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
//@ObjectModel: {
//  sapObjectNodeType.name: 'ZDRC'
//}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_IRN
  provider contract transactional_query
  as projection on ZR_IRN


{
  key BillingDocument,
      CompanyCode,
      BillingDocumentType,
      Plant,
      BillingDocumentDate,
      PartyCode,
      PartyName,
      DistributionChannel,
      DocumentReferenceID,
      IRNNo,
      IRNStatus,
      AckNo,
      AckDate,
      IrnCancelDate,
      SignedInvoice,
      SignedQRCode,
      EwayValidDate,
      Distance,
      VehicleNum,
      EwayBillNo,
      EwayDate,
      EwayStatus,
      EwayCancelDate,
      EwayTransType,
      Address,
      Place,
      PinCode,
      State,
      StateCode,
      TransporterName,
      TransporterGSTIN,
      TransportMode,
      GRNo,
      GRDate,
      ContainerNo,
      LineSealNo,
      CustomSealNo,
      GrossWeight,
      NetWeight,
      DestinationCountry,
      BookingNo,
      MaxGrossWT,
      CTareWT,
      MaxCargoWT,
      IrnCreatedBy,
      EwayCreatedBy,
      Shipbno,
      Shipbdt,
      Port,
      Refclm,
      Forcur,
      Cntcode,
      Expduty,
      Trans_ship_pin,

      @Semantics: {
        user.createdBy: true
      }
      CreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      CreatedAt,
      @Semantics: {
        user.localInstanceLastChangedBy: true
      }
      LastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LastChangedAt,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LocalLastChangedAt

}
