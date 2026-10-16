@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@ObjectModel.sapObjectNodeType.name: 'ZDRC'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_IRN
  as select from ztable_irn as a
    inner join   zuser_item as B on a.plant = B.plant

{
  key a.billingdocument       as BillingDocument,
      a.companycode           as CompanyCode,
      a.billingdocumenttype   as BillingDocumentType,
      a.plant                 as Plant,
      a.billingdocumentdate   as BillingDocumentDate,
      a.partycode             as PartyCode,
      a.partyname             as PartyName,
      a.distributionchannel   as DistributionChannel,
      a.documentreferenceid   as DocumentReferenceID,
      a.irnno                 as IRNNo,
      a.irnstatus             as IRNStatus,
      a.ackno                 as AckNo,
      a.ackdate               as AckDate,
      a.irncanceldate         as IrnCancelDate,
      a.signedinvoice         as SignedInvoice,
      a.signedqrcode          as SignedQRCode,
      a.ewayvaliddate         as EwayValidDate,
      a.ewaytranstype         as EwayTransType,
      a.distance              as Distance,
      a.vehiclenum            as VehicleNum,
      a.ewaybillno            as EwayBillNo,
      a.ewaydate              as EwayDate,
      a.ewaystatus            as EwayStatus,
      a.ewaycanceldate        as EwayCancelDate,
      a.address               as Address,
      a.place                 as Place,
      a.pincode               as PinCode,
      a.state                 as State,
      a.statecode             as StateCode,
      a.transportername       as TransporterName,
      a.transportergstin      as TransporterGSTIN,
      a.transportmode         as TransportMode,
      a.grno                  as GRNo,
      a.grdate                as GRDate,
      a.containerno           as ContainerNo,
      a.linesealno            as LineSealNo,
      a.customsealno          as CustomSealNo,
      a.grossweight           as GrossWeight,
      a.netweight             as NetWeight,
      a.destinationcountry    as DestinationCountry,
      a.bookingno             as BookingNo,
      a.maxgrosswt            as MaxGrossWT,
      a.ctarewt               as CTareWT,
      a.maxcargowt            as MaxCargoWT,
      a.irncreatedby          as IrnCreatedBy,
      a.ewaycreatedby         as EwayCreatedBy,
      a.shipbno               as Shipbno,
      a.shipbdt               as Shipbdt,
      a.port                  as Port,
      a.refclm                as Refclm,
      a.forcur                as Forcur,
      a.cntcode               as Cntcode,
      a.expduty               as Expduty,
      a.trans_ship_pin        as Trans_ship_pin,
      @Semantics.user.createdBy: true
      a.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      a.created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      a.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      a.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      a.local_last_changed_at as LocalLastChangedAt
}
where B.userid = $session.user
