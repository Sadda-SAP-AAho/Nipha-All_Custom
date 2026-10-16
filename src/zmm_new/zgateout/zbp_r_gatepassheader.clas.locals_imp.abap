CLASS lhc_zr_gatepassheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS: BEGIN OF lc_cancelled,
                 yes TYPE abap_boolean VALUE 'X',
                 no  TYPE abap_boolean VALUE '',
               END OF lc_cancelled.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zrgatepassheader
        RESULT result,
      earlynumbering_gph FOR NUMBERING
        IMPORTING entities FOR CREATE zrgatepassheader,
      earlynumbering_gpl FOR NUMBERING
        IMPORTING entities FOR CREATE zrgatepassheader\_gatepassline,
      calculate_duration FOR DETERMINE ON MODIFY
        IMPORTING keys FOR zrgatepassheader~calculate_duration,

      calculate_duration_time FOR DETERMINE ON MODIFY
        IMPORTING keys FOR zrgatepassheader~calculate_duration_time.



ENDCLASS.

CLASS lhc_zr_gatepassheader IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_gpl.
    READ ENTITIES OF zr_gatepassheader IN LOCAL MODE
      ENTITY zrgatepassheader BY \_gatepassline
        FIELDS ( passlineno )
          WITH CORRESPONDING #( entities )
          RESULT DATA(gate_entry_lines)
        FAILED failed.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<gate_entry_header>).
      " get highest item from lines
      DATA(max_item_id) = REDUCE #( INIT max = CONV posnr( '000000' )
                                    FOR gate_entry_line IN gate_entry_lines USING KEY entity WHERE ( gatepass = <gate_entry_header>-gatepass )
                                    NEXT max = COND posnr( WHEN gate_entry_line-passlineno > max
                                                           THEN gate_entry_line-passlineno
                                                           ELSE max )
                                  ).
    ENDLOOP.

    "assign Gate Entry Item id
    LOOP AT <gate_entry_header>-%target ASSIGNING FIELD-SYMBOL(<gate_entry_line>).
      APPEND CORRESPONDING #( <gate_entry_line> ) TO mapped-zrgatepassline ASSIGNING FIELD-SYMBOL(<mapped_gate_entry_line>).
      IF <gate_entry_line>-passlineno IS INITIAL.
        max_item_id += 10.
        <mapped_gate_entry_line>-passlineno = max_item_id.
      ENDIF.


    ENDLOOP.
  ENDMETHOD.


  METHOD earlynumbering_gph.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<gate_entry_header>).


      DATA: currentyear  TYPE string,
            currentmonth TYPE string,
            numyear      TYPE n LENGTH 4.


      currentyear  = <gate_entry_header>-entrydate+0(4).
      currentmonth = <gate_entry_header>-entrydate+4(2).
      numyear = currentyear.
      IF currentmonth >= '04'.  " April (04) to December (12)
        numyear = numyear.
      ELSE.
        numyear = numyear - 1.
      ENDIF.

      DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr = '10'
              toyear      = numyear
              object      = 'ZGATEPASS'
            IMPORTING
              number      = DATA(nextnumber)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          numyear = numyear.
      ENDTRY.
      SHIFT nextnumber LEFT DELETING LEADING '0'.
    ENDLOOP.

    "assign Gate Entry no.
    APPEND CORRESPONDING #( <gate_entry_header> ) TO mapped-zrgatepassheader ASSIGNING FIELD-SYMBOL(<mapped_gate_entry_header>).
    IF <gate_entry_header>-gatepass IS INITIAL.
      <mapped_gate_entry_header>-gatepass = |{ <gate_entry_header>-plant }-{ nextnumber }|.
    ENDIF.


  ENDMETHOD.



  METHOD calculate_duration.
    READ ENTITIES OF zr_gatepassheader IN LOCAL MODE
    ENTITY zrgatepassheader
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).
    DATA: lt_update TYPE TABLE FOR UPDATE zr_gatepassheader.


    LOOP AT lt_data INTO DATA(ls_data).

      IF ls_data-entrydate IS NOT INITIAL
         AND ls_data-outdate IS NOT INITIAL.
        DATA(lv_days) = ls_data-outdate - ls_data-entrydate.
        APPEND VALUE #(
         %tky          = ls_data-%tky
         duration_days = lv_days
       ) TO lt_update.

      ENDIF.
    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF zr_gatepassheader IN LOCAL MODE
        ENTITY zrgatepassheader
        UPDATE FIELDS ( duration_days )
        WITH lt_update.

    ENDIF.

  ENDMETHOD.
  METHOD calculate_duration_time.
    DATA:
           lt_update TYPE TABLE FOR UPDATE zr_gatepassheader.

    "  all records
    READ ENTITIES OF zr_gatepassheader IN LOCAL MODE
      ENTITY zrgatepassheader
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).

      " Only if Entry and Out times exist
      IF ls_data-entrytime IS NOT INITIAL
         AND ls_data-outtime IS NOT INITIAL.

        " Convert HHMMSS
        DATA lv_entry_sec TYPE i.
        DATA lv_out_sec   TYPE i.
        DATA lv_diff_sec  TYPE i.

        lv_entry_sec = ( ls_data-entrytime+0(2) * 3600 )
                     + ( ls_data-entrytime+2(2) * 60 )
                     + ( ls_data-entrytime+4(2) ).

        lv_out_sec   = ( ls_data-outtime+0(2) * 3600 )
                     + ( ls_data-outtime+2(2) * 60 )
                     + ( ls_data-outtime+4(2) ).

        " Duration in seconds
        lv_diff_sec = lv_out_sec - lv_entry_sec.
        IF lv_diff_sec < 0.
          lv_diff_sec = 0.
        ENDIF.

        " Split seconds → HH:MM:SS
        DATA(lv_hours)   = lv_diff_sec / 3600.
        DATA(lv_minutes) = ( lv_diff_sec MOD 3600 ) / 60.
        DATA(lv_seconds) = lv_diff_sec MOD 60.

        " RAP-safe HHMMSS string
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

        " Append update
        APPEND VALUE #(
          %tky          = ls_data-%tky
          duration_time = lv_time_str
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    " Update entity
    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zr_gatepassheader IN LOCAL MODE
        ENTITY zrgatepassheader
        UPDATE FIELDS ( duration_time )
        WITH lt_update.
    ENDIF.

  ENDMETHOD.





ENDCLASS.
