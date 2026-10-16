@EndUserText.label: 'Pending Sales Order Report CDS'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PENDING_SALESORDER_REP'
@UI.headerInfo: {
    typeName: 'Count',
    typeNamePlural: 'Count' }
define custom entity ZCE_PENDING_SO
{

      @UI.selectionField          : [{ position: 10 }]
      @UI.lineItem                : [{ position: 10,  label: 'Sales Order No' }]
      @EndUserText.label          : 'Sales Order Number'
      @Consumption.valueHelpDefinition: [{ entity : { element: 'SalesDocument', name : 'I_SalesDocumentStdVH' } } ]
  key salesorder                  : vbeln;

      @UI.lineItem                : [{ position: 20, label: 'Sales Order Item' }]
      @EndUserText.label          : 'Sales Order Item'
      @Consumption.filter         : { hidden: true }
  key salesorderitem              : abap.char(6);

      @UI.lineItem                : [{ position: 30, label: 'Sales Order Type Name' }]
      @EndUserText.label          : 'Sales Order Type Name'
      @Consumption.filter         : { hidden: true }
      SalesOrderTypeName          : abap.char(25);

      @UI.lineItem                : [{ position: 40, label: 'Sales Organization Name' }]
      @EndUserText.label          : 'Sales Organization Name'
      @Consumption.filter         : { hidden: true }
      SALESORGANIZATIONNAME       : abap.char(25);

      @UI.selectionField          : [{ position: 40 }]
      @UI.lineItem                : [{ position: 50, label: 'Distribution Channel Name' }]
      @EndUserText.label          : 'Distribution Channel Name'
      DistributionChannelName     : abap.char(23);

      @UI.selectionField          : [{ position: 50 }]
      @UI.lineItem                : [{ position: 60, label: 'Division' }]
      @EndUserText.label          : 'Division'
      Division                    : abap.char(23);

      @UI.lineItem                : [{ position: 70, label: 'Order Date' }]
      @EndUserText.label          : 'Order Date'
      @UI.selectionField          : [{ position: 11 }]
      CREATIONDATE                : datn;

      @UI.selectionField          : [{ position: 20 }]
      @UI.lineItem                : [{ position: 80, label: 'Customer Code' }]
      @EndUserText.label          : 'Customer Code'
      SOLDTOPARTY                 : abap.char(10);

      @UI.lineItem                : [{ position: 90, label: 'ACC Class' }]
      @EndUserText.label          : 'ACC Class'
      @Consumption.filter         : { hidden: true }
      AddressSearchTerm1          : abap.char(20);

      @UI.lineItem                : [{ position: 100, label: 'Customer Name' }]
      @EndUserText.label          : 'Customer Name'
      @Consumption.filter         : { hidden: true }
      Customername                : abap.char(80);

      @UI.lineItem                : [{ position: 110, label: 'GST TO STATE' }]
      @EndUserText.label          : 'GST TO STATE'
      @Consumption.filter         : { hidden: true }
      RegionName                  : abap.char(20);

      @UI.lineItem                : [{ position: 120, label: 'Customer PO Number' }]
      @EndUserText.label          : 'Customer PO Number'
      @Consumption.filter         : { hidden: true }
      purchaseorderbycustomer     : abap.char(35);

      @UI.lineItem                : [{ position: 130, label: 'Customer PO Date' }]
      @EndUserText.label          : 'Customer PO Date'
      @Consumption.filter         : { hidden: true }
      CustomerPurchaseOrderDate   : abap.char(10);

      @UI.selectionField          : [{ position: 30 }]
      @UI.lineItem                : [{ position: 140, label: 'Delivering Plant' }]
      @EndUserText.label          : 'Delivering Plant'
      Plant                       : abap.char(4);

      @UI.lineItem                : [{ position: 150, label: 'Created by' }]
      @EndUserText.label          : 'Created by'
      @Consumption.filter         : { hidden: true }
      PERSONFULLNAME              : abap.char(80);

      @UI.lineItem                : [{ position: 160, label: 'Item Code' }]
      @EndUserText.label          : 'Item Code'
      @Consumption.filter         : { hidden: true }
      Product                     : abap.char(40);

      @UI.lineItem                : [{ position: 170, label: 'Item Name' }]
      @EndUserText.label          : 'Item Name'
      @Consumption.filter         : { hidden: true }
      SALESDOCUMENTITEMTEXT       : abap.char(40);

      @UI.lineItem                : [{ position: 180, label: 'Item Remark' }]
      @EndUserText.label          : 'Item Remark'
      @Consumption.filter         : { hidden: true }
      ITEMREMARKS                 : abap.char(100);

      @UI.lineItem                : [{ position: 190, label: 'Sales Order Quantity' }]
      @EndUserText.label          : 'Sales Order Quantity'
      @Consumption.filter         : { hidden: true }
      ORDERQUANTITY               : abap.dec(18,3);

      @UI.lineItem                : [{ position: 200, label: 'Qty Short Closed' }]
      @EndUserText.label          : 'Qty Short Closed'
      @Consumption.filter         : { hidden: true }
      qty_short_closed            : abap.dec(18,3);

      @UI.lineItem                : [{ position: 210, label: 'UOM Name' }]
      @EndUserText.label          : 'UOM Name'
      @Consumption.filter         : { hidden: true }
      UOM                         : abap.char(3);

      @UI.lineItem                : [{ position: 220, label: 'Rate' }]
      @EndUserText.label          : 'Rate'
      @Consumption.filter         : { hidden: true }
      rate                        : abap.dec(13,2);

      @UI.lineItem                : [{ position: 230, label: 'Delivery Quantity' }]
      @EndUserText.label          : 'Delivery Quantity'
      @Consumption.filter         : { hidden: true }
      DELIVERY_QTY                : abap.dec(16,3);

      @UI.lineItem                : [{ position: 240, label: 'PGI Quantity' }]
      @EndUserText.label          : 'PGI Quantity'
      @Consumption.filter         : { hidden: true }
      pgi_qty                     : abap.dec(16,3);

      @UI.lineItem                : [{ position: 250, label: 'Pending for PKG' }]
      @EndUserText.label          : 'Pending for PKG'
      @Consumption.filter         : { hidden: true }
      pending_for_pkg             : abap.dec(16,3);

      @UI.lineItem                : [{ position: 260, label: 'Invoiced Quantity' }]
      @EndUserText.label          : 'Invoiced Quantity'
      @Consumption.filter         : { hidden: true }
      invoiced_qty                : abap.dec(16,3);

      @UI.lineItem                : [{ position: 270, label: 'Pending for Invoicing' }]
      @EndUserText.label          : 'Pending for Invoicing'
      @Consumption.filter         : { hidden: true }
      pending_for_invoicing       : abap.dec(16,3);

      @UI.lineItem                : [{ position: 280, label: 'Pending for Sale' }]
      @EndUserText.label          : 'Pending for Sale'
      @Consumption.filter         : { hidden: true }
      pending_for_sale            : abap.dec(16,3);




      @UI.lineItem                : [{ position: 290, label: 'Status' }]
      @EndUserText.label          : 'Status'
      @Consumption.filter         : { hidden: true }
      status                      : abap.char(10);

      @UI.lineItem                : [{ position: 300, label: 'Reason for Rejection' }]
      @EndUserText.label          : 'Reason for Rejection'
      @Consumption.filter         : { hidden: true }
      SALESDOCUMENTRJCNREASONTEXT : abap.char(40);

      @UI.lineItem                : [{ position: 310, label: 'ITEM ATTRIBUTE 1' }]
      @EndUserText.label          : 'ITEM ATTRIBUTE 1'
      @Consumption.filter         : { hidden: true }
      YY1_ITEMATTRIBUTE11_PRD     : abap.char(50);

      @UI.lineItem                : [{ position: 320, label: 'ITEM ATTRIBUTE 2' }]
      @EndUserText.label          : 'ITEM ATTRIBUTE 2'
      @Consumption.filter         : { hidden: true }
      YY1_ITEMATTRIBUTE2_PRD      : abap.char(50);

      @UI.lineItem                : [{ position: 330, label: 'ITEM ATTRIBUTE 3' }]
      @EndUserText.label          : 'ITEM ATTRIBUTE 3'
      @Consumption.filter         : { hidden: true }
      YY1_ITEMATTRIBUTE3_PRD      : abap.char(50);

      @UI.lineItem                : [{ position: 340, label: 'ITEM ATTRIBUTE 4' }]
      @EndUserText.label          : 'ITEM ATTRIBUTE 4'
      @Consumption.filter         : { hidden: true }
      YY1_ITEMATTRIBUTE4_PRD      : abap.char(50);

      @UI.lineItem                : [{ position: 350, label: 'ITEM ATTRIBUTE 5' }]
      @EndUserText.label          : 'ITEM ATTRIBUTE 5'
      @Consumption.filter         : { hidden: true }
      YY1_ITEMATTRIBUTE5_PRD      : abap.char(50);

      @UI.lineItem                : [{ position: 360, label: 'PRODUCT GROUP 1' }]
      @EndUserText.label          : 'PRODUCT GROUP 1'
      @Consumption.filter         : { hidden: true }
      YY1_PRODUCTGROUP1_PRD       : abap.char(50);

      @UI.lineItem                : [{ position: 370, label: 'PRODUCT GROUP 2' }]
      @EndUserText.label          : 'PRODUCT GROUP 2'
      @Consumption.filter         : { hidden: true }
      YY1_PRODUCTGROUP2_PRD       : abap.char(50);

      @UI.lineItem                : [{ position: 380, label: 'PRODUCT GROUP 3' }]
      @EndUserText.label          : 'PRODUCT GROUP 3'
      @Consumption.filter         : { hidden: true }
      YY1_PRODUCTGROUP3_PRD       : abap.char(50);

      @UI.lineItem                : [{ position: 390, label: 'PRODUCT GROUP 4' }]
      @EndUserText.label          : 'PRODUCT GROUP 4'
      @Consumption.filter         : { hidden: true }
      YY1_PRODUCTGROUP4_PRD       : abap.char(50);

      @UI.lineItem                : [{ position: 400, label: 'ASM Code' }]
      @EndUserText.label          : 'ASM Code'
      @Consumption.filter         : { hidden: true }
      asm_code                    : abap.char(10);

      @UI.lineItem                : [{ position: 410, label: 'ASM Name' }]
      @EndUserText.label          : 'ASM Name'
      @Consumption.filter         : { hidden: true }
      asm_name                    : abap.char(80);

      @UI.lineItem                : [{ position: 420, label: 'RSM Code' }]
      @EndUserText.label          : 'RSM Code'
      @Consumption.filter         : { hidden: true }
      rsm_code                    : abap.char(10);

      @UI.lineItem                : [{ position: 430, label: 'RSM Name' }]
      @EndUserText.label          : 'RSM Name'
      @Consumption.filter         : { hidden: true }
      rsm_name                    : abap.char(80);

      @UI.lineItem                : [{ position: 440, label: 'TSM Code' }]
      @EndUserText.label          : 'TSM Code'
      @Consumption.filter         : { hidden: true }
      tsm_code                    : abap.char(10);

      @UI.lineItem                : [{ position: 450, label: 'TSM Name' }]
      @EndUserText.label          : 'TSM Name'
      @Consumption.filter         : { hidden: true }
      tsm_name                    : abap.char(80);

      @UI.lineItem                : [{ position: 460, label: 'Supplier Type' }]
      @EndUserText.label          : 'Supplier Type'
      @Consumption.filter         : { hidden: true }
      BusinessPartnerType         : abap.char(4);

      @UI.lineItem                : [{ position: 470, label: 'Tax Amount' }]
      @EndUserText.label          : 'Tax Amount'
      @Consumption.filter         : { hidden: true }
      TaxAmount                   : abap.dec(15,2);

      @UI.lineItem                : [{ position: 480, label: 'Sales Rate' }]
      @EndUserText.label          : 'Sales Rate'
      @Consumption.filter         : { hidden: true }
      salesrate                   : abap.dec(15,2);

      @UI.lineItem                : [{ position: 490, label: 'Amount' }]
      @EndUserText.label          : 'Amount'
      @Consumption.filter         : { hidden: true }
      Amount                      : abap.dec(15,2);

      @UI.lineItem                : [{ position: 500, label: 'Net Amount' }]
      @EndUserText.label          : 'Net Amount'
      @Consumption.filter         : { hidden: true }
      NetAmount                   : abap.dec(15,2);

      @UI.lineItem                : [{ position: 510, label: 'Total Amount' }]
      @EndUserText.label          : 'Total Amount'
      @Consumption.filter         : { hidden: true }
      TotalAmount                 : abap.dec(15,2);

      @UI.lineItem                : [{ position: 520, label: 'Pending Sales Amount' }]
      @EndUserText.label          : 'Pending Sales Amount'
      @Consumption.filter         : { hidden: true }
      PendingSalesAmount          : abap.dec(15,2);


      @UI.lineItem                : [{ position: 530, label: 'HSN Code' }]
      @EndUserText.label          : 'HSN Code'
      @Consumption.filter         : { hidden: true }
      HSN_CODE                    : abap.char(20);

      @UI.lineItem                : [{ position: 540, label: 'GST Rate' }]
      @EndUserText.label          : 'GST Rate'
      @Consumption.filter         : { hidden: true }
      GST_RATE                    : abap.dec(13,2);

      @UI.lineItem                : [{ position: 550, label: 'Freight/Packing' }]
      @EndUserText.label          : 'Freight/Packing'
      @Consumption.filter         : { hidden: true }
      Freight_Packing             : abap.dec(15,2);


      @UI.lineItem                : [{ position: 560, label: 'Customer Currency' }]
      @EndUserText.label          : 'Customer Currency'
      @Consumption.filter         : { hidden: true }
      Customer_Currency           : waerk;

      @UI.lineItem                : [{ position: 570, label: 'Discount' }]
      @EndUserText.label          : 'Discount'
      @Consumption.filter         : { hidden: true }
      DISCOUNT                    : abap.dec(15,2);


      @UI.lineItem                : [{ position: 580, label: 'Discount %' }]
      @EndUserText.label          : 'Discount %'
      @Consumption.filter         : { hidden: true }
      DISCOUNT_PER                : abap.dec(15,2);

      @UI.lineItem                : [{ position: 590, label: 'Credit limit Value' }]
      @EndUserText.label          : 'Credit limit Value'
      @Consumption.filter         : { hidden: true }
      Credit_limit_Value          : abap.dec(15,2);

      @UI.lineItem                : [{ position: 600, label: 'Credit limit indicator' }]
      @EndUserText.label          : 'Credit limit indicator'
      @Consumption.filter         : { hidden: true }
      credit_limit_indicator      : abap.char(20);

      @UI.lineItem                : [{ position: 610, label: 'Product Group Id' }]
      @EndUserText.label          : 'Product Group Id'
      @Consumption.filter         : { hidden: true }
      Product_Group_Id            : abap.char(20);

      @UI.lineItem                : [{ position: 620, label: 'Product Group Description' }]
      @EndUserText.label          : 'Product Group Description'
      @Consumption.filter         : { hidden: true }
      Product_Group_Description   : abap.char(40);

}
