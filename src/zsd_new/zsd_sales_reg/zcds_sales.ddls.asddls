@EndUserText.label: 'Sales Register'
@Search.searchable: false
@UI.headerInfo: {typeName: 'Sales Register'}
@Metadata.allowExtensions: true
//@Analytics.query:true
define view entity ZCDS_SALES
  with parameters
    @EndUserText.label: 'Cancel Indicator'
    p_cancel : abap_boolean
  as select from zsales_reg_tb as a
    inner join   zuser_item    as B on B.plant = a.plant

{
      @Search.defaultSearchElement: true
      //      @UI.selectionField: [{ position: 10 }] // Select-Options
      @UI.lineItem: [{ position: 10, label: 'Sales Invoice No' }]
      @EndUserText.label: 'Sales Invoice No'
      //   @Consumption.valueHelpDefinition: [{ entity : {  name: 'i_billingdocument', element: 'BILLINGDOCUMENT' } }]
  key a.invoiceno                     as InvoiceNo,

      @UI.lineItem: [{ position: 20, label:'Line Item No' }]
  key a.itemno                        as ItemNo,

      @UI.hidden: true
  key a.pricingprocedurestep          as PricingProcedureStep,

      @UI.hidden: true
  key a.pricingprocedurecounter       as PricingProcedureCounter,

      @UI.hidden: true
  key a.plant                         as Plant,

      @UI.hidden: true
  key a.product                       as Product,

      @UI.hidden: true
  key a.salesorder                    as SalesOrder,

      @UI.hidden: true
  key a.salesordertype                as SalesOrderType,

      @UI.hidden: true
  key a.partnerfunction               as PartnerFunction,

      @UI.hidden: true
  key a.salesorderitem                as SalesOrderItem,

      @UI.hidden: true
  key a.salescontract                 as SalesContract,

      @UI.hidden: true
  key a.salescontracttype             as SalesContractType,

      @UI.hidden: true
  key a.customer                      as Customer,

      @UI.hidden: true
  key a.billingdocument               as BillingDocument,

      @UI.lineItem: [{ position:30, label:'Sales Invoice Type' }]
      a.invoicetype                   as InvoiceType,

      @UI.lineItem: [{ position:40, label:'Sales Invoice Document Type Des.' }]
      a.invoicedocumenttypedes        as InvoiceDocumentTypeDes,

      @Search.defaultSearchElement: true
      @UI.selectionField: [{ position:50 }]
      @UI.lineItem: [{ position:50, label:'Sales Invoice Date' }]
      a.invoicedate                   as InvoiceDate,

      @UI.lineItem: [{ position:60, label:'Reference Invoice No' }]
      a.referenceinvoiceno            as ReferenceInvoiceNo,

      @UI.lineItem: [{ position:70, label:'Ref Invoice Date' }]
      a.refinvoicedate                as RefInvoiceDate,

      @UI.lineItem: [{ position: 80, label: 'Accounting Doc. No.' }]
      a.accountingdocno               as AccountingDocNo,

      @UI.lineItem: [{ position: 90, label: 'Customer PO No' }]
      a.customerpono                  as CustomerPONo,

      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 100, label: 'Sales Organization' }]
      a.salesorganization             as SalesOrganization,

      @UI.lineItem: [{ position: 110, label: 'Sales Organization Name' }]
      a.salesorganizationname         as SalesOrganizationName,

      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 120, label: 'Distribution Channel' }]
      a.distributionchannel           as DistributionChannel,

      @UI.lineItem: [{ position: 130, label: 'Distribution Channel Name' }]
      a.distributionchannelname       as DistributionChannelName,

      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 140, label: 'Sales Division' }]
      a.salesdivision                 as SalesDivision,

      @UI.lineItem: [{ position: 150, label: 'Sales Division Name' }]
      a.salesdivisionname             as SalesDivisionName,

      @UI.lineItem: [{ position: 160, label: 'Sales Office' }]
      a.salesoffice                   as SalesOffice,

      @UI.lineItem: [{ position: 170, label: 'Sales Office Name' }]
      a.salesofficename               as SalesOfficeName,

      @UI.lineItem: [{ position: 180, label: 'Sales Group' }]
      a.salesgroup                    as SalesGroup,

      @UI.lineItem: [{ position: 190, label: 'Sales Group Name' }]
      a.salesgroupname                as SalesGroupName,

      @UI.lineItem: [{ position: 200, label: 'Sold To Customer Code' }]
      a.soldtocustomercode            as SoldToCustomerCode,

      @UI.lineItem: [{ position: 210, label: 'Sold To Customer Name' }]
      a.soldtocustomername            as SoldToCustomerName,

      @UI.lineItem: [{ position: 220, label: 'Sold To Customer GSTIN No' }]
      a.soldtocustomergstinno         as SoldToCustomerGSTINNo,

      @UI.lineItem: [{ position: 230, label: 'Sold-to-party Address' }]
      a.soldtopartyaddress            as SoldToPartyAddress,

      @UI.lineItem: [{ position: 240, label: 'Sold-to-party State' }]
      a.soldtopartystate              as SoldToPartyState,

      @UI.lineItem: [{ position: 245, label: 'Sold-to-party City' }]
      a.soldtopartycity               as SoldToPartyCity,

      @UI.lineItem: [{ position: 250, label: 'Sold-To Party Country' }]
      a.soldtopartycountry            as SoldToPartyCountry,

      @UI.lineItem: [{ position: 260, label: 'Sold to party Pincode' }]
      a.soldtopartypincode            as SoldToPartyPincode,

      @Search.defaultSearchElement: true
      @UI.selectionField: [{ position: 270 }]
      @UI.lineItem: [{ position: 270, label: 'Bill-To Party Code' }]
      a.billtopartycode               as BillToPartyCode,

      @UI.lineItem: [{ position: 280, label: 'Bill To Party Name' }]
      a.billtopartyname               as BillToPartyName,

      @UI.lineItem: [{ position: 290, label: 'Bill to party Address' }]
      a.billtopartyaddress            as BillToPartyAddress,

      @UI.lineItem: [{ position: 300, label: 'Bill to party State' }]
      a.billtopartystate              as BillToPartyState,


 @UI.lineItem: [{ position: 305, label: 'Bill to party City' }]
      a.billtopartycity             as BillToPartyCity,

      @UI.lineItem: [{ position: 310, label: 'Bill-To Party Country' }]
      a.billtopartycountry            as BillToPartyCountry,
      
      

      @UI.lineItem: [{ position: 320, label: 'Bill to party Pin Code' }]
      a.billtopartypincode            as BillToPartyPinCode,

      @UI.lineItem: [{position: 320, label: 'Bill to Customer GSTIN No' }]
      a.billtopartygstin              as BillToPartyGSTIN,

      @UI.lineItem: [{ position: 330, label: 'Item Code' }]
      a.itemcode                      as ItemCode,

      @UI.lineItem: [{ position: 340, label: 'Item Description' }]
      a.itemdescription               as ItemDescription,

      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 350, label: 'Material Group Code' }]
      a.materialgroupcode             as MaterialGroupCode,

      @UI.lineItem: [{ position: 360, label: 'Mat Group Code Description' }]
      a.matgroupcodedescription       as MatGroupCodeDescription,

      @UI.lineItem: [{ position: 370, label: 'HSN Code' }]
      a.hsncode                       as HSNCode,

      @UI.lineItem: [{ position: 380, label: 'Standard Cost per Unit' }]
      a.standardcostperunit           as StandardCostPerUnit,

      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 390, label: 'Material Type Code' }]
      a.materialtypecode              as MaterialTypeCode,

      a.materialtypedescription       as MaterialTypeDescription,

      @UI.lineItem: [{ position: 410, label: 'Sales Invoice Quantity' }]
      a.salesinvoicequantity          as SalesInvoiceQuantity,

      @UI.lineItem: [{ position: 420, label: 'Sales Invoice Qty UOM' }]
      a.salesinvoiceqtyuom            as SalesInvoiceQtyUOM,

      @UI.lineItem: [{ position: 430, label: 'Sales Invoice Gross Weight' }]
      a.salesinvoicegrossweight       as SalesInvoiceGrossWeight,

      @UI.lineItem: [{ position: 440, label: 'Sales Invoice Net Weight' }]
      a.salesinvoicenetweight         as SalesInvoiceNetWeight,

      @UI.lineItem: [{ position: 450, label: 'Sales Invoice Weight UOM' }]
      a.salesinvoiceweightuom         as SalesInvoiceWeightUOM,

      @UI.lineItem: [{ position: 460, label: 'Sales Invoice Unit Price' }]
      a.salesinvoiceunitprice         as SalesInvoiceUnitPrice,

      @UI.lineItem: [{ position: 470, label: 'Sales Invoice Taxable Amount' }]
      a.salesinvoicetaxableamount     as SalesInvoiceTaxableAmount,

      //      @UI.lineItem: [{ position: 480, label: 'Free Goods Discount' }]
      //      a.freegoodsdiscount             as FreeGoodsDiscount,

      @UI.lineItem: [{ position: 490, label: 'Freight Amount' }]
      a.freightamount                 as FreightAmount,

      @UI.lineItem: [{ position: 500, label: 'Packing Amount' }]
      a.packingamount                 as PackingAmount,

      @UI.lineItem: [{ position: 510, label: 'Insurance Amount' }]
      a.insuranceamount               as InsuranceAmount,

      //      @UI.lineItem: [{ position: 520, label: 'Broker Amount' }]
      //      a.brokeramount                  as BrokerAmount,

      @UI.lineItem: [{ position: 530, label: 'Commission Agent Amount' }]
      a.commissionagentamount         as CommissionAgentAmount,

      @UI.lineItem: [{ position: 540, label: 'CGST%' }]
      a.cgstpercentage                as CGSTPercentage,

      @UI.lineItem: [{ position: 550, label: 'CGST Amount' }]
      a.cgstamount                    as CGSTAmount,

      @UI.lineItem: [{ position: 560, label: 'SGST%' }]
      a.sgstpercentage                as SGSTPercentage,

      @UI.lineItem: [{ position: 570, label: 'SGST Amount' }]
      a.sgstamount                    as SGSTAmount,

      @UI.lineItem: [{ position: 580, label: 'IGST%' }]
      a.igstpercentage                as IGSTPercentage,

      @UI.lineItem: [{ position: 590, label: 'IGST Amount' }]
      a.igstamount                    as IGSTAmount,

      @UI.lineItem: [{ position: 580, label: 'ZOIG%' }]
      a.zoigpercentage                as ZOIGPercentage,

      @UI.lineItem: [{ position: 590, label: 'ZOIG Amount' }]
      a.zoigamount                    as ZOIGAmount,

      @UI.lineItem: [{ position: 600, label: 'UGST%' }]
      a.ugstpercentage                as UGSTPercentage,

      @UI.lineItem: [{ position: 610, label: 'UGST Amount' }]
      a.ugstamount                    as UGSTAmount,

      @UI.lineItem: [{ position: 620, label: 'TCS%' }]
      a.tcspercentage                 as TCSPercentage,

      @UI.lineItem: [{ position: 630, label: 'TCS Amount' }]
      a.tcsamount                     as TCSAmount,

      @UI.lineItem: [{ position: 630, label: 'Discount Percent' }]
      a.discountpercent               as DisPercent,

      @UI.lineItem: [{ position: 631, label: 'Discount Amount' }]
      a.discountamount                as DisAmount,

      @UI.lineItem: [{ position: 640, label: 'Tax Amount' }]
      a.taxamount                     as TaxAmount,

      @UI.lineItem: [{ position: 650, label: 'Round Off' }]
      a.roundoff                      as RoundOff,

      @UI.lineItem: [{ position: 660, label: 'Invoice Amount' }]
      a.invoiceamount                 as InvoiceAmount,

      @UI.lineItem: [{ position: 670, label: 'Document Currency' }]
      a.documentcurrency              as DocumentCurrency,

      @UI.lineItem: [{ position: 680, label: 'Payment Term Code' }]
      a.paymenttermcode               as PaymentTermCode,

      @UI.lineItem: [{ position: 690, label: 'Description' }]
      a.description                   as Description,

      @UI.lineItem: [{ position: 700, label: 'Business Place' }]
      a.businessplace                 as BusinessPlace,

      @UI.lineItem: [{ position: 710, label: 'INCO Terms' }]
      a.incoterms                     as INCOTerms,

      @UI.lineItem: [{ position: 720, label: 'INCO Terms Location' }]
      a.incotermslocation             as INCOTermsLocation,

      @UI.lineItem: [{ position: 730, label: 'E-way Bill Number' }]
      a.ewaybillnumber                as EwayBillNumber,

      @UI.lineItem: [{ position: 740, label: 'IRN Ack Number' }]
      a.irnacknumber                  as IRNAckNumber,

      @UI.lineItem: [{ position: 750, label: 'E-way Bill Date & Time' }]
      a.ewaybilldatetime              as EwayBillDateTime,

      @UI.lineItem: [{ position: 760, label: 'Cancellation Invoice Number' }]
      a.cancellationinvoicenumber     as CancellationInvoiceNumber,

      @UI.lineItem: [{ position: 770, label: 'Cancellation Indicator' }]
      a.cancellationindicator         as CancellationIndicator,

      @UI.lineItem: [{ position: 780, label: 'PO Number' }]
      a.ponumber                      as PONumber,

      @UI.lineItem: [{ position: 790, label: 'PO Date' }]
      a.podate                        as PODate,

      @UI.lineItem: [{ position: 800, label: 'Outbound Delivery Number' }]
      a.outbounddeliverynumber        as OutboundDeliveryNumber,

      @UI.lineItem: [{ position: 810, label: 'Delivery Order Date' }]
      a.deliveryorderdate             as DeliveryOrderDate,

      @UI.lineItem: [{ position: 820, label: 'Actual GI Date' }]
      a.actualgidate                  as ActualGIDate,

      @UI.lineItem: [{ position: 830, label: 'Ship To Customer Code' }]
      a.shiptocustomercode            as ShipToCustomerCode,

      @UI.lineItem: [{ position: 840, label: 'Ship To Customer Name' }]
      a.shiptocustomername            as ShipToCustomerName,

      @UI.lineItem: [{ position: 850, label: 'Ship-to-party Address' }]
      a.shiptopartyaddress            as ShipToPartyAddress,

      @UI.lineItem: [{ position: 860, label: 'Ship-to-party City' }]
      a.shiptopartycity               as ShipToPartyCity,

      @UI.lineItem: [{ position: 870, label: 'Ship To party State' }]
      a.shiptopartystate              as ShipToPartyState,

      @UI.lineItem: [{ position: 880, label: 'Ship-To Party Country' }]
      a.shiptopartycountry            as ShipToPartyCountry,

      @UI.lineItem: [{ position: 890, label: 'Ship-to-party Pincode' }]
      a.shiptopartypincode            as ShipToPartyPincode,

      @UI.lineItem: [{ position: 900, label: 'Transporter Code' }]
      a.transportercode               as TransporterCode,

      @UI.lineItem: [{ position: 910, label: 'Transporter Name' }]
      a.transportername               as TransporterName,

      @UI.lineItem: [{ position: 920, label: 'Mode of Transport' }]
      a.modeoftransport               as ModeOfTransport,

      @UI.lineItem: [{ position: 930, label: 'Shipping Point' }]
      a.shippingpoint                 as ShippingPoint,

      @UI.lineItem: [{ position: 940, label: 'Dispatching Plant' }]
      a.dispatchingplant              as DispatchingPlant,

      @UI.lineItem: [{ position: 950, label: 'Dispatching Plant Name' }]
      a.dispatchingplantname          as DispatchingPlantName,

      @UI.lineItem: [{ position: 960, label: 'Receiving Plant' }]
      @UI.hidden: true
      a.receivingplant                as ReceivingPlant,

      @UI.lineItem: [{ position: 970, label: 'Receiving Plant Name' }]
      @UI.hidden: true
      a.receivingplantname            as ReceivingPlantName,


      @UI.lineItem: [{ position: 980, label: 'Storage location' }]
      a.storagelocation               as StorageLocation,

      @UI.lineItem: [{ position: 990, label: 'Descr. of Storage Loc.' }]
      a.storagelocationdescription    as StorageLocationDescription,

      @UI.lineItem: [{ position: 1000, label: 'Delivery Quantity' }]
      a.deliveryquantity              as DeliveryQuantity,

      @UI.lineItem: [{ position: 1010, label: 'UOM Delivery Qty' }]
      a.uomdeliveryqty                as UOMDeliveryQty,

      @UI.lineItem: [{ position: 1020, label: 'Batch' }]
      a.batch                         as Batch,

      @UI.lineItem: [{ position: 1030, label: 'Delivery Gross Weight with Packaging' }]
      a.dlvrygrossweightwithpackaging as DlvryGrossWeightWithPackaging,

      @UI.lineItem: [{ position: 1040, label: 'Delivery Net Oil Weight' }]
      a.deliverynetoilweight          as DeliveryNetOilWeight,

      @UI.lineItem: [{ position: 1050, label: 'Delivery Weight UOM' }]
      a.deliveryweightuom             as DeliveryWeightUOM,

      //      @UI.lineItem: [{ position: 1060, label: 'Bill of Lading' }]
      //      a.billoflading                  as BillOfLading,

      //      @UI.lineItem: [{ position: 1070, label: 'Port of Loading' }]
      //      a.portofloading                 as PortOfLoading,

      //      @UI.lineItem: [{ position: 1080, label: 'Goods Receipt/Issue Slip' }]
      //      goodsreceiptissueslip as GoodsReceiptIssueSlip,

      @UI.lineItem: [{ position: 1090, label: 'Token Number' }]
      a.tokennumber                   as TokenNumber,

      @UI.lineItem: [{ position: 1100, label: 'Token Date & Time' }]
      a.tokendatetime                 as TokenDateTime,

      @UI.lineItem: [{ position: 1110, label: 'Gate Entry Number' }]
      a.gateentrynumber               as GateEntryNumber,

      @UI.lineItem: [{ position: 1120, label: 'Gate Entry Date & Time' }]
      a.gateentrydatetime             as GateEntryDateTime,

      @UI.lineItem: [{ position: 1130, label: 'Vehicle Number' }]
      a.vehiclenumber                 as VehicleNumber,

      @UI.lineItem: [{ position: 1140, label: 'Vessel Name' }]
      a.vesselname                    as VesselName,

      @UI.lineItem: [{ position: 1150, label: 'LR No' }]
      a.lrno                          as LRNo,

      @UI.lineItem: [{ position: 1160, label: 'LR Date' }]
      a.lrdate                        as LRDate,

      @UI.lineItem: [{ position: 1170, label: 'Weighbridge Gross Weight' }]
      a.weighbridgegrossweight        as WeighbridgeGrossWeight,

      @UI.lineItem: [{ position: 1180, label: 'Weighbridge Tare Weight' }]
      a.weighbridgetareweight         as WeighbridgeTareWeight,

      @UI.lineItem: [{ position: 1190, label: 'Weighbridge Net Weight' }]
      a.weighbridgenetweight          as WeighbridgeNetWeight,

      @UI.lineItem: [{ position: 1200, label: 'UOM Weighbridge' }]
      a.uomweighbridge                as UOMWeighbridge,

      @UI.lineItem: [{ position: 1210, label: 'Gate Out Number' }]
      a.gateoutnumber                 as GateOutNumber,

      @UI.lineItem: [{ position: 1220, label: 'Gate Out Date & Time' }]
      a.gateoutdatetime               as GateOutDateTime,

      @UI.lineItem: [{ position: 1230, label: 'Sales Order No' }]
      a.salesorderno                  as SalesOrderNo,

      @UI.lineItem: [{ position: 1240, label: 'Sales Order Date' }]
      a.salesorderdate                as SalesOrderDate,

      @UI.lineItem: [{ position: 1250, label: 'Sales Order Type' }]
      a.salesorder_type               as SalesOrder_Type,

      @UI.lineItem: [{ position: 1260, label: 'Sales Order Type Desc' }]
      a.salesordertypedesc            as SalesOrderTypeDesc,

      @UI.lineItem: [{ position: 1270, label: 'Customer PO No' }]
      a.customerpono2                 as CustomerPONo2,

      @UI.lineItem: [{ position: 1280, label: 'Customer PO Date' }]
      a.customerpodate                as CustomerPODate,

      @UI.lineItem: [{ position: 1290, label: 'Sales Employee Code' }]
      a.salesemployeecode             as SalesEmployeeCode,

      @UI.lineItem: [{ position: 1300, label: 'Sales Employee Name' }]
      a.salesemployeename             as SalesEmployeeName,

      @UI.lineItem: [{ position: 1310, label: 'Broker Code' }]
      a.brokercode                    as BrokerCode,

      @UI.lineItem: [{ position: 1320, label: 'Broker Name' }]
      a.brokername                    as BrokerName,

      @UI.lineItem: [{ position: 1330, label: 'Commission Agent Code' }]
      a.commissionagentcode           as CommissionAgentCode,

      @UI.lineItem: [{ position: 1340, label: 'Commission Agent Name' }]
      a.commissionagentname           as CommissionAgentName,

      @UI.lineItem: [{ position: 1350, label: 'Contact Person Code' }]
      a.contactpersoncode             as ContactPersonCode,

      @UI.lineItem: [{ position: 1360, label: 'Contact Person Name' }]
      a.contactpersonname             as ContactPersonName,

      //      @UI.lineItem: [{ position: 1370, label: 'Order Quantity' }]
      //      orderquantity as OrderQuantity,

      //      @UI.lineItem: [{ position: 1380, label: 'Confirmed Quantity' }]
      //      confirmedquantity as ConfirmedQuantity,

      //      @UI.lineItem: [{ position: 1390, label: 'Sales Unit' }]
      //      salesunit as SalesUnit,

      @UI.lineItem: [{ position: 1400, label: 'Order Reason' }]
      a.orderreason                   as OrderReason,

      @UI.lineItem: [{ position: 1410, label: 'Order Reason Description' }]
      a.orderreasondescription        as OrderReasonDescription,

      @UI.lineItem: [{ position: 1420, label: 'Against Invoice Number' }]
      a.againstinvoicenumber          as AgainstInvoiceNumber,

      @UI.lineItem: [{ position: 1430, label: 'Against Invoice Date' }]
      a.againstinvoicedate            as AgainstInvoiceDate,

      @UI.lineItem: [{ position: 1440, label: 'Customer Group' }]
      a.customergroup                 as CustomerGroup,

      @UI.lineItem: [{ position: 1450, label: 'Sales District' }]
      a.salesdistrict                 as SalesDistrict,

      @UI.lineItem: [{ position: 1460, label: 'Sales Contract No' }]
      @UI.selectionField: [{exclude: true}]
      a.salescontractno               as SalesContractNo,

      @UI.lineItem: [{ position: 1470, label: 'Sales Contract Date' }]
      a.salescontractdate             as SalesContractDate,

      @UI.lineItem: [{ position: 1480, label: 'Sales Contract Valid From Date' }]
      a.salescontractvalidfromdate    as SalesContractValidFromDate,

      @UI.lineItem: [{ position: 1490, label: 'Sales Contract Valid To Date' }]
      a.salescontractvalidtodate      as SalesContractValidToDate,

      //      @UI.lineItem: [{ position: 1500, label: 'Sales Contract Quantity' }]
      @UI.hidden: true
      a.salescontractquantity         as SalesContractQuantity,

      //      @UI.lineItem: [{ position: 1510, label: 'Sales Contract Quantity UOM' }]
      @UI.hidden: true
      a.salescontractquantityuom      as SalesContractQuantityUOM,

      @UI.lineItem: [{ position: 1520, label: 'Sales Contract Type' }]
      a.salescontract_type            as SalesContract_Type,


      @UI.lineItem: [{ position: 1521, label: 'Field' }]
      a.field,

      @UI.lineItem: [{ position: 1522, label: 'Designation' }]
      a.desgination,

      @UI.lineItem: [{ position: 1523, label: 'RM' }]
      a.rm,

      @UI.lineItem: [{ position: 1524, label: 'ZM' }]
      a.zm,

      @UI.lineItem: [{ position: 1525, label: 'Sales Head' }]
      a.sales_head,

      @UI.lineItem: [{ position: 1530, label: 'Created By' }]
      a.created_by                    as Created_By,

      @UI.lineItem: [{ position: 1540, label: 'Remarks' }]
      a.yy1_remarks_bd_bdh            as YY1_Remarks_bd_BDH,

      @UI.lineItem: [{ position: 1550, label: 'Profit Center' }]
      a.profit_center                 as Profit_Center,

      @UI.lineItem: [{ position: 1560, label: 'Customer State Code' }]
      a.customer_state_code           as Customer_State_Code,

      @UI.lineItem: [{ position: 1570, label: 'Sundry DR' }]
      a.glaccount                     as GlAccount,

      @UI.lineItem: [{ position: 1580, label: 'Sales GL description' }]
      a.glaccountname                 as GlAccountName,

      @UI.lineItem: [{ position: 1590, label: 'Gross Bill Value' }]
      a.gross_bill_num                as Gross_Bill_Num,

      @UI.lineItem: [{ position: 1600, label: 'Exchange Rate' }]
      a.exchange_rate                 as Exchange_Rate,


      @UI.lineItem: [{ position: 1610, label: 'Gross Value (Forex Currency)' }]
      a.gross_value_forex             as GrossValue_Forex,

      @UI.lineItem: [{ position: 1620, label: 'Gross Value (INR)' }]
      a.gross_value_inr               as GrossValue_Inr,

      @UI.lineItem: [{ position: 1630, label: 'Invoice Value (Forex Currency)' }]
      a.invoice_value_forex           as InvoiceValue_forex,

      @UI.lineItem: [{ position: 1640, label: 'Invoice Value (INR)' }]
      a.invoice_value_inr             as InvoiceValue_Inr



}
where
      B.userid                = $session.user
  and a.cancellationindicator = $parameters.p_cancel
  and a.invoicetype           <> 'S1'
  and a.invoicetype           <> 'S2'
