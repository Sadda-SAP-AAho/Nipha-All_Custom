@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS FOR GATEENTRY REPORT'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCDS_GATEENTRY_REPORT
  as select from    ZR_GateEntryHeader       as A
    left outer join ZR_GateEntryLines        as B on B.GateEntryNo = A.GateEntryNo 
    left outer join I_MaterialDocumentItem_2 as c on c.YY1_GatePassNo_MMI = A.GateEntryNo and c.PurchaseOrder   = B.DocumentNo
                                                                                          and c.PurchaseOrderItem = cast( right( B.DocumentItemNo, 5 ) as abap.numc( 5 ) )
    left outer join I_BusinessPartner        as D on D.BusinessPartner = lpad( A.InvoiceParty, 10, '0' )
{
  key A.GateEntryNo,
  key B.GateItemNo,
      B.DocumentItemNo,
      A.Plant,
      A.EntryType,
      A.GateInDate,
      A.GateInTime,
      A.GateOutDate,
      A.GateOutTime,
      A.VehicleNo,
      A.InvoiceParty,
      case 
        when A.InvoicePartyName is not initial then A.InvoicePartyName
        else D.BusinessPartnerName
      end as InvoicePartyName,
      B.DocumentNo,
      A.InvoiceNo,
      A.Remarks,
      B.ProductCode,
      B.ProductDesc,
      B.GateQty,
      B.UOM,
      A.GrossWt,
      A.TareWt,
      A.NetWt,
      A.TransporterName,
      A.DriverName,
      A.DriverNo,
      A.DriverLicenseNo,
      B.Remarks as LINEREMAKS,
      A.Duration_days,
      A.Duration_time,
      c.MaterialDocument,
      c.PostingDate
}
