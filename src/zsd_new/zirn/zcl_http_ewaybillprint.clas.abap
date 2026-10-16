CLASS zcl_http_ewaybillprint DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.
    METHODS handle_ewb_print_request
      IMPORTING
        VALUE(request) TYPE REF TO if_web_http_request
        response       TYPE REF TO if_web_http_response.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_EWAYBILLPRINT IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    "  DATA: lv_ewb TYPE string.

    CASE request->get_method( ).

      WHEN CONV string( if_web_http_client=>post ).
        handle_ewb_print_request( request = request response = response ).
      WHEN OTHERS.
        response->set_status( i_code = 405 i_reason = 'METHOD NOT ALLOWED' ).

    ENDCASE.
  ENDMETHOD.


  METHOD handle_ewb_print_request.
    DATA : wa_data  TYPE ty_ewb_request.
    DATA: ls_wrapper TYPE ty_wrapper,
          ewb_url    TYPE string,
          lv_client2 TYPE REF TO if_web_http_client.

    DATA request_data TYPE ty_request.
    xco_cp_json=>data->from_string( request->get_text(  ) )->write_to( REF #( request_data ) ).
    request_data-billingdocument = |{ request_data-billingdocument ALPHA = IN }|.
    """"""""EWAYBILL
    SELECT  SINGLE
     FROM ztable_irn
     FIELDS
     ewaybillno , ewaycanceldate
     WHERE  billingdocument  = @request_data-billingdocument
     AND companycode = @request_data-companycode
     INTO   @DATA(wa_ewb).

    IF wa_ewb-ewaybillno IS INITIAL.
      response->set_text( 'EWB Number required' ).
      RETURN.
    ELSEIF  wa_ewb-ewaycanceldate IS NOT INITIAL.
      response->set_text( 'EWB already cancelled for this document' ).

    ENDIF.

    """""""""""""""""GSTIN DETAILS
    SELECT SINGLE
    FROM ztable_plant  AS a
    INNER JOIN i_billingdocumentitem AS b ON a~plant_code = b~plant  AND a~comp_code = b~companycode
    FIELDS
    gstin_no,
    gsppassword,
    gspusername
     WHERE b~billingdocument = @request_data-billingdocument
     INTO   @DATA(lt_gstdetails).


    IF lt_gstdetails-gstin_no IS INITIAL.
      response->set_text( 'GSTIN not maintained for the plant' ).
    ENDIF.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    SELECT SINGLE FROM zr_integration_tab000
     FIELDS intgpath
     WHERE intgmodule = 'EWB-EFUNAME-EFPASS-CDKEY'
     INTO @DATA(efusercreds).

    SPLIT efusercreds AT '/' INTO ls_wrapper-efusername ls_wrapper-efpassword ls_wrapper-cdkey.
    wa_data-gstin  =  lt_gstdetails-gstin_no.
    wa_data-ewbusername  = lt_gstdetails-gspusername.
    wa_data-ewbpassword  = lt_gstdetails-gsppassword.
    wa_data-efusername  = ls_wrapper-efusername.
    wa_data-efpassword  = ls_wrapper-efpassword.
    wa_data-cdkey  = ls_wrapper-cdkey.
    wa_data-ewbno  = wa_ewb-ewaybillno.
    wa_data-year  = sy-datum+0(4).
    wa_data-month = sy-datum+4(2).
    DATA result TYPE string.
    DATA:json TYPE REF TO if_xco_cp_json_data.

    xco_cp_json=>data->from_abap(
      EXPORTING
        ia_abap      = wa_data
      RECEIVING
        ro_json_data = json   ).
    json->to_string(
      RECEIVING
        rv_string =   DATA(lv_string) ).

    REPLACE ALL OCCURRENCES OF '"GSTIN"' IN lv_string WITH '"GSTIN"'.
    REPLACE ALL OCCURRENCES OF '"EWBUSERNAME"' IN lv_string WITH '"EWbUserName"'.
    REPLACE ALL OCCURRENCES OF '"EWBPASSWORD"' IN lv_string WITH '"EWbPassword"'.
    REPLACE ALL OCCURRENCES OF '"EFUSERNAME"' IN lv_string WITH '"EFUserName"'.
    REPLACE ALL OCCURRENCES OF '"EFPASSWORD"' IN lv_string WITH '"EFPassword"'.
    REPLACE ALL OCCURRENCES OF '"CDKEY"' IN lv_string WITH '"CDKey"'.
    REPLACE ALL OCCURRENCES OF '"EWBNO"' IN lv_string WITH '"ewbNo"'.
    REPLACE ALL OCCURRENCES OF '"YEAR"' IN lv_string WITH '"Year"'.
    REPLACE ALL OCCURRENCES OF '"MONTH"' IN lv_string WITH '"Month"'.


    result = lv_string.

    TRY.

        SELECT SINGLE intgpath

            FROM zc_integration_tab000
            WHERE intgmodule = 'EWB-PRINT'
             INTO @ewb_url.


        TRY.
            DATA(dest2) = cl_http_destination_provider=>create_by_url( ewb_url ).
            lv_client2 = cl_web_http_client_manager=>create_by_http_destination( dest2 ).

          CATCH cx_static_check INTO DATA(lv_cx_static_check2).
            response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
            response->set_text( |Destination creation failed: { lv_cx_static_check2->get_longtext( ) }| ).
            RETURN.
        ENDTRY.


        DATA(req4) = lv_client2->get_http_request( ).

        req4->append_text( EXPORTING data = result ).
        req4->set_content_type( 'application/json' ).
        " DATA url_response2 TYPE string.

        TRY.
            DATA(lv_response) = lv_client2->execute( if_web_http_client=>post ).
            DATA(url_response2) = lv_response->get_text( ).
            response->set_content_type( 'application/json' ).  " or text/plain
            response->set_text( url_response2 ).
            RETURN.
          CATCH cx_web_http_client_error INTO DATA(lv_error_response2).
            response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
            response->set_text( |API request failed: { lv_error_response2->get_longtext( ) }| ).
        ENDTRY.
      CATCH cx_root INTO DATA(lv_general_error).
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( |Processing failed: { lv_general_error->get_longtext( ) }| ).

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
