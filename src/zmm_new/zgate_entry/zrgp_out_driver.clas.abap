CLASS zrgp_out_driver DEFINITION
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



CLASS ZRGP_OUT_DRIVER IMPLEMENTATION.


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

    SELECT SINGLE FROM zc_gateentryheader AS a
      LEFT JOIN i_supplier AS c ON c~supplier = a~invoiceparty
      FIELDS
      c~taxnumber3 AS gst
      WHERE a~gateentryno = @lv_gateentry
      INTO @DATA(lv_gno).

*   --- Line items ---
    SELECT *
      FROM zgateentrylines
      WHERE gateentryno = @lv_gateentry
      INTO TABLE @DATA(it_lines).

*   --- HSN ---
    SELECT FROM zgateentrylines AS a
      LEFT JOIN i_productplantbasic AS b ON b~plant = a~plant AND  ltrim( b~product, '0' )  = a~productcode
      FIELDS
      a~productcode,
      b~consumptiontaxctrlcode
      WHERE a~gateentryno = @lv_gateentry
      INTO TABLE @DATA(lt_hsn) PRIVILEGED ACCESS.

    SORT lt_hsn BY productcode.

*   --- Plant + Company info ---
    SELECT SINGLE *
      FROM zgateentryheader AS a
      INNER JOIN ztable_plant AS b ON a~plant = b~plant_code
      INNER JOIN i_companycode AS c ON b~comp_code = c~companycode
      WHERE a~gateentryno = @lv_gateentry
      INTO @DATA(lv_headerinfo).

*   --- Full company address string ---
    DATA(lv_address) =
  |{ lv_headerinfo-b-address1 }, | &&
  |{ lv_headerinfo-b-address2 }, | &&
  |{ lv_headerinfo-b-city }, | &&
  |{ lv_headerinfo-b-state_name }, | &&
  |{ lv_headerinfo-b-pin }, | &&
  |Phone : { lv_headerinfo-b-mob_no }, | &&
  |Email : { lv_headerinfo-b-email }|.

*   --- Vendor details ---
    SELECT SINGLE bpsupplierfullname,
                  phonenumber1
      FROM i_supplier
      WHERE supplier = @lv_header-invoiceparty
      INTO @DATA(lv_supplier).

  ""Vendor address
    SELECT SINGLE from zgateentryheader AS a
    LEFT JOIN I_SUPPLIER as b on b~Supplier = a~invoiceparty
    FIELDS
    b~BPAddrStreetName,
    b~BPAddrCityName,
    b~DistrictName
      WHERE a~gateentryno = @lv_gateentry
      INTO @DATA(ls_supplier).

    DATA lv_supplier_address TYPE string.

IF ls_supplier-BPAddrStreetName IS NOT INITIAL.
  lv_supplier_address = ls_supplier-BPAddrStreetName.
ENDIF.

IF ls_supplier-BPAddrCityName IS NOT INITIAL.
  IF lv_supplier_address IS INITIAL.
    lv_supplier_address = ls_supplier-BPAddrCityName.
  ELSE.
    CONCATENATE lv_supplier_address
                ls_supplier-BPAddrCityName
           INTO lv_supplier_address
           SEPARATED BY ', '.
  ENDIF.
ENDIF.

IF ls_supplier-DistrictName IS NOT INITIAL.
  IF lv_supplier_address IS INITIAL.
    lv_supplier_address = ls_supplier-DistrictName.
  ELSE.
    CONCATENATE lv_supplier_address
                ls_supplier-DistrictName
           INTO lv_supplier_address
           SEPARATED BY ', '.
  ENDIF.
ENDIF.
*   --- Prepared By ---
    SELECT SINGLE personfullname
      FROM I_BusinessUserBasic
      WHERE userid = @lv_header-created_by
      INTO @DATA(lv_preparedby).

*   --- Tax rates ---
    SELECT
        a~gateentryno,
        a~gateitemno,
        a~taxrate,
        c~taxcode,
        c~vatconditiontype,
        c~conditionrateratio
      FROM zgateentrylines AS a
      LEFT JOIN zgateentryheader AS b
        ON a~gateentryno = b~gateentryno
      LEFT JOIN i_taxcoderate AS c ON c~taxcode = a~taxrate
      WHERE a~gateentryno = @lv_gateentry
        AND c~country = 'IN'
        AND c~vatconditiontype IN ( 'JICG', 'JISG', 'JIIG' )
      INTO TABLE @DATA(lt_taxrates)
      PRIVILEGED ACCESS.

*   --- Running totals for footer / grand-total subform ---
    DATA: lv_total_value    TYPE p DECIMALS 2,
          lv_total_qty      TYPE p DECIMALS 3,
          lv_total_cgst_amt TYPE p DECIMALS 2,
          lv_total_sgst_amt TYPE p DECIMALS 2,
          lv_total_igst_amt TYPE p DECIMALS 2.

    SORT lt_taxrates BY taxcode vatconditiontype.
    SORT lt_hsn BY productcode.

**   --- Nature of work ---
*    DATA lv_nature_of_work TYPE string.
*    READ TABLE it_lines INTO DATA(wa_first_line) INDEX 1.
*    IF sy-subrc = 0.
*      lv_nature_of_work = wa_first_line-remarks.
*    ENDIF.

*   --- Build item rows + accumulate totals in one pass ---
    DATA lv_count TYPE i VALUE 1.
    DATA lv_xml1  TYPE string.

    DATA: wa_cgst LIKE LINE OF lt_taxrates,
          wa_sgst LIKE LINE OF lt_taxrates,
          wa_igst LIKE LINE OF lt_taxrates,
          wa_hsn  LIKE LINE OF lt_hsn.

    DATA: lv_line_cgst_rate   TYPE p DECIMALS 2,
          lv_line_cgst_amt    TYPE p DECIMALS 2,
          lv_line_sgst_rate   TYPE p DECIMALS 2,
          lv_line_sgst_amt    TYPE p DECIMALS 2,
          lv_line_igst_rate   TYPE p DECIMALS 2,
          lv_line_igst_amt    TYPE p DECIMALS 2,
          lv_line_total_amt   TYPE p DECIMALS 2,
          lv_line_grand_total TYPE p DECIMALS 2.

    LOOP AT it_lines INTO DATA(wa_line).

      lv_total_value = lv_total_value + wa_line-gatevalue.
      lv_total_qty   = lv_total_qty   + wa_line-gateqty.

*     --- HSN for this line ---
      CLEAR wa_hsn.
      READ TABLE lt_hsn INTO wa_hsn
        WITH KEY productcode = wa_line-productcode
        BINARY SEARCH.
      DATA(lv_line_hsn) = COND string( WHEN sy-subrc = 0 THEN wa_hsn-consumptiontaxctrlcode ELSE '' ).

*     --- CGST for this line ---
      CLEAR wa_cgst.
      CLEAR: lv_line_cgst_rate, lv_line_cgst_amt.
      READ TABLE lt_taxrates INTO wa_cgst
        WITH KEY taxcode = wa_line-taxrate
                 vatconditiontype = 'JICG'
        BINARY SEARCH.
      IF sy-subrc = 0.
        lv_line_cgst_rate = wa_cgst-conditionrateratio.
        lv_line_cgst_amt  = wa_line-gatevalue * wa_cgst-conditionrateratio / 100.
        lv_total_cgst_amt = lv_total_cgst_amt + lv_line_cgst_amt.
      ENDIF.

*     --- SGST for this line ---
      CLEAR wa_sgst.
      CLEAR: lv_line_sgst_rate, lv_line_sgst_amt.
      READ TABLE lt_taxrates INTO wa_sgst
        WITH KEY taxcode = wa_line-taxrate
                 vatconditiontype = 'JISG'
        BINARY SEARCH.
      IF sy-subrc = 0.
        lv_line_sgst_rate = wa_sgst-conditionrateratio.
        lv_line_sgst_amt  = wa_line-gatevalue * wa_sgst-conditionrateratio / 100.
        lv_total_sgst_amt = lv_total_sgst_amt + lv_line_sgst_amt.
      ENDIF.

*     --- IGST for this line ---
      CLEAR wa_igst.
      CLEAR: lv_line_igst_rate, lv_line_igst_amt.
      READ TABLE lt_taxrates INTO wa_igst
        WITH KEY taxcode = wa_line-taxrate
                 vatconditiontype = 'JIIG'
        BINARY SEARCH.
      IF sy-subrc = 0.
        lv_line_igst_rate = wa_igst-conditionrateratio.
        lv_line_igst_amt  = wa_line-gatevalue * wa_igst-conditionrateratio / 100.
        lv_total_igst_amt = lv_total_igst_amt + lv_line_igst_amt.
      ENDIF.

*     --- Row-level totals: plain total, and total incl. tax ---
      lv_line_total_amt   = wa_line-gatevalue.
      lv_line_grand_total = wa_line-gatevalue + lv_line_cgst_amt + lv_line_sgst_amt + lv_line_igst_amt.

      DATA lv_desc  TYPE string.

      lv_desc = wa_line-productdesc.

      REPLACE ALL OCCURRENCES OF '&' IN lv_desc WITH ''.
      REPLACE ALL OCCURRENCES OF '<' IN lv_desc WITH ''.
      REPLACE ALL OCCURRENCES OF '>' IN lv_desc WITH ''.
      REPLACE ALL OCCURRENCES OF '"' IN lv_desc WITH ''.
      REPLACE ALL OCCURRENCES OF '''' IN lv_desc WITH ''.

      DATA(lv_xml2) = |<Item>| &&
       |<SNO>{ lv_count }</SNO>| &&
       |<MATERIAL_CD>{ wa_line-productcode }</MATERIAL_CD>| &&
*        |<DESC>{ wa_line-productdesc }</DESC>| &&
       |<DESC>{ lv_desc }</DESC>| &&
       |<HSN>{ lv_line_hsn }</HSN>| &&
       |<UOM>{ wa_line-uom }</UOM>| &&
       |<QTY>{ wa_line-gateqty DECIMALS = 2 }</QTY>| &&
       |<CGST_RATE>{ lv_line_cgst_rate DECIMALS = 2 }</CGST_RATE>| &&
       |<CGST_AMT>{ lv_line_cgst_amt DECIMALS = 2 }</CGST_AMT>| &&
       |<SGST_RATE>{ lv_line_sgst_rate DECIMALS = 2 }</SGST_RATE>| &&
       |<SGST_AMT>{ lv_line_sgst_amt DECIMALS = 2 }</SGST_AMT>| &&
       |<IGST_RATE>{ lv_line_igst_rate DECIMALS = 2 }</IGST_RATE>| &&
       |<IGST_AMT>{ lv_line_igst_amt DECIMALS = 2 }</IGST_AMT>| &&
       |<TOTAL_AMT>{ lv_line_total_amt DECIMALS = 2 }</TOTAL_AMT>| &&
       |<GRAND_TOTAL_VALUE>{ lv_line_grand_total DECIMALS = 2 }</GRAND_TOTAL_VALUE>| &&
       |</Item>|.

      lv_xml1 = lv_xml1 && lv_xml2.
      lv_count += 1.

    ENDLOOP.

    DATA lv_grand_total TYPE p LENGTH 16 DECIMALS 2.

lv_grand_total =
      lv_total_value
    + lv_total_cgst_amt
    + lv_total_sgst_amt
    + lv_total_igst_amt.
*   --- Build header + footer XML ---
    DATA(lv_main_xml) = |<Form>| &&
      |<CompanyName>NIPHA LIMITED</CompanyName>| &&
      |<CompanyAddress>{ lv_address }</CompanyAddress>| &&
      |<DocumentTitle>RETURNABLE GATE PASS</DocumentTitle>| &&

      |<VendorName>{ lv_header-invoicepartyname }</VendorName>| &&
      |<VendorAddress>{ lv_supplier_address }</VendorAddress>| &&
      |<PhoneNumber>{ lv_supplier-phonenumber1 }</PhoneNumber>| &&
      |<GSTNumber>{ lv_gno }</GSTNumber>| &&

      |<GatePassNo>{ lv_header-gateentryno }</GatePassNo>| &&
      |<Date>{ lv_header-gateindate }</Date>| &&
      |<InvoiceNo>{ lv_header-invoiceno }</InvoiceNo>| &&
      |<VehicleNo>{ lv_header-vehicleno }</VehicleNo>| &&
      |<TransportName>{ lv_header-transportername }</TransportName>| &&
      |<NatureOfWork>{ lv_header-remarks }</NatureOfWork>| &&
      |<ExpectedReturnDate>{ lv_header-expectrtdate }</ExpectedReturnDate>| &&
        |<Phone_No>Phone: { lv_headerinfo-b-mob_no }</Phone_No>| &&
        |<Email>Email: { lv_headerinfo-b-email }</Email>| &&
        |<GSTIN>{ lv_headerinfo-b-gstin_no }</GSTIN>| &&
        |<PAN>{ lv_headerinfo-b-pan_no }</PAN>| &&
      |<GrossWeight>{ lv_header-grosswt }</GrossWeight>| &&
      |<NetWeight>{ lv_header-netwt }</NetWeight>| &&
      |<Packing>{ '' }</Packing>| &&
      |<Remarks>{ lv_header-remarks }</Remarks>| &&

      |<PreparedBy>{ lv_preparedby }</PreparedBy>| &&
      |<CheckedBy>{ '' }</CheckedBy>| &&
      |<ApprovedBy>{ '' }</ApprovedBy>| &&

      |<Table>|.

    DATA(lv_footer_xml) =
      |<FooterRow>| &&
      |<QTY_TOTAL>{ lv_total_qty DECIMALS = 2 }</QTY_TOTAL>| &&
      |<TOTAL_VALUE>{ lv_total_value DECIMALS = 2 }</TOTAL_VALUE>| &&
      |<FOOTER_CGST_AMT>{ lv_total_cgst_amt DECIMALS = 2 }</FOOTER_CGST_AMT>| &&
      |<FOOTER_SGST_AMT>{ lv_total_sgst_amt DECIMALS = 2 }</FOOTER_SGST_AMT>| &&
      |<FOOTER_IGST_AMT>{ lv_total_igst_amt DECIMALS = 2 }</FOOTER_IGST_AMT>| &&
      |<FOOTER_GRAND_TOTAL>{ lv_grand_total DECIMALS = 2 }</FOOTER_GRAND_TOTAL>| &&
      |</FooterRow>| &&
      |</Table>|.

*   --- Grand-total subform (below the table) ---
    DATA(lv_xml3) =

      |<OTHERCHARGES>{ '' }</OTHERCHARGES>| &&
      |<TOTAL>{ lv_grand_total DECIMALS = 2 }</TOTAL>| &&
      |</Form>|.




    CONCATENATE lv_main_xml lv_xml1 lv_footer_xml lv_xml3 INTO lv_main_xml.

*    REPLACE ALL OCCURRENCES OF '‹' IN lv_main_xml WITH ''.
*    REPLACE ALL OCCURRENCES OF '›' IN lv_main_xml WITH ''.
*    REPLACE ALL OCCURRENCES OF '&' IN lv_main_xml WITH 'AND'.


    CALL METHOD ycl_test_adobe1=>getpdf(
      EXPORTING
        xmldata  = lv_main_xml
        template = lc_template_name
      RECEIVING
        result   = result12 ).

  ENDMETHOD.
ENDCLASS.
