class ZCL_BRS_SERV definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_BRS_SERV IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
  DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

  DATA(HOUSEID) = req[ 2 ]-value.
  DATA(BANKID) = req[ 3 ]-value.
  DATA(STATEMENT_DT) = req[ 4 ]-value. "Statement_Date
*  DATA(STATEMENT_DT) = VALUE #( req[ name = 'Statement_Date' ]-value OPTIONAL ) .

  DATA(pdf2) = zcl_brs=>read_posts( bankid = bankid houseid = houseid   STATEMENT_DT = STATEMENT_DT ).

   response->set_text( pdf2  ).

  endmethod.
ENDCLASS.
