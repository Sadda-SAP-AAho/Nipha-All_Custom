CLASS lhc_zr_irn DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zrirn
        RESULT result,
      generatedata FOR MODIFY
        IMPORTING keys FOR ACTION zrirn~generatedata RESULT result.
ENDCLASS.

CLASS lhc_zr_irn IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD generatedata.


    DATA(plant) = keys[ 1 ]-%param-plant.
    DATA(documentdate) = keys[ 1 ]-%param-documentdate.


    SELECT SINGLE plant
          FROM zuser_item
          WHERE plant  = @plant
            AND userid = @sy-uname
          INTO @DATA(lv_plant).

    IF lv_plant IS INITIAL.
      APPEND INITIAL LINE TO failed-zrirn.

      APPEND VALUE #(
                   %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-warning
                        text     = |You are not authorized for Plant { plant }|
                     )
             ) TO reported-zrirn.

      RETURN.
    ENDIF.

    SELECT FROM i_billingdocumentitem AS a
       INNER JOIN i_billingdocument AS c ON a~billingdocument = c~billingdocument
       FIELDS a~companycode, a~billingdocument, a~billingdocumentdate, a~plant, a~distributionchannel, a~billingdocumenttype, c~documentreferenceid
       WHERE a~plant = @plant AND a~billingdocumentdate = @documentdate AND c~billingdocumentiscancelled = ''
             AND a~billingdocument NOT IN ( SELECT billingdocument FROM zr_irn WHERE billingdocument IS NOT INITIAL )
             AND a~billingdocumenttype NOT IN ( 'JSN'  , 'JDC'  )
             AND ( a~billingdocumenttype EQ 'F8' OR c~accountingpostingstatus EQ 'C' )
       ORDER BY a~billingdocument
       INTO TABLE @DATA(lt).

    DELETE ADJACENT DUPLICATES FROM lt COMPARING billingdocument companycode.

    LOOP AT lt INTO DATA(wa).

      SELECT SINGLE FROM i_billingdocumentpartner AS a
        INNER JOIN i_customer AS b ON a~customer = b~customer
        FIELDS a~customer,b~customername
        WHERE a~billingdocument = @wa-billingdocument
              AND a~partnerfunction = 'RE'
        INTO @DATA(buyer) PRIVILEGED ACCESS.

      MODIFY ENTITIES OF zr_irn IN LOCAL MODE
         ENTITY zrirn
         CREATE FIELDS (
                         billingdocument
                         companycode
                         plant
                         billingdocumentdate
                         billingdocumenttype
                         distributionchannel
                         documentreferenceid
                         partycode
                         partyname
              )
         WITH VALUE #( (
                     %cid                = zcl_uniqidgen=>getcid( )
                     billingdocument     = wa-billingdocument
                     companycode         = wa-companycode
                     plant               = wa-plant
                     billingdocumentdate = wa-billingdocumentdate
                     billingdocumenttype = wa-billingdocumenttype
                     distributionchannel = wa-distributionchannel
                     documentreferenceid = wa-documentreferenceid
                     partycode           = buyer-customer
                     partyname           = buyer-customername
              ) )
          REPORTED DATA(drc_reported)
          FAILED   DATA(drc_failed)
          MAPPED   DATA(drc_mapped).

      IF drc_failed IS NOT INITIAL.
        APPEND VALUE #(
              %msg = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = 'Error while generating DRC data for Billing Document ' && wa-billingdocument
                     )
             ) TO reported-zrirn.
        EXIT.

      ENDIF.

    ENDLOOP.

    APPEND VALUE #(
            %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-success
                      text     = |DRC data generation completed successfully for Plant { plant } on Document Date { documentdate }|
                   )
           ) TO reported-zrirn.



  ENDMETHOD.
ENDCLASS.
