@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS FOR GATEPASS REPORT'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCDS_GATEPASS_REPORT
  as select from    zgatepassheader            as A
    left outer join zgatepasslineitm           as B on B.gate_pass = A.gate_pass
    left outer join I_BillingDocumentPartner   as c on  c.BillingDocument = B.document_no
                                                    and c.PartnerFunction = 'AG'
    left outer join I_BillingDocumentItemBasic as d on  d.BillingDocument = B.document_no
    left outer join I_MaterialDocumentItem_2   as H on  H.MaterialDocument = d.ReferenceSDDocument
{
  key A.gate_pass                     as GateEntryNo,
  key B.pass_line_no,
      max( A.plant )                  as Plant,
      max( A.type )                   as type,
      max( A.out_date )               as GateOutDate,
      max( A.out_time )               as out_time,
      max( A.entry_date )             as GateInDate,
      max( A.entry_time )             as GateEntryTime,
      max( A.vehicle_number )         as vehicle_number,
      max( A.cancelled )              as cancelled,
      max( c.Customer )               as Customer,
      max( case
              when A.type = 'DC'  then H.PurchaseOrder
              when A.type = 'INV' then d.SalesDocument
              else ''
           end )                      as SalesDocument,
      max( B.document_no )            as document_no,
      max( case
              when A.type = 'DC' then B.document_no
              else ''
           end )                      as jobber_challan,
      max( case
              when A.type = 'DC' then B.document_date
              else null
           end )                      as challan_date,
      max( d.Product )                as Product,
      max( d.BillingDocumentItemText ) as BillingDocumentItemText,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      max( B.quantity )               as quantity,
       d.BaseUnit               as BaseUnit,
      max( A.driver_name )            as driver_name,
      max( A.remarks )                as remarks,
      max( A.duration_days )          as duration_days,
      max( A.duration_time )          as duration_time,
      max( A.driver_number )          as driver_number,
      max( A.transporter_name )       as transporter_name,
      max( case
              when A.cancelled is not initial then cast( 'Cancelled' as abap.char(20) )
              when A.out_date is not initial  then cast( 'Complete' as abap.char(20) )
              else cast( 'Pending' as abap.char(20) )
           end )                      as Status
}
group by A.gate_pass, B.pass_line_no , d.BaseUnit
