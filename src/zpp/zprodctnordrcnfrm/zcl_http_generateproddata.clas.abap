CLASS ZCL_HTTP_GENERATEPRODDATA DEFINITION
      PUBLIC
      CREATE PUBLIC .

      PUBLIC SECTION.



        TYPES:BEGIN OF tt_mfg_request,
                ManufacturingOrder TYPE aufnr,
                YieldQuantity      TYPE menge_d,
                Operation          TYPE c LENGTH 4,
                PostingDate        TYPE string,
                GoodYield          TYPE menge_d,
                PackSize           TYPE i,
                ReworkQuantity     TYPE menge_d,
                SaleableWaste      TYPE menge_d,
                ShiftDefinition    TYPE c LENGTH 2,
                RBConsumed         TYPE menge_d,
                Batch101           TYPE charg_d,
                ConfirmationText   TYPE co_rtext,
              END OF tt_mfg_request.

        TYPES: BEGIN OF tt_mfg_order_activites,
                 Quantity   TYPE p LENGTH 9 DECIMALS 3,
                 Unit       TYPE erfme,
                 Multiplier TYPE p LENGTH 10 DECIMALS 8,
                 Name       TYPE c LENGTH 40,
                 Item       TYPE i,
               END OF tt_mfg_order_activites.

        TYPES: BEGIN OF tt_mfg_order_movements,
                 Material          TYPE matnr,
                 Description       TYPE maktx,
                 Multiplier        TYPE p LENGTH 10 DECIMALS 8,
                 Item              TYPE i,
                 MaterialType      TYPE mtart,
                 Quantity          TYPE menge_d,
                 Plant             TYPE werks_d,
                 StorageLocation   TYPE c LENGTH 4,
                 Batch             TYPE charg_d,
                 GoodsMovementType TYPE bwart,
                 changeable        TYPE i,
                 Unit              TYPE erfme,
                 ScrpPer           TYPE STRING,
                 ExistingQty       TYPE menge_d,
                 Ordertype         TYPE STRING,
               END OF tt_mfg_order_movements.



        TYPES: BEGIN OF tt_response,
                 Product               TYPE matnr,
                 Batch101              TYPE charg_d,
                 ProductDescription    TYPE maktx,
                 Plant                 TYPE werks_d,
                 CompanyCode           TYPE bukrs,
                 ManufacturingOrder    TYPE aufnr,
                 Operation             TYPE c LENGTH 4,
                 OperationDescription  TYPE ltxa1,
                 ConfirmationText      TYPE co_rtext,
                 Sequence              TYPE plnfolge,
                 WorkCenter            TYPE arbpl,
                 WorkCenterDescription TYPE c LENGTH 40,
                 Confirmation          TYPE co_rueck,
                 YieldQuantity         TYPE menge_d,
                 YieldUnit             TYPE erfme,
                 ReworkQuantity        TYPE menge_d,
                 PostingDate           TYPE d,
                 GoodYield             TYPE menge_d,
                 ReworkUnit            TYPE erfme,
                 SaleableWaste         TYPE menge_d,
                 ShiftDefinition       TYPE c LENGTH 2,
                 RBConsumed            TYPE menge_d,
                 WastageThreshold      TYPE p LENGTH 10 DECIMALS 3,
                 OverdeliveryTolerance TYPE p LENGTH 3 DECIMALS 1,
                 PackSize              TYPE i,
                 CreatedDate           TYPE d,
                 GoodsMovements        TYPE TABLE OF tt_mfg_order_movements WITH EMPTY KEY,
                 Activities            TYPE TABLE OF tt_mfg_order_activites WITH EMPTY KEY,
               END OF tt_response.

        CLASS-DATA response_type TYPE tt_response.

        CLASS-METHODS validate
          IMPORTING
            filled_details TYPE tt_mfg_request
*              VALUE(filled_details) TYPE tt_mfg_request
          RETURNING
            VALUE(message) TYPE string.


        INTERFACES if_http_service_extension .
        CLASS-METHODS fetchDetails
          IMPORTING
            VALUE(request) TYPE REF TO if_web_http_request
          RETURNING
            VALUE(message) TYPE string .

        CLASS-METHODS sendActivity
          IMPORTING
            name     TYPE string
            quantity TYPE p
            over_qty TYPE p
            activity TYPE lstar
            unit     TYPE erfme.

        CLASS-METHODS generate_batch
          IMPORTING
            iv_material     TYPE matnr
            iv_mfg_date     TYPE d
            count           TYPE i
          RETURNING
            VALUE(rv_batch) TYPE charg_d.
      PROTECTED SECTION.
      PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_GENERATEPRODDATA IMPLEMENTATION.


      METHOD fetchdetails.
        DATA request_data TYPE tt_mfg_request.

        TRY.
            xco_cp_json=>data->from_string( request->get_text( ) )->write_to( REF #( request_data ) ).
          CATCH cx_root INTO DATA(lx_root).
            message = |General Error: { lx_root->get_text( ) }|.
        ENDTRY.

        message = validate( request_data ).
        IF message IS NOT INITIAL.
          RETURN.
        ENDIF.


        request_data-ManufacturingOrder = |{ request_data-ManufacturingOrder ALPHA = IN }|.
        request_data-operation = |{ request_data-operation ALPHA = IN }|.
        REPLACE ALL OCCURRENCES OF '-' IN request_data-postingdate WITH ''.

        SELECT SINGLE FROM I_ManufacturingOrder WITH PRIVILEGED ACCESS AS a
            INNER JOIN I_ProductionOrder WITH PRIVILEGED ACCESS AS f  ON f~ProductionOrder = a~ManufacturingOrder
            INNER JOIN I_ProductionOrderItem WITH PRIVILEGED ACCESS AS g ON f~ProductionOrder = g~ProductionOrder
            INNER JOIN I_ProductDescription_2 WITH PRIVILEGED ACCESS AS b ON a~Product = b~Product
            INNER JOIN I_ManufacturingOrderOperation WITH PRIVILEGED ACCESS AS c ON a~MfgOrderInternalID = c~MfgOrderInternalID
            INNER JOIN I_workCenter WITH PRIVILEGED ACCESS AS d ON c~WorkCenterTypeCode_2 = d~WorkCenterTypeCode
                                          AND c~WorkCenterInternalID = d~WorkCenterInternalID
            INNER JOIN I_WorkCenterText WITH PRIVILEGED ACCESS AS e ON d~WorkCenterInternalID = e~WorkCenterInternalID
                                             AND d~WorkCenterTypeCode   = e~WorkCenterTypeCode
            FIELDS b~ProductDescription,a~Product,a~ManufacturingOrder,a~ProductionPlant,e~WorkCenterText,d~WorkCenter,c~ManufacturingOrderOperation_2,
                   c~ManufacturingOrderSequence,c~MfgOrderOperationText,c~OperationConfirmation,a~BillOfOperationsGroup,a~CompanyCode, f~OrderActualReleaseDate,
                   g~OverdelivTolrtdLmtRatioInPct, c~OpTotConfdYieldQtyInOrdQtyUnit, c~OperationControlProfile
            WHERE a~ManufacturingOrder = @request_data-ManufacturingOrder
                AND (
                        (  @request_data-operation IS INITIAL AND c~ManufacturingOrderOperation_2 = ( SELECT MIN( ManufacturingOrderOperation_2 ) FROM I_ManufacturingOrderOperation WHERE MfgOrderInternalID = a~MfgOrderInternalID ) )
                        OR c~ManufacturingOrderOperation_2 = @request_data-operation
                    )
            INTO @DATA(mfg_order).


        response_type-product = |{ mfg_order-Product ALPHA = OUT }|.
        response_type-productdescription = mfg_order-ProductDescription.
        response_type-plant = mfg_order-ProductionPlant.
        response_type-manufacturingorder = |{ mfg_order-ManufacturingOrder ALPHA = OUT }|.
        response_type-operation = mfg_order-ManufacturingOrderOperation_2.
        response_type-operationdescription = mfg_order-MfgOrderOperationText.
        response_type-sequence = |{ mfg_order-ManufacturingOrderSequence ALPHA = OUT }|.
        response_type-workcenter = mfg_order-WorkCenter.
        response_type-workcenterdescription = mfg_order-WorkCenterText.
        response_type-confirmation = |{ mfg_order-OperationConfirmation ALPHA = OUT }|.
        response_type-saleablewaste = request_data-SaleableWaste.
        response_type-rbconsumed = request_data-RBConsumed.
        response_type-shiftdefinition = request_data-ShiftDefinition.
        response_type-companycode = mfg_order-CompanyCode.
        response_type-createddate = mfg_order-OrderActualReleaseDate.
        response_type-confirmationtext = request_data-confirmationtext.
        response_type-overdeliverytolerance = mfg_order-OverdelivTolrtdLmtRatioInPct.
        response_type-packsize = request_data-packsize.
        response_type-postingdate = request_data-PostingDate.


*       Get Activities and Yield Quantities


        READ ENTITIES OF i_productionordconfirmationtp
         ENTITY productionorderconfirmation
         EXECUTE getconfproposal
         FROM VALUE #( (
                ConfirmationGroup = mfg_order-OperationConfirmation
                %param-ConfirmationYieldQuantity = request_data-YieldQuantity
                %param-ConfirmationReworkQuantity = request_data-ReworkQuantity
                %param-OrderID =  mfg_order-ManufacturingOrder
                %param-OrderOperation = response_type-operation
                %param-Sequence = mfg_order-ManufacturingOrderOperation_2
          ) )
         RESULT DATA(lt_confproposal)
         REPORTED DATA(lt_reported_conf).

        DATA(conf_proposal) = VALUE #( lt_confproposal[ 1 ] OPTIONAL ).

        SELECT SINGLE FROM I_ManufacturingOrderItem WITH PRIVILEGED ACCESS AS a
             INNER JOIN I_Product WITH PRIVILEGED ACCESS AS c ON a~Material = c~Product
             INNER JOIN I_productDescription_2 WITH PRIVILEGED ACCESS AS b ON a~Material = b~Product
             LEFT JOIN I_MfgOrderComponentWithStatus WITH PRIVILEGED ACCESS AS E ON A~Material = E~Material AND A~Reservation = E~Reservation
              LEFT JOIN I_BillOfMaterialItemBasic WITH PRIVILEGED ACCESS AS D ON E~BillOfMaterialInternalID = D~BillOfMaterial AND E~BillOfMaterialItemNumber = D~BillOfMaterialItemNumber
             FIELDS a~ManufacturingOrder, a~Material,  a~StorageLocation, a~Batch, a~ProductionUnit,b~ProductDescription,c~ProductType, E~ComponentScrapInPercent,
                    a~MfgOrderItemPlannedYieldQty
             WHERE A~ManufacturingOrder = @mfg_order-ManufacturingOrder
             INTO @DATA(mfg_order_item_status).

         SELECT SINGLE FROM I_ProductionOrder
         FIELDS
         ProductionOrderType
         WHERE ProductionOrder = @mfg_order-ManufacturingOrder
         INTO @DATA(ORDERTYPE) PRIVILEGED ACCESS.

        SELECT SINGLE FROM I_UnitOfMeasure
             FIELDS UnitOfMeasure_E
             WHERE UnitOfMeasure = @mfg_order_item_status-ProductionUnit
             INTO @DATA(unit101) PRIVILEGED ACCESS.


        SELECT FROM zc_operationvh
        FIELDS ManufacturingOrderOperation_2, OperationControlProfile, ConfirmedYieldQuantity, OperationUnit,
                ConfirmedReworkQuantity, ConfirmedScrapQuantity, Sequence
        WHERE ManufacturingOrder = @mfg_order-ManufacturingOrder
        ORDER BY ManufacturingOrderOperation_2 DESCENDING
        INTO TABLE @DATA(operations_desc) PRIVILEGED ACCESS.

        IF operations_desc IS NOT INITIAL
        AND ( response_type-operation = operations_desc[ 1 ]-ManufacturingOrderOperation_2
                OR mfg_order-OperationControlProfile = 'YBP3' ).

          TRY.
              DATA(last_cnfmt) = operations_desc[ 2 ].
            CATCH cx_sy_itab_line_not_found.
              last_cnfmt = operations_desc[ 1 ].
          ENDTRY.

          SELECT SINGLE FROM I_UnitOfMeasure
            FIELDS UnitOfMeasure_E
            WHERE UnitOfMeasure = @last_cnfmt-OperationUnit
            INTO @DATA(unitmain) PRIVILEGED ACCESS.

          IF last_cnfmt-ManufacturingOrderOperation_2 NE  response_type-operation.
            IF last_cnfmt-ConfirmedYieldQuantity IS INITIAL.
              messAGE = |Up until now no quantity has been confirmed by predecessors { last_cnfmt-ManufacturingOrderOperation_2 } / { last_cnfmt-Sequence }|.
              RETURN.
            ELSEIF last_cnfmt-ConfirmedYieldQuantity LT request_data-YieldQuantity.
              message = |Up until now only  { last_cnfmt-ConfirmedYieldQuantity } { unitmain } has been confirmed by predecessors { last_cnfmt-ManufacturingOrderOperation_2 } / { last_cnfmt-Sequence }|.
              RETURN.
            ENDIF.
            response_type-yieldquantity = last_cnfmt-ConfirmedYieldQuantity.
            response_type-yieldunit = unitmain.
            response_type-reworkquantity = last_cnfmt-ConfirmedReworkQuantity.
            response_type-reworkunit = unitmain.
            response_type-goodyield = last_cnfmt-ConfirmedYieldQuantity.
          ELSE.
            response_type-yieldquantity = conf_proposal-%param-ConfirmationYieldQuantity. "- mfg_order-OpTotConfdYieldQtyInOrdQtyUnit.
            response_type-yieldunit = conf_proposal-%param-ConfirmationUnit.
            response_type-reworkquantity = conf_proposal-%param-ConfirmationReworkQuantity.
            response_type-reworkunit = conf_proposal-%param-ConfirmationUnit.
            response_type-goodyield = conf_proposal-%param-ConfirmationYieldQuantity. "- mfg_order-OpTotConfdYieldQtyInOrdQtyUnit.
          ENDIF.

          IF request_data-yieldquantity IS NOT INITIAL.
            response_type-yieldquantity = request_data-yieldquantity.
            response_type-goodyield = request_data-yieldquantity.
          ENDIF.


          DATA line_items TYPE i.
          DATA lv_packsize TYPE menge_d.

          IF ordertype <> 'ZDIS'.

          DATA(main_item) = VALUE tt_mfg_order_movements(
              Material          = mfg_order_item_status-Material
              Description       = mfg_order_item_status-ProductDescription
              Multiplier        = 1
              Item              = 1
              MaterialType      = mfg_order_item_status-ProductType
              Plant             = mfg_order-ProductionPlant
              StorageLocation   = mfg_order_item_status-StorageLocation
              Quantity          = response_type-yieldquantity + response_type-rbconsumed
              GoodsMovementType = '101'
              Unit              = unit101
              ScrpPer           = mfg_order_item_status-ComponentScrapInPercent
              ExistingQty       = response_type-yieldquantity + response_type-rbconsumed
              ordertype         = ordertype
          ).

          IF request_data-packsize IS NOT INITIAL
             AND request_data-packsize > 0.

            lv_packsize = request_data-packsize.

            IF response_type-goodyield MOD lv_packsize <> 0.
              message = |Good Yield { response_type-goodyield } is not divisible by Pack Size { lv_packsize }|.
              RETURN.
            ENDIF.

            line_items = response_type-goodyield DIV lv_packsize.

            DATA(line) = 1.

            WHILE line_items > 0.

              DATA(new_item) = main_item.

              new_item-Quantity = lv_packsize.
              new_item-Item     = line.
              new_item-Batch    = generate_batch(
                                     iv_material = main_item-Material
                                     iv_mfg_date = CONV d( request_data-PostingDate )
                                     count       = line
                                   ).
              IF new_item-Unit = 'PC'.
                new_item-Quantity = round( val = new_item-Quantity dec = 0 ).
              ENDIF.

              APPEND new_item TO response_type-GoodsMovements.
              line_items -= 1.
              line       += 1.
            ENDWHILE.
          ELSE.
            " Only one line when PackSize = 0
            main_item-Batch = generate_batch(
                                 iv_material = main_item-Material
                                 iv_mfg_date = CONV d( request_data-PostingDate )
                                 count       = 1
                                  ).

            APPEND main_item TO response_type-GoodsMovements.
          ENDIF.
    ENDIF.

        ELSE.
          response_type-yieldquantity = conf_proposal-%param-ConfirmationYieldQuantity. "- mfg_order-OpTotConfdYieldQtyInOrdQtyUnit.
          response_type-yieldunit = conf_proposal-%param-ConfirmationUnit.
          response_type-reworkquantity = conf_proposal-%param-ConfirmationReworkQuantity.
          response_type-reworkunit = conf_proposal-%param-ConfirmationUnit.
          response_type-goodyield = conf_proposal-%param-ConfirmationYieldQuantity. "- mfg_order-OpTotConfdYieldQtyInOrdQtyUnit.
        ENDIF.

        IF request_data-yieldquantity IS NOT INITIAL.
          response_type-yieldquantity = request_data-yieldquantity.
          response_type-goodyield = request_data-yieldquantity.
        ENDIF.



        SELECT SINGLE FROM I_ProductionOrderOperationTP
        FIELDS OperationReferenceQuantity,WorkCenterStandardWorkQtyUnit1,WorkCenterStandardWorkQty1,CostCtrActivityType1,
                    WorkCenterStandardWorkQtyUnit2,WorkCenterStandardWorkQty2,CostCtrActivityType2,
                   WorkCenterStandardWorkQtyUnit3,WorkCenterStandardWorkQty3,CostCtrActivityType3,
                   WorkCenterStandardWorkQtyUnit4,WorkCenterStandardWorkQty4,CostCtrActivityType4,
                   WorkCenterStandardWorkQtyUnit5,WorkCenterStandardWorkQty5,CostCtrActivityType5,
                   WorkCenterStandardWorkQtyUnit6,WorkCenterStandardWorkQty6,CostCtrActivityType6
        WHERE ProductionOrder = @mfg_order-ManufacturingOrder
            AND ProductionOrderOperation = @response_type-operation
            AND Plant = @mfg_order-ProductionPlant
            AND WorkCenter = @response_type-workcenter
        INTO @DATA(bill_of_operations_op_basic) PRIVILEGED ACCESS.

*         Machine
        sendactivity(
           name = 'Machine'
           quantity = bill_of_operations_op_basic-WorkCenterStandardWorkQty1
           over_qty = bill_of_operations_op_basic-OperationReferenceQuantity
           activity = bill_of_operations_op_basic-CostCtrActivityType1
           unit = bill_of_operations_op_basic-WorkCenterStandardWorkQtyUnit1 ).

*         Labor
        sendactivity(
            name = 'Labor'
            quantity = bill_of_operations_op_basic-WorkCenterStandardWorkQty2
            over_qty = bill_of_operations_op_basic-OperationReferenceQuantity
            activity = bill_of_operations_op_basic-CostCtrActivityType2
            unit = bill_of_operations_op_basic-WorkCenterStandardWorkQtyUnit2 ).

*         Power (KWH)
        sendactivity(
            name = 'Power (KWH)'
            quantity = bill_of_operations_op_basic-WorkCenterStandardWorkQty3
            over_qty = bill_of_operations_op_basic-OperationReferenceQuantity
            activity = bill_of_operations_op_basic-CostCtrActivityType3
            unit = bill_of_operations_op_basic-WorkCenterStandardWorkQtyUnit3 ).

*         Overhead
        sendactivity(
            name = 'Overhead'
            quantity = bill_of_operations_op_basic-WorkCenterStandardWorkQty4
            over_qty = bill_of_operations_op_basic-OperationReferenceQuantity
            activity = bill_of_operations_op_basic-CostCtrActivityType4
            unit = bill_of_operations_op_basic-WorkCenterStandardWorkQtyUnit4 ).




        SELECT FROM I_MfgOrderComponentWithStatus WITH PRIVILEGED ACCESS AS a
            INNER JOIN I_Product WITH PRIVILEGED ACCESS AS c ON a~Material = c~Product
            INNER JOIN I_ProductDescription_2 WITH PRIVILEGED ACCESS AS b ON a~Material = b~Product
            LEFT JOIN I_BillOfMaterialItemBasic WITH PRIVILEGED ACCESS AS D ON A~BillOfMaterialInternalID = D~BillOfMaterial AND A~BillOfMaterialItemNumber = D~BillOfMaterialItemNumber
            FIELDS a~MaterialComponentIsPhantomItem, a~Material, a~Plant, a~StorageLocation, a~Batch, a~GoodsMovementType, a~EntryUnit,b~ProductDescription,
                   c~ProductType,a~BillOfMaterialItemNumber,a~GoodsMovementEntryQty AS RequiredQuantity, a~MaterialQtyToBaseQtyNmrtr, a~MaterialQtyToBaseQtyDnmntr,D~ComponentScrapInPercent
            WHERE ManufacturingOrder = @mfg_order-ManufacturingOrder
            AND a~ManufacturingOrderOperation = @response_type-operation
            AND a~MaterialComponentIsPhantomItem <> 'X'
            ORDER BY a~BillOfMaterialItemNumber
            INTO TABLE @DATA(mfg_order_components).

        SELECT SINGLE FROM I_UnitOfMeasure
            FIELDS UnitOfMeasure_E
            INTO @DATA(unit145) PRIVILEGED ACCESS.


        LOOP AT mfg_order_components INTO DATA(mfg_order_component).

          SELECT SINGLE FROM I_UnitOfMeasure
         FIELDS UnitOfMeasure_E
         WHERE UnitOfMeasure = @mfg_order_component-EntryUnit
         INTO @DATA(unit1) PRIVILEGED ACCESS.


          IF mfg_order_component-GoodsMovementType = '531' AND mfg_order_component-ProductType = 'ZCOP'.
            DATA(mfg_order_movement) = VALUE tt_mfg_order_movements(
                 Material          = mfg_order_component-Material
                 Description       = mfg_order_component-ProductDescription
                 Item              = lines( response_type-GoodsMovements ) + 1
                 MaterialType      = mfg_order_component-ProductType
                 Plant             = mfg_order_component-Plant
                 StorageLocation   = mfg_order_component-StorageLocation
                 GoodsMovementType = mfg_order_component-GoodsMovementType
                 quantity          = request_data-reworkquantity
                 Unit              = unit1
                 ScrpPer           = conv string( mfg_order_component-ComponentScrapInPercent )
                 ExistingQty       = request_data-reworkquantity
                 ordertype         = ordertype
                 ).

            APPEND mfg_order_movement TO response_type-GoodsMovements.
            CONTINUE.
          ELSEIF mfg_order_component-GoodsMovementType = '261' AND mfg_order_component-ProductType = 'ZCOP'.
            mfg_order_movement = VALUE tt_mfg_order_movements(
                 Material          = mfg_order_component-Material
                 Description       = mfg_order_component-ProductDescription
                 Item              = lines( response_type-GoodsMovements ) + 1
                 MaterialType      = mfg_order_component-ProductType
                 Plant             = mfg_order_component-Plant
                 StorageLocation   = mfg_order_component-StorageLocation
                 GoodsMovementType = mfg_order_component-GoodsMovementType
                 quantity          = request_data-rbconsumed
                 Unit              = unit1
                 ScrpPer           =  CONV STRING( mfg_order_component-ComponentScrapInPercent )
                 ExistingQty       = request_data-rbconsumed
                 ordertype         = ordertype ).
            APPEND mfg_order_movement TO response_type-GoodsMovements.
            CONTINUE.
          ENDIF.

          SELECT SINGLE FROM  I_ProductionOrderOpComponentTP WITH PRIVILEGED ACCESS AS d
                FIELDS d~ComponentScrapInPercent
                WHERE  d~ProductionOrder = @mfg_order-ManufacturingOrder
                AND d~ProductionOrderOperation = @response_type-operation
                AND d~ProductionOrderSequence = @mfg_order-ManufacturingOrderSequence
                AND d~BillOfMaterialItemNumber = @mfg_order_component-BillOfMaterialItemNumber
                INTO @DATA(ComponentScrapInPercent).

          DATA multiplier TYPE p LENGTH 10 DECIMALS 8.

          IF mfg_order_component-RequiredQuantity IS INITIAL .
            multiplier = 0.

            mfg_order_movement = VALUE tt_mfg_order_movements(
                Material          = mfg_order_component-Material
                Description       = mfg_order_component-ProductDescription
                Item              = lines( response_type-GoodsMovements ) + 1
                MaterialType      = mfg_order_component-ProductType
                Plant             = mfg_order_component-Plant
                StorageLocation   = mfg_order_component-StorageLocation
                GoodsMovementType = mfg_order_component-GoodsMovementType
                quantity          = 0
                changeable        = COND #(
                                            WHEN mfg_order_component-Material EQ '000000001600000023'
                                            THEN 1
                                            ELSE 0     )
                Unit              = unit1
                ScrpPer           =  CONV STRING( mfg_order_component-ComponentScrapInPercent )
                ExistingQty       = 0
                ordertype         = ordertype ).
            APPEND mfg_order_movement TO response_type-GoodsMovements.
            CONTINUE.

          ELSE.
            multiplier =  mfg_order_component-RequiredQuantity / mfg_order_item_status-MfgOrderItemPlannedYieldQty. "* ( 1 + ( ComponentScrapInPercent / 100 ) ).
          ENDIF.

          DATA itew_quantity TYPE menge_d.
          itew_quantity = multiplier * ( response_type-yieldquantity + response_type-reworkquantity ).
          DATA(DIS_TEMP) = itew_quantity.

          IF unit1 = 'PC' .
            itew_quantity = round( val = itew_quantity dec = 0 ).
          ENDIF.

          IF mfg_order_component-GoodsMovementType = '531' AND ( mfg_order_component-ProductType = 'ZNVM' OR mfg_order_component-ProductType = 'ZWST' ).

            SELECT SINGLE FROM I_product
              FIELDS NetWeight, GrossWeight
              WHERE Product = @mfg_order_component-Material
              INTO @DATA(product_basic) PRIVILEGED ACCESS.

            response_type-wastagethreshold = ( product_basic-NetWeight + product_basic-GrossWeight ) * response_type-yieldquantity.

            mfg_order_movement = VALUE tt_mfg_order_movements(
                 Material          = mfg_order_component-Material
                 Description       = mfg_order_component-ProductDescription
                 Item              = lines( response_type-GoodsMovements ) + 1
                 MaterialType      = mfg_order_component-ProductType
                 Plant             = mfg_order_component-Plant
                 StorageLocation   = mfg_order_component-StorageLocation
                 GoodsMovementType = mfg_order_component-GoodsMovementType
                 quantity          = COND #(
                                             WHEN mfg_order_component-Material EQ '000000001600000023' THEN itew_quantity
                                             WHEN request_data-saleablewaste IS INITIAL THEN itew_quantity
                                             ELSE request_data-saleablewaste   )
                 changeable        = COND #(
                                             WHEN mfg_order_component-Material EQ '000000001600000023'
                                             THEN 1
                                             ELSE 0     )
                 Unit              = unit1
                 ScrpPer           =  CONV STRING( mfg_order_component-ComponentScrapInPercent )
                 ExistingQty       = COND #(
                                             WHEN mfg_order_component-Material EQ '000000001600000023' THEN itew_quantity
                                             WHEN request_data-saleablewaste IS INITIAL THEN itew_quantity
                                             ELSE request_data-saleablewaste   )
                 ordertype         = ordertype ).
            APPEND mfg_order_movement TO response_type-GoodsMovements.
            CONTINUE.
          ENDIF.

          DATA(today) = cl_abap_context_info=>get_system_date(  ).

          SELECT FROM I_StockQuantityCurrentValue_2( p_displaycurrency = 'INR' ) WITH PRIVILEGED ACCESS AS a
               INNER JOIN I_Batch WITH PRIVILEGED ACCESS AS b ON a~Batch = b~Batch AND a~Plant = b~Plant AND b~ShelfLifeExpirationDate >= @today
                                        AND a~Product = b~Material
               FIELDS a~MatlWrhsStkQtyInMatlBaseUnit, b~Batch
               WHERE a~Product = @mfg_order_component-Material
                 AND a~Plant = @mfg_order_component-Plant
                 AND a~StorageLocation = @mfg_order_component-StorageLocation
                 AND a~ValuationAreaType = '1'
                 AND a~InventoryStockType = '01'
                 AND a~MatlWrhsStkQtyInMatlBaseUnit > 0
                 ORDER BY b~ShelfLifeExpirationDate ASCENDING
                 INTO TABLE @DATA(stock_with_batch).


          SELECT FROM I_StockQuantityCurrentValue_2( p_displaycurrency = 'INR' ) WITH PRIVILEGED ACCESS AS a
              INNER JOIN I_Batch WITH PRIVILEGED ACCESS AS b ON a~Batch = b~Batch AND a~Plant = b~Plant AND b~ShelfLifeExpirationDate IS INITIAL
                                                  AND a~Product = b~Material
              FIELDS a~MatlWrhsStkQtyInMatlBaseUnit, b~Batch
              WHERE a~Product = @mfg_order_component-Material
                AND a~Plant = @mfg_order_component-Plant
                AND a~StorageLocation = @mfg_order_component-StorageLocation
                AND a~ValuationAreaType = '1'
                AND a~InventoryStockType = '01'
                AND a~MatlWrhsStkQtyInMatlBaseUnit > 0
                ORDER BY b~LastGoodsReceiptDate ASCENDING
                INTO TABLE @DATA(stock_with_batch1).

          APPEND LINES OF stock_with_batch1 TO stock_with_batch.

          IF stock_with_batch IS INITIAL.
            mfg_order_movement = VALUE tt_mfg_order_movements(
              Material          = mfg_order_component-Material
              Description       = mfg_order_component-ProductDescription
              Multiplier        = multiplier
              Item              = lines( response_type-GoodsMovements ) + 1
              MaterialType      = mfg_order_component-ProductType
              Plant             = mfg_order_component-Plant
              StorageLocation   = mfg_order_component-StorageLocation
              GoodsMovementType = mfg_order_component-GoodsMovementType
              quantity          = itew_quantity
              Unit              = unit1
              ScrpPer           =  CONV STRING( mfg_order_component-ComponentScrapInPercent )
              ExistingQty       = itew_quantity
              ordertype         = ordertype  ).

            APPEND mfg_order_movement TO response_type-GoodsMovements.
            CONTINUE.
          ENDIF.

          IF ordertype EQ 'ZDIS'.
          itew_quantity = 1.
          ENDIF.


          LOOP AT stock_with_batch INTO DATA(stock_item).
            IF itew_quantity <= 0.
              EXIT.
            ENDIF.

            stock_item-MatlWrhsStkQtyInMatlBaseUnit = stock_item-MatlWrhsStkQtyInMatlBaseUnit * mfg_order_component-MaterialQtyToBaseQtyDnmntr /
                                                   mfg_order_component-MaterialQtyToBaseQtyNmrtr.

            mfg_order_movement = VALUE tt_mfg_order_movements(
              Material          = mfg_order_component-Material
              Description       = mfg_order_component-ProductDescription
              Multiplier        = multiplier
              Item              = lines( response_type-GoodsMovements ) + 1
              MaterialType      = mfg_order_component-ProductType
              Plant             = mfg_order_component-Plant
              StorageLocation   = mfg_order_component-StorageLocation
              Batch             = COND #( WHEN ordertype <> 'ZDIS' THEN stock_item-Batch ELSE '' )
              GoodsMovementType = mfg_order_component-GoodsMovementType
              quantity          = COND #(
                                            WHEN ordertype EQ 'ZDIS' THEN dis_temp
                                            WHEN itew_quantity >= stock_item-MatlWrhsStkQtyInMatlBaseUnit
                                              THEN stock_item-MatlWrhsStkQtyInMatlBaseUnit
                                            ELSE itew_quantity
                                         )
              Unit              = unit1
             ScrpPer           =  CONV STRING( mfg_order_component-ComponentScrapInPercent )
             ExistingQty       = COND #(
                                            WHEN itew_quantity >= stock_item-MatlWrhsStkQtyInMatlBaseUnit
                                              THEN stock_item-MatlWrhsStkQtyInMatlBaseUnit
                                            ELSE itew_quantity
                                         )
               ordertype       = ordertype ).

            APPEND mfg_order_movement TO response_type-GoodsMovements.
            itew_quantity -= stock_item-MatlWrhsStkQtyInMatlBaseUnit.
          ENDLOOP.

          IF itew_quantity > 0.
            mfg_order_movement = VALUE tt_mfg_order_movements(
              Material          = mfg_order_component-Material
              Description       = mfg_order_component-ProductDescription
              Multiplier        = multiplier
              Item              = lines( response_type-GoodsMovements ) + 1
              MaterialType      = mfg_order_component-ProductType
              Plant             = mfg_order_component-Plant
              StorageLocation   = mfg_order_component-StorageLocation
              GoodsMovementType = mfg_order_component-GoodsMovementType
              quantity          = itew_quantity
              Unit              = unit1
              ScrpPer           =  CONV STRING( mfg_order_component-ComponentScrapInPercent )
              ExistingQty       = itew_quantity
              ordertype         = ordertype ).

            APPEND mfg_order_movement TO response_type-GoodsMovements.
          ENDIF.
        ENDLOOP.

        DATA:json TYPE REF TO if_xco_cp_json_data.

        xco_cp_json=>data->from_abap(
          EXPORTING
            ia_abap      = response_type
          RECEIVING
            ro_json_data = json   ).
        json->to_string(
          RECEIVING
            rv_string =   DATA(lv_string) ).


        REPLACE ALL OCCURRENCES OF '"PRODUCTDESCRIPTION"' IN lv_string WITH '"ProductDescription"'.
        REPLACE ALL OCCURRENCES OF '"PRODUCT"' IN lv_string WITH '"Product"'.
        REPLACE ALL OCCURRENCES OF '"MANUFACTURINGORDER"' IN lv_string WITH '"ManufacturingOrder"'.
        REPLACE ALL OCCURRENCES OF '"OPERATIONDESCRIPTION"' IN lv_string WITH '"OperationDescription"'.
        REPLACE ALL OCCURRENCES OF '"OPERATION"' IN lv_string WITH '"Operation"'.
        REPLACE ALL OCCURRENCES OF '"SEQUENCE"' IN lv_string WITH '"Sequence"'.
        REPLACE ALL OCCURRENCES OF '"WORKCENTERDESCRIPTION"' IN lv_string WITH '"WorkCenterDescription"'.
        REPLACE ALL OCCURRENCES OF '"WORKCENTER"' IN lv_string WITH '"WorkCenter"'.
        REPLACE ALL OCCURRENCES OF '"PLANT"' IN lv_string WITH '"Plant"'.
        REPLACE ALL OCCURRENCES OF '"CONFIRMATION"' IN lv_string WITH '"Confirmation"'.
        REPLACE ALL OCCURRENCES OF '"YIELDQUANTITY"' IN lv_string WITH '"YieldQuantity"'.
        REPLACE ALL OCCURRENCES OF '"YIELDUNIT"' IN lv_string WITH '"YieldUnit"'.
        REPLACE ALL OCCURRENCES OF '"REWORKQUANTITY"' IN lv_string WITH '"ReworkQuantity"'.
        REPLACE ALL OCCURRENCES OF '"GOODYIELD"' IN lv_string WITH '"GoodYield"'.
        REPLACE ALL OCCURRENCES OF '"CHANGEABLE"' IN lv_string WITH '"Changeable"'.
        REPLACE ALL OCCURRENCES OF '"REWORKUNIT"' IN lv_string WITH '"ReworkUnit"'.
        REPLACE ALL OCCURRENCES OF '"OVERDELIVERYTOLERANCE"' IN lv_string WITH '"OverdeliveryTolerance"'.

        REPLACE ALL OCCURRENCES OF '"GOODSMOVEMENTS"' IN lv_string WITH '"_GoodsMovements"'.
        REPLACE ALL OCCURRENCES OF '"MATERIAL"' IN lv_string WITH '"Material"'.
        REPLACE ALL OCCURRENCES OF '"DESCRIPTION"' IN lv_string WITH '"Description"'.
        REPLACE ALL OCCURRENCES OF '"QUANTITY"' IN lv_string WITH '"Quantity"'.
        REPLACE ALL OCCURRENCES OF '"STORAGELOCATION"' IN lv_string WITH '"StorageLocation"'.
        REPLACE ALL OCCURRENCES OF '"BATCH"' IN lv_string WITH '"Batch"'.
        REPLACE ALL OCCURRENCES OF '"GOODSMOVEMENTTYPE"' IN lv_string WITH '"GoodsMovementType"'.
        REPLACE ALL OCCURRENCES OF '"UNIT"' IN lv_string WITH '"Unit"'.
        REPLACE ALL OCCURRENCES OF '"MATERIALTYPE"' IN lv_string WITH '"MaterialType"'.
        REPLACE ALL OCCURRENCES OF '"ITEM"' IN lv_string WITH '"Item"'.
        REPLACE ALL OCCURRENCES OF '"MULTIPLIER"' IN lv_string WITH '"Multiplier"'.
        REPLACE ALL OCCURRENCES OF '"ACTIVITIES"' IN lv_string WITH '"_Activities"'.
        REPLACE ALL OCCURRENCES OF '"NAME"' IN lv_string WITH '"Name"'.
        REPLACE ALL OCCURRENCES OF '"UNIT"' IN lv_string WITH '"Unit"'.
        REPLACE ALL OCCURRENCES OF '"QUANTITY"' IN lv_string WITH '"Quantity"'.
        REPLACE ALL OCCURRENCES OF '"SALEABLEWASTE"' IN lv_string WITH '"SaleableWaste"'.
        REPLACE ALL OCCURRENCES OF '"RBCONSUMED"' IN lv_string WITH '"RBConsumed"'.
        REPLACE ALL OCCURRENCES OF '"SHIFTDEFINITION"' IN lv_string WITH '"ShiftDefinition"'.
        REPLACE ALL OCCURRENCES OF '"COMPANYCODE"' IN lv_string WITH '"CompanyCode"'.
        REPLACE ALL OCCURRENCES OF '"CREATEDDATE"' IN lv_string WITH '"CreatedDate"'.
        REPLACE ALL OCCURRENCES OF '"WASTAGETHRESHOLD"' IN lv_string WITH '"WastageThreshold"'.
        REPLACE ALL OCCURRENCES OF '"BATCH101"' IN lv_string WITH '"Batch101"'.
        REPLACE ALL OCCURRENCES OF '"POSTINGDATE"' IN lv_string WITH '"PostingDate"'.

        message = lv_string .
      ENDMETHOD.


      METHOD if_http_service_extension~handle_request.
        CASE request->get_method(  ).
          WHEN CONV string( if_web_http_client=>post ).
            response->set_text( fetchDetails( request ) ).
            response->set_content_type( 'application/json; charset=utf-8' ).
        ENDCASE.

      ENDMETHOD.


      METHOD sendActivity.
        DATA: op_multiplier TYPE p LENGTH 10 DECIMALS 8,
              qty           TYPE p LENGTH 9 DECIMALS 3.
        IF activity IS NOT INITIAL.
          op_multiplier = quantity / over_qty.
          qty = op_multiplier * ( response_type-yieldquantity + response_type-reworkquantity ).

          SELECT SINGLE FROM I_UnitOfMeasure
              FIELDS UnitOfMeasure_E
              WHERE UnitOfMeasure = @unit
              INTO @DATA(unit1) PRIVILEGED ACCESS.

          DATA(activit) = VALUE tt_mfg_order_activites(
                                  Item       = lines( response_type-Activities ) + 1
                                  Name       = to_upper( name )
                                  Multiplier = op_multiplier
                                  Quantity   = qty
                                  Unit       = unit1
                           ).
          APPEND activit TO response_type-Activities.
        ENDIF.

      ENDMETHOD.


      METHOD validate.


        DATA lv_mfgorder TYPE aufnr.
        lv_mfgorder = |{ filled_details-ManufacturingOrder ALPHA = IN }|.

        SELECT SINGLE FROM I_MfgOrderWithStatus
          FIELDS OrderIsReleased,OrderIsDelivered,OrderIsTechnicallyCompleted,OrderIsDeleted,
                 MfgOrderConfirmedYieldQty, MfgOrderPlannedTotalQty
          WHERE ManufacturingOrder = @lv_mfgorder
          INTO @DATA(mfg_order) PRIVILEGED ACCESS.

        IF mfg_order IS INITIAL.
          message = |Manufacturing Order { lv_mfgorder } does not exist.| .
          RETURN.
        ELSEIF mfg_order-OrderIsReleased IS INITIAL.
          message = |Manufacturing Order { lv_mfgorder } is not released.| .
          RETURN.
        ELSEIF mfg_order-MfgOrderConfirmedYieldQty EQ mfg_order-MfgOrderPlannedTotalQty.
          message = |Manufacturing Order { filled_details-ManufacturingOrder } is already delivered.| .
          RETURN.
        ELSEIF mfg_order-OrderIsTechnicallyCompleted IS NOT INITIAL.
          message = |Manufacturing Order { lv_mfgorder } is technically completed.| .
          RETURN.
        ELSEIF mfg_order-OrderIsDeleted IS NOT INITIAL.
          message = |Manufacturing Order { lv_mfgorder } is deleted.| .
          RETURN.
        ENDIF.

        IF filled_details-postingdate IS INITIAL.
          message = |Posting Date is mandatory.| .
          RETURN.
        ENDIF.
      ENDMETHOD.


      METHOD generate_batch.

        DATA: lv_day        TYPE c LENGTH 2,
              lv_month2     TYPE c LENGTH 2,
              lv_year       TYPE c LENGTH 2,
              lv_yearcode   TYPE c LENGTH 2,
              lv_nature     TYPE c LENGTH 1,
              lv_mat_type   TYPE prodh_d,
              lv_prefix     TYPE string,
              lv_pattern    TYPE string,
              lv_last_batch TYPE charg_d,
              lv_last_count TYPE i VALUE 0,
              lv_new_count  TYPE i,
              lv_prefix_len TYPE i.

        "---- Date split (YYYYMMDD)
        lv_day    = iv_mfg_date+6(2).
        lv_month2 = iv_mfg_date+4(2).
        lv_year   = iv_mfg_date+2(2).


        "commented by AS
*  IF lv_month2 BETWEEN '01' AND '03'.
*    lv_yearcode = lv_year - 1.
*  ELSE.
*    lv_yearcode = lv_year.
*  ENDIF.

        "Added by AS
        lv_yearcode = lv_year.


        "---- Get Material Type
        SELECT SINGLE ProductType
          FROM I_Product
          WHERE Product = @iv_material
          INTO @lv_mat_type.

        CASE lv_mat_type.
          WHEN 'ZFGM'. lv_nature = 'F'.
          WHEN 'ZRAW'. lv_nature = 'R'.
          WHEN 'ZSFG'. lv_nature = 'S'.
          WHEN 'ZTRD'. lv_nature = 'T'.
          WHEN 'ZPKG'. lv_nature = 'P'.
          WHEN OTHERS. lv_nature = 'X'.
        ENDCASE.

        SELECT SINGLE FROM I_MfgOrderConfMatlDocItem
        FIELDS MAX( Batch ) AS Batch
        WHERE Material = @iv_material
              AND PostingDate = @iv_mfg_date
              AND IsReversal IS INITIAL AND IsReversed IS INITIAL
        INTO @lv_last_batch.

        lv_new_count = CONV i( lv_last_batch+7(3) ) + count.
        rv_batch = |{ lv_nature }{ lv_day }{ lv_month2 }{ lv_yearcode }{ lv_new_count WIDTH = 3 ALIGN = RIGHT PAD = '0' }|.

      ENDMETHOD.
ENDCLASS.
