CLASS zrgp_in_driver DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CLASS-DATA : access_token TYPE string.
    CLASS-DATA : xml_file     TYPE string.

    CLASS-METHODS :
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,

      read_posts
        IMPORTING lv_gateentry    TYPE string
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS lc_ads_render    TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS lv1_url          TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.jp10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'.
    CONSTANTS lv2_url          TYPE string VALUE 'https://dev-tcul4uw9.authentication.jp10.hana.ondemand.com/oauth/token'.
    CONSTANTS lc_storage_name  TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'ZRGPIN/ZRGPIN'.

ENDCLASS.



CLASS ZRGP_IN_DRIVER IMPLEMENTATION.


  METHOD create_client.
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD.


  METHOD read_posts.

*   --- Header data from gate entry header ---
    SELECT SINGLE *
      FROM zgateentryheader
      WHERE gateentryno = @lv_gateentry
      INTO @DATA(lv_header).

*   --- Line items ---
    SELECT *
      FROM zgateentrylines
      WHERE gateentryno = @lv_gateentry
      INTO TABLE @DATA(it_lines).

*   --- Plant + Company info (same join pattern as RGP OUT) ---
    SELECT SINGLE *
      FROM zgateentryheader AS a
      INNER JOIN ztable_plant AS b ON a~plant = b~plant_code
      INNER JOIN i_companycode AS c ON b~comp_code = c~companycode
      WHERE a~gateentryno = @lv_gateentry
      INTO @DATA(lv_headerinfo).

*   --- Full company address string ---
    DATA lv_address TYPE string.
    CONCATENATE lv_headerinfo-b-plant_name1
                lv_headerinfo-b-address1
                lv_headerinfo-b-city
                lv_headerinfo-b-state_name
                lv_headerinfo-b-pin
      INTO lv_address SEPARATED BY ', '.

*   --- Vendor details from I_Supplier ---
    SELECT SINGLE bpsupplierfullname,
                  phonenumber1
      FROM i_supplier
      WHERE supplier = @lv_header-invoiceparty
      INTO @DATA(lv_supplier).

*   --- Prepared By: resolve CREATEDBY → full name via I_BusinessUser ---
    SELECT SINGLE personfullname
      FROM I_BusinessUserBasic
      WHERE userid = @lv_header-created_by
      INTO @DATA(lv_preparedby).

*   --- Totals: sum GATEVALUE and GATEQTY across line items ---
    DATA lv_total_value TYPE p DECIMALS 2.
    DATA lv_total_qty   TYPE p DECIMALS 3.
    LOOP AT it_lines INTO DATA(wa_total).
      lv_total_value = lv_total_value + wa_total-gatevalue.
      lv_total_qty   = lv_total_qty   + wa_total-gateqty.
    ENDLOOP.

*   --- Nature of work: pick remarks from first line item per FS ---
    DATA lv_nature_of_work TYPE string.
    READ TABLE it_lines INTO DATA(wa_first_line) INDEX 1.
    IF sy-subrc = 0.
      lv_nature_of_work = wa_first_line-remarks.
    ENDIF.

*   --- Build XML ---
    DATA lv_count TYPE i.
    lv_count = 1.

    DATA(lv_xml) = |<Form>| &&
      |<CompanyName>NIPHA LTD</CompanyName>| &&
      |<CompanyAddress>{ lv_address }</CompanyAddress>| &&
      |<DocumentTitle>RETURNABLE GATE PASS</DocumentTitle>| &&

      |<VendorName>{ lv_header-invoicepartyname }</VendorName>| &&
      |<VendorAddress>{ lv_supplier-bpsupplierfullname }</VendorAddress>| &&
      |<PhoneNumber>{ lv_supplier-phonenumber1 }</PhoneNumber>| &&
      |<GSTNumber>{ lv_header-invoicepartygst }</GSTNumber>| &&

      |<GatePassNo>{ lv_header-gateentryno }</GatePassNo>| &&
      |<Date>{ lv_header-gateindate }</Date>| &&
      |<InvoiceNo>{ lv_header-invoiceno }</InvoiceNo>| &&
      |<VehicleNo>{ lv_header-vehicleno }</VehicleNo>| &&
      |<TransportName>{ lv_header-transportername }</TransportName>| &&
      |<NatureOfWork>{ lv_nature_of_work }</NatureOfWork>| &&
      |<ExpectedReturnDate>{ lv_header-expectrtdate }</ExpectedReturnDate>| &&

      |<GrossWeight>{ lv_header-grosswt }</GrossWeight>| &&
      |<NetWeight>{ lv_header-netwt }</NetWeight>| &&
      |<Packing>{ '' }</Packing>| &&
      |<Remarks>{ lv_header-remarks }</Remarks>| &&

      |<PreparedBy>{ lv_preparedby }</PreparedBy>| &&
      |<CheckedBy>{ '' }</CheckedBy>| &&
      |<ApprovedBy>{ '' }</ApprovedBy>| &&

      |<TotalValue>{ lv_total_value }</TotalValue>| &&
      |<CGST>{ '' }</CGST>| &&
      |<SGST>{ '' }</SGST>| &&
      |<IGST>{ '' }</IGST>| &&
      |<OtherCharges>{ '' }</OtherCharges>| &&
      |<GrandTotal>{ lv_total_value }</GrandTotal>| &&

      |<Table>|.

    DATA lv_xml1 TYPE string.

    LOOP AT it_lines INTO DATA(wa_line).
      DATA(lv_xml2) = |<Item>| &&
        |<SRNO>{ lv_count }</SRNO>| &&
        |<CODE>{ wa_line-productcode }</CODE>| &&
        |<DESCRIPTION>{ wa_line-productdesc }</DESCRIPTION>| &&
        |<HSN>{ '' }</HSN>| &&
        |<UOM>{ wa_line-uom }</UOM>| &&
        |<QTY>{ wa_line-gateqty }</QTY>| &&
        |<TOTALVALUE>{ wa_line-gatevalue }</TOTALVALUE>| &&
        |</Item>|.

      CONCATENATE lv_xml1 lv_xml2 INTO lv_xml1.
      lv_count += 1.
    ENDLOOP.

    DATA(lv_xml3) = |</Table>| &&
                    |</Form>|.

    CONCATENATE lv_xml lv_xml1 lv_xml3 INTO lv_xml.

    CALL METHOD ycl_test_adobe1=>getpdf(
      EXPORTING
        xmldata  = lv_xml
        template = lc_template_name
      RECEIVING
        result   = result12 ).

  ENDMETHOD.
ENDCLASS.
