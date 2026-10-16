@EndUserText.label: 'GRN Register'
@Search.searchable: false
@ObjectModel.query.implementedBy: 'ABAP:ZCL_GRN_REGISTER'
@UI.headerInfo: {typeName: 'Count' , typeNamePlural : 'Counts' }
define custom entity ZCDS_GRN_REG
{

      @UI.facet                   : [
        {
          id                      : 'GRNRegister',
          type                    : #IDENTIFICATION_REFERENCE,
          label                   : 'GRN Register Details',
          position                : 10
        }
      ]
      @UI.selectionField          : [{ position: 10 }]
      @UI.identification          : [ { position: 10 , label: 'GRN Document Number' } ]
      @EndUserText.label          : 'GRN Document Number'
      @UI.lineItem                : [{ position: 10, label:'GRN Document Number' }]
  key MaterialDocument            : abap.char(10);

      @UI.identification          : [ { position: 20 , label: 'GRN Document Number Item' } ]
      @EndUserText.label          : 'GRN Document Number Item'
      @UI.lineItem                : [{ position: 20, label:'GRN Document Number Item' }]
  key MaterialDocumentItem        : abap.numc(4);

      @Consumption.filter.hidden  : true
      @UI.identification          : [ { position: 30 , label: 'Company Code' } ]
      @EndUserText.label          : 'Company Code'
      @UI.lineItem                : [{ position: 30, label:'Company Code' }]
      CompanyCode                 : abap.char(4);

      @UI.selectionField          : [{ position: 40 }]
      @UI.identification          : [ { position: 40 , label: 'Fiscal Year' } ]
      @EndUserText.label          : 'Fiscal Year'
      @UI.lineItem                : [{ position: 40, label:'Fiscal Year' }]
      FiscalYear                  : abap.numc(4);

      @UI.selectionField          : [{ position: 50 }]
      @UI.identification          : [ { position: 50 , label: 'Plant' } ]
      @EndUserText.label          : 'Plant'
      @UI.lineItem                : [{ position: 50, label:'Plant' }]
      Plant                       : abap.char(4);

      @Consumption.filter.mandatory:true
      @UI.selectionField          : [{ position: 60 }]
      @UI.identification          : [ { position: 60 , label: 'GRN Posting Date' } ]
      @EndUserText.label          : 'GRN Posting Date'
      @UI.lineItem                : [{ position: 60, label:'GRN Posting Date' }]
      GRNPostingDate              : abap.dats;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 70 , label: 'Purchase Order Type' }]
      @EndUserText.label          : 'Purchase Order Type'
      @UI.lineItem                : [{ position: 70, label:'Purchase Order Type' }]
      PurchaseOrderType           : abap.char(4);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 80 , label: 'Purchase Order Date' }]
      @EndUserText.label          : 'Purchase Order Date'
      @UI.lineItem                : [{ position: 80, label:'Purchase Order Date' }]
      PurchaseOrderDate           : abap.dats;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 85 , label: 'Purchase Order Last Change Time' }]
      @EndUserText.label          : 'Purchase Order Last Change Time'
      @UI.lineItem                : [{ position: 85, label:'Purchase Order Last Change Time' }]
      PurchaseOrderLastChangeTime : abap.char(19);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 90 , label: 'Purchase Order Number' }]
      @EndUserText.label          : 'Purchase Order Number'
      @UI.lineItem                : [{ position: 90, label:'Purchase Order Number' }]
      PurchaseOrderNo             : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 100 , label: 'PO Final Approver Name' }]
      @EndUserText.label          : 'Approver Name Level 1'
      @UI.lineItem                : [{ position: 100, label:'PO Final Approver Name' }]
      ApproverNameLevel1          : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 110 , label: 'PO Final Approve Date' }]
      @EndUserText.label          : 'Level 1 Date'
      @UI.lineItem                : [{ position: 110, label:'PO Final Approve Date' }]
      Level1Date                  : abap.char(30);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 120 , label: 'Purchase Order Quantity' }]
      @EndUserText.label          : 'Purchase Order Quantity'
      @UI.lineItem                : [{ position: 120, label:'Purchase Order Quantity' }]
      PurchaseOrderQty            : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 130 , label: 'Order Unit' }]
      @EndUserText.label          : 'Order Unit'
      @UI.lineItem                : [{ position: 130, label:'Order Unit' }]
      OrderUnit                   : abap.unit(3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 140 , label: 'PO Unit' }]
      @EndUserText.label          : 'PO Unit'
      @UI.lineItem                : [{ position: 140, label:'PO Unit' }]
      POUnit                      : abap.unit(3);


      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 150 , label: 'Open PO Quantity' }]
      @EndUserText.label          : 'Open PO Quantity'
      @UI.lineItem                : [{ position: 150, label:'Open PO Quantity' }]
      OpenPOQuantity              : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 160 , label: 'Delivery Schedule Date' }]
      @EndUserText.label          : 'Delivery Schedule Date'
      @UI.lineItem                : [{ position: 160, label:'Delivery Schedule Date' }]
      DeliveryScheduleDate        : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [ { position: 170 , label: 'Purchase Requisition' } ]
      @EndUserText.label          : 'Purchase Requisition'
      @UI.lineItem                : [{ position: 170, label:'Purchase Requisition' }]
      PurchaseRequisition         : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 180 , label: 'PR Final Approver Name' }]
      @EndUserText.label          : 'Approver Name Level 2'
      @UI.lineItem                : [{ position: 180, label:'PR Final Approver Name' }]
      ApproverNameLevel2          : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 190 , label: 'PR Final Approve Date' }]
      @EndUserText.label          : 'Level 2 Date'
      @UI.lineItem                : [{ position: 190, label:'PR Final Approve Date' }]
      Level2Date                  : abap.char(30);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 200 , label: 'Requisition Date' }]
      @EndUserText.label          : 'Requisition Date'
      @UI.lineItem                : [{ position: 200, label:'Requisition Date' }]
      RequisitionDate             : abap.dats;


      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 205 , label: 'PR Last Change Time' }]
      @EndUserText.label          : 'PR Last Change Time'
      @UI.lineItem                : [{ position: 205, label:'PR Last Change Time' }]
      PRLastChangeTime            : abap.char(19);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 210 , label: 'Purchase Requisition Qty' }]
      @EndUserText.label          : 'Purchase Requisition Quantity'
      @UI.lineItem                : [{ position: 210, label:'Purchase Requisition Qty' }]
      PurchaseRequisitionQty      : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 230 , label: 'Open Indent Quantity' }]
      @EndUserText.label          : 'Open Indent Quantity'
      @UI.lineItem                : [{ position: 230, label:'Open Indent Quantity' }]
      OpenIndentQuantity          : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 240 , label: 'RFQ No' }]
      @EndUserText.label          : 'RFQ Number'
      @UI.lineItem                : [{ position: 240, label:'RFQ No' }]
      RFQNo                       : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 250 , label: 'RFQ Date' }]
      @EndUserText.label          : 'RFQ Date'
      @UI.lineItem                : [{ position: 250, label:'RFQ Date' }]
      RFQDate                     : abap.dats;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 260 , label: 'RFQ Approver Name' }]
      @EndUserText.label          : 'RFQ Approver Name'
      @UI.lineItem                : [{ position: 260, label:'RFQ Approver Name' }]
      RFQApproverName             : abap.char(80);


      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 270 , label: 'RFQ Approve Date' }]
      @EndUserText.label          : 'RFQ Approve Date'
      @UI.lineItem                : [{ position: 270, label:'RFQ Approve Date' }]
      RFQApproveDate              : abap.dats;
      
      
      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 275 , label: 'RFQ LAST CHANGE TIME' }]
      @EndUserText.label          : 'RFQ LAST CHANGE TIME'
      @UI.lineItem                : [{ position: 275, label:'RFQ LAST CHANGE TIME' }]
      RFQLASTCHANGETIME              : abap.char(20);


      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 280 , label: 'RFQ Quantity' }]
      @EndUserText.label          : 'RFQ Quantity'
      @UI.lineItem                : [{ position: 280, label:'RFQ Quantity' }]
      RFQQty                      : abap.dec(15,3);

      @UI.selectionField          : [{ position: 30 }]
      @UI.identification          : [{ position: 212 , label: 'Delivery Note' }]
      @EndUserText.label          : 'Delivery Note'
      @UI.lineItem                : [{ position: 290, label:'Delivery Note' }]
      DeliveryNoteNo              : abap.char(16);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 300 , label: 'Goods Movement Type' }]
      @EndUserText.label          : 'Purchase Order Number'
      @UI.lineItem                : [{ position: 300, label:'Goods Movement Type' }]
      GoodsMovementType           : abap.char(5);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 310 , label: 'Vendor Invoice Date' }]
      @EndUserText.label          : 'Vendor Invoice Date'
      @UI.lineItem                : [{ position: 310, label:'Vendor Invoice Date' }]
      VendorInvoiceDate           : abap.dats;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 320 , label: 'Service Entry Sheet Number' }]
      @EndUserText.label          : 'Service Entry Sheet Number'
      @UI.lineItem                : [{ position: 320, label:'Service Entry Sheet Number' }]
      ServiceEntrySheetNumber     : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 330 , label: 'Service Posting Date' }]
      @EndUserText.label          : 'Service Posting Date'
      @UI.lineItem                : [{ position: 330, label:'Service Posting Date' }]
      ServicePostingDate          : abap.dats;


      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 340 , label: 'SES Approved By' }]
      @EndUserText.label          : 'SES Approved By'
      @UI.lineItem                : [{ position: 340, label:'SES Approved By' }]
      SESApprovedBy               : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 350 , label: 'Approval Date and Time' }]
      @EndUserText.label          : 'Approval Date and Time'
      @UI.lineItem                : [{ position: 350, label:'Approval Date and Time' }]
      ApprovalDateandTime         : abap.char(20);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 360 , label: 'Quality Clearance Date and Time' }]
      @EndUserText.label          : 'Quality Clearance Date and Time'
      @UI.lineItem                : [{ position: 360, label:'Quality Clearance Date and Time' }]
      QualityClearanceDateandTime : abap.utclong;


      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 370 , label: 'Quality Cleared By' }]
      @EndUserText.label          : 'Quality Cleared By'
      @UI.lineItem                : [{ position: 380, label:'Quality Cleared By' }]
      QualityClearedBy            : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 380 , label: 'GL Account' }]
      @EndUserText.label          : 'GL Account'
      @UI.lineItem                : [{ position: 380, label:'GL Account' }]
      GLAccount                   : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 390 , label: 'GL Account Name' }]
      @EndUserText.label          : 'GL Account Name'
      @UI.lineItem                : [{ position: 390, label:'GL Account Name' }]
      GLAccountName               : abap.char(50);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 400 , label: 'Cost Center' }]
      @EndUserText.label          : 'Cost Center'
      @UI.lineItem                : [{ position: 400, label:'Cost Center' }]
      CostCenter                  : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 410 , label: 'Cost Center Name' }]
      @EndUserText.label          : 'Cost Center Name'
      @UI.lineItem                : [{ position: 410, label:'Cost Center Name' }]
      CostCenterName              : abap.char(40);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 420, label: 'Delivery Date' }]
      @EndUserText.label          : 'Delivery Date'
      @UI.lineItem                : [{ position: 430, label:'Delivery Date' }]
      DeliveryDate                : abap.dats;

      @UI.identification          : [{ position: 430 , label: 'Supplier Code' }]
      @UI.selectionField          : [{ position: 10 }]
      @EndUserText.label          : 'Supplier Code'
      @UI.lineItem                : [{ position: 430, label:'Supplier Code' }]
      SupplierCode                : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 440 , label: 'Supplier Name' }]
      @EndUserText.label          : 'Supplier Name'
      @UI.lineItem                : [{ position: 440, label:'Supplier Name' }]
      SupplierName                : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 450 , label: 'Supplier Address' }]
      @EndUserText.label          : 'Supplier Address'
      @UI.lineItem                : [{ position: 450, label:'Supplier Address' }]
      SupplierAddress             : abap.char(120);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 450 , label: 'Supplier PAN No' }]
      @EndUserText.label          : 'Supplier PAN No'
      @UI.lineItem                : [{ position: 450, label:'Supplier PAN No' }]
      SupplierPANNo               : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 460 , label: 'Supplier GSTIN No' }]
      @EndUserText.label          : 'Supplier GSTIN No'
      @UI.lineItem                : [{ position: 460, label:'Supplier GSTIN No' }]
      SupplierGSTINNo             : abap.char(15);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 470 , label: 'Supplier State' }]
      @EndUserText.label          : 'Supplier State'
      @UI.lineItem                : [{ position: 470, label:'Supplier State' }]
      SupplierState               : abap.char(3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 480 , label: 'Material Type' }]
      @EndUserText.label          : 'Material Type'
      @UI.lineItem                : [{ position: 480, label:'Material Type' }]
      MaterialType                : abap.char(4);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 490 , label: 'Material' }]
      @EndUserText.label          : 'Material'
      @UI.lineItem                : [{ position: 490, label:'Material' }]
      Material                    : abap.char(18);


      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 500 , label: 'Material / Service Item Description' }]
      @EndUserText.label          : 'Material / Service Item Description'
      @UI.lineItem                : [{ position: 500, label:'Material / Service Item Description' }]
      MaterialDescription         : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 510 , label: 'Material Group' }]
      @EndUserText.label          : 'Material Group'
      @UI.lineItem                : [{ position: 520, label:'Material Group' }]
      MaterialGroup               : abap.char(9);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 520 , label: 'Material Group Description' }]
      @EndUserText.label          : 'Material Group Description'
      @UI.lineItem                : [{ position: 520, label:'Material Group Description' }]
      MaterialGroupDescription    : abap.char(60);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 530 , label: 'UOM' }]
      @EndUserText.label          : 'UOM'
      @UI.lineItem                : [{ position: 530, label:'UOM' }]
      UOM                         : abap.unit(3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 540 , label: 'Asset Code' }]
      @EndUserText.label          : 'Asset Code'
      @UI.lineItem                : [{ position: 540, label:'Asset Code' }]
      AssetCode                   : abap.char(12);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 550 , label: 'Asset Description' }]
      @EndUserText.label          : 'Asset Description'
      @UI.lineItem                : [{ position: 550, label:'Asset Description' }]
      AssetDescription            : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 560 , label: 'HSN/SAC Code' }]
      @EndUserText.label          : 'HSN/SAC Code'
      @UI.lineItem                : [{ position: 560, label:'HSN/SAC Code' }]
      HSNSACCode                  : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 570 , label: 'Transporter Name' }]
      @EndUserText.label          : 'Transporter Name'
      @UI.lineItem                : [{ position: 570, label:'Transporter Name' }]
      TransporterName             : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 580 , label: 'Vehicle No' }]
      @EndUserText.label          : 'Vehicle No'
      @UI.lineItem                : [{ position: 580, label:'Vehicle No' }]
      VehicleNo                   : abap.char(20);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 590 , label: 'EWay Bill No' }]
      @EndUserText.label          : 'EWay Bill No'
      @UI.lineItem                : [{ position: 590, label:'EWay Bill No' }]
      EWayBillNo                  : abap.char(20);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 600 , label: 'Gate Pass No' }]
      @EndUserText.label          : 'Gate Pass No'
      @UI.lineItem                : [{ position: 600, label:'Gate Pass No' }]
      GatePassNo                  : abap.char(20);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 610 , label: 'Gate Out Date' }]
      @EndUserText.label          : 'Gate Out Date'
      @UI.lineItem                : [{ position: 610, label:'Gate Out Date' }]
      GateOutDate                 : abap.dats;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 620 , label: 'Gate In Date' }]
      @EndUserText.label          : 'Gate In Date'
      @UI.lineItem                : [{ position: 620, label:'Gate In Date' }]
      GateInDate                  : abap.dats;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 630 , label: 'Gate Out Time' }]
      @EndUserText.label          : 'Gate Out Time'
      @UI.lineItem                : [{ position: 630, label:'Gate Out Time' }]
      GateOutTime                 : abap.tims;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 640 , label: 'Gate In Time' }]
      @EndUserText.label          : 'Gate In Time'
      @UI.lineItem                : [{ position: 640, label:'Gate In Time' }]
      GateInTime                  : abap.tims;

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 650 , label: 'Challan Invoice Qty' }]
      @EndUserText.label          : 'Challan Invoice Qty'
      @UI.lineItem                : [{ position: 650, label:'Challan Invoice Qty' }]
      ChallanInvoiceQty           : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 660 , label: 'Challan Invoice Qty OP Unit' }]
      @EndUserText.label          : 'Challan Invoice Qty OP Unit'
      @UI.lineItem                : [{ position: 660, label:'Challan Invoice Qty OP Unit' }]
      ChallanInvoiceQtyOPUn       : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 670 , label: 'Received Quantity' }]
      @EndUserText.label          : 'Received Quantity'
      @UI.lineItem                : [{ position: 670, label:'Received Quantity' }]
      ReceivedQuantity            : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 680 , label: 'Received Quantity OP Unit' }]
      @EndUserText.label          : 'Received Quantity OP Unit'
      @UI.lineItem                : [{ position: 680, label:'Received Quantity OP Unit' }]
      ReceivedQuantityOPUn        : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 690 , label: 'Short Quantity' }]
      @EndUserText.label          : 'Short Quantity'
      @UI.lineItem                : [{ position: 690, label:'Short Quantity' }]
      ShortQuantity               : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 700 , label: 'Net Quantity' }]
      @EndUserText.label          : 'Net Quantity'
      @UI.lineItem                : [{ position: 700, label:'Net Quantity' }]
      NetQuantity                 : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 710 , label: 'Net Quantity OP Unit' }]
      @EndUserText.label          : 'Net Quantity OP Unit'
      @UI.lineItem                : [{ position: 710, label:'Net Quantity OP Unit' }]
      NetQuantityOPUn             : abap.dec(15,3);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 720 , label: 'Basic Rate' }]
      @EndUserText.label          : 'Basic Rate'
      @UI.lineItem                : [{ position: 720, label:'Basic Rate' }]
      BasicRate                   : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 730 , label: 'GRN Basic Amount' }]
      @EndUserText.label          : 'GRN Basic Amount'
      @UI.lineItem                : [{ position: 730, label:'GRN Basic Amount' }]
      GRNBasicAmount              : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 740 , label: 'Discount Rate' }]
      @EndUserText.label          : 'Discount Rate'
      @UI.lineItem                : [{ position: 740, label:'Discount Rate' }]
      DiscountRate                : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 750 , label: 'Discount Amount' }]
      @EndUserText.label          : 'Discount Amount'
      @UI.lineItem                : [{ position: 750, label:'Discount Amount' }]
      DiscountAmount              : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 760 , label: 'Freight' }]
      @EndUserText.label          : 'Freight'
      @UI.lineItem                : [{ position: 760, label:'Freight' }]
      Freight                     : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 770 , label: 'Packing Forwarding' }]
      @EndUserText.label          : 'Packing & Forwarding'
      @UI.lineItem                : [{ position: 770, label:'Packing & Forwarding' }]
      PackingForwarding           : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 780 , label: 'Custom Duty Charges' }]
      @EndUserText.label          : 'Custom Duty Charges'
      @UI.lineItem                : [{ position: 780, label:'Custom Duty Charges' }]
      CustomDutyCharges           : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 790 , label: 'Total GRN Value' }]
      @EndUserText.label          : 'Total GRN Value'
      @UI.lineItem                : [{ position: 790, label:'Total GRN Value' }]
      TotalGRNValue               : abap.dec(15,2);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 800 , label: 'GRN Created By' }]
      @EndUserText.label          : 'GRN Created By'
      @UI.lineItem                : [{ position: 800, label:'GRN Created By' }]
      GrnCreatedBy                : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 810, label: 'GRN Creation Date and Time' }]
      @EndUserText.label          : 'GRN Creation Date and Time'
      @UI.lineItem                : [{ position: 810, label: 'GRN Creation Date and Time' }]
      GRNCreationDateandTime      : abap.char(19);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 820 , label: 'MIRO Number ' }]
      @EndUserText.label          : 'MIRO Number '
      @UI.lineItem                : [{ position: 820, label:'MIRO Number ' }]
      MIRONumber                  : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.identification          : [{ position: 830 , label: 'MIRO Posting Date' }]
      @EndUserText.label          : 'MIRO Posting Date'
      @UI.lineItem                : [{ position: 830, label:'MIRO Posting Date' }]
      MIROPostingDate             : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.hidden                  : true
      @UI.identification          : [{ position: 840 , label: 'PO Approver Name Level 1' }]
      @EndUserText.label          : 'PO Approver Name Level 1'
      @UI.lineItem                : [{ position: 840, label:'PO Approver Name Level 1' }]
      POApproverNameLevel1        : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.hidden                  : true
      @UI.identification          : [{ position: 850 , label: 'PO Level 1 Date' }]
      @EndUserText.label          : 'PO Level 1 Date'
      @UI.lineItem                : [{ position: 850, label:'PO Level 1 Date' }]
      POLevel1Date                : abap.dats;


      @Consumption.filter.hidden  : true
      @UI.hidden                  : true
      @UI.identification          : [{ position: 860 , label: 'PO Approver Name Level 2' }]
      @EndUserText.label          : 'PO Approver Name Level 2'
      @UI.lineItem                : [{ position: 860, label:'PO Approver Name Level 2' }]
      POApproverNameLevel2        : abap.char(80);

      @Consumption.filter.hidden  : true
      @UI.hidden                  : true
      @UI.identification          : [{ position: 870 , label: 'PO Level 2 Date' }]
      @EndUserText.label          : 'PO Level 2 Date'
      @UI.lineItem                : [{ position: 870, label:'PO Level 2 Date' }]
      POLevel2Date                : abap.dats;

      @Consumption.filter.hidden  : true
      @UI.hidden                  : true
      @UI.identification          : [{ position: 880 , label: 'Accounting Document RE' }]
      @EndUserText.label          : 'Accounting Document RE'
      @UI.lineItem                : [{ position: 880, label:'Accounting Document RE' }]
      AccountingDocumentRE        : abap.char(10);

      @Consumption.filter.hidden  : true
      @UI.hidden                  : true
      @UI.identification          : [{ position: 890 , label: 'Asset Class' }]
      @EndUserText.label          : 'Asset Class'
      @UI.lineItem                : [{ position: 890, label:'Asset Class' }]
      AssetClass                  : abap.char(8);
}
