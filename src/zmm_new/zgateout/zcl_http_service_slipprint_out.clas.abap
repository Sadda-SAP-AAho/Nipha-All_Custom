class ZCL_HTTP_SERVICE_SLIPPRINT_OUT definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_SERVICE_SLIPPRINT_OUT IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

  DATA(req) = request->get_method(  ).

  CASE req.

  WHEN Conv string( if_web_http_client=>post ).

    data(result) =  xml_class=>xml_function( response = response request = request ).

  WHEN OTHERS.
  response->set_status( i_code = 403 i_reason = 'Method not allowed' ).

  ENDCASE.

  endmethod.
ENDCLASS.
