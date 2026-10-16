class ZCL_PR_PRINT_SERVICE definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PR_PRINT_SERVICE IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

    DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

    data(prdoc) = value #( req[ name = 'prdoc' ]-value optional ) .



  DATA(pdf2) = zpr_print=>read_posts( prdoc = prdoc ) .


  response->set_text( pdf2 ).


  endmethod.
ENDCLASS.
