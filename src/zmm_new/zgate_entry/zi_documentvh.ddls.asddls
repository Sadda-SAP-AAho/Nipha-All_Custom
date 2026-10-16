@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help to Get Details in Lines'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DocumentVH
  as select from    I_PurchaseOrderAPI01     as PUR
    join            I_PurchaseOrderItemAPI01 as PurchaseOrderItem on PUR.PurchaseOrder = PurchaseOrderItem.PurchaseOrder
    left outer join ZREMQTY_CALC             as _GRN              on  _GRN.PurchaseOrder     = PUR.PurchaseOrder
                                                                  and _GRN.PurchaseOrderItem = concat(
      '0', PurchaseOrderItem.PurchaseOrderItem
    )
  //    left outer join ZR_TAXCODE as TaxCode on TaxCode.Taxcode = PurchaseOrderItem.TaxCode
    left outer join ZI_TaxCodeSum            as TaxCode           on TaxCode.TaxCode = PurchaseOrderItem.TaxCode
    left outer join I_UnitOfMeasure          as UOM               on UOM.UnitOfMeasure = PurchaseOrderItem.PurchaseOrderQuantityUnit
{
  key cast(PUR.PurchaseOrder as abap.char(15))                                     as DocumentNo,
  key cast('PUR'        as abap.char(10))                                          as EntryType,
  key concat('0',PurchaseOrderItem.PurchaseOrderItem)                              as DocumentItemNo,
      PurchaseOrderItem.Material                                                   as DocumentItem,
      PurchaseOrderItem.PurchaseOrderItemText                                      as DocumentItemText,
      PUR.PurchaseOrderDate                                                        as DocumentDate,
      cast(PUR.PurchaseOrderType as abap.char(10))                                 as DocumentType,
      PUR.Supplier                                                                 as InvoicingParty,
      cast(PUR._Supplier.SupplierName as abap.char(81))                            as InvoicingPartyName,
      PUR._Supplier.BusinessPartnerPanNumber                                       as InvoicingPartyPAN,
      PUR.CompanyCode                                                              as CompanyCode,
      PurchaseOrderItem.Plant                                                      as Plant,
      //        PurchaseOrderItem.StorageLocation               as                  StorageLocation,
      TaxCode.GST                                                                  as GST,
      cast(PurchaseOrderItem.OrderQuantity as abap.dec(15,2))                      as DocumentItemQty,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      PurchaseOrderItem.NetAmount                                                  as DocumentItemPrice,
      PurchaseOrderItem.DocumentCurrency                                           as DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      cast(PurchaseOrderItem.NetPriceAmount  as abap.curr(13,2))                   as Rate,
      UOM.UnitOfMeasure_E                                                          as DocumentItemQtyUnit,
      cast(case when _GRN.GRNQty is null then PurchaseOrderItem.OrderQuantity
      else (PurchaseOrderItem.OrderQuantity - _GRN.GRNQty)  end as abap.dec(15,2)) as BalQty,
      //        Tolerance Qty
      cast(
          PurchaseOrderItem.OrderQuantity * PurchaseOrderItem.OverdelivTolrtdLmtRatioInPct / 100
          as abap.dec(15,2))                                                       as ToleranceQty
}
where
      PurchaseOrderItem.PurchasingDocumentDeletionCode =  ''
  and PurchaseOrderItem.IsCompletelyDelivered          =  ''
  and PUR.ReleaseIsNotCompleted                        =  ''
  and PUR.PurchaseOrderType                            != 'ZSRV'
  and PUR.PurchaseOrderType                            != 'ZRET'

union select from ZR_GateEntryHeader as EntryHeader
  join            ZR_GateEntryLines  as EntryLines on EntryLines.GateEntryNo = EntryHeader.GateEntryNo
  left outer join ZREMQTY_CALC       as _GRN       on  _GRN.PurchaseOrder     = EntryHeader.GateEntryNo
                                                   and _GRN.PurchaseOrderItem = EntryLines.GateItemNo
  left outer join I_UnitOfMeasure    as UOM        on UOM.UnitOfMeasure_E = EntryLines.UOM
{
  key EntryHeader.GateEntryNo                       as DocumentNo,
  key 'RGP-IN'                                      as EntryType,
  key EntryLines.GateItemNo                         as DocumentItemNo,
      EntryLines.ProductCode                        as DocumentItem,
      EntryLines.ProductDesc                        as DocumentItemText,
      EntryHeader.EntryDate                         as DocumentDate,
      'RGP-OUT'                                     as DocumentType,
      EntryLines.PartyCode                          as InvoicingParty,
      EntryLines.PartyName                          as InvoicingPartyName,
      ''                                            as InvoicingPartyPAN,
      ''                                            as CompanyCode,
      EntryLines.Plant                              as Plant,
      //        EntryLines.SLoc                                 as                  StorageLocation,
      EntryLines.GST                                as GST,

      EntryLines.GateQty                            as DocumentItemQty,
      cast(EntryLines.GateValue as abap.curr(13,2)) as DocumentItemPrice,
      cast('INRAB' as abap.cuky)                    as DocumentCurrency,
      cast(EntryLines.Rate as abap.curr(13,2))      as Rate,
      UOM.UnitOfMeasure_E                           as DocumentItemQtyUnit,
      cast(
         ( case
             when _GRN.GRNQty is null then cast( EntryLines.GateQty as abap.dec(15,3) )
             else cast( EntryLines.GateQty as abap.dec(15,3) ) - cast( _GRN.GRNQty as abap.dec(15,3) )
           end
         ) as abap.dec(13,3)
      )                                             as BalQty,
      0                                             as ToleranceQty
}
where
      EntryHeader.GateOutward = 0
  and EntryHeader.EntryType   = 'RGP-OUT'
union

select from       I_SalesDocument                as SO
  join            I_SalesDocumentItem            as SOItem      on SO.SalesDocument = SOItem.SalesDocument
  left outer join I_SalesDocumentPartner         as SOP         on  SO.SalesDocument    = SOP.SalesDocument
                                                                and SOP.PartnerFunction = 'RE'
  left outer join I_SalesOrderItemPricingElement as SOItemPrice on  SOItem.SalesDocument        = SOItemPrice.SalesOrder
                                                                and SOItem.SalesDocumentItem    = SOItemPrice.SalesOrderItem
                                                                and (
                                                                   SOItemPrice.ConditionType    = 'ZBSP'
                                                                   or SOItemPrice.ConditionType = 'JOSG'
                                                                   or SOItemPrice.ConditionType = 'JOCG'
                                                                   or SOItemPrice.ConditionType = 'JOIG'
                                                                 )
//  Finding Refernce Document
  left outer join I_BillingDocumentItem          as RSO         on  RSO.BillingDocument     = SOItem.ReferenceSDDocument
                                                                and RSO.BillingDocumentItem = SOItem.ReferenceSDDocumentItem
  left outer join I_UnitOfMeasure                as UOM         on UOM.UnitOfMeasure = SOItem.OrderQuantityUnit
{
  key cast(SO.SalesDocument as abap.char(15))                        as DocumentNo,
  key cast('SALESRET' as abap.char(10))                              as EntryType,
  key cast(SOItem.SalesDocumentItem as abap.char(6))                 as DocumentItemNo,
      SOItem.Product                                                 as DocumentItem,
      SOItem.SalesDocumentItemText                                   as DocumentItemText,
      SO.CreationDate                                                as DocumentDate,
      cast(SO.SalesDocumentType as abap.char(10))                    as DocumentType,
      SOP.Customer                                                   as InvoicingParty,
      cast(SOP.FullName as abap.char(81))                            as InvoicingPartyName,
      ''                                                             as InvoicingPartyPAN,
      ''                                                             as CompanyCode,
      SOItem.Plant                                                   as Plant,
      case
      when SOItem.TaxAmount is null or SOItem.TaxAmount = 0
          then cast( 0 as abap.dec(5,2) )
      else
          cast(
              cast( (SOItem.TaxAmount * 100) as abap.dec(15,2) ) /
              cast( SOItem.NetAmount as abap.dec(15,2) )
              as abap.dec(5,2)
          )
      end                                                            as GST,
      cast(SOItem.OrderQuantity as abap.dec(15,2))                   as DocumentItemQty,
      //********
      //      cast((SOItem.NetAmount + SOItem.TaxAmount) as abap.curr(13,2)) as DocumentItemPrice,
      cast((SOItem.NetAmount + SOItem.TaxAmount) as abap.curr(23,2)) as DocumentItemPrice,
      cast('' as abap.cuky( 5 ))                                     as DocumentCurrency,
      cast(SOItem.NetPriceAmount as abap.curr(13,2))                 as Rate,
      //      cast(   UOM.UnitOfMeasure_E as abap.char(3) )                  as DocumentItemQtyUnit,
      cast(UOM.UnitOfMeasure_E as abap.char(3))                      as DocumentItemQtyUnit,

      cast(SOItem.OrderQuantity as abap.dec(15,2))                   as BalQty,
      cast( 0 as abap.dec(15,2))                                     as ToleranceQty

}
where
  SO.SalesDocumentType = 'CBRE';
