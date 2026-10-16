CLASS zcl_pr_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
           CLASS-METHODS :
      create_client
        IMPORTING url              TYPE string
        RETURNING VALUE(lo_client) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PR_API IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*comminucation arr -> SAP_COM_0102
  select single * from I_PurchaseRequisitionItemAPI01 where PurchaseRequisition = '5100000403' and PurchaseRequisitionItem = '20' into @data(lv_pr_item).
     if sy-subrc eq 0.
          DATA(lv_pr) = lv_pr_item-PurchaseRequisition.
          DATA(lv_item) = lv_pr_item-PurchaseRequisitionItem.
     endif.

  DATA: lv_full_url TYPE string.

    CONSTANTS: lc_http TYPE string VALUE 'https://'.

    TRY.
        DATA(lv_url) = cl_abap_context_info=>get_system_url( ).

        " OData V4 URL for PurchaseReqnItem - DYNAMIC PR and Item numbers
        DATA(lc_api_serv) = |/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/| &&
                            |PurchaseReqnItem(PurchaseRequisition='{ lv_pr }',| &&
                            |PurchaseRequisitionItem='{ lv_item }')|.

        lv_full_url = |{ lc_http }| & |{ lv_url }| & |{ lc_api_serv }|.

      CATCH cx_abap_context_info_error.
    ENDTRY.

    " Step 1: Create HTTP Client
    TRY.
        DATA(lo_http_client) = create_client( lv_full_url ).
      CATCH cx_static_check.
    ENDTRY.

    IF lo_http_client IS BOUND.

      " ====== STEP 1: GET CSRF TOKEN ======
      DATA(lo_request) = lo_http_client->get_http_request( ).

      lo_request->set_content_type( content_type = 'application/json' ).

      TRY.
          lo_http_client->accept_cookies( i_allow = abap_true ).
        CATCH cx_web_http_client_error.
      ENDTRY.

      " Set basic authentication
      lo_request->set_authorization_basic(
        i_username = 'TEST_USER'
        i_password = 'vy9F(<qVYJV%tz)P3kR7GF8om6]hMdX#]NazDZca'
      ).

      " Request CSRF token
      lo_request->set_header_field(
        i_name  = 'X-CSRF-Token'
        i_value = 'fetch'
      ).

      " Execute GET to fetch CSRF token
      TRY.
          DATA(lo_response_get) = lo_http_client->execute( if_web_http_client=>get ).
        CATCH cx_web_http_client_error.
*          CONTINUE.  " Skip this iteration if GET fails
      ENDTRY.

      " Get CSRF token and cookies
      DATA(lv_csrf_token) = lo_response_get->get_header_field( i_name = 'X-CSRF-Token' ).
      DATA(lv_cookies) = lo_response_get->get_header_field( i_name = 'set-cookie' ).

      " Check if CSRF token was fetched
      IF lv_csrf_token IS INITIAL.
*        CONTINUE.  " Skip this iteration if no CSRF token
      ENDIF.

      " ====== STEP 2: PATCH REQUEST WITH CSRF TOKEN ======

      " Prepare JSON body for PATCH - Update IsClousd
*      DATA(lv_json_body) = |\{ "YY1_BUYER_PRI": "{ lv_buyer_code }" \}|.
      DATA(lv_json_body) = |\{ "IsClosed": true \}|.

      " Set the body
      lo_request->set_text( lv_json_body ).

      " Set headers for PATCH request
      lo_request->set_header_field(
        i_name  = 'X-CSRF-Token'
        i_value = lv_csrf_token
      ).

      lo_request->set_header_field(
        i_name  = 'If-Match'
        i_value = '*'
      ).

      lo_request->set_header_field(
        i_name  = 'Content-Type'
        i_value = 'application/json'
      ).

      " Execute PATCH request
      TRY.
          DATA(lo_response_patch) = lo_http_client->execute( if_web_http_client=>patch ).
        CATCH cx_web_http_client_error.
*          CONTINUE.  " Skip this iteration if PATCH fails
      ENDTRY.

      " Check response
      DATA(lv_status) = lo_response_patch->get_status( ).
      DATA(lv_response_text) = lo_response_patch->get_text( ).

      IF lv_status-code = 200 OR lv_status-code = 204.
        " Success - Only add to update table if API PATCH was successful
*        APPEND VALUE #(
*          PurchaseRequisition     = lv_pr
*          PurchaseRequisitionItem = lv_item
*          BuyerCode              = lv_buyer_code
*          BuyerName              = lv_buyer_name
*          %control-BuyerCode     = if_abap_behv=>mk-on
*          %control-BuyerName     = if_abap_behv=>mk-on
*        ) TO lt_update.

      ELSE.
        " Log error or handle failure
        " You can add error handling here
        " Example: Add to failed or reported table
*        APPEND VALUE #(
*          PurchaseRequisition     = lv_pr
*          PurchaseRequisitionItem = lv_item
*          %msg = new_message_with_text(
*            severity = if_abap_behv_message=>severity-error
*            text     = |API PATCH failed: { lv_response_text }|
*          )
*        ) TO reported-prreport.

      ENDIF.

    ENDIF.
  ENDMETHOD.


    METHOD create_client.
   DATA(lo_dest) = cl_http_destination_provider=>create_by_url( url ).
    lo_client = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

  ENDMETHOD.
ENDCLASS.
