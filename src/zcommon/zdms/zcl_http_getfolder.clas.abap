class ZCL_HTTP_GETFOLDER definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
  METHODS: getFolders
    IMPORTING
      VALUE(request) TYPE REF TO if_web_http_request
      response       TYPE REF TO if_web_http_response.
protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_GETFOLDER IMPLEMENTATION.


   METHOD if_http_service_extension~handle_request.
     CASE request->get_method( ).
       WHEN CONV string( if_web_http_client=>get ).
         getFolders( request = request response = response ).
       WHEN OTHERS.
         response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
         response->set_text( 'Only POST method is supported' ).
     ENDCASE.
   ENDMETHOD.


   METHOD getfolders.
     TRY.
         DATA(curr_path) = COND #( WHEN request->get_header_field( i_name = 'CurrentPath' ) IS NOT INITIAL
                                   THEN request->get_header_field( i_name = 'CurrentPath' )
                                   ELSE '' ).

         SELECT SINGLE FROM zr_integration_tab000
         FIELDS intgpath
         WHERE intgmodule = @getfolderurl
         INTO @DATA(lv_intgmodule).

         SELECT SINGLE FROM zr_integration_tab000
         FIELDS intgpath
         WHERE intgmodule = @container
         INTO @DATA(lv_container).



         DATA(lv_url) = |{ lv_intgmodule }?container={ cl_web_http_utility=>escape_url( CONV string( lv_container ) ) }&currentPath={ cl_web_http_utility=>escape_url( curr_path ) }|.

         DATA(dest) = cl_http_destination_provider=>create_by_url( lv_url ).
         DATA(lv_client) = cl_web_http_client_manager=>create_by_http_destination( dest ).

         SELECT SINGLE FROM zr_integration_tab000
            FIELDS intgpath
            WHERE intgmodule = @headervalue
            INTO @DATA(lv_headervalue).

         lv_client->get_http_request(  )->set_header_field(
                i_name  = headername
                i_value = CONV string( lv_headervalue )
              ).

         DATA(lv_response) = lv_client->execute( if_web_http_client=>get ).

         IF lv_response->get_status( )-code = 200.
           response->set_status( i_code = 200 i_reason = 'Ok' ).
           response->set_text( lv_response->get_text(  ) ).
         ELSE.
           response->set_status( i_code = lv_response->get_status( )-code
                                 i_reason = lv_response->get_status( )-reason ).
           response->set_text( |External API failed: { lv_response->get_text( ) }| ).
         ENDIF.

       CATCH cx_root INTO DATA(lx_error).
         response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
         response->set_text( lx_error->get_longtext( ) ).
     ENDTRY.
   ENDMETHOD.
ENDCLASS.
