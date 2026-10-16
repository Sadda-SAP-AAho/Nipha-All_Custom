CLASS zcl_http__generateewb DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .

    METHODS handle_ewb_gen_request
      IMPORTING
        VALUE(request) TYPE REF TO if_web_http_request
        response       TYPE REF TO if_web_http_response.

    METHODS handle_ewb_json_request
      IMPORTING
        VALUE(request) TYPE REF TO if_web_http_request
        response       TYPE REF TO if_web_http_response.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP__GENERATEEWB IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    CASE request->get_method( ).
      WHEN CONV string( if_web_http_client=>post ).
        handle_ewb_gen_request( request = request response = response ).
      WHEN CONV string( if_web_http_client=>put ).
        handle_ewb_json_request( request = request response = response ).
      WHEN OTHERS.
        response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
        response->set_text( 'Only POST method is supported' ).
    ENDCASE.
  ENDMETHOD.


  METHOD handle_ewb_json_request.

***********************         PARSING REQUEST DATA        ******************************
    DATA request_data TYPE ty_request.
    xco_cp_json=>data->from_string( request->get_text(  ) )->write_to( REF #( request_data ) ).
    request_data-billingdocument = |{ request_data-billingdocument ALPHA = IN }|.

    DATA(lcl_conn) = lcl_generateewb=>getinstance( request_data ).

    lcl_conn->validatedocument(
      IMPORTING
        rv_is_valid        = DATA(lv_is_valid)
        rv_message         = DATA(lv_error_message)
    ).

    IF lv_is_valid = abap_false.
      response->set_status( i_code = 400 i_reason = 'Bad Request' ).
      response->set_text( lv_error_message ).
      RETURN.
    ENDIF.


***********************        Validating JSON Pay-load        *****************************
    lcl_conn->generatejson(
               IMPORTING
                 error = lv_error_message
               RECEIVING
                  result = DATA(get_payload)
           ).

    IF lv_error_message IS NOT INITIAL.
      response->set_status( i_code = 400 i_reason = 'Bad Request' ).
      response->set_text( lv_error_message ).
      RETURN.
    ENDIF.

    response->set_status( i_code = 200 i_reason = 'OK' ).
    response->set_text( get_payload ).

  ENDMETHOD.


  METHOD handle_ewb_gen_request.


***********************         PARSING REQUEST DATA        ******************************
    DATA request_data TYPE ty_request.
    xco_cp_json=>data->from_string( request->get_text(  ) )->write_to( REF #( request_data ) ).
    request_data-billingdocument = |{ request_data-billingdocument ALPHA = IN }|.

    DATA(lcl_conn) = lcl_generateewb=>getinstance( request_data ).

    lcl_conn->validatedocument(
      EXPORTING
        checkdetails = 'X'
      IMPORTING
        rv_is_valid        = DATA(lv_is_valid)
        rv_message         = DATA(lv_error_message)
    ).

    IF lv_is_valid = abap_false.
      response->set_status( i_code = 400 i_reason = 'Bad Request' ).
      response->set_text( lv_error_message ).
      RETURN.
    ENDIF.




*************************       CHECKING CONFIGs               ***********************************************
*    lcl_conn->checkconfigs(
*         IMPORTING
*           rv_is_valid        = lv_is_valid
*           rv_message         = lv_error_message
*
*       ).
*
*    IF lv_is_valid = abap_true.
*      response->set_status( i_code = 400 i_reason = 'Bad Request' ).
*      response->set_text( lv_error_message ).
*      RETURN.
*    ENDIF.



***********************        Validating JSON Pay-load        *****************************
    lcl_conn->generatejson(
               IMPORTING
                 error = lv_error_message
               RECEIVING
                  result = DATA(get_payload)
           ).

    IF lv_error_message IS NOT INITIAL.
      response->set_status( i_code = 400 i_reason = 'Bad Request' ).
      response->set_text( lv_error_message ).
      RETURN.
    ENDIF.


***********************    Preparing to Initialize External Service       ******************
    DATA: lv_client TYPE REF TO if_web_http_client,
          req       TYPE REF TO if_web_http_client,
          req_path  TYPE string.

    SELECT SINGLE FROM zr_integration_tab000
        FIELDS intgpath
        WHERE intgmodule = @req_module
        INTO @req_path.

    IF req_path IS INITIAL.
      response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
      response->set_text( |Integration path not found for module { req_module }| ).
      RETURN.
    ENDIF.

    TRY.
        DATA(dest) = cl_http_destination_provider=>create_by_url( req_path ).
        lv_client = cl_web_http_client_manager=>create_by_http_destination( dest ).

      CATCH cx_static_check INTO DATA(lv_cx_static_check2).
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( |Destination creation failed: { lv_cx_static_check2->get_longtext( ) }| ).
        RETURN.
    ENDTRY.

    TRY.

        DATA(req4) = lv_client->get_http_request( ).

        req4->append_text( data = get_payload ).
        req4->set_content_type( 'application/json' ).
        DATA url_response2 TYPE string.

        TRY.
***********************   Calling the API       ******************
            DATA(lv_response) = lv_client->execute( if_web_http_client=>post ).

            url_response2 = lv_response->get_text( ).
            REPLACE ALL OCCURRENCES OF '\' IN url_response2 WITH ''.
            url_response2 = substring( val = url_response2 len = strlen( url_response2 ) - 1 ).
            url_response2 = url_response2+1.
            DATA(lv_status_code) = lv_response->get_status( )-code.
            IF lv_status_code <> 200.
              response->set_status( i_code = lv_status_code i_reason = lv_response->get_status( )-reason ).
              response->set_text( |API request failed with status { lv_status_code }: { lv_response->get_status( )-reason }| ).
              RETURN.
            ENDIF.


***********************    Handling Response       ******************
            DATA primeres TYPE STANDARD TABLE OF mainres.
            xco_cp_json=>data->from_string( url_response2  )->write_to( REF #( primeres ) ).

            LOOP AT primeres INTO DATA(item_res).

              "Success Response
              IF item_res-ewaybill IS NOT INITIAL AND item_res-ewaybill NE '0' .

                MODIFY ENTITIES OF zr_irn
                     ENTITY zrirn
                     UPDATE FIELDS ( ewaybillno ewayvaliddate ewaydate ewaycreatedby ewaystatus ewaycanceldate )
                     WITH VALUE #( (
                                       ewaybillno     = item_res-ewaybill
                                       ewayvaliddate  = item_res-validupto
                                       ewaydate       = item_res-date
                                       ewaycreatedby  = sy-uname
                                       ewaystatus     = 'GEN'
                                       ewaycanceldate = VALUE d(  )
                                       billingdocument = request_data-billingdocument
                                   ) )
                     FAILED DATA(lt_failed)
                     REPORTED DATA(lt_reported).
                COMMIT ENTITIES BEGIN
                   RESPONSE OF zr_irn
                   FAILED DATA(lt_commit_failed2)
                   REPORTED DATA(lt_commit_reported2).
                ...
                COMMIT ENTITIES END.

                response->set_text( | Eway Bill Generated Successfully { item_res-ewaybill } for Document - { request_data-billingdocument }  | ).
                RETURN.

              ENDIF.

              "Error Response
              response->set_text( | { item_res-errormessage } for Document - { request_data-billingdocument }  | ).
              RETURN.

            ENDLOOP.

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
