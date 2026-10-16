CLASS zcl_uniqidgen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    CLASS-METHODS getcid RETURNING VALUE(cid) TYPE abp_behv_cid.
ENDCLASS.



CLASS ZCL_UNIQIDGEN IMPLEMENTATION.


  METHOD getcid.
    TRY.
        cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
