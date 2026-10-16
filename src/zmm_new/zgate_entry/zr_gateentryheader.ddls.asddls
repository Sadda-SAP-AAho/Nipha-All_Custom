@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gate Entry Header CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_GateEntryHeader
  as select from zgateentryheader as GateEntryHeader
    inner join   zuser_item       as B on B.plant = GateEntryHeader.plant
  composition [0..*] of ZR_GateEntryLines as _GateEntryLines
  association [0..1] to ZI_GateEntryType  as _gateentrytype on $projection.EntryType = _gateentrytype.Value
{

  key GateEntryHeader.gateentryno           as GateEntryNo,
      GateEntryHeader.entrytype             as EntryType,
      GateEntryHeader.gateoutward           as GateOutward,
      GateEntryHeader.entrydate             as EntryDate,
      GateEntryHeader.invoiceno             as InvoiceNo,
      GateEntryHeader.invoicedate           as InvoiceDate,
      GateEntryHeader.refdocno              as RefDocNo,
      GateEntryHeader.billamount            as BillAmount,
      GateEntryHeader.lrno                  as LrNo,
      GateEntryHeader.lrdate                as LrDate,
      GateEntryHeader.purpose               as Purpose,
      GateEntryHeader.gateindate            as GateInDate,
      GateEntryHeader.gateintime            as GateInTime,
      GateEntryHeader.expectrtdate          as ExpectedReturnDate,
      GateEntryHeader.transportmode         as TransportMode,
      GateEntryHeader.vehicleno             as VehicleNo,
      GateEntryHeader.transportername       as TransporterName,
      GateEntryHeader.vehrepdate            as VehRepDate,
      GateEntryHeader.vehreptime            as VehRepTime,
      GateEntryHeader.slipno                as SlipNo,
      GateEntryHeader.invoiceparty          as InvoiceParty,
      GateEntryHeader.invoicepartyname      as InvoicePartyName,
      GateEntryHeader.invoicepartygst       as InvoicePartyGST,
      GateEntryHeader.drivername            as DriverName,
      GateEntryHeader.driverlicenseno       as DriverLicenseNo,
      GateEntryHeader.driverno              as DriverNo,
      GateEntryHeader.remarks               as Remarks,
      GateEntryHeader.grosswt               as GrossWt,
      GateEntryHeader.tarewt                as TareWt,
      GateEntryHeader.netwt                 as NetWt,
      GateEntryHeader.plant                 as Plant,
      GateEntryHeader.sloc                  as SLoc,
      GateEntryHeader.gateoutdate           as GateOutDate,
      GateEntryHeader.gateouttime           as GateOutTime,
      GateEntryHeader.requestedby           as RequestedBy,
      GateEntryHeader.cancelled             as Cancelled,
      GateEntryHeader.duration_days         as Duration_days,
      GateEntryHeader.duration_time         as Duration_time,
      @Semantics.user.createdBy: true
      GateEntryHeader.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      GateEntryHeader.created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      GateEntryHeader.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      GateEntryHeader.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      GateEntryHeader.local_last_changed_at as LocalLastChangedAt,
      _GateEntryLines,
      _gateentrytype,
      _gateentrytype.Description            as Gateentrytypedesc
}
where B.userid = $session.user
