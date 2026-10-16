CLASS zcl_mail DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MAIL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


 DATA(bsendmail) = abap_true.

    IF bsendmail = abap_true.

      TYPES: BEGIN OF ty_mail,
               name  TYPE string,
               email TYPE string,
             END OF ty_mail.

      DATA(ls_mail) = VALUE ty_mail(
        name  = 'Vivek Kumar'
        email = 'vivek.kumar@sgnsoftware.com'
      ).

      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).

          lo_mail->set_sender( 'do.not.reply@my405896.mail.s4hana.cloud.sap' ).
*          lo_mail->set_sender( 'do.not.reply@my416394.mail.s4hana.cloud.sap' ) .
          lo_mail->add_recipient( CONV #( ls_mail-email ) ).

          lo_mail->set_subject( |Test mail - { ls_mail-name }| ).

          DATA(lv_body) =
            |<p>Date: { cl_abap_context_info=>get_system_date( ) DATE = ENVIRONMENT }</p>| &&
            |<p>Dear { ls_mail-name },</p>| &&
            |<p>We request to quote for the below RFQ:</p>| &&
            |<p><b>RFQ Number:</b> 123456789</p>| &&
            |<p>Please find the RFQ with all related information attached.</p>| &&
            |<p>Best Regards,</p>| &&
            |<p>Procurement Team</p>|.

          lo_mail->set_main(
            cl_bcs_mail_textpart=>create_text_html( lv_body )
          ).

          DATA(lo_status) = lo_mail->send( ).

          lo_status->get_email_status(
            IMPORTING
              es_mail_status = DATA(ls_status)
          ).

*          out->write( |Mail status: { ls_status-status }| ).
          out->write( |Mail status: { ls_status-send_status }| ).

        CATCH cx_bcs_mail INTO DATA(lx_mail).
          out->write( lx_mail->get_text( ) ).
      ENDTRY.

    ENDIF.

*  --------------------------------------------------------------------------------------------------------------------------------------------------------------

*  data : bsendmail tyPE c leNGTH 1.
*bsendmail = 'X' .
*  IF bsendmail = abap_true.
*          TYPES: BEGIN OF ty_file,
*                   filename    TYPE string,
*                   filecontent TYPE xstring,
*                 END OF ty_file.
*
*          DATA: lt_final TYPE TABLE OF ty_file.
*
**          ENDIF.
*          TYPES:BEGIN OF t_mail,
*                  purchasemail TYPE string,
*                  name         TYPE string,
*                  email        TYPE string,
*                END OF t_mail.
*
*          DATA: ls_mail TYPE t_mail.
*
*
*              ls_mail-purchasemail = 'vivek.kumar@sgnsoftware.com'   .
*              ls_mail-name         = 'Vivek Kumar' .
*              ls_mail-email        = 'vivek.kumar@sgnsoftware.com'.
*
*
*
*
*
*
*
*          try.
*
**              LOOP AT lt_mail INTO DATA(ls_mail).
*          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
**          lo_mail->set_sender( CONV #( ls_mail-purchasemail ) ).
*          lo_mail->set_sender( 'do.not.reply@my416394.mail.s4hana.cloud.sap' ) .
*
*          lo_mail->add_recipient( CONV #( ls_mail-email ) ).
*          lo_mail->add_recipient( iv_address = 'vivek.kumar@sgnsoftware.com' iv_copy = cl_bcs_mail_message=>cc ).
**                lo_mail->set_subject( |Request for Quotation { rfqno  }-{ ls_mail-companycodename }| ).
**          lo_mail->set_subject( |Request for Quotation { accountingdocument  }-{ ls_mail-name }| ).
*          lo_mail->set_subject( |Test mail -{ ls_mail-name }| ).
**              lo_mail->set_importance( cl_bcs_mail_message=>importance-low ).
**              lo_mail->set_sensitivity( cl_bcs_mail_message=>sensitivity-confidential ).
**              lo_mail->set_additional_mime_headers( VALUE #( ( field_name = 'Additional_Header' field_body = 'Header_Body' ) ) ).
*          DATA(lv_body) =
*          |<p>Date: { cl_abap_context_info=>get_system_date(  ) DATE = ENVIRONMENT } </p>| &&
*          |<p>Dear { ls_mail-name },</p>| &&
*          |<p>We request to quote for the below RFQ:</p>| &&
**                |<p><b>RFQ Number:</b> { rfqno }</p>| &&
**          |<p><b>RFQ Number:</b> { accountingdocument }</p>| &&
*          |<p><b>RFQ Number:</b> 123456789</p>| &&
*          |<p>Please find the RFQ with all related information attached herewith.</p>| &&
*          |<p>Your quote should state the RFQ number stated above.</p>| &&
**                |<p>Please note that your quote should be submitted to us by { ls_mail-deadlinedate DATE = ENVIRONMENT }.</p>| &&
*          |<p>Please note that your quote should be submitted to us by { ls_mail-name  }.</p>| &&
*          |<p>Best Regards,</p>| &&
*          |<p>{ ls_mail-name },</p>| &&
*          |<p>Procurement Team.</p>|.
*
*          lo_mail->set_main( cl_bcs_mail_textpart=>create_text_html( lv_body ) ).
*
*          DATA lv_xstring TYPE xstring.
*
*          DATA(lo_mail_status_monitor) = lo_mail->send( ).
*
*          lo_mail_status_monitor->get_email_status(
*            IMPORTING
*              es_mail_status         = DATA(ls_mail_status)
*              et_recipients_statuses = DATA(lt_recipients_statuses) ).
*
**              ENDLOOP.
*
*        CATCH cx_bcs_mail INTO DATA(lx_mail).
*
*
*    ENDTRY..
*          DATA(lv_original_xstring) = xco_cp=>string( result12
**  )->as_xstring( xco_cp_binary=>text_encoding->base64
*            )->as_xstring( xco_cp_binary=>text_encoding->base64
*            )->value.
*
*          TRY.
*              lo_mail->add_attachment(
*                cl_bcs_mail_binarypart=>create_instance(
*                  iv_content      = lv_original_xstring
*                  iv_content_type = 'application/pdf'
*                  iv_filename     = 'Document.pdf'
*
*                )
*              ).
*            CATCH cx_bcs_mail INTO DATA(lx_bcs).
*              " Handle BCS exception (e.g., log error or show message)
*          ENDTRY.

*          LOOP AT lt_final INTO DATA(ls_final).
*data ls_final tyPE xstring.
*ls_final = 'JVBERi0xLjYNJeLjz9MNCjExIDAgb2JqCjw8L0ZpbHRlci9GbGF0ZURlY29kZS9GaXJzdCA5L0xlbmd0aCAxNjgvTiAyL1R5cGUvT2JqU3RtPj5zdHJlYW0NCmjePE7bCoJAEP2V+YJmNzETZB8yBIlIzIdAJGwdwkA33BXs75s16GHOHDgXTgACQghCSBJMzTw6kHjqO1uHLJQNVp83YdE+ySq1WkZHo7Ow9zKeqevbg' &&
*'1lqsRHgbye3jFHM2HB'.
*            TRY.
*                lo_mail->add_attachment(
*                  cl_bcs_mail_binarypart=>create_instance(
**                    iv_content      = ls_final-filecontent
*                    iv_content      = ls_final
*                    iv_content_type = 'application/pdf'
*                    iv_filename     = 'ABC'
*
*                  )
*                ).
*              CATCH cx_bcs_mail INTO lx_bcs.
*                " Handle BCS exception (e.g., log error or show message)
*            ENDTRY.
**          ENDLOOP.
*
*          DATA(lo_mail_status_monitor) = lo_mail->send( ).
*
*          lo_mail_status_monitor->get_email_status(
*            IMPORTING
*              es_mail_status         = DATA(ls_mail_status)
*              et_recipients_statuses = DATA(lt_recipients_statuses) ).
*
**              ENDLOOP.
*
*        CATCH cx_bcs_mail INTO DATA(lx_mail).
*
*      ENDTRY.

*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

*    ENDIF.

  ENDMETHOD.
ENDCLASS.
