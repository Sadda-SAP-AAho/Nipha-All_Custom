CLASS zdms_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZDMS_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*
*
*    SELECT *
*      FROM zdms_activitylog
*      INTO TABLE @DATA(lt_logs).
*
*    out->write( lt_logs ).

  ENDMETHOD.
ENDCLASS.
