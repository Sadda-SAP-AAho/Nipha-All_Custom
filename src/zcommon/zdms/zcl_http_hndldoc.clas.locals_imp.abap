class handle_doc definition create private.

  public section.

  CLASS-METHODS parse_request
    importing
      !io_request type ref to if_web_http_request
    returning
       VALUE(req_data) TYPE ty_request.
  CLASS-METHODS parse_get_request
    importing
      !io_request type ref to if_web_http_request
    returning
       VALUE(req_data) TYPE ty_get_request.

  protected section.
  private section.

endclass.

class handle_doc implementation.

    METHOD parse_request.
      req_data-doctype = io_request->get_form_field( i_name = 'DocType' ).
      req_data-category = io_request->get_form_field( i_name = 'Category' ).
      req_data-description = io_request->get_form_field( i_name = 'Description' ).
      req_data-refobjecttype = io_request->get_form_field( i_name = 'RefObjectType' ).
      req_data-refobjectkey = io_request->get_form_field( i_name = 'RefObjectKey' ).
      req_data-doclink = io_request->get_form_field( i_name = 'DocLink' ).
      req_data-filename = io_request->get_form_field( i_name = 'FileName' ).
      req_data-filesize = io_request->get_form_field( i_name = 'FileSize' ).
      req_data-filetype = io_request->get_form_field( i_name = 'FileType' ).
      req_data-filecontent = cl_web_http_utility=>decode_x_base64( encoded = io_request->get_form_field( i_name = 'FileContent' ) ).
    ENDMETHOD.

     METHOD parse_get_request.
       req_data-docuuid = io_request->get_header_field( i_name = 'DocUUID' ).
       req_data-action = io_request->get_header_field( i_name = 'Action' ).
     ENDMETHOD.

endclass.
