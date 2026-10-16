class ZCL_MM_PRICE_COMPARISION definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MM_PRICE_COMPARISION IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

  DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

    DATA(pricedocument) = VALUE #( req[ name = 'pricedocument' ]-value OPTIONAL ) .


    DATA(pdf2) = zcomparison_price=>read_posts( pricedocument = pricedocument  ) .


     response->set_text( pdf2  ).


  endmethod.
ENDCLASS.
