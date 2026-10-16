CLASS zcl_material_issue_print DEFINITION
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
        IMPORTING
          url           TYPE string
        RETURNING
          VALUE(result) TYPE REF TO if_web_http_client
        RAISING
          cx_static_check,

      read_posts
        IMPORTING
          lv_materialdocument TYPE string
        RETURNING
          VALUE(result12)     TYPE string
        RAISING
          cx_static_check.

  PROTECTED SECTION.
    CONSTANTS lc_template_name TYPE string VALUE 'ZMATERIAL_ISSUE_PRINT/ZMATERIAL_ISSUE_PRINT'.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MATERIAL_ISSUE_PRINT IMPLEMENTATION.


  METHOD read_posts.

    """Header Data
    SELECT SINGLE FROM i_materialdocumentitem_2  AS a
    LEFT JOIN ztable_plant AS b ON b~plant_code = a~plant
    LEFT JOIN i_reservationdocumentheader AS c ON c~reservation = a~reservation
    LEFT JOIN i_businessuserbasic  AS d ON d~userid = c~userid
    LEFT JOIN I_MATERIALDOCUMENTHEADER_2  AS e ON e~MaterialDocument = a~MaterialDocument
    LEFT JOIN i_businessuserbasic  AS f ON f~userid = e~CreatedByUser
    LEFT JOIN I_MATERIALDOCUMENTHEADER_2 as g on a~MaterialDocument = g~MaterialDocument AND a~Plant = g~Plant
    FIELDS
    a~plant,a~materialdocument,a~postingdate,a~goodsmovementtype,g~MaterialDocumentHeaderText,
    b~address1,b~address2,b~address3,b~state_name,b~pin,b~gstin_no,
    c~userid,c~creationdatetime,
    d~personfullname,
    e~CreatedByUser,
    f~PersonFullName as issue_PersonFullName
    WHERE a~materialdocument = @lv_materialdocument
    INTO @DATA(wa_header).

    DATA lt_addr TYPE TABLE OF string.

    IF wa_header-address1 IS NOT INITIAL.
      APPEND wa_header-address1 TO lt_addr.
    ENDIF.

    IF wa_header-address2 IS NOT INITIAL.
      APPEND wa_header-address2 TO lt_addr.
    ENDIF.

    IF wa_header-address3 IS NOT INITIAL.
      APPEND wa_header-address3 TO lt_addr.
    ENDIF.

    IF wa_header-state_name IS NOT INITIAL.
      APPEND wa_header-state_name TO lt_addr.
    ENDIF.

    IF wa_header-pin IS NOT INITIAL.
      APPEND wa_header-pin TO lt_addr.
    ENDIF.

    DATA(lv_full_address) = concat_lines_of(
      table = lt_addr
      sep   = |, |
    ).

    ""Item Data
    SELECT FROM i_materialdocumentitem_2 AS a
    LEFT JOIN i_reservationdocumentitem  AS b ON b~reservation = a~reservation
    left    jOIN I_PRODUCTDESCRIPTION as c on a~Material = c~Product
    LEFT JOIN I_COSTCENTERTEXT as d on a~CostCenter = d~CostCenter
    FIELDS
    a~materialdocumentitem,a~material,a~goodsmovementtype,a~reservation,a~costcenter,a~StorageLocation,
    a~QuantityInBaseUnit,a~entryunit,a~MaterialBaseUnit,a~TOTALGOODSMVTAMTINCCCRCY,
    b~resvnitmrequiredqtyinentryunit,b~entryunit AS issue_qty_entry_unit,b~resvnitmwithdrawnamtincccrcy,
    c~ProductDescription, d~CostCenterDescription
    WHERE a~materialdocument = @lv_materialdocument
    INTO TABLE @DATA(it_item).

    DATA: lv_sno             TYPE i,
          lv_total_value      TYPE p LENGTH 16 DECIMALS 2,
          lv_total_issued_qty TYPE p LENGTH 16 DECIMALS 2,
          lv_unit_rate        TYPE p LENGTH 16 DECIMALS 2.

    DATA: lv_xml_header TYPE string,
          lv_xml_items  TYPE string,
          lv_xml_footer TYPE string,
          lv_main_xml   TYPE string.

    lv_xml_header =
      |<FORM>| &&
      |<HEADER>| &&
      |<COMPANY_NAME>NIPHA LIMITED</COMPANY_NAME>| &&
*      |<PLANT>{ wa_header-Plant }</PLANT>| &&
      |<ADDRESS>{ 'Plant-' } { wa_header-Plant } { '-' } { lv_full_address } GSTIN :{ wa_header-gstin_no }</ADDRESS>| &&
*      |<GSTIN>{ wa_header-gstin_no }</GSTIN>| &&
      |<TITLE>MATERIAL ISSUE SLIP</TITLE>| &&
      |<ISSUE_SLIP_NO>{ wa_header-MaterialDocument }</ISSUE_SLIP_NO>| &&
      |<ISSUE_DATE>{ wa_header-PostingDate DATE = ISO }</ISSUE_DATE>| &&
      |<MOVEMENT_TYPE>{ wa_header-GoodsMovementType }</MOVEMENT_TYPE>| &&
      |<STORAGE_LOCATION>{ wa_header-MaterialDocumentHeaderText }</STORAGE_LOCATION>| &&
      |</HEADER>|.

    LOOP AT it_item INTO DATA(wa_item).

      lv_sno = lv_sno + 1.
      lv_total_value += wa_item-TOTALGOODSMVTAMTINCCCRCY.
      lv_total_issued_qty += wa_item-QuantityInBaseUnit.

      CLEAR lv_unit_rate.

      IF wa_item-QuantityInBaseUnit IS NOT INITIAL.
        lv_unit_rate = wa_item-TOTALGOODSMVTAMTINCCCRCY /
                       wa_item-QuantityInBaseUnit.
      ENDIF.

        IF wa_item-EntryUnit = 'ST'.
           wa_item-EntryUnit = 'PC'.
        ENDIF.
        ShIFT wa_item-MaterialDocumentItem lEFT DELETING LEADING '0'.
        ShIFT wa_item-Reservation lEFT DELETING LEADING '0'.


     lv_xml_items  =
        |<ITEM>| &&
        |<SLNO>{ lv_sno }</SLNO>| &&
        |<ITEM_NO>{ wa_item-MaterialDocumentItem }</ITEM_NO>| &&
        |<MATERIAL_CODE>{ wa_item-Material ALPHA = OUT }</MATERIAL_CODE>| &&
        |<MATERIAL_DESCRIPTION>{ wa_item-ProductDescription }</MATERIAL_DESCRIPTION>| &&
        |<RESERVATION>{ wa_item-Reservation }</RESERVATION>| &&
        |<COST_CENTER>{ wa_item-CostCenter } { cl_abap_char_utilities=>newline } { wa_item-CostCenterDescription }</COST_CENTER>| &&
        |<REQ_QTY>{ wa_item-ResvnItmRequiredQtyInEntryUnit }{ wa_item-MaterialBaseUnit } </REQ_QTY>| &&
        |<REQ_QTY_UNIT>{ wa_item-issue_qty_entry_unit }</REQ_QTY_UNIT>| &&
        |<ISSUED_QTY>{ wa_item-QuantityInBaseUnit } { wa_item-EntryUnit } </ISSUED_QTY>| &&
        |<ISSUED_QTY_UNIT>{ wa_item-EntryUnit }</ISSUED_QTY_UNIT>| &&
        |<STORAGE_LOCATION>{ wa_item-StorageLocation }</STORAGE_LOCATION>| &&
        |<UNIT_RATE>{ lv_unit_rate }</UNIT_RATE>| &&
        |<TOTAL_VALUE>{ wa_item-TOTALGOODSMVTAMTINCCCRCY }</TOTAL_VALUE>| &&
        |</ITEM>|.

    ENDLOOP.

    IF wa_header-CreationDateTime is noT iNITIAL.

    DATA(date1) = CONV string( wa_header-CreationDateTime ).
date1 = date1+0(8).





    ENDIF.

    lv_xml_footer =
      |<FOOTER>| &&
      |<TOTAL_ISSUED_QTY>{ lv_total_issued_qty }</TOTAL_ISSUED_QTY>| &&
      |<TOTAL_VALUE>{ lv_total_value }</TOTAL_VALUE>| &&
      |<TOTAL_ISSUED_VALUE></TOTAL_ISSUED_VALUE>| &&
      |<REQUISITIONED_BY>HARDCODE</REQUISITIONED_BY>| &&
      |<REQUISITIONED_USER_ID>{ wa_header-UserID }</REQUISITIONED_USER_ID>| &&
      |<REQUISITIONED_NAME>{ wa_header-PersonFullName }</REQUISITIONED_NAME>| &&
      |<REQUISITIONED_DATE>{ date1 }</REQUISITIONED_DATE>| &&
      |<ISSUED_BY></ISSUED_BY>| &&
      |<ISSUED_USER_ID>{ wa_header-CreatedByUser }</ISSUED_USER_ID>| &&
      |<ISSUED_NAME>{ wa_header-issue_personfullname }</ISSUED_NAME>| &&
      |<ISSUED_DATE>{ wa_header-PostingDate DATE = ISO }</ISSUED_DATE>| &&
      |<RECEIVED_BY>HARDCODE</RECEIVED_BY>| &&
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
