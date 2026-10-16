CLASS zcl_http_hndldoc DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES if_http_service_extension .

    METHODS: uploadFile
      IMPORTING
        VALUE(request) TYPE REF TO if_web_http_request
        response       TYPE REF TO if_web_http_response,
      DownloadFile
        IMPORTING
          VALUE(request) TYPE REF TO if_web_http_request
          response       TYPE REF TO if_web_http_response,
      RemoveFile
        IMPORTING
          VALUE(request) TYPE REF TO if_web_http_request
          response       TYPE REF TO if_web_http_response,
      updateFile
        IMPORTING
          VALUE(request) TYPE REF TO if_web_http_request
          response       TYPE REF TO if_web_http_response.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS write_activity_log
      IMPORTING
        iv_action   TYPE zdms_activitylog-action
        iv_entity   TYPE zdms_activitylog-entity   OPTIONAL
        iv_old_path TYPE zdms_activitylog-old_path OPTIONAL
        iv_new_path TYPE zdms_activitylog-new_path OPTIONAL.
ENDCLASS.



CLASS ZCL_HTTP_HNDLDOC IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    CASE request->get_method( ).
      WHEN CONV string( if_web_http_client=>post ).
        uploadfile( request = request response = response ).
      WHEN CONV string( if_web_http_client=>get ).
        downloadfile( request = request response = response ).
      WHEN CONV string( if_web_http_client=>put ).
        UPDATEfile( request = request response = response ).
      WHEN CONV string( if_web_http_client=>delete ).
        removeFile( request = request response = response ).
      WHEN OTHERS.
        response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
        response->set_text( 'Only POST method is supported' ).
    ENDCASE.
  ENDMETHOD.


  METHOD uploadfile.

    DATA: request_data TYPE ty_request,
          file_path    TYPE string.
    request_data = handle_doc=>parse_request( request ).

    SELECT SINGLE FROM zr_user_header
    FIELDS allowcreate
    WHERE userid = @sy-uname
    INTO @DATA(lv_allow_create).

    IF lv_allow_create = abap_false.
      response->set_status( i_code = 200 i_reason = 'Ok' ).
      response->set_text( 'Error: You do not have permission to upload files.' ).
      RETURN.
    ENDIF.


    CASE request_data-doctype.
      WHEN 'XLSX' OR 'CSV'.
        request_data-doctype = 'Excel'.
      WHEN 'PDF'.
        request_data-doctype = 'PDF'.
      WHEN 'JPG' OR 'PNG' OR 'GIF' OR 'BMP' OR 'WEBP' OR 'JPEG'.
        request_data-doctype = 'Image'.
      WHEN 'TXT'.
        request_data-doctype = 'Text'.
      WHEN 'DOCX' OR 'PPTX'.
        request_data-doctype = 'Document'.
      WHEN 'ZIP'.
        request_data-doctype = 'Archive'.
      WHEN 'XML'.
        request_data-doctype = 'XML'.
      WHEN OTHERS.
        request_data-doctype = 'Other'.
    ENDCASE.

    IF request_data-doclink IS NOT INITIAL.
      SELECT SINGLE FROM zr_dms
      FIELDS docnumber
      WHERE refobjectkey = @request_data-refobjectkey
            AND refobjecttype = @request_data-refobjecttype
      INTO @DATA(lv_docnumber).


      MODIFY ENTITIES OF zr_dms
       ENTITY zrdms
       CREATE FIELDS ( category description doclink docnumber docsize doctype title docversion mimetype owner refobjectkey refobjecttype  )
       AUTO FILL CID
       WITH VALUE #( (
                        category    = request_data-category
                        description = request_data-description
                        doclink     = request_data-doclink
                        docnumber   = CONV string( CONV i( lv_docnumber ) + 10 )
*                        docnumber = CONV string( lv_next_docnumber )
                        doctype     = 'Link'
                        title       = request_data-filename
                        docversion   = '1.0'
                        owner       = sy-uname
                        refobjectkey = request_data-refobjectkey
                        refobjecttype = request_data-refobjecttype
                     ) )
       FAILED DATA(lt_failed)
       REPORTED DATA(lt_reported).

      IF lt_failed IS NOT INITIAL.
        LOOP AT lt_reported-zrdms INTO DATA(ls_reported).
          response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
          response->set_text( |Failed to update record: { ls_reported-%msg->if_message~get_text( ) }| ).
          RETURN.
        ENDLOOP.
      ENDIF.

      COMMIT ENTITIES RESPONSES
      FAILED DATA(lt_failed1)
      REPORTED DATA(lt_reported1).
      response->set_text( 'Link Added' ).


      """""""""""activity log use
      write_activity_log(
           iv_action   = 'Link Added'
           iv_entity   = CONV #( request_data-refobjecttype )
           iv_new_path = |{ file_path }/{ request_data-filename }|
      ).

      """""""""""""""
      RETURN.
    ENDIF.


    DATA: lv_client TYPE REF TO if_web_http_client,
          req       TYPE REF TO if_web_http_client.

    SELECT SINGLE FROM zr_integration_tab000
    FIELDS intgpath
    WHERE intgmodule = @uploadurl
    INTO @DATA(lv_intgmodule).

    TRY.
        DATA(dest) = cl_http_destination_provider=>create_by_url( CONV string( lv_intgmodule ) ).
        lv_client = cl_web_http_client_manager=>create_by_http_destination( dest ).

      CATCH cx_static_check INTO DATA(lv_cx_static_check2).
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( |Destination creation failed: { lv_cx_static_check2->get_longtext( ) }| ).
        RETURN.
    ENDTRY.

    TRY.
        SELECT SINGLE FROM zr_dms_config
        FIELDS path
        WHERE entity = @request_data-refobjecttype
        INTO @DATA(configured_path).
        file_path = |{ configured_path }/{ request_data-refobjectkey }|.

        DATA(lo_request) = lv_client->get_http_request( ).

        DATA(lv_boundary) = '---ABAPBoundary' && cl_system_uuid=>create_uuid_c32_static( ).
        lo_request->set_header_field( i_name = 'Content-Type'
                                     i_value = |multipart/form-data; boundary={ lv_boundary }| ).

        SELECT SINGLE FROM zr_integration_tab000
        FIELDS intgpath
        WHERE intgmodule = @headervalue
        INTO @DATA(lv_headervalue).

        SELECT SINGLE FROM zr_integration_tab000
        FIELDS intgpath
        WHERE intgmodule = @container
        INTO @DATA(lv_container).

        lo_request->set_header_field(
                  i_name  = headername
                  i_value = CONV string( lv_headervalue )
                ).

        DATA(lo_part_cont) = lo_request->add_multipart( ).
        lo_part_cont->set_header_field( i_name = 'Content-Disposition'
                                        i_value = 'form-data; name="Container"' ).
        lo_part_cont->set_text( i_text = CONV string( lv_container ) ).

        DATA(lo_part_path) = lo_request->add_multipart( ).
        lo_part_path->set_header_field( i_name = 'Content-Disposition'
                                        i_value = 'form-data; name="CurrentPath"' ).
        lo_part_path->set_text( i_text = file_path ).
        DATA(lo_part_file) = lo_request->add_multipart( ).
        lo_part_file->set_header_field( i_name = 'Content-Disposition'
                                            i_value = |form-data; name="File"; filename="{ request_data-filename }"| ).
        lo_part_file->set_header_field( i_name = 'Content-Type' i_value = 'application/octet-stream' ).
        lo_part_file->set_binary( request_data-filecontent ).

        DATA url_response2 TYPE string.

        TRY.
            DATA(lv_response) = lv_client->execute( if_web_http_client=>post ).
            url_response2 = lv_response->get_text( ).
            DATA(lv_status_code) = lv_response->get_status( )-code.
            IF lv_status_code <> 200.
              DATA  error_res TYPE ty_error_res.
              xco_cp_json=>data->from_string( url_response2 )->write_to( REF #( error_res ) ).
              response->set_status( i_code = lv_status_code i_reason = lv_response->get_status( )-reason ).
              response->set_text( |API request failed with status { lv_status_code }: { error_res-error[ 1 ] }| ).
              RETURN.
            ENDIF.

            DATA  lv_status TYPE ty_upload_res.
            xco_cp_json=>data->from_string( url_response2 )->write_to( REF #( lv_status ) ).

            IF lv_status-issuccess = 'true'.

              SELECT SINGLE FROM zr_dms
              FIELDS docnumber
              WHERE refobjectkey = @request_data-refobjectkey
                    AND refobjecttype = @request_data-refobjecttype
              INTO @lv_docnumber.


              MODIFY ENTITIES OF zr_dms
                   ENTITY zrdms
                   CREATE FIELDS ( category description doclink docnumber docsize doctype title docversion mimetype owner refobjectkey refobjecttype )
                   AUTO FILL CID
                   WITH VALUE #( (
                                    category    = request_data-category
                                    description = request_data-description
                                    doclink     = |{ file_path }/{ request_data-filename }|
                                    docnumber   = CONV string( CONV i( lv_docnumber ) + 10 )
                                    docsize     = request_data-filesize
                                    doctype     = request_data-doctype
                                    title       = request_data-filename
                                    docversion   = '1.0'
                                    mimetype    = request_data-filetype
                                    owner       = sy-uname
                                    refobjectkey = request_data-refobjectkey
                                    refobjecttype = request_data-refobjecttype
                                 ) )
                   FAILED lt_failed
                   REPORTED lt_reported.
              COMMIT ENTITIES RESPONSES
              FAILED lt_failed1
              REPORTED lt_reported1.

              """""""""""activity log use
              write_activity_log(
                   iv_action   = 'UPLOAD'
                   iv_entity   = CONV #( request_data-refobjecttype )
                   iv_new_path = |{ file_path }/{ request_data-filename }|
              ).

              """""""""""""""
              response->set_text( 'Added Successfully' ).
            ELSE.
              xco_cp_json=>data->from_string( url_response2 )->write_to( REF #( error_res ) ).
              response->set_text( error_res-error[ 1 ] ).
            ENDIF.
          CATCH cx_web_http_client_error INTO DATA(lv_error_response2).
            response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
            response->set_text( |API request failed: { lv_error_response2->get_text( ) }| ).
        ENDTRY.
      CATCH cx_root INTO DATA(lv_general_error).
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( |Processing failed: { lv_general_error->get_longtext( ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD removefile.
    DATA: request_data TYPE ty_get_request.
    request_data = handle_doc=>parse_get_request( request ).


    SELECT SINGLE FROM zr_user_header
    FIELDS allowdelete
    WHERE userid = @sy-uname
    INTO @DATA(lv_allow_delete).

    IF lv_allow_delete = abap_false.
      response->set_status( i_code = 200 i_reason = 'Ok' ).
      response->set_text( 'Error: You do not have permission to remove files.' ).
      RETURN.
    ENDIF.

    SELECT SINGLE FROM zr_dms
      FIELDS docuuid, doclink
      WHERE docuuid = @request_data-docuuid
      INTO @DATA(ls_db_record).

    IF sy-subrc <> 0.
      response->set_status( i_code = 404 i_reason = 'Not Found' ).
      response->set_text( 'Document record not found in system' ).
      RETURN.
    ENDIF.

    TRY.
        SELECT SINGLE FROM zr_integration_tab000
      FIELDS intgpath
      WHERE intgmodule = @deleteurl
      INTO @DATA(lv_intgmodule).


        SELECT SINGLE FROM zr_integration_tab000
        FIELDS intgpath
        WHERE intgmodule = @container
        INTO @DATA(lv_container).

        DATA(lv_url) = |{ lv_intgmodule }?container={ cl_web_http_utility=>escape_url(  CONV string( lv_container ) ) }&blobPath={ cl_web_http_utility=>escape_url( CONV string( ls_db_record-doclink ) ) }|.

        DATA(dest) = cl_http_destination_provider=>create_by_url( lv_url ).
        DATA(lv_client) = cl_web_http_client_manager=>create_by_http_destination( dest ).

        SELECT SINGLE FROM zr_integration_tab000
               FIELDS intgpath
               WHERE intgmodule = @headervalue
               INTO @DATA(lv_headervalue).

        lv_client->get_http_request(  )->set_header_field(
               i_name  = headername
               i_value = CONV string( lv_headervalue )
             ).

        DATA(lv_response) = lv_client->execute( if_web_http_client=>delete ).

        IF lv_response->get_status( )-code = 200.

          MODIFY ENTITIES OF zr_dms
            ENTITY zrdms
            DELETE FROM VALUE #( ( %key-docuuid = ls_db_record-docuuid ) )
            FAILED DATA(lt_failed)
            REPORTED DATA(lt_reported).

          IF lt_failed IS INITIAL.
            COMMIT ENTITIES.
            write_activity_log(
              iv_action   = 'Delete'
              iv_entity   = ''
              iv_old_path = CONV #( ls_db_record-doclink )
            ).
            response->set_status( i_code = 200 i_reason = 'OK' ).
            response->set_text( 'File and record deleted successfully' ).
          ELSE.
            response->set_status( i_code = 500 i_reason = 'Internal Error' ).
            response->set_text( 'External file deleted, but failed to remove database record' ).
          ENDIF.

        ELSE.
          response->set_status( i_code = lv_response->get_status( )-code
                                i_reason = lv_response->get_status( )-reason ).
          response->set_text( |External API failed: { lv_response->get_text( ) }| ).
        ENDIF.

      CATCH cx_root INTO DATA(lx_error).
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( lx_error->get_longtext( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD downloadfile.

    DATA: request_data TYPE ty_get_request.
    request_data = handle_doc=>parse_get_request( request ).

    IF request_data-action EQ 'Preview'.

      SELECT SINGLE FROM zr_user_header
      FIELDS allowview
      WHERE userid = @sy-uname
      INTO @DATA(lv_allow_view).

      IF lv_allow_view = abap_false.
        response->set_status( i_code = 200 i_reason = 'Ok' ).
        response->set_text( 'Error: You do not have permission to preview files.' ).
        RETURN.
      ENDIF.
    ELSEIF request_data-action EQ 'Download'.
      SELECT SINGLE FROM zr_user_header
      FIELDS allowdownload
      WHERE userid = @sy-uname
      INTO @DATA(lv_allow_download).
      IF lv_allow_download = abap_false.
        response->set_status( i_code = 200 i_reason = 'Ok' ).
        response->set_text( 'Error: You do not have permission to download files.' ).
        RETURN.
      ENDIF.
    ENDIF.

    SELECT SINGLE FROM zr_dms
      FIELDS docuuid, doclink , title, refobjecttype
      WHERE docuuid = @request_data-docuuid
      INTO @DATA(ls_db_record).

    IF sy-subrc <> 0.
      response->set_status( i_code = 404 i_reason = 'Not Found' ).
      response->set_text( 'Document record not found in system' ).
      RETURN.
    ENDIF.

    TRY.
        SELECT SINGLE FROM zr_integration_tab000
          FIELDS intgpath
          WHERE intgmodule = @downloadurl
          INTO @DATA(lv_intgmodule).


        SELECT SINGLE FROM zr_integration_tab000
        FIELDS intgpath
        WHERE intgmodule = @container
        INTO @DATA(lv_container).
        DATA(lv_url) = |{ lv_intgmodule }?container={ cl_web_http_utility=>escape_url( CONV string( lv_container ) ) }&blobPath={ cl_web_http_utility=>escape_url( CONV string( ls_db_record-doclink ) ) }|.

        DATA(dest) = cl_http_destination_provider=>create_by_url( lv_url ).
        DATA(lv_client) = cl_web_http_client_manager=>create_by_http_destination( dest ).

        SELECT SINGLE FROM zr_integration_tab000
           FIELDS intgpath
           WHERE intgmodule = @headervalue
           INTO @DATA(lv_headervalue).

        lv_client->get_http_request(  )->set_header_field(
           i_name  = headername
           i_value = CONV string( lv_headervalue )
         ).

        DATA(lv_response) = lv_client->execute( if_web_http_client=>get ).
        DATA(lv_bin_data) = lv_response->get_binary( ).

        response->set_status( i_code = 200 ).
        response->set_header_field( i_name = 'Content-Type' i_value = 'application/octet-stream' ).
        response->set_header_field( i_name = 'Content-Disposition'
                                    i_value = |attachment; filename="{ ls_db_record-title }"| ).
        response->set_binary( lv_bin_data ).
        """""""""""""""""""
        write_activity_log(
           iv_action   = CONV #( request_data-action )
           iv_entity   = CONV #( ls_db_record-refobjecttype )
           iv_old_path = CONV #( ls_db_record-doclink )
         ).

      CATCH cx_root INTO DATA(lx_error).
        response->set_status( i_code = 500 i_reason = 'Internal Server Error' ).
        response->set_text( lx_error->get_longtext( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD updatefile.
  ENDMETHOD.


  METHOD if_oo_Adt_Classrun~main.


    TRY.

        DATA(lv_url) = |{ DownloadURL }?container={ container }&blobPath={ '/Yash/hero23.jpg' }|.

        DATA(dest) = cl_http_destination_provider=>create_by_url( lv_url ).
        DATA(lv_client) = cl_web_http_client_manager=>create_by_http_destination( dest ).

        DATA(lv_response) = lv_client->execute( if_web_http_client=>get ).
        DATA(lv_bin_data) = lv_response->get_binary( ).


        out->write( lv_bin_data ).


      CATCH cx_root INTO DATA(lx_error).

    ENDTRY.


  ENDMETHOD.


  METHOD write_activity_log.
    DATA lv_uuid TYPE sysuuid_x16.
    DATA lv_ts   TYPE abp_creation_tstmpl.
    DATA ls_log     TYPE zdms_activitylog.

    TRY.
        lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.
    GET TIME STAMP FIELD lv_ts.

    ls_log-client    = sy-mandt.
    ls_log-log_uuid  = lv_uuid.
    ls_log-entity    = iv_entity.
    ls_log-action    = iv_action.
    ls_log-old_path  = iv_old_path.
    ls_log-new_path  = iv_new_path.
    ls_log-action_by = sy-uname.
    ls_log-action_at = lv_ts.

    INSERT zdms_activitylog FROM @ls_log.



  ENDMETHOD.
ENDCLASS.
