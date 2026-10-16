    CLASS lhc_gateentryheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
      PRIVATE SECTION.
        CONSTANTS: BEGIN OF lc_cancelled,
                     yes TYPE abap_boolean VALUE 'X',
                     no  TYPE abap_boolean VALUE '',
                   END OF lc_cancelled.

        METHODS get_instance_features FOR FEATURES
          IMPORTING keys REQUEST requested_features FOR gateentryheader RESULT result.

        METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
          IMPORTING keys REQUEST requested_authorizations FOR gateentryheader RESULT result.

        METHODS cancelgateentry FOR MODIFY
          IMPORTING keys FOR ACTION gateentryheader~cancelgateentry RESULT result.
        METHODS validatemandatory FOR VALIDATE ON SAVE
          IMPORTING keys FOR gateentryheader~validatemandatory.
        METHODS changevalues FOR DETERMINE ON MODIFY
          IMPORTING keys FOR gateentryheader~changevalues.
*    METHODS ReCalcTotals FOR MODIFY
*      IMPORTING keys FOR ACTION GateEntryHeader~ReCalcTotals.
        METHODS precheck_update FOR PRECHECK
          IMPORTING entities FOR UPDATE gateentryheader.
        METHODS precheck_create FOR PRECHECK
          IMPORTING entities FOR CREATE gateentryheader.
        METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
          IMPORTING REQUEST requested_authorizations FOR gateentryheader RESULT result.
        METHODS cancelmultiple FOR MODIFY
          IMPORTING keys FOR ACTION gateentryheader~cancelmultiple.
        METHODS calculate_duration FOR DETERMINE ON MODIFY
          IMPORTING keys FOR gateentryheader~calculate_duration.
        METHODS calculate_duration_time FOR DETERMINE ON MODIFY
          IMPORTING keys FOR gateentryheader~calculate_duration_time.



        METHODS is_update_allowed
          RETURNING VALUE(update_allowed) TYPE abap_boolean.

        METHODS earlynumbering_gateentrylines FOR NUMBERING
          IMPORTING entities FOR CREATE gateentryheader\_gateentrylines.

        METHODS earlynumbering_gateentryheader FOR NUMBERING
          IMPORTING entities FOR CREATE gateentryheader.


    ENDCLASS.

    CLASS lhc_gateentryheader IMPLEMENTATION.

      METHOD get_instance_authorizations.
        DATA: cancelled_requested TYPE abap_boolean.

        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
        ENTITY gateentryheader
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gateentryheaders)
        FAILED failed.

        CHECK gateentryheaders IS NOT INITIAL.

        cancelled_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on
    "    OR requested_authorizations-
                                      THEN abap_true ELSE abap_false ).

        LOOP AT gateentryheaders ASSIGNING FIELD-SYMBOL(<lfs_gateheader>).
          IF cancelled_requested = abap_true.
            IF is_update_allowed(  ) = abap_false.

              "          APPEND VALUE #( %tky = <lfs_gateheader>-%tky ) to failed-gateentryheader.

              APPEND VALUE #( "%tky = <lfs_gateheader>-%tky
                              %msg = new_message_with_text(
                                    severity = if_abap_behv_message=>severity-error
                                    text = 'No authorization to cancel'
                              ) ) TO reported-gateentryheader.

            ENDIF.
          ENDIF.
        ENDLOOP.

      ENDMETHOD.

      METHOD get_instance_features.
        " Fill the response table
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
        ENTITY gateentryheader
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gateentryheaders).

        result = VALUE #( FOR gateentryheader IN gateentryheaders
                            LET
                              is_cancelled = COND #( WHEN gateentryheader-cancelled = lc_cancelled-yes
                                                     THEN if_abap_behv=>fc-o-disabled
                                                     ELSE if_abap_behv=>fc-o-enabled  )
    "                            is_not_set_as_fav = COND #( WHEN contact-PbFavourite = lc_favourite-no
    "                                                        THEN if_abap_behv=>fc-o-disabled
    "                                                        ELSE if_abap_behv=>fc-o-enabled  )
                            IN
                                ( %tky                   = gateentryheader-%tky
                                  %action-cancelgateentry    = is_cancelled
                                   ) ).
        "                              %action-removeFavourite = is_not_set_as_fav ) ).

      ENDMETHOD.

      METHOD cancelgateentry.

*    validate the reference entry already exists
        DATA gateentryno TYPE string.

        LOOP AT keys INTO DATA(key2).
          gateentryno  = key2-gateentryno.
        ENDLOOP.

        SELECT SINGLE FROM zr_gateentryheader
            FIELDS ( entrytype )
            WHERE gateentryno = @gateentryno
            INTO @DATA(entrytype).


        SELECT SINGLE FROM zr_gateentrylines
        FIELDS ( gateentryno )
        WHERE documentno = @gateentryno
        INTO @DATA(refentry).

        IF refentry IS NOT INITIAL AND entrytype = 'RGP-IN'.

          APPEND VALUE #(
                         %msg = new_message_with_text(
                           severity = if_abap_behv_message=>severity-error
                           text = | Cannot Cancel Entry RGP-IN { refentry } | )
                           ) TO reported-gateentryheader.
          RETURN.


        ENDIF.

*    check that grn is done or not

        SELECT SINGLE FROM i_materialdocumentheader_2 AS mthead
        JOIN i_materialdocumentitem_2 AS mtdocitem
        ON mtdocitem~materialdocument = mthead~materialdocument AND mtdocitem~materialdocumentyear = mthead~materialdocumentyear
        FIELDS mthead~materialdocument, mthead~materialdocumentyear
        WHERE mthead~materialdocumentheadertext = @gateentryno AND mtdocitem~goodsmovementiscancelled = '' AND mtdocitem~goodsmovementtype = '101'
        INTO @DATA(grndoc).

        IF grndoc IS NOT INITIAL.
          APPEND VALUE #(
                         %msg = new_message_with_text(
                           severity = if_abap_behv_message=>severity-error
                           text = | GRN Already done. Cannot Cancel Entry | )
                           ) TO reported-gateentryheader.
          RETURN.

        ENDIF.


        " Set as Cancelled
        MODIFY ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader
             UPDATE
               FIELDS ( cancelled )
               WITH VALUE #( FOR key IN keys
                               ( %tky      = key-%tky
                                 cancelled = lc_cancelled-yes ) )
        FAILED failed
        REPORTED reported.

        " Fill the response table
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
        ENTITY gateentryheader
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(gateentryheaders).

        result = VALUE #( FOR gateentryheader IN gateentryheaders
                            ( %tky   = gateentryheader-%tky
                              %param = gateentryheader ) ).
      ENDMETHOD.

      METHOD earlynumbering_gateentrylines.
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader BY \_gateentrylines
            FIELDS ( gateitemno )
              WITH CORRESPONDING #( entities )
              RESULT DATA(gate_entry_lines)
            FAILED failed.


        LOOP AT entities ASSIGNING FIELD-SYMBOL(<gate_entry_header>).
          " get highest item from lines
          DATA(max_item_id) = REDUCE #( INIT max = CONV posnr( '000000' )
                                        FOR gate_entry_line IN gate_entry_lines USING KEY entity WHERE ( gateentryno = <gate_entry_header>-gateentryno )
                                        NEXT max = COND posnr( WHEN gate_entry_line-gateitemno > max
                                                               THEN gate_entry_line-gateitemno
                                                               ELSE max )
                                      ).
        ENDLOOP.

        "assign Gate Entry Item id
        LOOP AT <gate_entry_header>-%target ASSIGNING FIELD-SYMBOL(<gate_entry_line>).
          APPEND CORRESPONDING #( <gate_entry_line> ) TO mapped-gateentrylines ASSIGNING FIELD-SYMBOL(<mapped_gate_entry_line>).
          IF <gate_entry_line>-gateitemno IS INITIAL.
            max_item_id += 10.
            <mapped_gate_entry_line>-gateitemno = max_item_id.
          ENDIF.


        ENDLOOP.
      ENDMETHOD.

      METHOD earlynumbering_gateentryheader.


        LOOP AT entities ASSIGNING FIELD-SYMBOL(<gate_entry_header>).


          DATA: currentyear  TYPE string,
                currentmonth TYPE string,
                numyear      TYPE n LENGTH 4.


          currentyear  = <gate_entry_header>-gateindate+0(4).
          currentmonth = <gate_entry_header>-gateindate+4(2).
          numyear = currentyear.
          IF currentmonth >= '04'.  " April (04) to December (12)
            numyear = numyear.
          ELSE.
            numyear = numyear - 1.
          ENDIF.

          DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
          TRY.

              DATA interval TYPE c LENGTH 2.

              IF <gate_entry_header>-entrytype = 'PUR'.
                interval = '10'.
              ELSEIF <gate_entry_header>-entrytype = 'RGP-OUT'.
                interval = '20'.
              ELSEIF <gate_entry_header>-entrytype = 'RGP-IN'.
                interval = '30'.
              ELSEIF <gate_entry_header>-entrytype = 'NRGP'.
                interval = '40'.
              ELSEIF <gate_entry_header>-entrytype = 'WREF'.
                interval = '50'.
              ELSEIF <gate_entry_header>-entrytype = 'SALESRET'.
                interval = '60'.
              ENDIF.


              cl_numberrange_runtime=>number_get(
                EXPORTING
                  nr_range_nr = interval
                  toyear      = numyear
                  object      = 'ZGENO'
                IMPORTING
                  number      = DATA(nextnumber)
              ).
            CATCH cx_number_ranges INTO DATA(lx_number_ranges).
              numyear = numyear.
          ENDTRY.
          SHIFT nextnumber LEFT DELETING LEADING '0'.
        ENDLOOP.

        "assign Gate Entry no.
        APPEND CORRESPONDING #( <gate_entry_header> ) TO mapped-gateentryheader ASSIGNING FIELD-SYMBOL(<mapped_gate_entry_header>).
        IF <gate_entry_header>-gateentryno IS INITIAL.
          "      max_item_id += 10.
          <mapped_gate_entry_header>-gateentryno =  |{ <gate_entry_header>-plant }-{ nextnumber }|.
        ENDIF.


      ENDMETHOD.

      METHOD validatemandatory.
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader
            FIELDS ( vehicleno plant entrytype invoiceparty invoiceno invoicedate cancelled gateouttime gateintime )
              WITH CORRESPONDING #( keys )
              RESULT DATA(entryheaders).

        LOOP AT entryheaders INTO DATA(entryheader).

          IF ( entryheader-entrytype = 'PUR' OR entryheader-entrytype = 'WREF' OR entryheader-entrytype = 'NRGP' OR entryheader-entrytype = 'RGP-IN' OR entryheader-entrytype = 'RGP-OUT' or entryheader-entrytype = 'SALESRET' ) AND entryheader-gateouttime
IS NOT INITIAL.
            CONTINUE.
          ELSEIF entryheader-entrytype NE 'PUR' AND entryheader-entrytype NE 'WREF' AND entryheader-entrytype NE 'NRGP' AND entryheader-entrytype NE 'RGP-OUT' AND   entryheader-entrytype NE 'SALESRET' AND entryheader-entrytype NE 'RGP-IN'  AND
entryheader-gateintime IS NOT INITIAL.
            CONTINUE.
          ELSEIF entryheader-cancelled = 'X'.
            CONTINUE.
          ENDIF.

          IF entryheader-invoiceno IS NOT INITIAL.
*          IF entryHeader-InvoiceDate IS NOT INITIAL.
            DATA: currentyear  TYPE string,
                  currentmonth TYPE string,
                  currentdate  TYPE string,
                  fystart      TYPE string,
                  fyend        TYPE string,
                  numyear      TYPE i.

            currentyear  = entryheader-entrydate+0(4). "InvoiceDate
            currentmonth = entryheader-entrydate+4(2). "InvoiceDate
            currentdate  = entryheader-entrydate+6(2). "InvoiceDate
            numyear = currentyear.
            IF currentmonth >= '04'.  " April (04) to December (12)
              fystart = currentyear && '0401'.   " YYYY-04-01
              numyear = numyear + 1.
              fyend   = numyear && '0331'.  " (YYYY+1)-03-31
            ELSE.  " January (01) to March (03)
              numyear = numyear - 1.
              fystart = numyear && '0401'.  " (YYYY-1)-04-01
              fyend   = currentyear && '0331'.  " YYYY-03-31
            ENDIF.

*            current companycode
*            SELECT SINGLE FROM I_PurchaseOrderAPI01 AS pur
*            FIELDS pur~PurchasingOrganization
*            WHERE pur~PurchaseOrder = @entryHeader-RefDocNo
*            INTO @DATA(CompanyCode).
*
*
*            SELECT SINGLE FROM I_PurchaseOrderAPI01 AS pur
*            JOIN ZR_GateEntryLines AS EntryLines ON EntryLines~DocumentNo = pur~PurchaseOrder
*            JOIN ZR_GateEntryHeader AS EntryHeader ON EntryLines~GateEntryNo = EntryHeader~GateEntryNo
*            FIELDS pur~PurchasingOrganization
*            WHERE EntryHeader~InvoiceNo = @entryHeader-InvoiceNo AND pur~PurchasingOrganization = @CompanyCode
*                 AND EntryHeader~EntryDate BETWEEN @fyStart AND @fyEnd AND EntryHeader~InvoiceParty = @entryheader-InvoiceParty
**                 AND EntryHeader~InvoiceDate BETWEEN @fyStart AND @fyEnd AND EntryHeader~InvoiceParty = @entryheader-InvoiceParty
*            INTO @DATA(CompanyCode2).
*
*            IF CompanyCode2 IS NOT INITIAL.
*              APPEND VALUE #( %tky = entryheader-%tky ) TO failed-gateentryheader.
*
*              APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                         %msg = new_message_with_text(
*                                  severity = if_abap_behv_message=>severity-error
*                                  text = 'Party Bill No already used within the Organisation in a Year'
*                         ) ) TO reported-gateentryheader.
*            ENDIF.
            RETURN.
          ENDIF.

*
*        select from ZR_GateEntryHeader
*        fields GateEntryNo
*        where InvoiceNo = @entryHeader-InvoiceNo

          IF entryheader-vehicleno = ''.
            APPEND VALUE #( %tky = entryheader-%tky ) TO failed-gateentryheader.

            APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text = 'Vehicle No. is mandatory'
                            ) ) TO reported-gateentryheader.
            RETURN.

          ELSEIF entryheader-invoiceparty = '' AND entryheader-entrytype = 'PUR' .
            APPEND VALUE #( %tky = entryheader-%tky ) TO failed-gateentryheader.

            APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text = 'Invoicing Party is mandatory'
                            ) ) TO reported-gateentryheader.
            RETURN.
          ENDIF.

          DATA inv_party TYPE c LENGTH 10.

          inv_party = |{ entryheader-invoiceparty ALPHA = IN }|.

*          IF entryheader-EntryType = 'SALESRET'.
*              SELECT SINGLE FROM ZI_Customer
*              FIELDS InvoicingParty
*              WHERE InvoicingParty = @inv_party
*              INTO @DATA(lv_invoiceparty).
*          ELSEIF entryheader-EntryType = 'STO'.
*              SELECT SINGLE FROM ZI_PlantVH
*              FIELDS SendingPlant
*              WHERE SendingPlant = @inv_party
*              INTO @lv_invoiceparty.
*          ELSE.
*              SELECT SINGLE FROM ZI_InvoiceParty_VH
*              FIELDS InvoicingParty
*              WHERE InvoicingParty = @inv_party
*              INTO @lv_invoiceparty.
*          ENDIF.
*
*          IF entryheader-InvoiceParty NE '' AND lv_invoiceparty IS INITIAL .
*            APPEND VALUE #( %tky = entryheader-%tky ) TO failed-gateentryheader.
*
*            APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                            %msg = new_message_with_text(
*                                     severity = if_abap_behv_message=>severity-error
*                                     text = 'Invoicing Party is not valid'
*                            ) ) TO reported-gateentryheader.
*            RETURN.
*          ENDIF.
*
          IF entryheader-entrytype = 'PUR'.

            SELECT SINGLE FROM i_purchaseorderapi01
            FIELDS purchaseorderdate
            WHERE purchaseorder = @entryheader-refdocno
            INTO @DATA(lv_podate) PRIVILEGED ACCESS.

            IF lv_podate IS NOT INITIAL AND entryheader-gateindate < lv_podate.

              APPEND VALUE #( %tky = keys[ 1 ]-%tky
                                %msg = new_message_with_text(
                                         severity = if_abap_behv_message=>severity-error
                                         text = 'Gate In Date Should not be less than PO Date.'
                                ) ) TO reported-gateentryheader.
              APPEND VALUE #( %tky = entryheader-%tky ) TO failed-gateentryheader.
              RETURN.
            ENDIF.
          ENDIF.

*      if entryheader-Plant = ''.
*        APPEND VALUE #( %tky = entryheader-%tky ) to failed-gateentryheader.
*
*        APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                        %msg = new_message_with_text(
*                                 severity = if_abap_behv_message=>severity-error
*                                 text = 'Plant field is mandatory'
*                        ) ) TO reported-gateentryheader.
*      endif.
*      if entryheader-Entrytype NE 'PUR' AND entryheader-Entrytype NE 'SRET'
*          AND entryheader-Entrytype NE 'JOB' AND entryheader-Entrytype NE 'SALES'.
*        APPEND VALUE #( %tky = entryheader-%tky ) to failed-gateentryheader.

*        APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                        %msg = new_message_with_text(
*                                 severity = if_abap_behv_message=>severity-error
*                                 text = 'Entrytype must be of Inward type (PUR, SRET, JOB)'
*                        ) ) TO reported-gateentryheader.
*      endif.

        ENDLOOP.

      ENDMETHOD.


      METHOD changevalues.
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader
            FIELDS ( vehicleno plant entrytype )
              WITH CORRESPONDING #( keys )
              RESULT DATA(entryheaders).

        LOOP AT entryheaders INTO DATA(entryheader).

*    if entryheader-Grosswt is not INITIAL.
*
*       DATA(max_item_id) = '100001234'.
*
*      DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
*      TRY.
*        cl_numberrange_runtime=>number_get(
*          EXPORTING
*            nr_range_nr = '02'
*            object      = 'ZRGATENUM'
*          IMPORTING
*            number      = DATA(nextnumber)
*        ).
*      CATCH cx_number_ranges INTO DATA(lx_number_ranges).
*      ENDTRY.
*      SHIFT nextnumber LEFT DELETING LEADING '0'.
*      max_item_id = nextnumber.
**    ENDLOOP.
*
*      MODIFY ENTITIES OF ZR_GateEntryHeader IN LOCAL MODE
*        ENTITY GateEntryHeader
*        UPDATE
*        FIELDS ( Gateno ) WITH VALUE #( ( %tky = entryheader-%tky Gateno = nextnumber ) ).

          "assign Gate Entry no.
*    APPEND CORRESPONDING #( <entryheader> ) TO entryheaders ASSIGNING FIELD-SYMBOL(<mapped_gate_entry_header>).
*    IF <gate_entry_header>-Gateentryno IS INITIAL.
*"      max_item_id += 10.
*      <mapped_gate_entry_header>-Gateentryno = nextnumber.
*    ENDIF.
*    endif.

          DATA: gateoutwardval TYPE int1.
*      gateoutwardval = 1.
*      if entryheader-Entrytype = 'PUR' OR entryheader-Entrytype = 'SRET' OR entryheader-Entrytype = 'JOB'.
*      if entryheader-Entrytype = 'PUR' OR entryheader-Entrytype = 'RGP' OR entryheader-Entrytype = 'WREF'.
          gateoutwardval = 0.
*      else.
*        gateoutwardval = 1.
*      endif.
*      ENDIF.
          MODIFY ENTITIES OF zr_gateentryheader IN LOCAL MODE
            ENTITY gateentryheader
            UPDATE
            FIELDS ( gateoutward ) WITH VALUE #( ( %tky = entryheader-%tky gateoutward = gateoutwardval ) ).

        ENDLOOP.

      ENDMETHOD.

*  METHOD ReCalcTotals.
*    READ ENTITIES OF ZR_GateEntryHeader IN LOCAL MODE
*      ENTITY GateEntryHeader
*      FIELDS ( Totallines )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_gateentry).
*
*    LOOP AT lt_gateentry ASSIGNING FIELD-SYMBOL(<fs_gateentry>).
*      <fs_gateentry>-Totallines = 0.
*
*      READ ENTITIES OF ZR_GateEntryHeader IN LOCAL MODE
*        ENTITY GateEntryHeader
*        by \_GateEntryLines
*        FIELDS ( Gateitemno )
*        WITH VALUE #( ( %tky = <fs_gateentry>-%tky ) )
*        RESULT DATA(lt_lines).
*
*      LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).
*        <fs_gateentry>-Totallines = <fs_gateentry>-Totallines + 1.
*      ENDLOOP.
*
*
*      MODIFY ENTITIES OF ZR_GateEntryHeader IN LOCAL MODE
*        ENTITY GateEntryHeader
*        UPDATE
*        FIELDS ( Totallines ) WITH VALUE #( ( %tky = <fs_gateentry>-%tky Totallines = <fs_gateentry>-Totallines ) ).
*
*    ENDLOOP.
*
*    READ ENTITIES OF ZR_GateEntryHeader IN LOCAL MODE
*      ENTITY GateEntryHeader
*      FIELDS ( Totallines )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_gateentry1).
*
*"    MODIFY ENTITIES OF ZR_GateEntryHeader IN LOCAL MODE
*"    ENTITY GateEntryHeader
*"    UPDATE
*"    FIELDS ( Totallines )
*"    WITH VALUE #( FOR gateentry IN lt_gateentry ( %tky = gateentry-%tky Totallines = gateentry-Totallines ) ).
*
*
*  ENDMETHOD.

      METHOD precheck_update.
        LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
          CHECK <lfs_entity>-%control-drivername EQ '01' OR <lfs_entity>-%control-driverno EQ '01'.

          READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader
          FIELDS ( drivername driverno ) WITH VALUE #( ( %key = <lfs_entity>-%key ) )
          RESULT DATA(lt_gateheader).

          IF sy-subrc IS INITIAL.
            READ TABLE lt_gateheader ASSIGNING FIELD-SYMBOL(<lfs_driverdetail>) INDEX 1.
            IF sy-subrc IS INITIAL.
              <lfs_driverdetail>-drivername = COND #( WHEN <lfs_entity>-%control-drivername EQ '01' THEN
                                                        <lfs_entity>-drivername ELSE <lfs_driverdetail>-drivername ).

              <lfs_driverdetail>-driverno = COND #( WHEN <lfs_entity>-%control-driverno EQ '01' THEN
                                                        <lfs_entity>-driverno ELSE <lfs_driverdetail>-driverno ).

              IF ( <lfs_driverdetail>-drivername = '' AND <lfs_driverdetail>-driverno <> '' ) OR
                 ( <lfs_driverdetail>-drivername <> '' AND <lfs_driverdetail>-driverno = '' ).

                APPEND VALUE #( %tky = <lfs_driverdetail>-%tky ) TO failed-gateentryheader.

                APPEND VALUE #( %tky = <lfs_driverdetail>-%tky
                                %msg = new_message_with_text(
                                  severity = if_abap_behv_message=>severity-error
                                  text = 'Both Driver Name and Contact information must be blank or having a value.' )
                                ) TO reported-gateentryheader.

              ENDIF.

            ENDIF.
          ENDIF.

        ENDLOOP.

      ENDMETHOD.

      METHOD precheck_create.
        LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
          CHECK <lfs_entity>-%control-drivername EQ '01' OR <lfs_entity>-%control-driverno EQ '01'.

          IF ( <lfs_entity>-drivername = '' AND <lfs_entity>-driverno <> '' ) OR
             ( <lfs_entity>-drivername <> '' AND <lfs_entity>-driverno = '' ).

            "        APPEND VALUE #( %tky = <lfs_entity>-%key ) to failed-gateentryheader.

            APPEND VALUE #( "%tky = <lfs_entity>-%key
                            %msg = new_message_with_text(
                              severity = if_abap_behv_message=>severity-error
                              text = 'Both Driver Name and Contact information must be blank or having a value.' )
                              ) TO reported-gateentryheader.

          ENDIF.

        ENDLOOP.
      ENDMETHOD.



      METHOD get_global_authorizations.
        IF requested_authorizations-%update = if_abap_behv=>mk-on.
          "     OR requested_authorizations-%action-Edit
          IF is_update_allowed(  ) = abap_true.
            result-%update = if_abap_behv=>auth-allowed.
            "        result-%action-cancelGateEntry = if_abap_behv=>auth-allowed.
          ELSE.
            result-%update = if_abap_behv=>auth-unauthorized.
            "        result-%action-cancelGateEntry = if_abap_behv=>auth-unauthorized.
          ENDIF.
        ENDIF.
      ENDMETHOD.

      METHOD is_update_allowed.
        update_allowed = abap_true.
      ENDMETHOD.


      METHOD cancelmultiple.
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(gateheaders)
          FAILED failed.

        SORT gateheaders BY cancelled DESCENDING.
        LOOP AT gateheaders ASSIGNING FIELD-SYMBOL(<lfs_gateheader>).
          <lfs_gateheader>-cancelled = lc_cancelled-yes.
        ENDLOOP.

        MODIFY ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader
          UPDATE FIELDS ( cancelled ) WITH CORRESPONDING #( gateheaders ).


        APPEND VALUE #( %tky = <lfs_gateheader>-%tky
                        %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-success
                          text = 'Gate Entries Cancelled.' )
                          ) TO reported-gateentryheader.

      ENDMETHOD.

      METHOD calculate_duration.
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
    ENTITY gateentryheader
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).
        DATA: lt_update TYPE TABLE FOR UPDATE zr_gateentryheader.


        LOOP AT lt_data INTO DATA(ls_data).

          IF ls_data-gateindate IS NOT INITIAL
             AND ls_data-gateoutdate IS NOT INITIAL.
            DATA(lv_days) = ls_data-gateoutdate - ls_data-gateindate.
            APPEND VALUE #(
             %tky          = ls_data-%tky
             duration_days = lv_days
           ) TO lt_update.

          ENDIF.
        ENDLOOP.

        IF lt_update IS NOT INITIAL.

          MODIFY ENTITIES OF zr_gateentryheader IN LOCAL MODE
            ENTITY gateentryheader
            UPDATE FIELDS ( duration_days )
            WITH lt_update.

        ENDIF.
      ENDMETHOD.


      METHOD calculate_duration_time.
        DATA:
               lt_update TYPE TABLE FOR UPDATE zr_gateentryheader.

        "  all records
        READ ENTITIES OF zr_gateentryheader IN LOCAL MODE
          ENTITY gateentryheader
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_data).

        LOOP AT lt_data INTO DATA(ls_data).

          " Only if Entry and Out times exist
          IF ls_data-gateintime IS NOT INITIAL
             AND ls_data-gateouttime IS NOT INITIAL.

            " Convert HHMMSS
            DATA lv_entry_sec TYPE i.
            DATA lv_out_sec   TYPE i.
            DATA lv_diff_sec  TYPE i.

            lv_entry_sec = ( ls_data-gateintime+0(2) * 3600 )
                         + ( ls_data-gateintime+2(2) * 60 )
                         + ( ls_data-gateintime+4(2) ).

            lv_out_sec   = ( ls_data-gateouttime+0(2) * 3600 )
                         + ( ls_data-gateouttime+2(2) * 60 )
                         + ( ls_data-gateouttime+4(2) ).

            " Duration in seconds
            lv_diff_sec = lv_out_sec - lv_entry_sec.
            IF lv_diff_sec < 0.
              lv_diff_sec = 0.
            ENDIF.

            " Split seconds → HH:MM:SS
            DATA(lv_hours)   = lv_diff_sec / 3600.
            DATA(lv_minutes) = ( lv_diff_sec MOD 3600 ) / 60.
            DATA(lv_seconds) = lv_diff_sec MOD 60.

            "  HHMMSS string
            DATA lv_h TYPE c LENGTH 2.
            DATA lv_m TYPE c LENGTH 2.
            DATA lv_s TYPE c LENGTH 2.
            DATA lv_time_str TYPE c LENGTH 8.

            lv_h = lv_hours.
            IF lv_hours < 10.
              lv_h = |0{ lv_hours }|.
            ENDIF.

            lv_m = lv_minutes.
            IF lv_minutes < 10.
              lv_m = |0{ lv_minutes }|.
            ENDIF.

            lv_s = lv_seconds.
            IF lv_seconds < 10.
              lv_s = |0{ lv_seconds }|.
            ENDIF.



            lv_time_str = lv_h && ':' && lv_m && ':' && lv_s.


            APPEND VALUE #(
              %tky          = ls_data-%tky
              duration_time = lv_time_str
            ) TO lt_update.

          ENDIF.

        ENDLOOP.


        IF lt_update IS NOT INITIAL.
          MODIFY ENTITIES OF zr_gateentryheader IN LOCAL MODE
            ENTITY gateentryheader
            UPDATE FIELDS ( duration_time )
            WITH lt_update.
        ENDIF.


      ENDMETHOD.

    ENDCLASS.
