CLASS ZCL_HTTP_EXPORT_TAX_INV DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_EXPORT_TAX_INV IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    CASE request->get_method( ).
      WHEN CONV string( if_web_http_client=>post ).
        DATA(result) = taxinvoiceclass=>taxinvoice( request =  request  response =  response ).
        response->set_text( result ) .
      WHEN OTHERS.
        response->set_status( i_code = 405 i_reason = 'METHOD NOT ALLOWED' ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
