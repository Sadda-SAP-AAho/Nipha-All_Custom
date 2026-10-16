CLASS zcl_http_rgp_print  DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: get_html RETURNING VALUE(html) TYPE string.
    METHODS: post_html
      IMPORTING
                lv_billingdocno TYPE string
                lv_print_type   TYPE string
      RETURNING VALUE(html)     TYPE string.

    CLASS-DATA url TYPE string.
ENDCLASS.



CLASS ZCL_HTTP_RGP_PRINT IMPLEMENTATION.


  METHOD get_html.    "Response HTML for GET request

    html = |<html> \n| &&
   |<body> \n| &&
   |<title>RGP Print</title> \n| &&
   |<form action="{ url }" method="POST">\n| &&
   |<H2>RGP Print</H2> \n| &&
   |<label for="fname">Billing Doc no : </label> \n| &&
   |<input type="text" id="lv_billingdocno" name="lv_billingdocno" required ><br><br> \n| &&
   |<label for="fname">Print Type : </label> \n| &&
   |<input type="text" id="lv_print_type" name="lv_print_type" required ><br><br> \n| &&
   |<input type="submit" value="Submit"> \n| &&
   |</form>| &&
   |</body> \n| &&
   |</html> | .

  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.
    DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).
    DATA(cookies)  = request->get_cookies(  ) .

    DATA req_host TYPE string.
    DATA req_proto TYPE string.
    DATA req_uri TYPE string.

    req_host = request->get_header_field( i_name = 'Host' ).
    req_proto = request->get_header_field( i_name = 'X-Forwarded-Proto' ).
    IF req_proto IS INITIAL.
      req_proto = 'https'.
    ENDIF.
*     req_uri = request->get_request_uri( ).
    DATA(symandt) = sy-mandt.
    req_uri = '/sap/bc/http/sap/ZHTTP_RGP_PRINT?sap-client=080'.
    url = |{ req_proto }://{ req_host }{ req_uri }client={ symandt }|.


    CASE request->get_method( ).

      WHEN CONV string( if_web_http_client=>get ).

        response->set_text( get_html( ) ).

      WHEN CONV string( if_web_http_client=>post ).

        DATA(bill_doc_no) = request->get_form_field( `lv_billingdocno` ).
        DATA(print_type) = request->get_form_field( `lv_print_type` ).

        DATA(bill_num)  = |{ bill_doc_no WIDTH  = 10 PAD =  '0'  ALIGN  = RIGHT }|.

        response->set_header_field( i_name = 'Content-Type' i_value = 'text/html' ).

        IF bill_doc_no IS NOT INITIAL.

          IF print_type   = 'NRGP' .
            SELECT SINGLE FROM   zgate_nrgp_hdr  WITH PRIVILEGED ACCESS AS a
            FIELDS document_no WHERE a~document_no = @bill_num
            INTO @DATA(lv_ac).

            IF  lv_ac  IS  INITIAL.
              response->set_status( i_code = '404' i_reason = 'Not Found' ).
              response->set_text( 'Document number does not exist in NRGP' ).
              RETURN.
            ENDIF.

            TRY.
                DATA(pdf) = zcl_nrgp_driver_class=>read_posts( lv_po2 = bill_num ).
                DATA(html) = |{ pdf }|.
                response->set_text( html ).
              CATCH cx_static_check INTO DATA(err).
                response->set_text( err->get_longtext(  ) ).
            ENDTRY.


          ELSEIF  print_type   = 'RGP' .

            SELECT SINGLE FROM   zgate_rgp_hdr  WITH PRIVILEGED ACCESS AS a
            FIELDS document_no WHERE a~document_no = @bill_num
            INTO @DATA(lv_ac2).

            IF  lv_ac2  IS  INITIAL.
              response->set_status( i_code = '404' i_reason = 'Not Found' ).
              response->set_text( 'Document number does not exist in RGP' ).
              RETURN.
            ENDIF.

            TRY.
                DATA(pdf1) = zcl_rgp_driver_class=>read_posts( lv_po2 = bill_num ).
                DATA(html1) = |{ pdf1 }|.
                response->set_text( html1 ).
              CATCH cx_static_check INTO DATA(err1).
                response->set_text( err1->get_longtext(  ) ).
            ENDTRY.

          ENDIF.
        ELSE.
          response->set_text( 'Document number does not exist.' ).
        ENDIF.


*        IF bill_doc_no IS NOT INITIAL.
*
*
*
*
*          TRY.
*              DATA(pdf) = zcl_nrgp_driver_class=>read_posts( lv_po2 = bill_num ).
*
*              DATA(html) = |{ pdf }|.
*
*
*              response->set_text( html ).
*            CATCH cx_static_check INTO DATA(err).
*              response->set_text( err->get_longtext(  ) ).
*          ENDTRY.
*        ELSE.
*          response->set_text( 'Document number does not exist.' ).
*        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD post_html.

    html = |<html> \n| &&
   |<body> \n| &&
   |<title>Purchase Order Print</title> \n| &&
   |<form action="{ url }" method="Get">\n| &&
   |<H2>Purchase Order Print Success </H2> \n| &&
   |<input type="submit" value="Go Back"> \n| &&
   |</form> | &&
   |</body> \n| &&
   |</html> | .
  ENDMETHOD.
ENDCLASS.
