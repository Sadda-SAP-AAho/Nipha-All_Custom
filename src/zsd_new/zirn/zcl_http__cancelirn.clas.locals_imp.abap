*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_cnlirn DEFINITION CREATE PRIVATE.

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
        VALUE(ro_instance) TYPE REF TO lcl_cnlirn.

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
                lcl_class      TYPE REF TO lcl_cnlirn.


ENDCLASS.

CLASS lcl_cnlirn IMPLEMENTATION.

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

*    SELECT SINGLE FROM zr_integration_tab000
*        FIELDS intgpath
*        WHERE intgmodule = @header_key
*        INTO @DATA(header_value).
*
*    IF header_value IS INITIAL.
*      rv_message = 'Header Value is not maintained for EWB Generation'.
*      rv_is_valid = abap_false.
*      RETURN.
*    ENDIF.

  ENDMETHOD.

  METHOD validatedocument.
    rv_is_valid = abap_true.
    SELECT SINGLE FROM zr_irn
       FIELDS irnno, irncanceldate
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
    ELSEIF lv_irnstatus-irnno IS  INITIAL.
      rv_message = 'IRN not generated for this document'.
      rv_is_valid = abap_false.
      RETURN.
    ELSEIF lv_irnstatus-irncanceldate IS NOT INITIAL.
      rv_message = 'IRN already cancelled for this document'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD generatejson.

    TYPES: BEGIN OF ty_json_root,
             push_data_list TYPE ty_push_data_list,
           END OF ty_json_root.

    DATA: ls_json_root TYPE ty_json_root,
          ls_data      TYPE ty_data.

    SELECT SINGLE FROM zr_irn
      FIELDS irnno
      WHERE billingdocument = @mv_document
      AND companycode = @mv_companycode
      INTO @DATA(lv_irn).


    SELECT SINGLE FROM i_billingdocumentitem AS a
    INNER JOIN ztable_plant AS b ON b~plant_code = a~plant
    FIELDS b~gspusername ,  b~gsppassword , b~gstin_no
    WHERE a~billingdocument = @mv_document
    AND a~companycode = @mv_companycode
    INTO @DATA(wa_username).


    SELECT SINGLE FROM zr_integration_tab000
    FIELDS intgpath
    WHERE intgmodule = 'IRN-EFUNAME-EFPASS-CDKEY'
    INTO @DATA(wa_cdkey).

    SPLIT wa_cdkey AT '/' INTO ls_data-efusername ls_data-efpassword ls_data-cdkey.


    ls_data-irn          = lv_irn.
    ls_data-gstin        = wa_username-gstin_no.
    ls_data-cnlrsn       = '1'.
    ls_data-cnlrem       = 'Wrong Entry'.
    ls_data-einvusername = wa_username-gspusername.
    ls_data-einvpassword = wa_username-gsppassword.

    APPEND ls_data TO ls_json_root-push_data_list-data.

    DATA: json TYPE REF TO if_xco_cp_json_data.

    xco_cp_json=>data->from_abap(
        EXPORTING
          ia_abap      = ls_json_root
        RECEIVING
          ro_json_data = json ).

    json->to_string(
        RECEIVING
          rv_string = DATA(lv_string) ).

    REPLACE ALL OCCURRENCES OF '"PUSH_DATA_LIST"' IN lv_string WITH '"Push_Data_List"'.
    REPLACE ALL OCCURRENCES OF '"DATA"'           IN lv_string WITH '"Data"'.
    REPLACE ALL OCCURRENCES OF '"IRN"'            IN lv_string WITH '"Irn"'.
    REPLACE ALL OCCURRENCES OF '"GSTIN"'          IN lv_string WITH '"GSTIN"'.
    REPLACE ALL OCCURRENCES OF '"CNLRSN"'         IN lv_string WITH '"CnlRsn"'.
    REPLACE ALL OCCURRENCES OF '"CNLREM"'         IN lv_string WITH '"CnlRem"'.
    REPLACE ALL OCCURRENCES OF '"CDKEY"'          IN lv_string WITH '"CDKey"'.
    REPLACE ALL OCCURRENCES OF '"EFUSERNAME"'     IN lv_string WITH '"EFUserName"'.
    REPLACE ALL OCCURRENCES OF '"EFPASSWORD"'     IN lv_string WITH '"EFPassword"'.
    REPLACE ALL OCCURRENCES OF '"EINVUSERNAME"'   IN lv_string WITH '"EInvUserName"'.
    REPLACE ALL OCCURRENCES OF '"EINVPASSWORD"'   IN lv_string WITH '"EInvPassword"'.

    result = lv_string.

  ENDMETHOD.

ENDCLASS.
