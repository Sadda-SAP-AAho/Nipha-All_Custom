CLASS zcl_http_material_issue_print DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS get_html
      RETURNING VALUE(html) TYPE string.

    METHODS post_html
      IMPORTING
        lv_materialdocument TYPE string
      RETURNING VALUE(html) TYPE string.

    CLASS-DATA url TYPE string.

ENDCLASS.



CLASS ZCL_HTTP_MATERIAL_ISSUE_PRINT IMPLEMENTATION.


  METHOD get_html.

    html = |<html> \n| &&
           |<body> \n| &&
           |<title>Material Issue Print</title> \n| &&
           |<form action="/sap/bc/http/sap/ZHTTP_MATERIAL_ISSUE_PRINT?sap-client=080" method="POST">\n| &&
           |<H2>Material Issue Print</H2> \n| &&
           |<label for="materialdocument">Material Document</label> \n| &&
           |<input type="text" id="lv_materialdocument" name="lv_materialdocument" required><br><br> \n| &&
           |<input type="submit" value="Submit"> \n| &&
           |</form> \n| &&
           |</body> \n| &&
           |</html>|.

  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

    DATA req_host TYPE string.
    DATA req_proto TYPE string.
    DATA req_uri TYPE string.
    DATA symandt TYPE string.
    DATA pdf TYPE string.
    DATA html TYPE string.
    DATA lv_materialdocument TYPE string.

    DATA lv_materialdocument_check
      LIKE lv_materialdocument.

    response->set_header_field(
      i_name  = 'Access-Control-Allow-Origin'
      i_value = '*'
    ).

    response->set_header_field(
      i_name  = 'Access-Control-Allow-Credentials'
      i_value = 'true'
    ).

    req_host = request->get_header_field(
      i_name = 'Host'
    ).

    req_proto = request->get_header_field(
      i_name = 'X-Forwarded-Proto'
    ).

    IF req_proto IS INITIAL.
      req_proto = 'https'.
    ENDIF.

    symandt = sy-mandt.

    req_uri =
      '/sap/bc/http/sap/ZHTTP_MATERIAL_ISSUE_PRINT?sap-client=080'.

    url = |{ req_proto }://{ req_host }{ req_uri }|.

    CASE request->get_method( ).

      WHEN CONV string( if_web_http_client=>get ).

        response->set_header_field(
          i_name  = 'Content-Type'
          i_value = 'text/html'
        ).

        response->set_text(
          get_html( )
        ).

      WHEN CONV string( if_web_http_client=>post ).

        lv_materialdocument =
          request->get_form_field(
            `lv_materialdocument`
          ).

        SELECT SINGLE FROM I_MATERIALDOCUMENTITEM_2
          FIELDS MaterialDocument
          WHERE MaterialDocument = @lv_materialdocument
          INTO @lv_materialdocument_check.

        IF lv_materialdocument_check IS INITIAL.

          html =
            |Material Document { lv_materialdocument } not found|.

          response->set_header_field(
            i_name  = 'Content-Type'
            i_value = 'text/plain'
          ).

          response->set_text( html ).

          RETURN.

        ENDIF.

        TRY.

            pdf =
              zcl_material_issue_print=>read_posts(
                lv_materialdocument = lv_materialdocument
              ).

            response->set_header_field(
              i_name  = 'Content-Type'
              i_value = 'text/plain'
            ).

            response->set_text( pdf ).

          CATCH cx_static_check INTO DATA(er).

            html =
              |Material Document error: { er->get_longtext( ) }|.

            response->set_header_field(
              i_name  = 'Content-Type'
              i_value = 'text/plain'
            ).

            response->set_text( html ).

        ENDTRY.

    ENDCASE.

  ENDMETHOD.


  METHOD post_html.

    html = |<html> \n| &&
           |<body> \n| &&
           |<title>Material Issue Print</title> \n| &&
           |<form action="{ url }" method="GET">\n| &&
           |<H2>Material Issue Print</H2> \n| &&
           |<input type="submit" value="Go Back"> \n| &&
           |</form> \n| &&
           |</body> \n| &&
           |</html>|.

  ENDMETHOD.
ENDCLASS.
