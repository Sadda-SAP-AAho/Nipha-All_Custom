CLASS lhc_zr_dms_config DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS:
      get_global_authorizations
        FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrDmsConfig
        RESULT result.

ENDCLASS.



CLASS lhc_zr_dms_config IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.



CLASS lsc_zr_dms_config DEFINITION
  INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

  PRIVATE SECTION.

    DATA mt_logs TYPE TABLE OF zdms_activitylog.

    METHODS write_log
      IMPORTING
        iv_entity   TYPE zdms_config-entity
        iv_action   TYPE zdms_activitylog-action
        iv_old_path TYPE zdms_config-path OPTIONAL
        iv_new_path TYPE zdms_config-path OPTIONAL.

ENDCLASS.



CLASS lsc_zr_dms_config IMPLEMENTATION.

  METHOD save_modified.

    "========================
    " CREATE
    "========================
    LOOP AT create-ZrDmsConfig INTO DATA(ls_create).

      write_log(
        iv_entity   = ls_create-Entity
        iv_action   = 'CREATE'
        iv_new_path = ls_create-Path
      ).

    ENDLOOP.



    "========================
    " UPDATE
    "========================
    LOOP AT update-ZrDmsConfig INTO DATA(ls_update).

      DATA lv_old_path TYPE zdms_config-path.

      SELECT SINGLE path
        FROM zdms_config
        WHERE entity = @ls_update-Entity
        INTO @lv_old_path.

      IF lv_old_path <> ls_update-Path.

        write_log(
          iv_entity   = ls_update-Entity
          iv_action   = 'UPDATE'
          iv_old_path = lv_old_path
          iv_new_path = ls_update-Path
        ).

      ENDIF.

    ENDLOOP.



    "========================
    " DELETE
    "========================
    LOOP AT delete-ZrDmsConfig INTO DATA(ls_delete).

      DATA lv_deleted_path TYPE zdms_config-path.

      SELECT SINGLE path
        FROM zdms_config
        WHERE entity = @ls_delete-Entity
        INTO @lv_deleted_path.

      write_log(
        iv_entity   = ls_delete-Entity
        iv_action   = 'DELETE'
        iv_old_path = lv_deleted_path
      ).

    ENDLOOP.



    "========================
    " INSERT LOGS
    "========================
    IF mt_logs IS NOT INITIAL.

      INSERT zdms_activitylog FROM TABLE @mt_logs.
*
*      IF sy-subrc <> 0.
*        "  MESSAGE 'Activity log insert failed' TYPE 'E'.
*      ENDIF.

    ENDIF.

  ENDMETHOD.



  METHOD write_log.

    DATA lv_uuid TYPE sysuuid_x16.
    DATA lv_action_at TYPE abp_creation_tstmpl.

    TRY.

        lv_uuid = cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_uuid_error.
        RETURN.

    ENDTRY.

    GET TIME STAMP FIELD lv_action_at.

    APPEND VALUE zdms_activitylog(

    client    = sy-mandt
    log_uuid  = lv_uuid
    entity    = iv_entity
    action    = iv_action
    old_path  = iv_old_path
    new_path  = iv_new_path
    action_by = sy-uname
  action_at = lv_action_at

  ) TO mt_logs.

  ENDMETHOD.

ENDCLASS.
