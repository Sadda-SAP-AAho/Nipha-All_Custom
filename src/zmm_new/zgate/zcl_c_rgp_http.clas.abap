CLASS zcl_c_rgp_http DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
    INTERFACES if_oo_adt_classrun .

    TYPES: BEGIN OF resp_type,
             postnumber TYPE c LENGTH 10,
             docnumber  TYPE c LENGTH 30,
           END OF resp_type.

    TYPES: BEGIN OF ty_response,
             message TYPE string,
             count   TYPE i,
           END OF ty_response.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_C_RGP_HTTP IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    DELETE FROM zgate_rgp_hdr .
*    DELETE FROM zgate_rgp_item  .
  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

    DATA(req) = request->get_form_fields( ).
    DATA(lv_method) = request->get_header_field( '~request_method' ).
    DATA(shipped) =  VALUE #( req[ name = 'shipped' ]-value OPTIONAL ) .

    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).


    CASE lv_method.
      WHEN 'POST'.

        IF shipped IS NOT INITIAL AND shipped = 'true'.
          DATA ls_header1 TYPE zgate_rgp_hdr.
          DATA ls_item1   TYPE zgate_rgp_item.

          TYPES: BEGIN OF ty_wrapper1,
                   header TYPE zgate_rgp_hdr,
                   item   TYPE STANDARD TABLE OF zgate_rgp_item WITH DEFAULT KEY,
                 END OF ty_wrapper1.

          DATA(lv_json) =  request->get_text( ).

          DATA ls_wrapper1 TYPE ty_wrapper1.



          TRY.
              /ui2/cl_json=>deserialize(
                EXPORTING
                  json = lv_json
                CHANGING
                  data = ls_wrapper1
              ).

              ls_header1 = ls_wrapper1-header.

              DATA(postnum) = ls_header1-document_no.

            CATCH cx_sy_move_cast_error INTO DATA(lx_cast1).
              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
              response->set_text( 'Type mismatch in JSON: ' && lx_cast1->get_text( ) ).
              RETURN.
            CATCH cx_root INTO DATA(lx_root1).
              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
              response->set_text( 'JSON deserialize error: ' && lx_root1->get_text( ) ).
              RETURN.
          ENDTRY.

          DATA wa_rgp TYPE zgate_rgp_item.
          DATA it_final TYPE TABLE OF zgate_rgp_item.

          LOOP AT ls_wrapper1-item INTO ls_item1.

            wa_rgp-batch = |{ ls_item1-batch ALPHA = IN }|.
            wa_rgp-item_code = ls_item1-item_code.
            wa_rgp-qty = ls_item1-qty.
            wa_rgp-line_no = ls_item1-line_no.
            wa_rgp-document_no = ls_item1-document_no.
            wa_rgp-rgp_date = ls_item1-rgp_date.
            wa_rgp-rgp_no = ls_item1-rgp_no.
            wa_rgp-reference_document = ls_item1-reference_document.
            wa_rgp-reference_doc_date =  ls_item1-reference_doc_date.
            wa_rgp-reference_doc_item = ls_item1-reference_doc_item.
            wa_rgp-reference_doc_year = ls_item1-reference_doc_year.
            wa_rgp-weight = ls_item1-weight.
            wa_rgp-item_code = ls_item1-item_code.
            wa_rgp-item_name = ls_item1-item_name.
            wa_rgp-item_amount = ls_item1-item_amount.
            wa_rgp-description = ls_item1-description.
            wa_rgp-rate = ls_item1-rate.
            wa_rgp-tax_code = ls_item1-tax_code.
            wa_rgp-tax_percent = ls_item1-tax_percent.
            wa_rgp-tax_amount = ls_item1-tax_amount.
            wa_rgp-net_amount = ls_item1-net_amount.


            " Optional: generate line_no if missing

*            IF ls_item1-line_no IS INITIAL.
*              ls_item1-line_no = sy-tabix.
*            ENDIF.

            SELECT SINGLE FROM i_unitofmeasuretext AS a
            FIELDS a~unitofmeasure
            WHERE a~unitofmeasurecommercialname = @ls_item1-unit AND a~language = 'E'
            INTO @DATA(lv_unit) PRIVILEGED ACCESS.
            wa_rgp-unit = lv_unit.

            APPEND wa_rgp TO it_final.
            CLEAR : wa_rgp ,lv_unit.

          ENDLOOP.

          MODIFY ENTITIES OF i_materialdocumenttp
           ENTITY materialdocument
           CREATE FROM VALUE #( ( %cid = 'CID_001'
           goodsmovementcode = '04'
           postingdate = cl_abap_context_info=>get_system_date( )
           documentdate = cl_abap_context_info=>get_system_date( )
           %control-goodsmovementcode = cl_abap_behv=>flag_changed
           %control-postingdate = cl_abap_behv=>flag_changed
           %control-documentdate = cl_abap_behv=>flag_changed
           ) )
           ENTITY materialdocument
           CREATE BY \_materialdocumentitem
           FROM VALUE #( (
           %cid_ref = 'CID_001'
           %target = VALUE #(  FOR wa_final IN it_final INDEX INTO i ( %cid = |'CID_{ i }_001'|
           plant = ls_header1-plant
           material = wa_final-item_code
           goodsmovementtype = '311'
           storagelocation = ls_header1-from_storage_location
           issuingorreceivingstorageloc = ls_header1-to_storage_location
           quantityinentryunit = wa_final-qty
           batch = wa_final-batch
           issgorrcvgbatch = wa_final-batch
           entryunit = wa_final-unit
           %control-plant = cl_abap_behv=>flag_changed
           %control-material = cl_abap_behv=>flag_changed
           %control-goodsmovementtype = cl_abap_behv=>flag_changed
           %control-storagelocation = cl_abap_behv=>flag_changed
           %control-issuingorreceivingstorageloc = cl_abap_behv=>flag_changed
           %control-quantityinentryunit = cl_abap_behv=>flag_changed
           %control-batch = cl_abap_behv=>flag_changed
           %control-issgorrcvgbatch = cl_abap_behv=>flag_changed
           %control-entryunit = cl_abap_behv=>flag_changed  ) ) ) )
           MAPPED DATA(ls_create_mapped)
           FAILED DATA(ls_create_failed)
           REPORTED DATA(ls_create_reported).


          COMMIT ENTITIES BEGIN
          RESPONSE OF i_materialdocumenttp
          FAILED DATA(commit_failed)
          REPORTED DATA(commit_reported).

          COMMIT ENTITIES END.



          IF commit_failed IS INITIAL AND ls_create_failed IS INITIAL.
            DATA lv_docnumber TYPE string.

            lv_docnumber = commit_reported-materialdocumentitem[ 1 ]-materialdocument.

            TRY.
                /ui2/cl_json=>deserialize(
                  EXPORTING
                    json = lv_json
                  CHANGING
                    data = ls_wrapper1
                ).
              CATCH cx_sy_move_cast_error INTO DATA(lx_cast11).
                response->set_status( i_code = 400 i_reason = 'Bad Request' ).
                response->set_text( 'Type mismatch in JSON: ' && lx_cast11->get_text( ) ).
                RETURN.
              CATCH cx_root INTO DATA(lx_root22).
                response->set_status( i_code = 400 i_reason = 'Bad Request' ).
                response->set_text( 'JSON deserialize error: ' && lx_root22->get_text( ) ).
                RETURN.
            ENDTRY.

            IF ls_wrapper1-header-document_no IS INITIAL.
              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
              response->set_text( 'Header RGPNo is missing' ).
              RETURN.
            ENDIF.

            " Insert header
            ls_header1 = ls_wrapper1-header.
            ls_header1-reference_document = lv_docnumber.
            ls_header1-created_by = cl_abap_context_info=>get_user_technical_name( ).
*          ls_header1-created_at = cl_abap_context_info=>get_system_time( ).
            MODIFY zgate_rgp_hdr FROM @ls_header1.
            IF sy-subrc <> 0.
              response->set_status( i_code = 500 i_reason = 'Header insert failed' ).
              response->set_text( 'Failed to insert RGPNo: ' && ls_header1-document_no ).
              RETURN.
            ENDIF.

            LOOP AT ls_wrapper1-item INTO ls_item1.
              " Optional: generate line_no if missing
              IF ls_item1-line_no IS INITIAL.
                ls_item1-line_no = sy-tabix.
              ENDIF.

              ls_item1-reference_document = lv_docnumber.
              ls_item1-created_by = cl_abap_context_info=>get_user_technical_name( ).
*            ls_item1-created_at = cl_abap_context_info=>get_system_time( ).
              MODIFY zgate_rgp_item FROM @ls_item1.
              IF sy-subrc <> 0.
                response->set_status( i_code = 500 i_reason = 'Item insert failed' ).
                response->set_text( 'Failed to insert item line: ' && ls_item1-line_no ).
                RETURN.
              ENDIF.

            ENDLOOP.


            response->set_text( lv_docnumber ).

            DATA(response_text) = VALUE resp_type(
            docnumber = lv_docnumber
            postnumber = postnum ).

            DATA(lv_res) = /ui2/cl_json=>serialize( response_text ).
            response->set_text( lv_res ).
          ENDIF.

        ELSEIF shipped = 'receive' .

          DATA ls_header2 TYPE zgate_rgp_hdr.
          DATA ls_item2   TYPE zgate_rgpreceive.

          TYPES: BEGIN OF ty_wrapper2,
                   header TYPE zgate_rgp_hdr,
                   item   TYPE STANDARD TABLE OF zgate_rgpreceive WITH DEFAULT KEY,
                 END OF ty_wrapper2.

          DATA(lv_json1) =  request->get_text( ).

          DATA ls_wrapper2 TYPE ty_wrapper2.



          TRY.
              /ui2/cl_json=>deserialize(
                EXPORTING
                  json = lv_json1
                CHANGING
                  data = ls_wrapper2
              ).

              ls_header2 = ls_wrapper2-header.

              DATA(postnum1) = ls_header2-document_no.

            CATCH cx_sy_move_cast_error INTO DATA(lx_cast12).
              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
              response->set_text( 'Type mismatch in JSON: ' && lx_cast1->get_text( ) ).
              RETURN.
            CATCH cx_root INTO DATA(lx_root12).
              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
              response->set_text( 'JSON deserialize error: ' && lx_root1->get_text( ) ).
              RETURN.
          ENDTRY.

          DATA wa_rgp1 TYPE zgate_rgpreceive.
          DATA it_final1 TYPE TABLE OF zgate_rgpreceive.


          LOOP AT ls_wrapper2-item INTO ls_item2.



            wa_rgp1-batch = |{ ls_item2-batch ALPHA = IN }|.
            wa_rgp1-item_code = ls_item2-item_code.
            wa_rgp1-qty = ls_item2-qty.
            wa_rgp1-line_no = ls_item2-line_no.
            wa_rgp1-document_no = ls_item2-document_no.
            wa_rgp1-rgp_date = ls_item2-rgp_date.
            wa_rgp1-rgp_no = ls_item2-rgp_no.
            wa_rgp1-ship_reference_document = ls_item2-reference_document.
            wa_rgp1-reference_doc_date =  ls_item2-reference_doc_date.
            wa_rgp1-reference_doc_item = ls_item2-reference_doc_item.
            wa_rgp1-reference_doc_year = ls_item2-reference_doc_year.
            wa_rgp1-weight = ls_item2-weight.
            wa_rgp1-item_code = ls_item2-item_code.
            wa_rgp1-item_name = ls_item2-item_name.
            wa_rgp1-item_amount = ls_item2-item_amount.
            wa_rgp1-description = ls_item2-description.
            wa_rgp1-rate = ls_item2-rate.
            wa_rgp1-tax_code = ls_item2-tax_code.
            wa_rgp1-tax_percent = ls_item2-tax_percent.
            wa_rgp1-tax_amount = ls_item2-tax_amount.
            wa_rgp1-net_amount = ls_item2-net_amount.



            SELECT SINGLE FROM i_unitofmeasuretext AS a
            FIELDS a~unitofmeasure
            WHERE a~unitofmeasurecommercialname = @ls_item2-unit AND a~language = 'E'
            INTO @DATA(lv_unit1) PRIVILEGED ACCESS.
            wa_rgp1-unit = lv_unit1.

            APPEND wa_rgp1 TO it_final1.
            CLEAR : wa_rgp1 ,lv_unit1.

          ENDLOOP.

          MODIFY ENTITIES OF i_materialdocumenttp
           ENTITY materialdocument
           CREATE FROM VALUE #( ( %cid = 'CID_001'
           goodsmovementcode = '04'
           postingdate = cl_abap_context_info=>get_system_date( )
           documentdate = cl_abap_context_info=>get_system_date( )
           %control-goodsmovementcode = cl_abap_behv=>flag_changed
           %control-postingdate = cl_abap_behv=>flag_changed
           %control-documentdate = cl_abap_behv=>flag_changed
           ) )
           ENTITY materialdocument
           CREATE BY \_materialdocumentitem
           FROM VALUE #( (
           %cid_ref = 'CID_001'
           %target = VALUE #(  FOR wa_final1 IN it_final1 INDEX INTO i ( %cid = |'CID_{ i }_001'|
           plant = ls_header2-plant
           material = wa_final1-item_code
           goodsmovementtype = '311'
           storagelocation = ls_header2-to_storage_location
           issuingorreceivingstorageloc = ls_header2-from_storage_location
           quantityinentryunit = wa_final1-qty
           batch = wa_final1-batch
           issgorrcvgbatch = wa_final1-batch
           entryunit = wa_final1-unit
           %control-plant = cl_abap_behv=>flag_changed
           %control-material = cl_abap_behv=>flag_changed
           %control-goodsmovementtype = cl_abap_behv=>flag_changed
           %control-storagelocation = cl_abap_behv=>flag_changed
           %control-issuingorreceivingstorageloc = cl_abap_behv=>flag_changed
           %control-quantityinentryunit = cl_abap_behv=>flag_changed
           %control-batch = cl_abap_behv=>flag_changed
           %control-issgorrcvgbatch = cl_abap_behv=>flag_changed
           %control-entryunit = cl_abap_behv=>flag_changed  ) ) ) )
           MAPPED DATA(ls_create_mapped1)
           FAILED DATA(ls_create_failed1)
           REPORTED DATA(ls_create_reported1).


          COMMIT ENTITIES BEGIN
          RESPONSE OF i_materialdocumenttp
          FAILED DATA(commit_failed1)
          REPORTED DATA(commit_reported1).

          COMMIT ENTITIES END.



          IF commit_failed1 IS INITIAL AND ls_create_failed1 IS INITIAL.
            DATA lv_docnumber1 TYPE string."c LENGTH 10.

            lv_docnumber1 =  commit_reported1-materialdocumentitem[ 1 ]-materialdocument.

            TRY.
                /ui2/cl_json=>deserialize(
                  EXPORTING
                    json = lv_json1
                  CHANGING
                    data = ls_wrapper2
                ).
              CATCH cx_sy_move_cast_error INTO DATA(lx_cast112).
                response->set_status( i_code = 400 i_reason = 'Bad Request' ).
                response->set_text( 'Type mismatch in JSON: ' && lx_cast11->get_text( ) ).
                RETURN.
              CATCH cx_root INTO DATA(lx_root222).
                response->set_status( i_code = 400 i_reason = 'Bad Request' ).
                response->set_text( 'JSON deserialize error: ' && lx_root22->get_text( ) ).
                RETURN.
            ENDTRY.

             LOOP AT ls_wrapper2-item INTO ls_item2.


            SELECT SINGLE from zgate_rgp_item
            FIELDS qty ,is_item_received
            WHERE document_no = @ls_item2-document_no and line_no = @ls_item2-line_no
            into @DATA(lv_qty) PRIVILEGED ACCESS.

             DATA partial_qty TYPE p DECIMALS 3.

            partial_qty = lv_qty-qty - ls_item2-qty.


            IF (  partial_qty = 0 ).
              UPDATE zgate_rgp_item SET is_item_received = 'X', qty = @partial_qty WHERE document_no = @ls_item2-document_no and line_no = @ls_item2-line_no.

            ELSEIF ( partial_qty > 0 ).
             UPDATE zgate_rgp_item SET qty = @partial_qty WHERE document_no = @ls_item2-document_no and line_no = @ls_item2-line_no.
             ELSE.
              response->set_status( i_code = 500 i_reason = 'Item qty error' ).
              response->set_text( 'Received qty is greater than shipped qty for document_no: ' && ls_item2-document_no && ' line_no: ' && ls_item2-line_no ).
              RETURN.
            ENDIF.

            ENDLOOP.

            SELECT from zgate_rgp_item
            FIELDS is_item_received
            WHERE document_no = @ls_wrapper2-header-document_no
            into TABLE @DATA(lt_check) PRIVILEGED ACCESS.

            DATA(lv_all_received) = REDUCE abap_bool(
                  INIT x = abap_true
                  FOR wa IN lt_check
                  NEXT x = COND abap_bool(
                    WHEN x = abap_true AND wa-is_item_received = 'X' THEN abap_true
                    ELSE abap_false
                  )
                ).

            IF lv_all_received = abap_true.
              UPDATE zgate_rgp_hdr SET is_all_received = 'X' WHERE document_no = @ls_wrapper2-header-document_no.
            ENDIF.






*            IF ls_wrapper2-header-document_no IS INITIAL.
*              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
*              response->set_text( 'Header RGPNo is missing' ).
*              RETURN.
*            ENDIF.
*
*            " Insert header
*            ls_header2 = ls_wrapper2-header.
*            ls_header2-reference_document = lv_docnumber1.
*            ls_header2-created_by = cl_abap_context_info=>get_user_technical_name( ).
**          ls_header1-created_at = cl_abap_context_info=>get_system_time( ).
*            MODIFY zgate_rgp_hdr FROM @ls_header2.
*            IF sy-subrc <> 0.
*              response->set_status( i_code = 500 i_reason = 'Header insert failed' ).
*              response->set_text( 'Failed to insert RGPNo: ' && ls_header2-document_no ).
*              RETURN.
*            ENDIF.

            LOOP AT ls_wrapper2-item INTO ls_item2.
              " Optional: generate line_no if missing
              IF ls_item2-line_no IS INITIAL.
                ls_item2-line_no = sy-tabix.
              ENDIF.

              ls_item2-reference_document = lv_docnumber1.
              ls_item2-ship_reference_document = ls_wrapper2-header-document_no.
              ls_item2-created_by = cl_abap_context_info=>get_user_technical_name( ).
*            ls_item1-created_at = cl_abap_context_info=>get_system_time( ).
              MODIFY zgate_rgpreceive FROM @ls_item2.
              IF sy-subrc <> 0.
                response->set_status( i_code = 500 i_reason = 'Item insert failed' ).
                response->set_text( 'Failed to insert item line: ' && ls_item2-reference_document ).
                RETURN.
              ENDIF.

            ENDLOOP.


            response->set_text( lv_docnumber1 ).

            DATA(response_text1) = VALUE resp_type(
            docnumber = lv_docnumber1
            postnumber = postnum1 ).

            DATA(lv_res1) = /ui2/cl_json=>serialize( response_text ).
            response->set_text( lv_res1 ).
          ENDIF.

        ELSEIF shipped = 'false'.

          " Header and item structures
          DATA ls_header TYPE zgate_rgp_hdr.
          DATA ls_item   TYPE zgate_rgp_item.
          DATA ls_resp   TYPE ty_response.

          TYPES: BEGIN OF ty_wrapper,
                   header TYPE zgate_rgp_hdr,
                   item   TYPE STANDARD TABLE OF zgate_rgp_item WITH DEFAULT KEY,
                 END OF ty_wrapper.

          DATA ls_wrapper TYPE ty_wrapper.

          DATA(lv_data) =  request->get_text( ).

          TRY.
              /ui2/cl_json=>deserialize(
                EXPORTING
                  json = lv_data
                CHANGING
                  data = ls_wrapper
              ).
            CATCH cx_sy_move_cast_error INTO DATA(lx_cast).
              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
              response->set_text( 'Type mismatch in JSON: ' && lx_cast->get_text( ) ).
              RETURN.
            CATCH cx_root INTO DATA(lx_root).
              response->set_status( i_code = 400 i_reason = 'Bad Request' ).
              response->set_text( 'JSON deserialize error: ' && lx_root->get_text( ) ).
              RETURN.
          ENDTRY.

          IF ls_wrapper-header-document_no IS INITIAL.
            response->set_status( i_code = 400 i_reason = 'Bad Request' ).
            response->set_text( 'Header RGPNo is missing' ).
            RETURN.
          ENDIF.

          " Insert header
          ls_header = ls_wrapper-header.
          ls_header-created_by = cl_abap_context_info=>get_user_technical_name( ).
*          ls_header-created_at = cl_abap_context_info=>get_system_time( ).
          MODIFY zgate_rgp_hdr FROM @ls_header.
          IF sy-subrc <> 0.
            response->set_status( i_code = 500 i_reason = 'Header insert failed' ).
            response->set_text( 'Failed to insert RGPNo: ' && ls_header-document_no ).
            RETURN.
          ENDIF.

          " Insert items
          LOOP AT ls_wrapper-item INTO ls_item.
            " Optional: generate line_no if missing
            IF ls_item-line_no IS INITIAL.
              ls_item-line_no = sy-tabix.
            ENDIF.

            ls_item-created_by = cl_abap_context_info=>get_user_technical_name( ).
*            ls_item-created_at = cl_abap_context_info=>get_system_time( ).
            MODIFY zgate_rgp_item FROM @ls_item.
            IF sy-subrc <> 0.
              response->set_status( i_code = 500 i_reason = 'Item insert failed' ).
              response->set_text( 'Failed to insert item line: ' && ls_item-line_no ).
              RETURN.
            ENDIF.

          ENDLOOP.

          DATA(lv_response) = | Document { ls_header-document_no } saved successfully |.

          response->set_status( i_code = 200 i_reason = 'OK' ).

          response->set_text( lv_response ).

        ELSE.
          response->set_status( i_code = 400 i_reason = 'Bad Request' ).
          response->set_text( 'Parameter shipped is missing or invalid' ).
          RETURN.

        ENDIF.

      WHEN 'GET'.

        IF shipped IS NOT INITIAL AND shipped = 'true'.

          TRY.
              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr = '1'
                  object      = 'ZNRO_RGP_P'
                IMPORTING
                  number      = DATA(nextnumber1)
              ).
            CATCH cx_number_ranges INTO DATA(lx_number_ranges1).
              DATA(lv_error_msg1) = lx_number_ranges1->get_text( ).
              response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
              response->set_text( 'Only POST method is allowed' ).

          ENDTRY.

          DATA(lv_result1) = |{ nextnumber1 }| .

          TRY .
              DATA(lv_rgpno1) =  /ui2/cl_json=>serialize( data = lv_result1 ).
              response->set_status( i_code = 200 i_reason = 'OK' ).
              response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
              response->set_text( lv_rgpno1 ).
            CATCH cx_root INTO DATA(lx_roots1).
              response->set_status( i_code = 500 i_reason = 'Number Range Error' ).
              response->set_text( lx_roots1->get_text( ) ).

          ENDTRY.

        ELSEIF shipped = 'false'.

          TRY.
              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr = '1'
                  object      = 'ZNRO_RGP'
                IMPORTING
                  number      = DATA(nextnumber)
              ).
            CATCH cx_number_ranges INTO DATA(lx_number_ranges).
              DATA(lv_error_msg) = lx_number_ranges->get_text( ).
              response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
              response->set_text( 'Only POST method is allowed' ).
          ENDTRY.

          DATA(lv_result) = |{ nextnumber }| .
          TRY .
              DATA(lv_rgpno) =  /ui2/cl_json=>serialize( data = lv_result ).
              response->set_status( i_code = 200 i_reason = 'OK' ).
              response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
              response->set_text( lv_rgpno ).
            CATCH cx_root INTO DATA(lx_roots).
              response->set_status( i_code = 500 i_reason = 'Number Range Error' ).
              response->set_text( lx_roots->get_text( ) ).
          ENDTRY.
        ELSE.
          response->set_status( i_code = 400 i_reason = 'Bad Request' ).
          response->set_text( 'Parameter shipped is missing or invalid' ).

        ENDIF.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
