class ZCL_INVC_SERVICE definition
  public
  create public .

public section.
*
*  DATA invoice1 TYPE string .
*  DATA year TYPE string .
*  DATA invoice TYPE string .


  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_INVC_SERVICE IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
*
*   DATA(req) = request->get_form_fields(  ).
*    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
*    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).
*
*      invoice1          = VALUE #( req[ name = 'invoice' ]-value OPTIONAL ) .
*        year            = VALUE #( req[ name = 'year' ]-value OPTIONAL ) .
*
*       DATA(invtype) =  VALUE #( req[ name = 'invoicetype' ]-value OPTIONAL ) .
*
*     IF invtype = 'Sales Invoice'.
*        invoice = invoice1 .
*   SELECT SINGLE * FROM i_billingdocumentbasic WHERE billingdocument = @invoice1  INTO @DATA(invdata)  .
*     IF invdata-billingdocument IS NOT INITIAL      .
*          DATA(pdf2) = z_invoice=>read_posts( variable = invoice ) .
*      ENDIF.
*      ENDIF.
*
*
*
  ENDMETHOD.
ENDCLASS.
