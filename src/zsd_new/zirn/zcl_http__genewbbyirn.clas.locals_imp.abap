*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_generateewbirn DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS validatedocument
      IMPORTING
        checkdetais TYPE abap_boolean OPTIONAL
      EXPORTING
        rv_is_valid TYPE abap_bool
        rv_message  TYPE string.

    CLASS-METHODS checkconfigs
      EXPORTING
        rv_is_valid TYPE abap_bool
        rv_message  TYPE string.

    CLASS-METHODS getinstance
      IMPORTING
        !iv_body           TYPE ty_request
      RETURNING
        VALUE(ro_instance) TYPE REF TO lcl_generateewbirn.

    CLASS-METHODS generatejson
      EXPORTING
        error         TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
    METHODS constructor
      IMPORTING
        !iv_body TYPE ty_request.

    CLASS-METHODS split_addr_line
      IMPORTING
        addr_line TYPE string
      EXPORTING
        part1     TYPE string
        part2     TYPE string.

    CLASS-DATA: mv_companycode TYPE bukrs,
                mv_document    TYPE vbeln,
                lcl_class      TYPE REF TO lcl_generateewbirn.


ENDCLASS.

CLASS lcl_generateewbirn IMPLEMENTATION.

  METHOD getinstance.
    IF lcl_class IS NOT BOUND.
      CREATE OBJECT lcl_class
        EXPORTING
          iv_body = iv_body.
    ENDIF.
    ro_instance = lcl_class.
  ENDMETHOD.

  METHOD constructor.
    mv_companycode = iv_body-companycode.
    mv_document    = iv_body-billingdocument.
  ENDMETHOD.

  METHOD checkconfigs.

    SELECT SINGLE FROM zr_table_plant000 AS a
        INNER JOIN i_billingdocumentitem AS b ON a~plantcode = b~plant AND a~compcode = b~companycode
        FIELDS a~gstinno
        WHERE b~companycode = @mv_companycode AND b~billingdocument = @mv_document
        INTO @DATA(plant_gstin).

    IF plant_gstin IS INITIAL.
      rv_message = 'GSTIN not maintained for the plant'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM zr_integration_tab000
        FIELDS intgpath
        WHERE intgmodule = @header_key
        INTO @DATA(header_value).

    IF header_value IS INITIAL.
      rv_message = 'Header Value is not maintained for EWB Generation'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD validatedocument.

    SELECT SINGLE FROM zr_irn
       FIELDS ewaystatus, ewaybillno, irnno
       WHERE companycode = @mv_companycode
           AND billingdocument = @mv_document
       INTO @DATA(lv_irnstatus).

    IF mv_companycode IS INITIAL OR mv_document IS INITIAL.
      rv_message = 'Company code and document number are required'.
      rv_is_valid = abap_false.
      RETURN.
    ELSEIF sy-subrc <> 0.
      rv_message = 'Document not found'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.
    IF checkdetais IS NOT INITIAL.
      IF lv_irnstatus-ewaybillno IS NOT INITIAL.
        rv_message = 'EWB already generated for this document'.
        rv_is_valid = abap_false.
        RETURN.
      ELSEIF lv_irnstatus-ewaystatus IS NOT INITIAL.
        rv_message = 'Document is already processed for EWB generation'.
        rv_is_valid = abap_false.
        RETURN.
      ELSEIF lv_irnstatus-irnno IS INITIAL.
        rv_message = 'IRN not generated for this document'.
        rv_is_valid = abap_false.
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD generatejson.

    DATA: wa_final    TYPE ty_json_data.


    SELECT SINGLE FROM i_billingdocument AS a
    INNER JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
    FIELDS a~billingdocument, a~billingdocumenttype, a~billingdocumentdate, b~plant,b~companycode
    WHERE a~billingdocument = @mv_document
    INTO @DATA(lv_document_details) PRIVILEGED ACCESS.

    SELECT SINGLE FROM zr_table_plant000
        FIELDS gstinno, city, address1, address2, pin, statecode1, plantname1, statename, companyname, ewbpassword, ewbusername
        WHERE plantcode = @lv_document_details-plant AND compcode = @lv_document_details-companycode
        INTO @DATA(sellerplantaddress) PRIVILEGED ACCESS.


    SELECT SINGLE FROM zr_irn
        FIELDS ewaytranstype, address, statecode, state, pincode, place, distance, transportername, vehiclenum,
               grdate, grno, transportergstin, irnno
        WHERE billingdocument = @mv_document AND companycode = @mv_companycode
        INTO @DATA(transtype).

    IF transtype = 'Regular' OR transtype = 'Bill to-ship to'.
      wa_final-dispdtls-nm          =  sellerplantaddress-companyname.
      wa_final-dispdtls-addr1       =  sellerplantaddress-address1.
      wa_final-dispdtls-addr2       =  sellerplantaddress-address2.
      wa_final-dispdtls-loc         =  sellerplantaddress-address2 .
      IF sellerplantaddress-city IS NOT INITIAL.
        wa_final-dispdtls-loc       =  sellerplantaddress-city .
      ENDIF.
      wa_final-dispdtls-stcd        =  sellerplantaddress-statecode1.
      wa_final-dispdtls-pin         =  sellerplantaddress-pin.

    ELSEIF transtype = 'Bill from-dispatch from' OR transtype = 'Combination'.

      IF transtype-address IS NOT INITIAL.
        wa_final-dispdtls-nm        = transtype-address .

        DATA dispatch_full_addr TYPE string.
        dispatch_full_addr          = transtype-place.

        CALL METHOD split_addr_line
          EXPORTING
            addr_line = dispatch_full_addr
          IMPORTING
            part1     = wa_final-dispdtls-addr1
            part2     = wa_final-dispdtls-addr2.
        wa_final-dispdtls-loc       =  transtype-state.
        wa_final-dispdtls-stcd      =  transtype-statecode.
        wa_final-dispdtls-pin       =  transtype-pincode.
      ELSE.
        wa_final-dispdtls-nm        =  sellerplantaddress-companyname.
        wa_final-dispdtls-addr1     =  sellerplantaddress-address1.
        wa_final-dispdtls-addr2     =  sellerplantaddress-address2.
        wa_final-dispdtls-loc       =  sellerplantaddress-address2 .
        IF sellerplantaddress-city IS NOT INITIAL.
          wa_final-dispdtls-loc     =  sellerplantaddress-city .
        ENDIF.
        wa_final-dispdtls-stcd      =  sellerplantaddress-statecode1.
        wa_final-dispdtls-pin       =  sellerplantaddress-pin.

      ENDIF.
    ENDIF.

    wa_final-vehno                  = transtype-vehiclenum .
    wa_final-irn                    = transtype-irnno .
    wa_final-transname              = transtype-transportername .
    wa_final-transdocdt             = transtype-grdate+6(2) && '/' && transtype-grdate+4(2) && '/' && transtype-grdate(4).
    wa_final-transdocno             = transtype-grno .
    wa_final-transid                = transtype-transportergstin .
    wa_final-transmode              = '1'.
    wa_final-distance               = transtype-distance.
    wa_final-vehtype                = 'R'.



    DATA: lt_payload TYPE TABLE OF ty_ewb_payload,
          ls_payload TYPE ty_ewb_payload.


    SELECT SINGLE FROM zr_integration_tab000
 FIELDS intgpath
 WHERE intgmodule = 'EWB-EFUNAME-EFPASS-CDKEY'
 INTO @DATA(efusercreds).

    SPLIT efusercreds AT '/' INTO ls_payload-efusername ls_payload-efpassword ls_payload-cdkey.

    ls_payload-ewbusername = sellerplantaddress-ewbusername.
    ls_payload-ewbpassword = sellerplantaddress-ewbpassword.


    ls_payload-irn        = transtype-irnno.
    ls_payload-transmode  = '1'.
    ls_payload-transid    = transtype-transportergstin.
    ls_payload-transname  = transtype-transportername.
    ls_payload-distance   = transtype-distance.
    ls_payload-transdocno = transtype-grno.
    ls_payload-transdocdt = transtype-grdate.
    ls_payload-vehno      = transtype-vehiclenum.
    ls_payload-vehtype    = 'R'.
    ls_payload-gstin       = sellerplantaddress-gstinno.
    ls_payload-shipfrom_addr1 = sellerplantaddress-address1.
    ls_payload-shipfrom_addr2 = sellerplantaddress-address2.
    ls_payload-shipfrom_loc   = COND #( WHEN sellerplantaddress-city IS NOT INITIAL
                                        THEN sellerplantaddress-city
                                        ELSE sellerplantaddress-address2 ).
    ls_payload-shipfrom_pin   = sellerplantaddress-pin.
    ls_payload-shipfrom_stcd  = sellerplantaddress-statecode1.


    SELECT SINGLE * FROM i_billingdocitempartner AS a
    INNER JOIN i_customer AS b ON ( a~customer = b~customer  )
    INNER JOIN i_address_2 AS c ON ( b~addressid = c~addressid )
    WHERE a~billingdocument = @mv_document AND a~partnerfunction = 'WE'
    INTO  @DATA(shiptoadd) PRIVILEGED ACCESS.

    DATA(shipper_full_addr) = shiptoadd-c-housenumber && ' ' && shiptoadd-c-streetname && ' ' && shiptoadd-c-streetprefixname1 && ' ' && shiptoadd-c-streetprefixname2
                                  && ' ' && shiptoadd-c-streetsuffixname1 && ' ' && shiptoadd-c-streetsuffixname2 && ' ' && shiptoadd-c-districtname && ' ' && shiptoadd-c-villagename.


    CALL METHOD split_addr_line
      EXPORTING
        addr_line = shipper_full_addr
      IMPORTING
        part1     = ls_payload-shipto_addr1
        part2     = ls_payload-shipto_addr2.

    ls_payload-shipto_gstin   = COND #( WHEN shiptoadd-b-taxnumber3 IS INITIAL THEN shiptoadd-b-taxnumber3 ELSE 'URP' ).
    ls_payload-shipto_trdnm   = shiptoadd-b-customername.
    ls_payload-shipto_loc     = shiptoadd-c-cityname.
    ls_payload-shipto_pin     = shiptoadd-c-postalcode.
    ls_payload-shipto_stcd    = shiptoadd-c-region.


    APPEND ls_payload TO lt_payload.


    DATA: BEGIN OF ls_wrapper,
            push_data_list TYPE TABLE OF ty_ewb_payload,
          END OF ls_wrapper.

    ls_wrapper-push_data_list = lt_payload.


    DATA:json TYPE REF TO if_xco_cp_json_data.

    xco_cp_json=>data->from_abap(
      EXPORTING
        ia_abap      = ls_wrapper
      RECEIVING
        ro_json_data = json   ).
    json->to_string(
      RECEIVING
        rv_string =   DATA(lv_string) ).


    REPLACE ALL OCCURRENCES OF '"PUSH_DATA_LIST"' IN lv_string WITH '"Push_Data_List"'.
    REPLACE ALL OCCURRENCES OF '"IRN"'            IN lv_string WITH '"Irn"'.
    REPLACE ALL OCCURRENCES OF '"TRANSMODE"'      IN lv_string WITH '"TransMode"'.
    REPLACE ALL OCCURRENCES OF '"TRANSID"'        IN lv_string WITH '"Transid"'.
    REPLACE ALL OCCURRENCES OF '"TRANSNAME"'      IN lv_string WITH '"Transname"'.
    REPLACE ALL OCCURRENCES OF '"DISTANCE"'       IN lv_string WITH '"Distance"'.
    REPLACE ALL OCCURRENCES OF '"TRANSDOCNO"'     IN lv_string WITH '"Transdocno"'.
    REPLACE ALL OCCURRENCES OF '"TRANSDOCDT"'     IN lv_string WITH '"TransdocDt"'.
    REPLACE ALL OCCURRENCES OF '"VEHNO"'          IN lv_string WITH '"Vehno"'.
    REPLACE ALL OCCURRENCES OF '"VEHTYPE"'        IN lv_string WITH '"Vehtype"'.
    REPLACE ALL OCCURRENCES OF '"SHIPFROM_ADDR1"' IN lv_string WITH '"ShipFrom_Addr1"'.
    REPLACE ALL OCCURRENCES OF '"SHIPFROM_ADDR2"' IN lv_string WITH '"ShipFrom_Addr2"'.
    REPLACE ALL OCCURRENCES OF '"SHIPFROM_LOC"'   IN lv_string WITH '"ShipFrom_Loc"'.
    REPLACE ALL OCCURRENCES OF '"SHIPFROM_PIN"'   IN lv_string WITH '"ShipFrom_Pin"'.
    REPLACE ALL OCCURRENCES OF '"SHIPFROM_STCD"'  IN lv_string WITH '"ShipFrom_Stcd"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTO_ADDR1"'   IN lv_string WITH '"ShipTo_Addr1"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTO_GSTIN"'   IN lv_string WITH '"ShipTo_Gstin"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTO_TRDNM"'   IN lv_string WITH '"ShipTo_Trdnm"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTO_ADDR2"'   IN lv_string WITH '"ShipTo_Addr2"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTO_LOC"'     IN lv_string WITH '"ShipTo_Loc"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTO_PIN"'     IN lv_string WITH '"ShipTo_Pin"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTO_STCD"'    IN lv_string WITH '"ShipTo_Stcd"'.
    REPLACE ALL OCCURRENCES OF '"GSTIN"'          IN lv_string WITH '"GSTIN"'.
    REPLACE ALL OCCURRENCES OF '"CDKEY"'          IN lv_string WITH '"CDKey"'.
    REPLACE ALL OCCURRENCES OF '"EWBUSERNAME"'    IN lv_string WITH '"EWbUserName"'.
    REPLACE ALL OCCURRENCES OF '"EWBPASSWORD"'    IN lv_string WITH '"EWbPassword"'.
    REPLACE ALL OCCURRENCES OF '"EFUSERNAME"'     IN lv_string WITH '"EFUserName"'.
    REPLACE ALL OCCURRENCES OF '"EFPASSWORD"'     IN lv_string WITH '"EFPassword"'.


    result = lv_string .


  ENDMETHOD.


  METHOD split_addr_line.
    DATA: lt_words    TYPE STANDARD TABLE OF string WITH EMPTY KEY,
          lv_word     TYPE string,
          part2_start TYPE abap_boolean.


    SPLIT addr_line AT space INTO TABLE lt_words.
    DATA(counter) = 1.
    part2_start = abap_false.
    LOOP AT lt_words INTO lv_word.

      IF ( part2_start = 'X' ) OR ( strlen( part1 ) >= 90 ) OR ( strlen( lv_word ) + strlen( part1 ) > 98 )  OR ( lines( lt_words ) - 2 < counter AND lines( lt_words ) > 2 ).
        CONCATENATE part2 lv_word INTO part2 SEPARATED BY space.
        part2_start = abap_true.
      ELSE.
        CONCATENATE part1 lv_word INTO part1 SEPARATED BY space.
      ENDIF.

      counter += 1.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
