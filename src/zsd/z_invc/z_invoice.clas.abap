CLASS z_invoice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

   INTERFACES if_oo_adt_classrun .


    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .
    CLASS-DATA : template TYPE string .
    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct."


   CLASS-METHODS :

      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check ,

      read_posts
        IMPORTING variable        TYPE string


        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://devtenant-ux00yyve.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'ZSD_INVC_FORM/ZSD_INVC_FORM'.

ENDCLASS.



CLASS Z_INVOICE IMPLEMENTATION.


 METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

    ENDMETHOD .


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


   METHOD read_posts .

    SELECT SINGLE * FROM i_billingdocumentbasic WHERE billingdocument =  @variable INTO @DATA(billhead) .
    SELECT * FROM
                  i_billingdocument AS a
                       LEFT OUTER JOIN i_billingdocumentitem AS b ON ( a~billingdocument = b~billingdocument )
                       LEFT OUTER JOIN i_deliverydocumentitem AS c ON  ( c~deliverydocument = b~referencesddocument AND
                                                                         c~product = b~product AND c~plant = b~plant )
                                                                         AND a~billingdocument = @variable
                       INTO TABLE @DATA(it) .


    SELECT SINGLE * FROM  i_billingdocumentitem AS a  LEFT OUTER JOIN i_deliverydocumentitem AS b
    ON ( a~referencesddocument = b~deliverydocument AND a~referencesddocumentitem = b~deliverydocumentitem )
    WHERE  billingdocument  =  @variable INTO @DATA(billingitem)  .

   SELECT SINGLE * FROM i_salesdocument WHERE salesdocument  =  @billingitem-a-salesdocument  INTO  @DATA(salesorder)  .

     DATA(lv_xml) =  |<form1>| &&
      |<Subform1>| &&
      |<Subform2>| &&
         |<nameadd></nameadd>| &&
         |<gst></gst>| &&
         |<PhoneNo.></PhoneNo.>| &&
         |<placeofsupply></placeofsupply>| &&
         |<statecode></statecode>| &&
         |<Country0fDestination></Country0fDestination>| &&
         |<nameadd></nameadd>| &&
         |<gst></gst>| &&
         |<PhoneNo.></PhoneNo.>| &&
         |<placeofsupply></placeofsupply>| &&
         |<statecode></statecode>| &&
         |<Country0fDestination></Country0fDestination>| &&
         |<Subform4>| &&
            |<PONO></PONO>| &&
            |<modeoftransport></modeoftransport>| &&
            |<nameoftranspoter></nameoftranspoter>| &&
            |<VehicleRegnNo></VehicleRegnNo>| &&
            |<cnoteno></cnoteno>| &&
            |<podate></podate>| &&
         |</Subform4>| &&
         |<Subform5>| &&
            |<IRN></IRN>| &&
            |<ACKNO></ACKNO>| &&
            |<E-wayBillNo></E-wayBillNo>| &&
         |</Subform5>| &&
         |<Subform3>| &&
            |<InvoiceNo></InvoiceNo>| &&
            |<incdate></incdate>| &&
            |<QRCodeBarcode1/>| &&
         |</Subform3>| &&
      |</Subform2>| &&
      |<Subform6>| &&
         |<Table1>| &&
            |<HeaderRow/>| &&
            |<Row1>| &&
               |<sno></sno>| &&
               |<desandhsn></desandhsn>| &&
               |<despackage></despackage>| &&
               |<unit></unit>| &&
               |<quantity></quantity>| &&
               |<weight></weight>| &&
               |<traficvalue></traficvalue>| &&
               |<totaltraficvalue></totaltraficvalue>| &&
               |<taxprcntge></taxprcntge>| &&
               |<totaltaxamount></totaltaxamount>| &&
               |<totalassvalue></totalassvalue>| &&
            |</Row1>| &&
            |<Row1>| &&
               |<sno></sno>| &&
               |<desandhsn></desandhsn>| &&
               |<despackage></despackage>| &&
               |<unit>Proinde</unit>| &&
               |<quantity></quantity>| &&
               |<weight></weight>| &&
               |<traficvalue></traficvalue>| &&
               |<totaltraficvalue></totaltraficvalue>| &&
               |<taxprcntge></taxprcntge>| &&
               |<totaltaxamount></totaltaxamount>| &&
               |<totalassvalue></totalassvalue>| &&
            |</Row1>| &&
            |<Row1>| &&
               |<sno></sno>| &&
               |<desandhsn></desandhsn>| &&
               |<despackage></despackage>| &&
               |<unit></unit>| &&
               |<quantity></quantity>| &&
               |<weight></weight>| &&
               |<traficvalue></traficvalue>| &&
               |<totaltraficvalue></totaltraficvalue>| &&
               |<taxprcntge></taxprcntge>| &&
               |<totaltaxamount></totaltaxamount>| &&
               |<totalassvalue></totalassvalue>| &&
            |</Row1>| &&
            |<Row2>| &&
               |<totquan></totquan>| &&
               |<totalweight></totalweight>| &&
               |<tottraficvalue></tottraficvalue>| &&
               |<tottottraficvalue></tottottraficvalue>| &&
               |<totaltaxamt></totaltaxamt>| &&
               |<totassvalue></totassvalue>| &&
            |</Row2>| &&
         |</Table1>| &&
      |</Subform6>| &&
      |<Subform7>| &&
         |<Amountinwords></Amountinwords>| &&
         |<CGSTAmountinwords></CGSTAmountinwords>| &&
         |<SGSTAmountinwords></SGSTAmountinwords>| &&
         |<IGSTAmountinwords></IGSTAmountinwords>| &&
      |</Subform7>| &&
      |<Subform8>| &&
         |<Remarks></Remarks>| &&
         |<Paymentterms></Paymentterms>| &&
         |<REVERSECHARGEYN></REVERSECHARGEYN>| &&
         |<Freight></Freight>| &&
         |<Jurisdiction></Jurisdiction>| &&
         |<DateTimeofIssueofInvoice></DateTimeofIssueofInvoice>| &&
         |<DateTimeofRemovalofGoods></DateTimeofRemovalofGoods>| &&
         |<Subform9>| &&
            |<CONTAINERNO></CONTAINERNO>| &&
            |<EXCHANGERATEONEUS></EXCHANGERATEONEUS>| &&
            |<SEALNO></SEALNO>| &&
            |<E.SEALNO></E.SEALNO>| &&
         |</Subform9>| &&
      |</Subform8>| &&
      |<Subform10>| &&
         |<BasicValue></BasicValue>| &&
         |<CGSTvalue></CGSTvalue>| &&
         |<SGSTvalue></SGSTvalue>| &&
         |<IGSTvalue></IGSTvalue>| &&
         |<TCSvalue></TCSvalue>| &&
         |<RoundingOff></RoundingOff>| &&
         |<Total></Total>| &&
      |</Subform10>| &&
      |<Subform11/>| &&
   |</Subform1>| &&
|</form1>| .

CALL METHOD ycl_test_adobe=>getpdf(
      EXPORTING
        xmldata  = lv_xml
        template = template
      RECEIVING
        result   = result12 ).

 ENDMETHOD.
ENDCLASS.
