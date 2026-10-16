class ZCL_HTTP_POCVALIDATION definition
  public
  create public .

public section.

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

    TYPES: BEGIN OF MISSING,
            MATERIAL TYPE MATNR,
            BATCH TYPE charg_d,
            mfgorder TYPE aufnr,
          END OF MISSING.


  INTERFACES if_http_service_extension .
  CLASS-METHODS VALIDATEBATCH
    IMPORTING
      VALUE(request) TYPE REF TO if_web_http_request
    RETURNING
      VALUE(message) TYPE string .

protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_POCVALIDATION IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
   CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>post ).
        response->set_text( validatebatch( request ) ).
    ENDCASE.
  endmethod.


  METHOD validatebatch.

  DATA filled_details TYPE tt_response.

  xco_cp_json=>data->from_string( request->get_text( ) )->write_to( REF #( filled_details ) ).
        REPLACE ALL OCCURRENCES OF '-' IN filled_details-postingdate WITH ''.

        message =  ZCL_HTTP_PRODORDERCONFIRM=>validate( filled_details ).
        IF message IS NOT INITIAL.
          RETURN.
        ENDIF.

        DATA: mfgorder          TYPE aufnr,
              mfgorderoperation TYPE c LENGTH 4,
              plant             TYPE c LENGTH 4.
        plant =   filled_details-plant.
        mfgorder = |{ filled_details-manufacturingorder ALPHA = IN }|.
        mfgorderoperation = |{ filled_details-operation ALPHA = IN }|.

*        SELECT FROM zr_dtreser AS A
*        LEFT JOIN I_MaterialDocumentItem_2 AS B ON B~Reservation = A~Reservationno AND B~Material = A~Material AND B~IsAutomaticallyCreated EQ 'X'
*        FIELDS
*        A~Reservationno,A~Porder,
*        B~Material,B~Batch,B~Reservation, B~ReservationItem
*        WHERE A~Porder = @mfgorder AND B~GoodsMovementType EQ '311'
*        INTO tABLE @DATA(RESTB) PRIVILEGED ACCESS.

        DATA: LT_MISSING TYPE TABLE OF missing.
*        DATA: ls_row LIKE LINE OF filled_details-_goodsmovements.
*        READ TABLE filled_details-_goodsmovements INDEX 1 INTO ls_row.

*        LOOP AT filled_details-_goodsmovements ASSIGNING FIELD-SYMBOL(<WA_ITE>).
*
*        IF <wa_ite>-goodsmovementtype EQ '261'.
*
*        READ TABLE restb WITH KEY Batch = <wa_ite>-batch Material = <wa_ite>-material INTO DATA(FLAGITEM).
*        IF SY-subrc <> 0.
*
**        APPEND VALUE #( material = <wa_ite>-material
**                    batch    = <wa_ite>-batch
**                    mfgorder = mfgorder ) TO lt_missing.
*        message = |BATCH { <wa_ite>-batch } IS NOT TRANSFERED FOR PRODUCTION ORDER { mfgorder }|.
*        RETURN.
*
*        ENDIF.
*        ENDIF.
*        CLEAR: flagitem, <wa_ite>.
*        ENDLOOP.




  ENDMETHOD.
ENDCLASS.
