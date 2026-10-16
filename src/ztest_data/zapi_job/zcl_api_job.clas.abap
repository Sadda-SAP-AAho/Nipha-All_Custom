CLASS zcl_api_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

      CLASS-METHODS:
      create_client
        IMPORTING url              TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
                        RAISING   cx_no_check
                  cx_http_dest_provider_error
                  cx_web_http_client_error.
*        RAISING   cx_static_check.




ENDCLASS.



CLASS ZCL_API_JOB IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  et_parameter_def = VALUE #( datatype       = 'C'
                                changeable_ind = abap_true
                                ( selname       = 'TEXT'
                                  kind          = if_apj_dt_exec_object=>parameter
                                  param_text    = 'Free text'
                                  length        = 50
                                  lowercase_ind = abap_true
                                  mandatory_ind = abap_true )
                                ( selname    = 'COUNTRY'
                                  kind       = if_apj_dt_exec_object=>select_option
                                  param_text = 'Country'
                                  length     = 3 )
                                ( selname         = 'R_TEXT'
                                  kind            = if_apj_dt_exec_object=>parameter
                                  param_text      = 'Text'
                                  length          = 1
                                  radio_group_ind = abap_true
                                  radio_group_id  = 'R1' )
                                ( selname         = 'R_LAND'
                                  kind            = if_apj_dt_exec_object=>parameter
                                  param_text      = 'Country'
                                  length          = 1
                                  radio_group_ind = abap_true
                                  radio_group_id  = 'R1' )
                                ( selname      = 'TEST'
                                  kind         = if_apj_dt_exec_object=>parameter
                                  param_text   = 'Test'
                                  length       = 1
                                  checkbox_ind = abap_true ) ).

    et_parameter_val = VALUE #( sign   = 'I'
                                option = 'EQ'
                                ( selname = 'TEST' low = abap_true )
                                ( selname = 'R_TEXT' low = abap_false )
                                ( selname = 'R_LAND' low = abap_true ) ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

     DATA ld_text          TYPE c LENGTH 50.
    DATA lt_r_country     TYPE RANGE OF I_CountryText-Country.
    DATA ld_radio_text    TYPE abap_boolean.
    DATA ld_radio_country TYPE abap_boolean.
    DATA ld_test          TYPE abap_boolean.

    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'TEXT'.
          ld_text = ls_parameter-low.
        WHEN 'COUNTRY'.
          INSERT CORRESPONDING #( ls_parameter ) INTO TABLE lt_r_country.
        WHEN 'R_TEXT'.
          ld_radio_text = ls_parameter-low.
        WHEN 'R_LAND'.
          ld_radio_country = ls_parameter-low.
        WHEN 'TEST'.
          ld_test = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

*    DATA(ls_database) = VALUE zbs_jtrack( identifier = cl_system_uuid=>create_uuid_x16_static( )
*                                              rdate      = cl_abap_context_info=>get_system_date( )
*                                              rtime      = cl_abap_context_info=>get_system_time( )
*                                              test       = ld_test ).
*
*    CASE abap_true.
*      WHEN ld_radio_text.
*        ls_database-content = ld_text.
*
*      WHEN ld_radio_country.
*        SELECT FROM I_CountryText
*          FIELDS CountryName
*          WHERE Country IN @lt_r_country
*            and Language = @sy-langu
*          INTO TABLE @DATA(lt_names).
*
*        ls_database-content = concat_lines_of( table = lt_names sep = `, ` ).
*
*    ENDCASE.
*
*    INSERT zbs_jtrack FROM @ls_database.
*    COMMIT WORK.

  ENDMETHOD.


  METHOD create_client.

*      try.
*       DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
*          CATCH cx_abap_context_info_error INTO DATA(lx_http6).
*             DATA(lv_text6) = lx_http6->get_text( ) .
*             RETURN.
*       endtry.
*    try .
*    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
*              CATCH cx_abap_context_info_error INTO DATA(lx_http5).
*             DATA(lv_text5) = lx_http5->get_text( ) .
*             RETURN.
*
*      endtry.

  DATA(dest) =
    cl_http_destination_provider=>create_by_url( url ).

  result =
    cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA: lc_url    TYPE string.
       CONSTANTS:
      lc_user TYPE string VALUE 'TEST_USER',
      lc_pass TYPE string VALUE 'vy9F(<qVYJV%tz)P3kR7GF8om6]hMdX#]NazDZca'.
*
*     TRY.
*
*        DATA(lv_url) = cl_abap_context_info=>get_system_url( ).
*    ENDTRY.
*

*

*-----------------------------------------------------------------------------------------------------------------
*  DATA(lo_client) = create_client( lc_url ).
    DATA:url TYPE string.

* https://my413347-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PURCHASEREQ_PROCESS_SRV/A_PurchaseReqnItemText(PurchaseRequisition='0010000113',PurchaseRequisitionItem='00020',DocumentText='B04',TechnicalObjectType='EBAN',Language='EN')
        CONSTANTS:lc_http  TYPE string VALUE  'https://',
                  lc_date  TYPE string VALUE '/Date(',
                  lc_close TYPE string VALUE ')/'.
*              lc_api_serv TYPE string VALUE '/sap/opu/odata/sap/API_PURCHASEREQ_PROCESS_SRV/A_PurchaseReqnItemText'.
        TRY.
            DATA(lv_url) = cl_abap_context_info=>get_system_url( ).

      IF lv_url = 'my405896.s4hana.cloud.sap'.

      lc_url = 'my405896-api.s4hana.cloud.sap'.
     ELSEIF lv_url = 'my405907.s4hana.cloud.sap'.

      lc_url = 'my405907-api.s4hana.cloud.sap'.
    endif.
*    ELSEIF lv_url = 'my405896.s4hana.cloud.sap'.
*      lc_url = 'https://my412532-api.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi?sap-client=100'.
*    ENDIF.



*        DATA lv_req     TYPE  i .
            DATA lv_item    TYPE string  .
            DATA lv_doc     TYPE string  .
            DATA lv_objtype TYPE string  .
            DATA lv_lang    TYPE string  .


            data(lv_req) = 5100000041.
            lv_item = 10.
*            lv_doc = 'B04'.
*            lv_objtype = 'EBAN' .
*            lv_lang = 'EN' .

     DATA lv_body  TYPE string.

TYPES: BEGIN OF ty_body,
         isclosed TYPE abap_bool,
       END OF ty_body.

DATA(ls_body) = VALUE ty_body( isclosed = abap_true ).

lv_body = /ui2/cl_json=>serialize( ls_body ).

            DATA(lc_api_serv) =
               |/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001//PurchaseReqnItem/| &&
               |{ lv_req }| && |/| &&
               |{ lv_item }| .


          url =  |{ lc_http }| & |{ lc_url }|          & |{ lc_api_serv }|.
          CATCH cx_abap_context_info_error INTO DATA(lx_http3).
             DATA(lv_text3) = lx_http3->get_text( ) .
             RETURN.
        ENDTRY.
        TRY.
            DATA(lo_http_client) = create_client( url ).
          CATCH cx_static_check INTO DATA(lx_http2).
             DATA(lv_text) = lx_http2->get_text( ).
        ENDTRY.
        IF  lo_http_client IS BOUND.
          DATA(lo_request) = lo_http_client->get_http_request(  ).
          lo_request->set_content_type( content_type = 'application/json' ).
          TRY.
              lo_http_client->accept_cookies( i_allow = abap_true ).
              CATCH cx_web_http_client_error INTO DATA(lx_http)..
              DATA(lv_text1) = lx_http->get_text( ).
          ENDTRY.
          lo_request->set_authorization_basic(
          i_username = lc_user  i_password = lc_pass ).
          lo_request->set_header_field( i_name = 'X-CSRF-Token' i_value = 'fetch' ).
          lo_request->set_header_field( i_name = 'If-Match' i_value = '*' ).
          lo_request->set_text( lv_body ).
          TRY.
              DATA(lo_web_http_response2) = lo_http_client->execute( if_web_http_client=>patch ).
            CATCH cx_web_http_client_error INTO DATA(lx_http1).
            DATA(lv_text2) = lx_http1->get_text( ).
          ENDTRY.


          DATA(lv_status) = lo_web_http_response2->get_status( ).
          DATA(lv_json1)   = lo_web_http_response2->get_text( ).
          DATA(lvv_xmll) = lv_json1.
*          DATA:lv_notedesc TYPE string.
*
*          DATA: lv_start          TYPE i,
*                lv_end            TYPE i,
*                lv_accounting_doc TYPE string.
*
*          " Look for the AccountingDocument in the SOAP response
*          lv_start = find( val = lv_json1 sub = '<d:NoteDescription>' ).
*          lv_end   = find( val = lv_json1 sub = '</d:NoteDescription>' ).

*          IF lv_start > 0 AND lv_end > lv_start.
*            lv_start += strlen( '<d:NoteDescription>' ).
*            lv_accounting_doc = substring( val = lv_json1 off = lv_start len = lv_end - lv_start ).
*          ENDIF.
        ENDIF.


*----------------------------------------------------------------------------------------------------------


*
*
*  DATA: lv_entries_xml TYPE string,
*          lv_item_xml    TYPE string,
*          lv_xml_request    TYPE string,
*          lv_response       TYPE string.
*
*
*
* " Step 3: Set Request Headers and Auth
*      DATA(lo_request) = lo_client->get_http_request( ).
*
**      lo_request->set_header_field( i_name = 'Content-Type' i_value = 'text/xml;charset=UTF-8' ).
*      lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/json;odata.metadata=minimal;charset=utf-8' ).
*
*      lo_request->set_authorization_basic(
*        i_username = lc_user
*        i_password = lc_pass ).
*
*
*      DATA(rv_xml) = '{ "IsClosed": true }'.
*
*      lv_xml_request = rv_xml.
**          {
**
**          "IsClosed": true
**
**
**          }
*
*                 "": "' wa_header-so
*
*
*      " Step 4: Set Request Body
*      lo_request->set_text( i_text = lv_xml_request ).
*
*
*
*      " Step 5: Execute Request
*      DATA(lo_response) = lo_client->execute( if_web_http_client=>patch ).
*
*      " Step 6: Handle Response
*      lv_response = lo_response->get_text( ).
*
**    cl_demo_output=>display( lv_response ).
*
*      " Step 7: Optional - Check Status
*      TRY.
*          lo_response->get_status( RECEIVING r_value = DATA(ls_status) ).
*        CATCH cx_web_message_error.
*      ENDTRY.
*
*      IF ls_status-code <> '200'.
**      cl_demo_output=>display( |HTTP Error: { ls_status-code } - { ls_status-reason }| ).
*
*      ENDIF.



  ENDMETHOD.
ENDCLASS.
