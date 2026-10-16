CLASS lcl_cnlewb DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    CLASS-METHODS validatedocument
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
        VALUE(ro_instance) TYPE REF TO lcl_cnlewb.

    CLASS-METHODS generatejson
      EXPORTING
        error         TYPE string
      RETURNING
        VALUE(result) TYPE string.

PRIVATE SECTION.

    METHODS constructor
      IMPORTING
        !iv_body TYPE ty_request.
    CLASS-DATA: mv_companycode TYPE bukrs,
                mv_document    TYPE vbeln,
                lcl_class      TYPE REF TO lcl_cnlewb.


ENDCLASS.

CLASS lcl_cnlewb IMPLEMENTATION.

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


  ENDMETHOD.

  METHOD validatedocument.
    rv_is_valid = abap_true.
    SELECT SINGLE FROM zr_irn
       FIELDS ewaybillno, ewaycanceldate
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
    ELSEIF lv_irnstatus-ewaybillno IS  INITIAL.
      rv_message = 'EWB not generated for this document'.
      rv_is_valid = abap_false.
      RETURN.
    ELSEIF lv_irnstatus-ewaycanceldate IS NOT INITIAL.
      rv_message = 'EWB already cancelled for this document'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD generatejson.
    DATA : wa_json TYPE ty_item_list.

    SELECT SINGLE FROM zr_irn
     FIELDS ewaybillno
     WHERE billingdocument = @mv_document AND companycode = @mv_companycode
     INTO @DATA(lv_table_data).


    wa_json-ewbno = lv_table_data.
    wa_json-cancelrmrk =  'Cancelled'.
    wa_json-cancelrsncode = 1.


    TYPES: ty_t_push_data TYPE STANDARD TABLE OF ty_push_data WITH EMPTY KEY.

    TYPES: BEGIN OF ty_eway_cancel_request,
             push_data_list TYPE ty_t_push_data,
             year           TYPE i,
             month          TYPE i,
             efusername     TYPE string,
             efpassword     TYPE string,
             cdkey          TYPE string,
           END OF ty_eway_cancel_request.



    DATA: ls_push_data TYPE ty_push_data,
          lt_push_data TYPE STANDARD TABLE OF ty_push_data,
          ls_request   TYPE ty_eway_cancel_request.

    SELECT SINGLE ewaybillno
    FROM zr_irn
    WHERE billingdocument = @mv_document
    AND companycode = @mv_companycode
    INTO @DATA(lv_ewaybill).



    SELECT SINGLE FROM i_billingdocumentitem AS a
    INNER JOIN ztable_plant AS b ON b~plant_code = a~plant
    FIELDS b~ewbpassword ,  b~ewbusername , b~gstin_no
    WHERE a~billingdocument = @mv_document
    AND a~companycode = @mv_companycode
    INTO @DATA(wa_username).

    SELECT SINGLE FROM zr_integration_tab000
    FIELDS intgpath
    WHERE intgmodule = 'EWB-EFUNAME-EFPASS-CDKEY'
    INTO @DATA(wa_cdkey).

    SPLIT wa_cdkey AT '/' INTO ls_request-efusername ls_request-efpassword ls_request-cdkey.

    ls_push_data-gstin            = wa_username-gstin_no.
    ls_push_data-ewbnumber        = lv_ewaybill.
    ls_push_data-cancelreasoncode = '2'.
    ls_push_data-cancelremark     = 'Cancelled'.
    ls_push_data-ewbusername      = wa_username-ewbusername.
    ls_push_data-ewbpassword      = wa_username-ewbusername.

    DATA(sys_date) = cl_abap_context_info=>get_system_date(  ).

    APPEND ls_push_data TO lt_push_data.

    ls_request-push_data_list = lt_push_data.
    ls_request-year           = sys_date+0(4).
    ls_request-month          = sys_date+4(2).

    DATA:json TYPE REF TO if_xco_cp_json_data.
    xco_cp_json=>data->from_abap(
      EXPORTING
        ia_abap      = ls_request
      RECEIVING
        ro_json_data = json   ).
    json->to_string(
      RECEIVING
        rv_string =   DATA(lv_string) ).

    REPLACE ALL OCCURRENCES OF '"PUSH_DATA_LIST"' IN lv_string WITH '"Push_Data_List"'.
    REPLACE ALL OCCURRENCES OF 'GSTIN'            IN lv_string WITH 'GSTIN'.
    REPLACE ALL OCCURRENCES OF 'EWBNUMBER'        IN lv_string WITH 'EWBNumber'.
    REPLACE ALL OCCURRENCES OF 'CANCELREASONCODE' IN lv_string WITH 'CancelReasonCode'.
    REPLACE ALL OCCURRENCES OF 'CANCELREMARK'     IN lv_string WITH 'CancelRemark'.
    REPLACE ALL OCCURRENCES OF 'EWBUSERNAME'      IN lv_string WITH 'EWBUserName'.
    REPLACE ALL OCCURRENCES OF 'EWBPASSWORD'      IN lv_string WITH 'EWBPassword'.
    REPLACE ALL OCCURRENCES OF 'PUSH_DATA_LIST'   IN lv_string WITH 'Push_Data_List'.
    REPLACE ALL OCCURRENCES OF 'YEAR'             IN lv_string WITH 'Year'.
    REPLACE ALL OCCURRENCES OF 'MONTH'            IN lv_string WITH 'Month'.
    REPLACE ALL OCCURRENCES OF 'EFUSERNAME'       IN lv_string WITH 'EFUserName'.
    REPLACE ALL OCCURRENCES OF 'EFPASSWORD'       IN lv_string WITH 'EFPassword'.
    REPLACE ALL OCCURRENCES OF 'CDKEY'            IN lv_string WITH 'CDKey'.

    result = lv_string.
  ENDMETHOD.

ENDCLASS.
