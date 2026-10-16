CLASS zsd_prcg_doc_condition_amount DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_prcg_doc_cndn_amount .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZSD_PRCG_DOC_CONDITION_AMOUNT IMPLEMENTATION.


  METHOD if_prcg_doc_cndn_amount~change_condition_amount.
*   MOVE-CORRESPONDING prcg_element_attributes TO prcg_element_result_amounts.
*   TRY.
*       IF doc_attributes-transactioncurrency = 'USD'.
*         IF PRCG_ELEMENT_ATTRIBUTES-conditiontype = 'ZFRN'.
*           IF PRCG_ELEMENT_ATTRIBUTES-conditionamount > 0.
*               PRCG_ELEMENT_ATTRIBUTES-conditionamount = PRCG_ELEMENT_ATTRIBUTES-conditionamount * -1.
*               prcg_element_result_amounts-conditionamount = PRCG_ELEMENT_ATTRIBUTES-conditionamount * -1.
*               prcg_element_result_amounts-conditionbasevalue = PRCG_ELEMENT_ATTRIBUTES-conditionamount * -1.
*               prcg_element_result_amounts-conditionratevalue = PRCG_ELEMENT_ATTRIBUTES-conditionamount * -1.
*            ENDIF.


*         ENDIF.
*          prcg_element_result_amounts-conditionamount = prcg_element_result_amounts-conditionamount * 20.
*          prcg_element_result_amounts-conditionamount = |{ round( val  = prcg_element_result_amounts-conditionamount
*                           dec  = 0 ) }|.
*          prcg_element_result_amounts-conditionamount = prcg_element_result_amounts-conditionamount / 20.
*      ENDIF.
*       CATCH cx_sy_conversion_error cx_sy_arithmetic_error INTO DATA(lx_conversion).
*       prcg_element_result_amounts-conditioninactivereason = 'X'.
*        prcg_element_result_amounts-conditionamount = 0.
*   You should use the statement "RAISE EXCEPTION" only for critical business errors or programming runtime errors.
**********************************************************************
*RAISE EXCEPTION TYPE cx_ble_runtime_error
*          EXPORTING
*            previous = lx_conversion.

*       Remark: Alternative exception handling
* IF doc_attributes-transactioncurrency = 'USD'.
*   IF PRCG_ELEMENT_ATTRIBUTES-conditiontype = 'ZISN'.
*    IF PRCG_ELEMENT_ATTRIBUTES-conditionamount > 0.
*        TRY.
*            RAISE EXCEPTION TYPE cx_pricing_formula EXPORTING error_message = 'Conversion Error' ##NO_TEXT .
*          CATCH cx_pricing_formula INTO DATA(lx_pricing_formula).
*            RAISE EXCEPTION TYPE cx_ble_runtime_error
*              EXPORTING
*                previous = lx_pricing_formula.
*        ENDTRY.
*    endif.
*  endif.
*endif.
*    ENDTRY.
  ENDMETHOD.
ENDCLASS.
