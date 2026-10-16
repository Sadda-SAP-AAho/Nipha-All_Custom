@EndUserText.label: 'custom entity for serial no report'
@Search.searchable: false
@ObjectModel.query.implementedBy: 'ABAP:ZCL_SERIAL_NO'
@Metadata.allowExtensions: false
@UI.headerInfo: {typeName: 'Count' , typeNamePlural : 'Counts' }
define custom entity zce_serial_no_report

{
      @UI.facet            : [
              {
                id         : 'SerialNumberReport',
                type       : #IDENTIFICATION_REFERENCE,
                label      : 'Serial Number Details',
                position   : 10
              }
            ]
      @UI.selectionField   : [{ position: 1 }]
      @UI.identification   : [ { position: 1 , label: 'SAP Doc No' } ]
      @EndUserText.label   : 'SAP Doc No'
      @UI.lineItem         : [{ position: 1, label:'SAP Doc No' }]
  key BillingDocument      : abap.char(10);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 2, label: 'SAP Doc Item No' }]
      @UI.lineItem         : [{ position: 2 , label: 'SAP Doc Item No' }]
      @EndUserText.label   : 'SAP Doc Item No'
  key BillingDocumentitem  : abap.numc(6);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 150, label: 'Serial No' }]
      @UI.lineItem         : [{ position: 150 ,  label: 'Serial No'}]
  key serial_no            : abap.char(50);

      @UI.identification   : [{ position: 10, label: 'Sales Org' }]
      @UI.lineItem         : [{ position: 10 }]
      @UI.selectionField   : [{ position: 10 }]
      @EndUserText.label   : 'Sales Org'
      Sales_org            : abap.char( 36 );

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 20, label: 'Customer Type' }]
      @UI.lineItem         : [{ position: 20 }]
      @EndUserText.label   : 'Customer type'
      customer_type        : abap.char( 4 );

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 21, label: 'Customer Type Description' }]
      @UI.lineItem         : [{ position: 21 , label: 'Customer Type Description'  }]
      @EndUserText.label   : 'Customer Type Description'
      customer_type_desc   : abap.char(10);

      @UI.identification   : [{ position: 30, label: 'Customer Code' }]
      @UI.lineItem         : [{ position: 30 , label: 'Customer Code'  }]
      @UI.selectionField   : [{ position: 30 }]
      @EndUserText.label   : 'Customer Code'
      customer_code        : abap.char(10);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 40, label: 'Customer Name' }]
      @UI.lineItem         : [{ position: 40,  label: 'Customer Name'   }]
      @EndUserText.label   : 'Customer Name'
      customer_name        : abap.char(100);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 50, label: 'Customer Address' }]
      @UI.lineItem         : [{ position: 50, label: 'Customer Address'  }]
      customer_address     : abap.char(200);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 60, label: 'Customer City' }]
      @UI.lineItem         : [{ position: 60 ,label: 'Customer City' }]
      customer_city        : abap.char(40);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 70, label: 'Customer State' }]
      @UI.lineItem         : [{ position: 70, label: 'Customer State' }]
      customer_state       : abap.char(20);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 80, label: 'Customer Country' }]
      @UI.lineItem         : [{ position: 80, label: 'Customer Country' }]
      customer_country     : abap.char(10);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 100, label: 'Invoice No(Tax)' }]
      @UI.lineItem         : [{ position: 100 , label: 'Invoice No(Tax)'}]
      invoice_no           : abap.char(20);

      @EndUserText.label   : 'Invoice Date'
      @UI.selectionField   : [{ position: 2 }]
      @UI.identification   : [{ position: 3, label: 'Invoice Date' }]
      @UI.lineItem         : [{ position: 3 , label: 'Invoice Date' }]
      @Consumption.filter.mandatory: true
      invoice_date         : abap.dats;

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 120, label: 'Product Code' }]
      @UI.lineItem         : [{ position: 120 ,label: 'Product Code'  }]
      product_code         : abap.char(18);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 130, label: 'Product Name' }]
      @UI.lineItem         : [{ position: 130 , label: 'Product Name' }]
      product_name         : abap.char(100);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 140, label: 'Mfg Serial Number' }]
      @UI.lineItem         : [{ position: 140 , label: 'Mfg Serial Number' }]
      mfg_serial_no        : abap.char(50);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 160, label: 'Division' }]
      @UI.lineItem         : [{ position: 160,  label: 'Division' }]
      division             : abap.char(4);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 170, label: 'Brand' }]
      @UI.lineItem         : [{ position: 170,  label: 'Brand' }]
      brand                : abap.char(60);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 180, label: 'Product Group' }]
      @UI.lineItem         : [{ position: 180 ,   label: 'Product Group'}]
      product_group        : abap.char(20);

      @Consumption.filter.hidden: true
      @UI.identification   : [{ position: 181, label: 'Product Group Description' }]
      @UI.lineItem         : [{ position: 181 ,   label: 'Product Group Description'}]
      product_group_desc   : abap.char(20);

      @EndUserText.label   : 'Plant'
      @UI.selectionField   : [{ position: 40 }]
      @UI.identification   : [{ position: 190, label: 'Plant' }]
      @UI.lineItem         : [{ position: 190 ,   label: 'Plant'}]
      plant                : abap.char(20);

      @EndUserText.label   : 'Distribution Channel'
      @UI.selectionField   : [{ position: 50 }]
      @UI.identification   : [{ position: 200, label: 'Distribution Channel' }]
      @UI.lineItem         : [{ position: 200 ,   label: 'Distribution Channel'}]
      Distribution_Channel : abap.char(20);

}
