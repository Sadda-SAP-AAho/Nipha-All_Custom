CLASS LHC_ZR_DMS DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrDms
        RESULT result.
*      early_numbering FOR NUMBERING
*           IMPORTING entities FOR CREATE ZrDms.
ENDCLASS.

CLASS LHC_ZR_DMS IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

*  METHOD early_numbering.
*
*    ASSIGN entities[ 1 ] TO FIELD-SYMBOL(<doc>).
*
*    APPEND CORRESPONDING #( <doc> ) TO mapped ASSIGNING FIELD-SYMBOL(<mapped_doc>).
*    IF <doc>- IS INITIAL.
*      "      max_item_id += 10.
*      <mapped_doc>- =  .
*    ENDIF.
*
*  ENDMETHOD.
ENDCLASS.
