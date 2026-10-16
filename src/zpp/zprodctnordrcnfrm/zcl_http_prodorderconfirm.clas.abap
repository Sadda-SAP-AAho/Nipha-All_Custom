class ZCL_HTTP_PRODORDERCONFIRM definition
  public
  create public .

PUBLIC SECTION.

  TYPES: BEGIN OF tt_mfg_order_activites,
           Quantity TYPE p LENGTH 9 DECIMALS 3,
           Unit     TYPE erfme,
           Name     TYPE c LENGTH 40,
           Item     TYPE i,
         END OF tt_mfg_order_activites.


  TYPES: BEGIN OF tt_mfg_order_movements,
           Material          TYPE matnr,
           Description       TYPE maktx,
           Item              TYPE i,
           Quantity          TYPE menge_d,
           Plant             TYPE werks_d,
           StorageLocation   TYPE c LENGTH 4,
           Batch             TYPE charg_d,
           GoodsMovementType TYPE bwart,
           Unit              TYPE erfme,
         END OF tt_mfg_order_movements.

  TYPES: BEGIN OF tt_response,
           Plant              TYPE werks_d,
           ManufacturingOrder TYPE aufnr,
           Operation          TYPE c LENGTH 4,
           Sequence           TYPE plnfolge,
           PostingDate        TYPE c LENGTH 10,
           ConfirmationText   TYPE co_rtext,
           ManufacturingDate  TYPE c LENGTH 8,
           Confirmation       TYPE co_rueck,
           YieldQuantity      TYPE menge_d,
           WorkCenter         TYPE arbpl,
           ReworkQuantity     TYPE menge_d,
           ShiftDefinition    TYPE c LENGTH 2,
           _GoodsMovements    TYPE TABLE OF tt_mfg_order_movements WITH EMPTY KEY,
           _Activities        TYPE TABLE OF tt_mfg_order_activites WITH EMPTY KEY,
         END OF tt_response.


  INTERFACES if_http_service_extension .
  CLASS-METHODS postOrder
    IMPORTING
      VALUE(request) TYPE REF TO if_web_http_request
    RETURNING
      VALUE(message) TYPE string .

  CLASS-METHODS validate
    IMPORTING
      filled_details TYPE tt_response
    RETURNING
      VALUE(message) TYPE string.

  CLASS-METHODS convertISTSeparate
    IMPORTING
      sdate        TYPE d
      stime        TYPE t
    RETURNING
      VALUE(idate) TYPE d.


protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_PRODORDERCONFIRM IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>post ).
        response->set_text( postOrder( request ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD validate.

    DATA: from_date TYPE d,
          to_date   TYPE d.
********************************************************

*    IF filled_details-postingdate IS INITIAL.
*      message = |Error: Posting date is mandatory| .
*      RETURN.
*    ENDIF.

DATA lv_today_ist TYPE d.

" Get today's date in IST
lv_today_ist = convertISTSeparate(
                  sdate = cl_abap_context_info=>get_system_date( )
                  stime = cl_abap_context_info=>get_system_time( )
               ).

" Posting date mandatory check
IF filled_details-postingdate IS INITIAL.
  message = |Error: Posting date is mandatory|.
  RETURN.
ENDIF.

" Posting date must be today's IST date
*IF filled_details-postingdate <> lv_today_ist.
*  message = |Error: Posting cant be done in future date|.
*  RETURN.
*ENDIF.

***********************************************************
    IF filled_details-confirmationtext IS INITIAL AND filled_details-plant EQ 'BB02'
        or filled_details-plant EQ 'BB03' or filled_details-plant EQ 'HV02'.
      message = |Error: Internal Document Number is mandatory| .
      RETURN.
    ENDIF.


    DATA: mfgorder          TYPE aufnr.
    mfgorder = |{ filled_details-manufacturingorder ALPHA = IN }|.


    SELECT SINGLE FROM I_ProductionOrder
    FIELDS OrderConfirmedYieldQty, OrderPlannedTotalQty
    WHERE ProductionOrder = @mfgorder
    INTO @DATA(order).

***********************************
    IF ( order-OrderConfirmedYieldQty + filled_details-yieldquantity ) > order-OrderPlannedTotalQty.
*    IF ( order-OrderConfirmedYieldQty + filled_details-_goodsmovements[ 1 ]-quantity ) > order-OrderPlannedTotalQty.
      message = |Error: Yield quantity exceeds the planned total quantity for manufacturing order|.
      RETURN.
    ENDIF.
***********************************

      READ  TABLE filled_details-_goodsmovements INTO DATA(output_product) WITH KEY goodsmovementtype = '101'.

      SELECT SINGLE FROM I_ProductStorage_2
        FIELDS MinRemainingShelfLife,TotalShelfLife
        WHERE Product = @output_product-material
              AND MinRemainingShelfLife IS NOT INITIAL
              AND TotalShelfLife IS NOT INITIAL
        INTO @DATA(res).

      IF res IS NOT INITIAL.

        IF filled_details-manufacturingdate IS INITIAL.
          message = |Error: Manufacturing date is mandatory for material { output_product-material }| .
          RETURN.
        ENDIF.

*    get IST date and time for insertion
        DATA(curr_date_ist) = convertISTSeparate( sdate = cl_abap_context_info=>get_system_date( ) stime = cl_abap_context_info=>get_system_time( ) ).
        to_date = curr_date_ist + res-MinRemainingShelfLife.
        from_date = to_date - res-TotalShelfLife.

        IF filled_details-manufacturingdate < from_date OR filled_details-manufacturingdate > to_date.
          message = |Error: Manufacturing date is not within the valid range for material { output_product-material }. Valid range is from { to_date } to { from_date }|.
          RETURN.
        ENDIF.
      ENDIF.
*    ENDIF.

    LOOP AT filled_details-_goodsmovements INTO DATA(ls_goodsmovement) WHERE quantity GT 0.

      IF ls_goodsmovement-plant IS INITIAL.
        message = |Error: Plant is mandatory for material { ls_goodsmovement-material }| .
        RETURN.
      ELSEIF ls_goodsmovement-storagelocation IS INITIAL.
        message = |Error: Storage location is mandatory for material { ls_goodsmovement-material }| .
      ENDIF.

      IF ls_goodsmovement-goodsmovementtype NE '101' AND ls_goodsmovement-goodsmovementtype NE '531'.

*       BASE Unit
        SELECT SINGLE FROM I_StockQuantityCurrentValue_2( P_DisplayCurrency = 'INR' ) AS Stock
           FIELDS  SUM( Stock~MatlWrhsStkQtyInMatlBaseUnit ) AS StockQty
           WHERE Stock~ValuationAreaType = '1'
           AND stock~InventoryStockType = '01'
           AND stock~Product = @ls_goodsmovement-material
           AND stock~Plant = @ls_goodsmovement-plant
           AND stock~StorageLocation = @ls_goodsmovement-storagelocation
           AND stock~Batch = @ls_goodsmovement-batch
           INTO @DATA(result).

*************************************
*       Entry Unit
        SELECT SINGLE FROM I_MfgOrderComponentWithStatus
        FIELDS MaterialQtyToBaseQtyNmrtr , MaterialQtyToBaseQtyDnmntr
        WHERE material = @ls_goodsmovement-material
        AND plant = @ls_goodsmovement-plant
        AND ManufacturingOrder = @mfgorder
        INTO @DATA(quantity).

        DATA: lv_conv_qty TYPE p DECIMALS 3.
        lv_conv_qty = ls_goodsmovement-quantity * quantity-MaterialQtyToBaseQtyNmrtr /  quantity-MaterialQtyToBaseQtyDnmntr.

***************************************



        IF result IS INITIAL.
          message = |Error: Material { ls_goodsmovement-material ALPHA = OUT } not found in stock for plant { ls_goodsmovement-plant } and storage location { ls_goodsmovement-storagelocation } Quantity { ls_goodsmovement-quantity }|.
          RETURN.
        ELSEIF result < lv_conv_qty.
          message = |Error: Insufficient stock for material { ls_goodsmovement-material ALPHA = OUT } in plant { ls_goodsmovement-plant } and storage location { ls_goodsmovement-storagelocation } Quantity { ls_goodsmovement-quantity - result }|.
          RETURN.
        ENDIF.
      ELSE.

        SELECT SINGLE FROM I_Product AS Material
          FIELDS Material~Product, Material~IsBatchManagementRequired
          WHERE Material~Product = @ls_goodsmovement-material
          INTO @DATA(res1).

        IF res1-IsBatchManagementRequired  = 'X' AND ls_goodsmovement-batch IS INITIAL.
          message = |Error: Batch is mandatory for material { ls_goodsmovement-material }|.
          RETURN.
        ENDIF.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.


    METHOD convertISTSeparate.

      DATA: timestamp   TYPE timestampl,
            timestp_str TYPE string.
      timestamp = sdate && stime.

      CALL METHOD cl_abap_tstmp=>add
        EXPORTING
          tstmp   = timestamp
          secs    = 19800 " 5 hours 30 minutes in seconds
        RECEIVING
          r_tstmp = timestamp.

      timestp_str = timestamp.

      idate = timestp_str+0(8). " Extracting date part
    ENDMETHOD.


  METHOD postOrder.

    DATA filled_details TYPE tt_response.

    TRY.
        xco_cp_json=>data->from_string( request->get_text( ) )->write_to( REF #( filled_details ) ).
        REPLACE ALL OCCURRENCES OF '-' IN filled_details-postingdate WITH ''.

        message = validate( filled_details ).
        IF message IS NOT INITIAL.
          RETURN.
        ENDIF.

************added plant to save the data in plant*************************
        DATA: mfgorder          TYPE aufnr,
              mfgorderoperation TYPE c LENGTH 4,
              plant             TYPE c LENGTH 4.
        plant =   filled_details-plant.
        mfgorder = |{ filled_details-manufacturingorder ALPHA = IN }|.
        mfgorderoperation = |{ filled_details-operation ALPHA = IN }|.

        DATA lt_confirmation TYPE TABLE FOR CREATE i_productionordconfirmationtp.
        DATA lt_matldocitm TYPE TABLE FOR CREATE i_productionordconfirmationtp\_prodnordconfmatldocitm.
        FIELD-SYMBOLS <ls_matldocitm> LIKE LINE OF lt_matldocitm.
        DATA lt_target LIKE <ls_matldocitm>-%target.

        " read proposals and corresponding times for given quantity
        READ ENTITIES OF i_productionordconfirmationtp
         ENTITY productionorderconfirmation
         EXECUTE getconfproposal
         FROM VALUE #( (
                ConfirmationGroup = |{ filled_details-confirmation ALPHA = IN }|
                %param-ConfirmationYieldQuantity = 0
                %param-OrderOperation = filled_details-operation
                %param-Sequence = filled_details-sequence
          ) )
         RESULT DATA(lt_confproposal)
         REPORTED DATA(lt_reported_conf).

        LOOP AT lt_confproposal ASSIGNING FIELD-SYMBOL(<ls_confproposal>).
          APPEND INITIAL LINE TO lt_confirmation ASSIGNING FIELD-SYMBOL(<ls_confirmation>).
          <ls_confirmation>-%cid = zcl_uniqidgen=>getcid( ).
          <ls_confirmation>-%data = CORRESPONDING #( <ls_confproposal>-%param ).
          <ls_confirmation>-%data-WorkCenter = filled_details-workcenter.
          <ls_confirmation>-PostingDate = filled_details-postingdate.
*          <ls_confirmation>-ConfirmationReworkQuantity = filled_details-reworkquantity.
          <ls_confirmation>-ConfirmationYieldQuantity = filled_details-yieldquantity.
          <ls_confirmation>-ConfirmationText = filled_details-ConfirmationText.
          <ls_confirmation>-OrderOperation = mfgorderoperation.
*          <ls_confirmation>-%data-ShiftDefinition = filled_details-shiftdefinition .
*          <ls_confirmation>-%data-ShiftGrouping = '01' .



*
          LOOP AT filled_details-_activities INTO DATA(act).
            IF act-item = 1.
              <ls_confirmation>-%data-OpConfirmedWorkQuantity1 = act-quantity.
              <ls_confirmation>-%data-OpWorkQuantityUnit1 = act-unit.
            ELSEIF act-item = 2.
              <ls_confirmation>-%data-OpConfirmedWorkQuantity2 = act-quantity.
              <ls_confirmation>-%data-OpWorkQuantityUnit2 = act-unit.
            ELSEIF act-item = 3.
              <ls_confirmation>-%data-OpConfirmedWorkQuantity3 = act-quantity.
              <ls_confirmation>-%data-OpWorkQuantityUnit3 = act-unit.
            ELSEIF act-item = 4.
              <ls_confirmation>-%data-OpConfirmedWorkQuantity4 = act-quantity.
              <ls_confirmation>-%data-OpWorkQuantityUnit4 = act-unit.
            ELSEIF act-item = 5.
              <ls_confirmation>-%data-OpConfirmedWorkQuantity5 = act-quantity.
              <ls_confirmation>-%data-OpWorkQuantityUnit5 = act-unit.
            ELSEIF act-item = 6.
              <ls_confirmation>-%data-OpConfirmedWorkQuantity6 = act-quantity.
              <ls_confirmation>-%data-OpWorkQuantityUnit6 = act-unit.
            ENDIF.
          ENDLOOP.

          " read proposals for corresponding goods movements for proposed quantity
          READ ENTITIES OF i_productionordconfirmationtp
            ENTITY productionorderconfirmation
            EXECUTE getgdsmvtproposal
            FROM VALUE #( ( confirmationgroup               = <ls_confproposal>-confirmationgroup
                            %param-confirmationyieldquantity = <ls_confproposal>-%param-confirmationyieldquantity
                            %param-orderoperation           = <ls_confproposal>-%param-orderoperation
                            %param-sequence                 = <ls_confproposal>-%param-sequence
                            ) )
            RESULT DATA(lt_gdsmvtproposal)
            REPORTED DATA(lt_reported_gdsmvt).

          CHECK lt_gdsmvtproposal[] IS NOT INITIAL.

          CLEAR lt_target[].

          IF lt_gdsmvtproposal IS INITIAL.
            message = |Error: No goods movement proposal found for the given confirmation details.|.
            RETURN.
          ENDIF.


          DATA: reserv_items TYPE STANDARD TABLE OF D_ProdnOrdConfGetGdsMvtPrpslR WITH EMPTY KEY.

          LOOP AT lt_gdsmvtproposal ASSIGNING FIELD-SYMBOL(<ls_gdsmvtproposal1>).
            APPEND CORRESPONDING #( <ls_gdsmvtproposal1>-%param ) TO reserv_items.
          ENDLOOP.


          ASSIGN lt_gdsmvtproposal[ ConfirmationGroup = <ls_confproposal>-confirmationgroup ] TO FIELD-SYMBOL(<ls_gdsmvtproposal>).

          LOOP AT filled_details-_goodsmovements INTO DATA(filled_details_goodsmovement) WHERE quantity > 0.
            APPEND INITIAL LINE TO lt_target ASSIGNING FIELD-SYMBOL(<ls_target>).

            <ls_target> = CORRESPONDING #( <ls_gdsmvtproposal>-%param ).
            <ls_target>-%cid = zcl_uniqidgen=>getcid( ).
            <ls_target>-Material = filled_details_goodsmovement-material.
            <ls_target>-StorageLocation = filled_details_goodsmovement-storagelocation.
            <ls_target>-EntryUnit = filled_details_goodsmovement-unit.
            <ls_target>-GoodsmovementType = filled_details_goodsmovement-goodsmovementtype.
            <ls_target>-QuantityInEntryUnit = filled_details_goodsmovement-quantity.
            <ls_target>-Batch = filled_details_goodsmovement-batch.

            READ TABLE reserv_items INTO DATA(reserv_item) WITH KEY Material = filled_details_goodsmovement-material
                                                                    StorageLocation = filled_details_goodsmovement-storagelocation
                                                                    Plant = filled_details_goodsmovement-Plant
                                                                    GoodsmovementType = filled_details_goodsmovement-goodsmovementtype.

            IF sy-subrc = 0.
              <ls_target>-Reservation = reserv_item-Reservation.
              <ls_target>-ReservationItem = reserv_item-ReservationItem.
            ELSE.
              <ls_target>-Reservation = ''.
              <ls_target>-ReservationItem = ''.
            ENDIF.

            CLEAR: reserv_item.

            IF filled_details_goodsmovement-goodsmovementtype = '101' OR
               filled_details_goodsmovement-goodsmovementtype = '102'.
              <ls_target>-ManufactureDate = filled_details-manufacturingdate.
              <ls_target>-OrderItem = '1'.
            ELSEIF filled_details_goodsmovement-goodsmovementtype = '261' OR
                   filled_details_goodsmovement-goodsmovementtype = '262' OR
                   filled_details_goodsmovement-goodsmovementtype = '531' OR
                   filled_details_goodsmovement-goodsmovementtype = '532'.
              <ls_target>-GoodsMovementRefDocType = ''.
              <ls_target>-InventorySpecialStockType = ''.
              <ls_target>-InventoryUsabilityCode = ''.
              <ls_target>-OrderItem = ''.
            ENDIF.


          ENDLOOP.


          APPEND VALUE #( %cid_ref = <ls_confirmation>-%cid
          %target = lt_target
          confirmationgroup = <ls_confproposal>-confirmationgroup ) TO lt_matldocitm.
        ENDLOOP.

        MODIFY ENTITIES OF i_productionordconfirmationtp
         ENTITY productionorderconfirmation
         CREATE FROM lt_confirmation
         CREATE BY \_prodnordconfmatldocitm FROM lt_matldocitm
         MAPPED DATA(lt_mapped)
         FAILED DATA(lt_failed)
         REPORTED DATA(lt_reported).



        IF lt_failed IS INITIAL.
          COMMIT ENTITIES BEGIN
             RESPONSE OF i_productionordconfirmationtp
             FAILED DATA(ls_save_failed)
             REPORTED DATA(ls_save_reported).
          IF ls_save_failed IS INITIAL AND lines( lt_mapped-productionorderconfirmation ) > 0.
            LOOP AT lt_mapped-productionorderconfirmation ASSIGNING FIELD-SYMBOL(<fs_migo>).
              CONVERT KEY OF i_productionordconfirmationtp FROM <fs_migo>-%pid TO <fs_migo>-%key.
              DATA(conf_count) = <fs_migo>-%key-ConfirmationCount.
            ENDLOOP.
          ELSE.
            ROLLBACK ENTITIES.
          ENDIF.
          COMMIT ENTITIES END.
        ENDIF.

        IF conf_count IS NOT INITIAL.
          message = |Confirmation successful for manufacturing order { mfgorder } and operation { mfgorderoperation } with confirmation number { conf_count }. Document Number Posted Successfully.|.
        ELSE.
          " Handle errors
          DATA lv_error TYPE string.

          IF lines( ls_save_reported-productionorderconfirmation ) > 0.
            message = |Error: { sy-msgid } { sy-msgno }|.
          ENDIF.

          LOOP AT ls_save_reported-productionorderconfirmation ASSIGNING FIELD-SYMBOL(<fs_error>).
            message =  |Error: { <fs_error>-%msg->if_message~get_text( ) } |.
          ENDLOOP.

          LOOP AT ls_save_reported-prodorderconfmatldocitem ASSIGNING FIELD-SYMBOL(<fs_error4>).
            message =  |Error: { <fs_error4>-%msg->if_message~get_text( ) } |.
          ENDLOOP.

          LOOP AT lt_reported-prodorderconfmatldocitem ASSIGNING FIELD-SYMBOL(<fs_error1>).
            message = |Error: { <fs_error1>-%msg->if_message~get_text( ) } |.
          ENDLOOP.

          LOOP AT lt_reported-productionorderconfirmation ASSIGNING FIELD-SYMBOL(<fs_error3>).
            message =  |Error: { <fs_error3>-%msg->if_message~get_text( ) } |.
          ENDLOOP.
        ENDIF.


        TYPES: BEGIN OF ty_frontend,
                 message            TYPE string,
                 manufacturingorder TYPE aufnr,
                 operation          TYPE c LENGTH 4,
                 confirmation       TYPE string,
               END OF ty_frontend.

        DATA(ls_front) = VALUE ty_frontend(
             message            = message
             manufacturingorder = mfgorder
             operation          = mfgorderoperation
             confirmation       = conf_count
          ).


        message = /ui2/cl_json=>serialize( data = ls_front ).

        REPLACE ALL OCCURRENCES OF 'MANUFACTURINGORDER' IN message WITH 'ManufacturingOrder'.
        REPLACE ALL OCCURRENCES OF 'OPERATION' IN message WITH 'Operation'.
        REPLACE ALL OCCURRENCES OF 'CONFIRMATION' IN message WITH 'Confirmation'.
        REPLACE ALL OCCURRENCES OF 'MESSAGE' IN message WITH 'message'.

      CATCH cx_root INTO DATA(lx_root).
        message = |General Error: { lx_root->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
