CLASS zcl_boi_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BOI_JOB IMPLEMENTATION.


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


  METHOD if_oo_adt_classrun~main.

   MODIFY ENTITIES OF i_purchaserequisitiontp
     ENTITY purchaserequisitionitem UPDATE
     SET FIELDS WITH VALUE #( ( purchaserequisition = '5100000042'
     purchaserequisitionitem = '20'
     IsClosed = ''
*     purchaserequisitionitemtext = 'Updated text'
*     requestedquantity = '20.00'
*     baseunit = 'EA'
     ) ) .

COMMIT ENTITIES.
*data test1 TYPE c LENGTH 1.
*if test1 eq 'x'.
*
*ENDIF.

  ENDMETHOD.
ENDCLASS.
