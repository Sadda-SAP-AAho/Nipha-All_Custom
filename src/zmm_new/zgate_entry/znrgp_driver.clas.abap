CLASS znrgp_driver DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-DATA: access_token TYPE string,
                xml_file     TYPE string.

    TYPES:
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct.

    CLASS-METHODS:
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,

      read_posts
        IMPORTING lv_gateentry          TYPE string
        RETURNING VALUE(result12)       TYPE string
        RAISING   cx_static_check.

  PROTECTED SECTION.
      CONSTANTS lc_template_name TYPE string VALUE 'ZNRGP_FORM/ZNRGP_FORM'.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZNRGP_DRIVER IMPLEMENTATION.


  METHOD read_posts.

    " --- HEADER ---
    SELECT SINGLE FROM zc_gateentryheader AS a
      LEFT JOIN ztable_plant   AS b ON b~plant_code = a~plant
      LEFT JOIN i_supplier     AS c ON c~supplier   = a~invoiceparty
      LEFT JOIN I_BusinessUserBasic AS d ON d~userid     = a~createdby
      FIELDS
        a~invoicepartyname,
*        a~invoicepartygst,
        a~gateentryno,
        a~gateindate,
        a~invoiceno,
        a~vehicleno,
        a~transportername,
        a~remarks,
        b~address1,
        b~address2,
        b~city,
        b~state_name,
        b~pin,
        b~email,
        b~mob_no,
        b~gstin_no,
        b~pan_no,
        c~bpsupplierfullname,
        c~phonenumber1,
        c~TaxNumber3,
        d~personfullname
      WHERE a~gateentryno = @lv_gateentry
      INTO @DATA(wa_header).



    " --- FULL ADDRESS ---
    DATA lt_addr TYPE TABLE OF string.
    IF wa_header-address1   IS NOT INITIAL. APPEND wa_header-address1   TO lt_addr. ENDIF.
    IF wa_header-address2   IS NOT INITIAL. APPEND wa_header-address2   TO lt_addr. ENDIF.
    IF wa_header-city       IS NOT INITIAL. APPEND wa_header-city       TO lt_addr. ENDIF.
    IF wa_header-state_name IS NOT INITIAL. APPEND wa_header-state_name TO lt_addr. ENDIF.
    IF wa_header-pin        IS NOT INITIAL. APPEND wa_header-pin        TO lt_addr. ENDIF.
    IF wa_header-mob_no        IS NOT INITIAL. APPEND |Phone : { wa_header-mob_no }|        TO lt_addr. ENDIF.
    IF wa_header-email        IS NOT INITIAL. APPEND |Email : { wa_header-email }|        TO lt_addr. ENDIF.
    DATA(lv_full_address) = concat_lines_of( table = lt_addr sep = |, | ).

    " --- ITEMS ---
    SELECT FROM zc_gateentrylines AS a
      FIELDS
        a~productdesc,
        a~uom,
        a~gateqty,
        a~gatevalue,
        a~remarks
      WHERE a~gateentryno = @lv_gateentry
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(it_item).

    DATA: lv_sno       TYPE i,
          lv_total     TYPE p LENGTH 16 DECIMALS 2,
          lv_qty_total TYPE p LENGTH 16 DECIMALS 2.

    DATA: lv_xml_header TYPE string,
          lv_xml_items  TYPE string,
          lv_xml_footer TYPE string,
          lv_main_xml   TYPE string.

    " --- XML HEADER ---
    lv_xml_header =
      |<FORM>| &&
      |<HEADER>| &&
        |<COMPANY_NAME>NIPHA LIMITED</COMPANY_NAME>| &&
        |<FULL_ADDRESS>{ lv_full_address }</FULL_ADDRESS>| &&
        |<NAME>{ wa_header-invoicepartyname }</NAME>| &&
        |<ADDRESS>{ wa_header-bpsupplierfullname }</ADDRESS>| &&
        |<PHONE_NUMBER>{ wa_header-phonenumber1 }</PHONE_NUMBER>| &&
        |<GST_NUMBER>{ wa_header-TaxNumber3 }</GST_NUMBER>| &&
        |<GATE_PASS_NO>{ wa_header-gateentryno }</GATE_PASS_NO>| &&
        |<DATE>{ wa_header-gateindate DATE = ISO }</DATE>| &&
        |<INVOICE_NO>{ wa_header-invoiceno }</INVOICE_NO>| &&
        |<VEHICLE_NO>{ wa_header-vehicleno }</VEHICLE_NO>| &&
        |<TRANSPORTER_NAME>{ wa_header-transportername }</TRANSPORTER_NAME>| &&
        |<Phone_No>Phone: { wa_header-mob_no }</Phone_No>| &&
        |<Email>Email: { wa_header-email }</Email>| &&
        |<GSTIN>{ wa_header-gstin_no }</GSTIN>| &&
        |<PAN>{ wa_header-pan_no }</PAN>| &&
      |</HEADER>|.

    " --- XML ITEMS ---
    LOOP AT it_item INTO DATA(wa_item).
      lv_sno        = lv_sno + 1.
      lv_total     += wa_item-gatevalue.
      lv_qty_total += wa_item-gateqty.

      lv_xml_items = lv_xml_items &&
        |<ITEM>| &&
          |<SLNO>{ lv_sno }</SLNO>| &&
          |<DESCRIPTION>{ wa_item-productdesc }</DESCRIPTION>| &&
          |<UOM>{ wa_item-uom }</UOM>| &&
          |<QTY>{ wa_item-gateqty }</QTY>| &&
          |<APPROXVALUE>{ wa_item-gatevalue }</APPROXVALUE>| &&
          |<REMARK>{ wa_item-remarks }</REMARK>| &&
        |</ITEM>|.
    ENDLOOP.

    " --- XML FOOTER ---
    " Note: CHECKED_BY and APPROVED_BY — confirm source table with functional team
    lv_xml_footer =
      |<FOOTER>| &&
        |<TOTAL_QTY>{ lv_qty_total }</TOTAL_QTY>| &&
        |<TOTAL_VALUE>{ lv_total }</TOTAL_VALUE>| &&
        |<HEADER_REMARK>{ wa_header-remarks }</HEADER_REMARK>| &&
        |<PREPARED_BY>{ wa_header-personfullname }</PREPARED_BY>| &&
        |<CHECKED_BY></CHECKED_BY>| &&
        |<APPROVED_BY></APPROVED_BY>| &&
      |</FOOTER>|.


    CONCATENATE
      lv_xml_header
      '<ITEMS>'
      lv_xml_items
      '</ITEMS>'
      lv_xml_footer
      '</FORM>'
    INTO lv_main_xml.

    REPLACE ALL OCCURRENCES OF '&' IN lv_main_xml WITH 'and'.


    CALL METHOD ycl_test_adobe1=>getpdf
      EXPORTING
        xmldata  = lv_main_xml
        template = lc_template_name
      RECEIVING
        result   = result12.

  ENDMETHOD.


  METHOD create_client.
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD.
ENDCLASS.
