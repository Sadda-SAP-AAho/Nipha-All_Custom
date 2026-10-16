CLASS zcl_http_so_print DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_SO_PRINT IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA lv_method TYPE string.

    lv_method = request->get_method( ).

    CASE lv_method.

      WHEN CONV string( if_web_http_client=>get ).
        DATA(result) = salesorderdriver=>salesorder(
                          request  = request
                          response = response ).

        response->set_text( result ).

      WHEN OTHERS.

        response->set_status(
          i_code   = 405
          i_reason = 'METHOD NOT ALLOWED'
        ).

    ENDCASE.
  ENDMETHOD.
ENDCLASS.
