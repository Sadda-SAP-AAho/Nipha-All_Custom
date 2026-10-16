CLASS LHC_TMGFORMATERIALCOALL DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PUBLIC SECTION.
    CONSTANTS:
      CO_ENTITY TYPE abp_entity_name VALUE `ZI_TMGFORMATERIALCODE_S`,
      CO_TRANSPORT_OBJECT TYPE mbc_cp_api=>indiv_transaction_obj_name VALUE `ZTMGFORMATERIALCODE`,
      CO_AUTHORIZATION_ENTITY TYPE abp_entity_name VALUE `ZI_TMGFORMATERIALCODE`.

  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TmgForMaterialCoAll
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TmgForMaterialCoAll
        RESULT result.
ENDCLASS.

CLASS LHC_TMGFORMATERIALCOALL IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
  mbc_cp_api=>rap_bc_api( )->get_instance_features(
    transport_object   = co_transport_object
    entity             = co_entity
    keys               = REF #( keys )
    requested_features = REF #( requested_features )
    result             = REF #( result )
    failed             = REF #( failed )
    reported           = REF #( reported ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  mbc_cp_api=>rap_bc_api( )->get_global_authorizations(
    entity                   = co_authorization_entity
    requested_authorizations = REF #( requested_authorizations )
    result                   = REF #( result )
    reported                 = REF #( reported ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LSC_TMGFORMATERIALCOALL DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LSC_TMGFORMATERIALCOALL IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
  mbc_cp_api=>rap_bc_api( )->update_last_changed_date_time(
    maintenance_object = 'ZTMGFORMATERIALCODE'
    entity             = lhc_TmgForMaterialCoAll=>co_authorization_entity
    create             = REF #( create )
    update             = REF #( update )
    delete             = REF #( delete )
    reported           = REF #( reported ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LHC_TMGFORMATERIALCODE DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PUBLIC SECTION.
    CONSTANTS:
      CO_ENTITY TYPE abp_entity_name VALUE `ZI_TMGFORMATERIALCODE`.

  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR TmgForMaterialCode
        RESULT result,
      COPY FOR MODIFY
        IMPORTING
          KEYS FOR ACTION TmgForMaterialCode~Copy,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR TmgForMaterialCode
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR TmgForMaterialCode
        RESULT result,
      fill_descrip FOR DETERMINE ON MODIFY
          IMPORTING keys FOR TmgForMaterialCode~fill_descrip.
ENDCLASS.

CLASS LHC_TMGFORMATERIALCODE IMPLEMENTATION.
  METHOD GET_GLOBAL_FEATURES.
  mbc_cp_api=>rap_bc_api( )->get_global_features(
    transport_object   = lhc_TmgForMaterialCoAll=>co_transport_object
    entity             = co_entity
    requested_features = REF #( requested_features )
    result             = REF #( result )
    reported           = REF #( reported ) ).
  ENDMETHOD.
  METHOD COPY.
  mbc_cp_api=>rap_bc_api( )->copy_by_association(
    entity   = co_entity
    keys     = REF #( keys )
    mapped   = REF #( mapped )
    failed   = REF #( failed )
    reported = REF #( reported ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  mbc_cp_api=>rap_bc_api( )->get_global_authorizations(
    entity                   = lhc_TmgForMaterialCoAll=>co_authorization_entity
    requested_authorizations = REF #( requested_authorizations )
    result                   = REF #( result )
    reported                 = REF #( reported ) ).
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
  mbc_cp_api=>rap_bc_api( )->get_action_features(
    entity             = co_entity
    keys               = REF #( keys )
    requested_features = REF #( requested_features )
    result             = REF #( result )
    failed             = REF #( failed )
    reported           = REF #( reported ) ).
  ENDMETHOD.
  METHOD fill_descrip.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<wa_keys>).
    Data lv_matnr TYPE n LENGTH 18.

    lv_matnr =  <wa_keys>-MaterialCode.

    SELECT SINGLE
      FROM ZI_ProductVH
      FIELDS ProductDescription
      WHERE Product = @lv_matnr
      INTO @DATA(lv_product)
      PRIVILEGED ACCESS.

      IF lv_product IS NOT INITIAL.
        MODIFY ENTITIES OF ZI_TmgForMaterialCode_S IN LOCAL MODE
          ENTITY TmgForMaterialCode
            UPDATE FIELDS ( MaterialDesc )
            WITH VALUE #( (
              %tky    = <wa_keys>-%tky
              MaterialDesc = lv_product
            ) ).
      ENDIF.
      CLEAR : lv_product.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
