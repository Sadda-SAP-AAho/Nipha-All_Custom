 CLASS zcl_grn_register DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

   PUBLIC SECTION.
     INTERFACES if_rap_query_provider.
   PROTECTED SECTION.
   PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GRN_REGISTER IMPLEMENTATION.


   METHOD if_rap_query_provider~select.

     DATA: lt_response    TYPE TABLE OF zcds_grn_reg,
           ls_response    LIKE LINE OF lt_response,
           lt_responseout LIKE lt_response,
           ls_responseout LIKE LINE OF lt_responseout,
           grn_value      TYPE p LENGTH 8 DECIMALS 2.
     DATA: lr_mat_doc TYPE RANGE OF i_operationalacctgdocitem-originalreferencedocument,
           mat_doc    TYPE c LENGTH 10.
     DATA: lv_fiscal_year TYPE n LENGTH 4.
     DATA: lv_year TYPE n LENGTH 4.
     DATA: lv_month TYPE n LENGTH 2.
     DATA: lv_postingdate TYPE string.
     DATA: month TYPE n LENGTH 2.

     DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
     DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
     DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                 ELSE lv_top ).

     TRY.
         DATA(lt_clause) = io_request->get_filter( )->get_as_ranges( ).
       CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
         CLEAR lx_no_range.
     ENDTRY.

     DATA(lt_parameter) = io_request->get_parameters( ).
     DATA(lt_fields)    = io_request->get_requested_elements( ).
     DATA(lt_sort)      = io_request->get_sort_elements( ).

     TRY.
         DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
       CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
         CLEAR lx_no_sel_option.
     ENDTRY.

     LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
       IF ls_filter_cond-name = 'MATERIALDOCUMENT'.
         DATA(lt_material_document) = ls_filter_cond-range[].
       ELSEIF ls_filter_cond-name = 'SUPPLIERCODE'.
         DATA(lt_supplier_code) = ls_filter_cond-range[].
       ELSEIF ls_filter_cond-name = 'FISCALYEAR'.
         DATA(lt_fiscal_year) = ls_filter_cond-range[].
       ELSEIF ls_filter_cond-name = 'PLANT'.
         DATA(lt_plant) = ls_filter_cond-range[].
       ELSEIF ls_filter_cond-name = 'GRNPOSTINGDATE'.
         DATA(lt_postingdate) = ls_filter_cond-range[].
       ELSEIF ls_filter_cond-name = 'DELIVERYNOTENO'.
         DATA(lt_delivery_note) = ls_filter_cond-range[].
       ENDIF.
     ENDLOOP.

     SELECT FROM i_materialdocumentitem_2 AS a
       INNER JOIN i_purchaseorderitemapi01 AS b ON  b~purchaseorder = a~purchaseorder AND b~purchaseorderitem = a~purchaseorderitem
       LEFT JOIN i_purchaserequisitionitemapi01 AS c ON  c~purchaserequisition = b~purchaserequisition AND c~purchaserequisitionitem = b~purchaserequisitionitem
       INNER JOIN i_purchaseorderapi01 AS d ON  d~purchaseorder = b~purchaseorder
       INNER JOIN i_materialdocumentheader_2 AS h ON  h~materialdocument = a~materialdocument AND h~materialdocumentyear = a~materialdocumentyear
       LEFT JOIN i_supplier AS k ON  k~supplier = d~supplier
       LEFT JOIN i_purchaseorderitemtp_2 AS l ON  l~purchaseorder = a~purchaseorder AND l~purchaseorderitem = a~purchaseorderitem
       LEFT JOIN i_materialdocumentitemtp AS m ON  m~materialdocument = a~materialdocument AND m~materialdocumentitem = a~materialdocumentitem AND m~materialdocumentyear = a~materialdocumentyear
       LEFT JOIN i_product AS n ON  n~product = b~material
       LEFT JOIN i_unitofmeasure AS o ON  n~baseunit = o~unitofmeasuresapcode
*       LEFT JOIN i_purchaseorderhistoryapi01 AS p ON a~purchaseorder = p~purchaseorder
*LEFT JOIN I_PURCHASEREQUISITIONITEMBASIC as q on b~PURCHASEREQUISITION = q~PURCHASEREQUISITION
       FIELDS
*       d~lastchangedatetime,
            a~materialdocument ,
            a~purchaseorderitem,
            c~purchaserequisitionitem,
            a~materialdocumentitem ,
            a~plant ,
            a~companycode ,
            a~postingdate ,
            a~documentdate,
            a~glaccount,
            a~costcenter ,
            a~documentdate AS deliverydate ,
            a~yy1_ewaybillno_mmi ,
            a~quantityinentryunit,
            a~totalgoodsmvtamtincccrcy,
            b~purchaserequisition ,
            b~yy1_pr_date_pdi ,
            b~purchaseorder ,
            b~orderquantity ,
            b~purchaseorderquantityunit,
            b~materialtype ,
            b~material ,
            b~purchaseorderitemtext ,
            b~materialgroup ,
            b~baseunit ,
            b~yy1_assetcode_pdi ,
            b~grossamount,
            b~netamount,
            c~requestedquantity ,
            d~purchaseordertype ,
            d~purchaseorderdate,
            d~supplier,
            h~referencedocument ,
            k~suppliername ,
            k~bpaddrcityname ,
            k~businesspartnerpannumber ,
            k~taxnumber3 ,
            k~region ,
            l~consumptiontaxctrlcode ,
            m~yy1_shortqty_mmi ,
            b~grossamount AS netpriceamount,
            o~unitofmeasure_e,
            a~goodsmovementtype
           WHERE a~materialdocument IN @lt_material_document
           AND a~supplier IN @lt_supplier_code
           AND h~referencedocument IN @lt_delivery_note
           AND a~plant IN @lt_plant
           AND a~postingdate IN @lt_postingdate
           AND a~goodsmovementtype IN ( '101' , '102' , '161' , '162' )
           AND a~purchaseorder IS NOT INITIAL
           ORDER BY a~postingdate DESCENDING
           INTO TABLE @DATA(it)
           PRIVILEGED ACCESS.


     SELECT DISTINCT
            a~materialdocument,
            a~purchaseorder,
            b~lastchangedatetime
       FROM i_materialdocumentitem_2 AS a
       INNER JOIN i_purchaseorderapi01 AS b
         ON a~purchaseorder = b~purchaseorder
       WHERE a~materialdocument IN @lt_material_document
       INTO TABLE @DATA(polasttime)
       PRIVILEGED ACCESS.


*   SELECT FROM i_materialdocumentitem_2 AS a
*       left JOIN i_purchaseorderitemapi01 AS b ON  b~purchaseorder = a~purchaseorder
*       left join I_PURCHASEREQUISITIONAPI01 as c on b~PurchaseRequisition = c~PurchaseRequisition
*       fields
*       a~PurchaseOrder,
*       b~PurchaseRequisition,
*       c~LastChangeDateTime
*       WHERE a~materialdocument IN @lt_material_document
*      INTO TABLE @DATA(prlasttime)
*   PRIVILEGED ACCESS.


     SELECT FROM i_materialdocumentitem_2 AS a

            INNER JOIN i_purchaseorderitemapi01 AS b
              ON  b~purchaseorder     = a~purchaseorder
              AND b~purchaseorderitem = a~purchaseorderitem

            LEFT JOIN i_purchaserequisitionitemapi01 AS c
              ON  c~purchaserequisition     = b~purchaserequisition
              AND c~purchaserequisitionitem = b~purchaserequisitionitem

            FIELDS
              a~materialdocument,
              a~materialdocumentitem,
              a~purchaseorder,
              a~purchaseorderitem,
              b~purchaserequisition,
              b~purchaserequisitionitem,
              c~lastchangedatetime

            WHERE a~materialdocument IN @lt_material_document

            INTO TABLE @DATA(prlasttime)

            PRIVILEGED ACCESS.



     SELECT FROM i_materialdocumentitem_2 AS a
      LEFT JOIN i_purordschedulelineapi01 AS b ON a~purchaseorder = b~purchaseorder AND a~purchaseorderitem = b~purchaseorderitem
      FIELDS
      a~materialdocument,
      a~materialdocumentitem,
      b~schedulelineorderquantity,
      b~roughgoodsreceiptqty
      WHERE a~materialdocument IN @lt_material_document
      INTO TABLE @DATA(it_poqty)
   PRIVILEGED ACCESS.



     SELECT FROM i_materialdocumentitem_2 AS a
     INNER JOIN i_workflowstatusoverview AS w_po ON  w_po~sapbusinessobjectnodekey1 = a~purchaseorder
     INNER JOIN i_workflowstatusdetails AS wd_po ON  wd_po~workflowinternalid = w_po~workflowinternalid
     INNER JOIN i_businessuserbasic AS bu_po ON  bu_po~userid = wd_po~workflowtaskprocessor
        FIELDS a~materialdocument ,
        a~materialdocumentitem ,
         bu_po~personfullname,
        w_po~wrkflwtskcompletionutcdatetime
         WHERE a~materialdocument IN @lt_material_document
         AND a~supplier IN @lt_supplier_code
         AND a~plant IN @lt_plant
         AND a~postingdate IN @lt_postingdate
         AND a~goodsmovementtype IN ( '101' , '102' , '161' , '162' )
         AND a~purchaseorder IS NOT INITIAL
         ORDER BY wd_po~wrkflwtskcompletionutcdatetime DESCENDING
         INTO TABLE @DATA(it_appprove_po)
         PRIVILEGED ACCESS.

     SELECT FROM i_materialdocumentitem_2 AS a

       INNER JOIN i_purchaseorderitemapi01 AS b
         ON  b~purchaseorder     = a~purchaseorder
         AND b~purchaseorderitem = a~purchaseorderitem

       INNER JOIN i_workflowstatusoverview AS w_pr
         ON w_pr~sapbusinessobjectnodekey1 = b~purchaserequisition

       INNER JOIN i_workflowstatusdetails AS wd_pr
         ON wd_pr~workflowinternalid = w_pr~workflowinternalid

       LEFT JOIN i_businessuserbasic AS bu_pr
         ON bu_pr~userid = wd_pr~workflowtaskprocessor

       FIELDS
         a~materialdocument,
         a~materialdocumentitem,

         bu_pr~personfullname AS pr_approver,

         wd_pr~wrkflwtskcompletionutcdatetime AS pr_approver_date


       WHERE a~materialdocument IN @lt_material_document
         AND a~supplier        IN @lt_supplier_code
         AND a~plant           IN @lt_plant
         AND a~postingdate     IN @lt_postingdate
         AND a~goodsmovementtype IN ( '101', '102', '161', '162' )
         AND a~purchaseorder IS NOT INITIAL
         AND b~purchaserequisition IS NOT INITIAL

       ORDER BY
         a~materialdocument ASCENDING,
         a~materialdocumentitem ASCENDING,
         wd_pr~wrkflwtskcompletionutcdatetime DESCENDING

       INTO TABLE @DATA(it_appprove_pr)

       PRIVILEGED ACCESS.

     SELECT FROM i_materialdocumentitem_2 AS a
     INNER JOIN i_purchaseorderitemapi01 AS b ON b~purchaseorder = a~purchaseorder AND b~purchaseorderitem = a~purchaseorderitem
     LEFT JOIN i_rfqitem_api01 AS e ON e~purchaserequisition = b~purchaserequisition AND e~purchaserequisitionitem = b~purchaserequisitionitem
           AND e~purchaserequisition IS NOT INITIAL
     INNER JOIN i_glaccounttext AS f ON f~glaccount = a~glaccount AND f~language EQ 'E'
     INNER JOIN i_costcentertext AS g ON g~costcenter = a~costcenter AND g~language EQ 'E'
     INNER JOIN i_productgrouptext_2 AS h ON h~productgroup = b~materialgroup AND h~language EQ 'E'
     FIELDS a~materialdocument , a~materialdocumentitem , a~purchaseorder, b~purchaserequisition ,b~purchaserequisitionitem,
     a~costcenter,
            e~requestforquotation ,
            f~glaccountname ,
            g~costcenterdescription ,
            h~productgroupname
     WHERE a~materialdocument IN @lt_material_document
*     AND a~purchaseorder IS NOT INITIAL
     AND a~supplier IN @lt_supplier_code
     ORDER BY a~postingdate DESCENDING , a~materialdocumentitem ASCENDING , a~materialdocument ASCENDING
     INTO TABLE @DATA(it_2)
     PRIVILEGED ACCESS.


     SELECT FROM i_materialdocumentitem_2 AS a
     INNER JOIN i_purchaseorderitemapi01 AS b ON b~purchaseorder = a~purchaseorder AND b~purchaseorderitem = a~purchaseorderitem
     LEFT JOIN i_rfqitem_api01 AS e ON e~purchaserequisition = b~purchaserequisition AND e~purchaserequisitionitem = b~purchaserequisitionitem
           AND e~purchaserequisition IS NOT INITIAL
     LEFT JOIN c_requestforquotationdex AS f ON e~requestforquotation = f~requestforquotation
*     LEFT join I_RFQITEMENHWD as h on b~PurchaseRequisition = h~PurchaseRequisition

           FIELDS a~materialdocument , a~materialdocumentitem , a~purchaseorder, b~purchaserequisition ,b~purchaserequisitionitem,
     a~costcenter,
            e~requestforquotation,
            f~rfqpublishingdate,
            f~LastChangeDateTime
            WHERE a~materialdocument IN @lt_material_document
            INTO TABLE @DATA(it_3)
     PRIVILEGED ACCESS.




     SELECT FROM i_materialdocumentitem_2 AS a
     INNER JOIN i_costcentertext AS g ON g~costcenter = a~costcenter AND g~language EQ 'E'
     FIELDS a~materialdocument , a~materialdocumentitem ,
     a~costcenter,
            g~costcenterdescription
            WHERE a~materialdocument IN @lt_material_document
            INTO TABLE @DATA(costname)
     PRIVILEGED ACCESS.

     SORT costname BY
    materialdocument ASCENDING
    materialdocumentitem ASCENDING.


     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_purorditmpricingelementapi01 AS b ON b~purchaseorder = a~purchaseorder AND b~purchaseorderitem = a~purchaseorderitem
     FIELDS a~materialdocument , a~materialdocumentitem ,
            b~conditionamount , b~conditiontype , b~conditionratevalue
     WHERE a~materialdocument IN @lt_material_document
       AND b~conditiontype IN ('PMP0' , 'ZL01' , 'ZDC2' , 'ZFGW' , 'ZPFC' , 'ZCDB' , 'ZFVA')
       ORDER BY a~materialdocument ASCENDING, a~materialdocumentitem ASCENDING
     INTO TABLE @DATA(it_pricing)
     PRIVILEGED ACCESS.

     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_serviceentrysheetapi01 AS b ON b~materialdocument = a~materialdocument
     FIELDS a~materialdocument , a~materialdocumentitem ,
            b~serviceentrysheet , b~postingdate
     WHERE a~materialdocument IN @lt_material_document
     INTO TABLE @DATA(it_serviceentry)
     PRIVILEGED ACCESS.

     SORT it_serviceentry BY materialdocument ASCENDING materialdocumentitem ASCENDING.

     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_purchaseorderitemapi01 AS po ON po~purchaseorder = a~purchaseorder "AND po~purchaseorderitem = a~purchaseorderitem
     LEFT JOIN i_serviceentrysheetapi01 AS b ON b~materialdocument = a~materialdocument
     LEFT JOIN i_materialdocumentheader_2 AS c ON a~materialdocument = c~materialdocument
     LEFT JOIN i_businessuserbasic AS d ON c~createdbyuser = d~userid
     FIELDS a~materialdocument ,
            a~materialdocumentitem ,
            b~serviceentrysheet ,
            b~postingdate,
            b~createdbyuser ,
            c~createdbyuser AS createduser,
            d~personfullname
     WHERE a~materialdocument IN @lt_material_document
     INTO TABLE @DATA(it_grncreatedby)
     PRIVILEGED ACCESS.

     SELECT FROM i_materialdocumentitem_2 AS a
          LEFT JOIN i_purchaseorderitemapi01 AS po ON po~purchaseorder = a~purchaseorder "AND po~purchaseorderitem = a~purchaseorderitem
          LEFT JOIN i_serviceentrysheetapi01 AS b ON b~materialdocument = a~materialdocument
          LEFT JOIN i_businessuserbasic AS d ON b~createdbyuser = d~userid
          FIELDS a~materialdocument ,
                 a~materialdocumentitem ,
                 b~serviceentrysheet ,
                 b~postingdate,
                 b~createdbyuser ,
                 d~personfullname
                 WHERE a~materialdocument IN @lt_material_document
          INTO TABLE @DATA(it_grncreatedbyifzser)
          PRIVILEGED ACCESS.


     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_materialdocumentheader_2 AS b ON a~materialdocument = b~materialdocument
     FIELDS
     a~materialdocument,
    a~materialdocumentitem,
     b~creationdate , b~creationtime
      WHERE a~materialdocument IN @lt_material_document
      INTO TABLE @DATA(it_grncreateddateandtimee)
     PRIVILEGED ACCESS.

     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_purchaserequisitionitemapi01 AS b ON a~purchaseorder = b~purchasingdocument
     FIELDS
     b~purchaserequisitionitem,
     b~purchaserequisition,
     a~materialdocument,
      b~requestedquantity  AS requestedquantity,
     b~orderedquantity    AS orderedquantity
     WHERE a~materialdocument IN @lt_material_document
     GROUP BY
     a~materialdocument,
    b~purchaserequisition,
    b~purchaserequisitionitem,
    b~requestedquantity,
    b~orderedquantity
    INTO TABLE @DATA(it_pr_qty)
     PRIVILEGED ACCESS.

     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_serviceentrysheetapi01 AS c ON a~materialdocument = c~materialdocument
     LEFT JOIN i_workflowstatusoverview AS d ON c~serviceentrysheet = d~sapbusinessobjectnodekey1
     LEFT JOIN i_workflowstatusdetails AS e ON d~workflowinternalid = e~workflowinternalid
     LEFT JOIN i_businessuser AS f ON e~workflowtaskprocessor = f~userid
     FIELDS
     a~materialdocument,
     a~materialdocumentitem,
     c~serviceentrysheet,
     d~workflowinternalid,
     e~workflowtaskprocessor,
     f~personfullname,
     e~wrkflwtskcompletionutcdatetime
     WHERE a~materialdocument IN @lt_material_document
      INTO TABLE @DATA(sesapprovedby)
     PRIVILEGED ACCESS.

     SORT sesapprovedby BY materialdocument
                       materialdocumentitem
                       wrkflwtskcompletionutcdatetime DESCENDING.

     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_serviceentrysheetapi01 AS c ON a~materialdocument = c~materialdocument
     LEFT JOIN i_workflowstatusoverview AS d ON c~serviceentrysheet = d~sapbusinessobjectnodekey1
     LEFT JOIN i_workflowstatusdetails AS e ON d~workflowinternalid = e~workflowinternalid
     FIELDS
     c~serviceentrysheet,
     a~materialdocument,
     a~materialdocumentitem,
     d~workflowinternalid,
     e~workflowtaskprocessor,
     e~wrkflwtskcompletionutcdatetime
     WHERE a~materialdocument IN @lt_material_document
     ORDER BY e~workflowtaskprocessor DESCENDING
     INTO TABLE @DATA(approvedatetime)
     PRIVILEGED ACCESS.


     SELECT FROM i_inspectionlot AS a
      INNER JOIN i_insplotusagedecision AS b ON a~inspectionlot = b~inspectionlot
      INNER JOIN i_businessuser AS c ON b~inspectionlotusagedecidedby = c~userid

      FIELDS
        a~materialdocument,
        a~inspectionlot,
        b~inspectionlotusagedecidedon,
        b~insplotusagedecisiontime,
        b~inspectionlotusagedecidedby,
        c~personfullname
      WHERE a~materialdocument IN @lt_material_document
      INTO TABLE @DATA(it_quality_clearance)
      PRIVILEGED ACCESS.

     SORT it_quality_clearance BY
          materialdocument
          inspectionlotusagedecidedon DESCENDING
          insplotusagedecisiontime DESCENDING.

     SELECT FROM i_materialdocumentitem_2 AS a
       INNER JOIN i_purchaseorderitemapi01 AS b
         ON  b~purchaseorder     = a~purchaseorder
         AND b~purchaseorderitem = a~purchaseorderitem
       FIELDS
         a~materialdocument,
         a~materialdocumentitem,
         a~purchaseorder,
         a~purchaseorderitem,
         b~orderquantity
       WHERE a~materialdocument IN @lt_material_document
         AND a~purchaseorder IS NOT INITIAL
       INTO TABLE @DATA(it_po_qty)
       PRIVILEGED ACCESS.


     SELECT FROM i_materialdocumentitem_2 AS a
     INNER JOIN i_purchaseorderhistoryapi01 AS c
       ON  c~purchaseorder     = a~purchaseorder
       AND c~purchaseorderitem = a~purchaseorderitem
     FIELDS
       a~materialdocument,
       a~materialdocumentitem,
       a~purchaseorder,
       a~purchaseorderitem,
       SUM( c~qtyinpurchaseorderpriceunit ) AS historyqty
     WHERE a~materialdocument IN @lt_material_document
       AND a~purchaseorder IS NOT INITIAL
     GROUP BY
       a~materialdocument,
       a~materialdocumentitem,
       a~purchaseorder,
       a~purchaseorderitem
     INTO TABLE @DATA(it_po_history)
     PRIVILEGED ACCESS.


     DATA: lv_open_qty TYPE decfloat34.

     LOOP AT it_po_qty INTO DATA(wa_po_qty).


       READ TABLE it_po_history INTO DATA(wa_po_history)
         WITH KEY
           purchaseorder     = wa_po_qty-purchaseorder
           purchaseorderitem = wa_po_qty-purchaseorderitem.

       IF sy-subrc = 0.

         lv_open_qty = wa_po_qty-orderquantity
                     - wa_po_history-historyqty.

       ELSE.

         lv_open_qty = wa_po_qty-orderquantity.

       ENDIF.

     ENDLOOP.

     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_purchaseordschedulelinetp_2 AS b ON a~purchaseorder = b~purchaseorder
     FIELDS
     a~materialdocument,
     a~materialdocumentitem,
     b~schedulelinedeliverydate
     WHERE a~materialdocument IN @lt_material_document
     INTO TABLE @DATA(it_deliverysecduledate)
       PRIVILEGED ACCESS.

     SELECT FROM i_materialdocumentitem_2 AS a
     INNER JOIN i_suplrinvcitempurordrefapi01 AS b
    ON a~invtrymgmtreferencedocument = b~referencedocument

  INNER JOIN i_supplierinvoiceapi01 AS c
    ON b~supplierinvoice = c~supplierinvoice
     FIELDS
     a~materialdocument,
     a~materialdocumentitem,
     a~invtrymgmtreferencedocument,
     b~supplierinvoice,
     c~postingdate,
     c~creationtime
     WHERE a~materialdocument IN @lt_material_document
*     AND b~supplierinvoice IS NOT INITIAL
     INTO TABLE @DATA(it_mironumber)
     PRIVILEGED ACCESS.

*     SORT it_mironumber BY
*    materialdocument ASCENDING
*    materialdocumentitem ASCENDING
*    supplierinvoice DESCENDING.
*     DELETE ADJACENT DUPLICATES FROM it_mironumber COMPARING materialdocument.


     SELECT FROM i_materialdocumentitem_2 AS a
     LEFT JOIN i_purchaseorderhistoryapi01 AS b ON b~purchasinghistorydocument = a~materialdocument
     FIELDS a~materialdocument , a~materialdocumentitem ,
            b~quantityindeliveryqtyunit , a~goodsmovementtype , b~purchaseorderamount
     WHERE a~materialdocument IN @lt_material_document
     INTO TABLE @DATA(it_challanqty)
     PRIVILEGED ACCESS.

     SORT it_challanqty BY materialdocument ASCENDING materialdocumentitem ASCENDING.

     DATA: lv_previous_materialdocument TYPE i_materialdocumentitem_2-materialdocument.


     DATA lt_vehicle_shown
       TYPE SORTED TABLE OF i_purchaseorderitemapi01-purchaseorder
       WITH UNIQUE KEY table_line.

     DATA lt_pr_lastchange_shown
TYPE SORTED TABLE OF i_purchaseorderitemapi01-purchaserequisition
WITH UNIQUE KEY table_line.

     DATA lt_po_lastchange_shown
       TYPE SORTED TABLE OF i_purchaseorderitemapi01-purchaseorder
       WITH UNIQUE KEY table_line.


     LOOP AT it INTO DATA(wa).

       DATA: lv_pr_lastchange_ts  TYPE timestampl,
             lv_pr_lastchange_ist TYPE timestampl.

       CLEAR:
         lv_pr_lastchange_ts,
         lv_pr_lastchange_ist,
         ls_response-prlastchangetime.

       READ TABLE lt_pr_lastchange_shown
         WITH TABLE KEY table_line = wa-purchaserequisition
         TRANSPORTING NO FIELDS.

       IF sy-subrc <> 0.

*         READ TABLE prlasttime
*           INTO DATA(wa_prlasttime)
*           WITH KEY
*             purchaseorder       = wa-purchaseorder
*             purchaserequisition = wa-purchaserequisition.
*
*         IF sy-subrc = 0
*            AND wa_prlasttime-lastchangedatetime IS NOT INITIAL.
*
*           lv_pr_lastchange_ts = wa_prlasttime-lastchangedatetime.
*
*           " UTC -> IST
*           lv_pr_lastchange_ist = cl_abap_tstmp=>add(
*                                    tstmp = lv_pr_lastchange_ts
*                                    secs  = 19800 ).
*
*           DATA(lv_pr_lastchange_string) =
*             CONV string( lv_pr_lastchange_ist ).
*
*           CONDENSE lv_pr_lastchange_string NO-GAPS.
*
*           IF strlen( lv_pr_lastchange_string ) >= 14.
*
*             ls_response-prlastchangetime =
*               |{ lv_pr_lastchange_string+8(2) }:{ lv_pr_lastchange_string+10(2) }:{ lv_pr_lastchange_string+12(2) }|.
*
*           ENDIF.
*
*         ENDIF.
*
*         INSERT wa-purchaserequisition INTO TABLE lt_pr_lastchange_shown.
*
*       ELSE.
*
*         CLEAR ls_response-prlastchangetime.
*
*       ENDIF.



         READ TABLE prlasttime
           INTO DATA(wa_prlasttime)
           WITH KEY
             materialdocument     = wa-materialdocument
             materialdocumentitem = wa-materialdocumentitem
             purchaseorder        = wa-purchaseorder
             purchaseorderitem    = wa-purchaseorderitem
             purchaserequisition  = wa-purchaserequisition
             purchaserequisitionitem = wa-purchaserequisitionitem.

         IF sy-subrc = 0
            AND wa_prlasttime-lastchangedatetime IS NOT INITIAL.

           lv_pr_lastchange_ts = wa_prlasttime-lastchangedatetime.

           " UTC -> IST
           lv_pr_lastchange_ist = cl_abap_tstmp=>add(
                                    tstmp = lv_pr_lastchange_ts
                                    secs  = 19800 ).

           DATA(lv_pr_lastchange_string) =
             CONV string( lv_pr_lastchange_ist ).

           CONDENSE lv_pr_lastchange_string NO-GAPS.

           IF strlen( lv_pr_lastchange_string ) >= 14.

             ls_response-prlastchangetime =
               |{ lv_pr_lastchange_string+8(2) }:{ lv_pr_lastchange_string+10(2) }:{ lv_pr_lastchange_string+12(2) }|.

           ENDIF.

         ENDIF.

       ENDIF.

       DATA: lv_lastchange_ts  TYPE timestampl,
             lv_lastchange_ist TYPE timestampl.

       CLEAR:
         lv_lastchange_ts,
         lv_lastchange_ist,
         ls_response-purchaseorderlastchangetime.

       READ TABLE lt_po_lastchange_shown
         WITH TABLE KEY table_line = wa-purchaseorder
         TRANSPORTING NO FIELDS.

       IF sy-subrc <> 0.


         READ TABLE polasttime
           INTO DATA(wa_polasttime)
           WITH KEY purchaseorder = wa-purchaseorder.

         IF sy-subrc = 0
            AND wa_polasttime-lastchangedatetime IS NOT INITIAL.

           lv_lastchange_ts = wa_polasttime-lastchangedatetime.

           " UTC -> IST
           lv_lastchange_ist = cl_abap_tstmp=>add(
                                 tstmp = lv_lastchange_ts
                                 secs  = 19800 ).

           DATA(lv_lastchange_string) =
             CONV string( lv_lastchange_ist ).

           CONDENSE lv_lastchange_string NO-GAPS.

           IF strlen( lv_lastchange_string ) >= 14.

             ls_response-purchaseorderlastchangetime =
               |{ lv_lastchange_string+8(2) }:{ lv_lastchange_string+10(2) }:{ lv_lastchange_string+12(2) }|.

           ENDIF.

         ENDIF.
       ENDIF.


*  READ TABLE polasttime
*    INTO DATA(wa_polasttime)
*    WITH KEY
*      materialdocument = wa-materialdocument
*      purchaseorder    = wa-purchaseorder.
*
*  IF sy-subrc = 0
*     AND wa_polasttime-lastchangedatetime IS NOT INITIAL.
*
*    lv_lastchange_ts = wa_polasttime-lastchangedatetime.
*
*    " UTC -> IST
*    lv_lastchange_ist = cl_abap_tstmp=>add(
*                          tstmp = lv_lastchange_ts
*                          secs  = 19800 ).
*
*    DATA(lv_lastchange_string) =
*      CONV string( lv_lastchange_ist ).
*
*    CONDENSE lv_lastchange_string NO-GAPS.
*
*    IF strlen( lv_lastchange_string ) >= 14.
*
*      ls_response-purchaseorderlastchangetime =
*        |{ lv_lastchange_string+8(2) }:{ lv_lastchange_string+10(2) }:{ lv_lastchange_string+12(2) }|.
*
*    ENDIF.
*
*  ENDIF.
*
*  INSERT wa-purchaseorder INTO TABLE lt_po_lastchange_shown.
*
*ELSE.
*
*  CLEAR ls_response-purchaseorderlastchangetime.
*
*ENDIF.



       DATA: lt_quality_shown
          TYPE SORTED TABLE OF i_materialdocumentitem_2-materialdocument
          WITH UNIQUE KEY table_line.

*       IF wa-purchaseordertype = 'ZSER'.
*         IF lv_previous_materialdocument = wa-materialdocument.
*
*           CLEAR:
*             ls_response-mironumber,
*             ls_response-miropostingdate.
*
*         ELSE.
*
*           READ TABLE it_mironumber
*             INTO DATA(wa_mironumber)
*             WITH KEY materialdocument = wa-materialdocument.
*
*           IF sy-subrc = 0.
*             ls_response-mironumber     = wa_mironumber-supplierinvoice.
*           ENDIF.
*
*         ENDIF.
*       ENDIF.



       CLEAR:
         ls_response-mironumber,
         ls_response-miropostingdate.



       READ TABLE it_mironumber
         INTO DATA(wa_mironumber)
         WITH KEY materialdocument = wa-materialdocument.

       IF sy-subrc = 0.

         IF wa-purchaseordertype = 'ZSER'.

           " ZSER -> MIRO/Supplier Invoice
           ls_response-mironumber =
             wa_mironumber-supplierinvoice.

         ELSE.

           " Non-ZSER -> Supplier Invoice also
           ls_response-mironumber =
             wa_mironumber-supplierinvoice.

         ENDIF.

       ENDIF.



*       IF wa-purchaseordertype = 'ZSER'.
*
*  CLEAR ls_response-mironumber.
*
*  READ TABLE it_mironumber
*    INTO DATA(wa_mironumber)
*    WITH KEY materialdocument = wa-materialdocument.
*
*  IF sy-subrc = 0.
*
*    ls_response-mironumber =
*      wa_mironumber-invtrymgmtreferencedocument.
*
*  ENDIF.
*
*ELSE.
*
*  ls_response-mironumber =
*    wa_mironumber-supplierinvoice.
*
*ENDIF.

       lv_previous_materialdocument = wa-materialdocument.

       READ TABLE it_grncreatedbyifzser INTO DATA(wa_grncreatedbyifzser)
            WITH KEY
            materialdocument = wa-materialdocument.


       DATA(lv_open_pr_qty) = CONV decfloat34( 0 ).

       READ TABLE it_pr_qty
         INTO DATA(wa_pr_qty)
         WITH KEY
           purchaserequisition     = wa-purchaserequisition
           purchaserequisitionitem = wa-purchaserequisitionitem.

       IF sy-subrc = 0.

         lv_open_pr_qty =
             CONV decfloat34( wa_pr_qty-requestedquantity )
           - CONV decfloat34( wa_pr_qty-orderedquantity ).

       ENDIF.

       ls_response-openindentquantity = lv_open_pr_qty.

       DATA(lv_open_po_qty) = CONV decfloat34( 0 ).

       READ TABLE it_poqty
         INTO DATA(wa_poqty)
         WITH KEY
           materialdocument     = wa-materialdocument
           materialdocumentitem = wa-materialdocumentitem.

       IF sy-subrc = 0.

         lv_open_po_qty =
             CONV decfloat34( wa_poqty-schedulelineorderquantity )
           - CONV decfloat34( wa_poqty-roughgoodsreceiptqty ).

       ENDIF.

       IF lv_open_po_qty < 0.
         lv_open_po_qty = 0.
       ENDIF.

       ls_response-openpoquantity = lv_open_po_qty.

       READ TABLE it_deliverysecduledate
       INTO DATA(wa_deliverysecduledate)
       WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem.

       IF sy-subrc = 0.
         IF wa_deliverysecduledate-materialdocument IS NOT INITIAL
         AND wa_deliverysecduledate-schedulelinedeliverydate IS NOT INITIAL.
           DATA(deliveryscheduledate) =
                 wa_deliverysecduledate-schedulelinedeliverydate.
           ls_response-deliveryscheduledate =
           |{ deliveryscheduledate+0(4) }-{ deliveryscheduledate+4(2) }-{ deliveryscheduledate+6(2) }|.
         ENDIF.
       ENDIF.


       READ TABLE lt_quality_shown
         WITH TABLE KEY table_line = wa-materialdocument
         TRANSPORTING NO FIELDS.

       IF sy-subrc <> 0.

         READ TABLE it_quality_clearance
           INTO DATA(wa_quality_clearance)
           WITH KEY materialdocument = wa-materialdocument.

         IF sy-subrc = 0.

           IF wa_quality_clearance-inspectionlotusagedecidedon IS NOT INITIAL
              AND wa_quality_clearance-insplotusagedecisiontime IS NOT INITIAL.

             DATA(lv_quality_date) =
               wa_quality_clearance-inspectionlotusagedecidedon.

             DATA(lv_quality_time) =
               wa_quality_clearance-insplotusagedecisiontime.

             ls_response-qualityclearancedateandtime =
               |{ lv_quality_date+0(4) }-{ lv_quality_date+4(2) }-{ lv_quality_date+6(2) }| &&
               | { lv_quality_time+0(2) }:{ lv_quality_time+2(2) }:{ lv_quality_time+4(2) }|.

             ls_response-qualityclearedby =
               wa_quality_clearance-personfullname.

           ENDIF.

         ENDIF.

         INSERT wa-materialdocument INTO TABLE lt_quality_shown.

       ELSE.

         CLEAR:
           ls_response-qualityclearedby,
           ls_response-qualityclearancedateandtime.

       ENDIF.


       READ TABLE sesapprovedby INTO DATA(wa_sesapprovedby)
    WITH KEY materialdocument     = wa-materialdocument
             materialdocumentitem = wa-materialdocumentitem.

       READ TABLE approvedatetime
  INTO DATA(wa_approvedatetime)
  WITH KEY materialdocument     = wa-materialdocument
           materialdocumentitem = wa-materialdocumentitem.

       IF wa-plant <> '7001' OR wa-plant <> '7002'.

         READ TABLE it_appprove_po
           INTO DATA(wa_approve_po)
           WITH KEY materialdocument     = wa-materialdocument
                    materialdocumentitem = wa-materialdocumentitem.

         IF sy-subrc = 0.

           ls_response-approvernamelevel1 =
             wa_approve_po-personfullname.

           IF wa_approve_po-wrkflwtskcompletionutcdatetime IS NOT INITIAL.

             DATA(lv_timestamp) =
               CONV string(
                 wa_approve_po-wrkflwtskcompletionutcdatetime ).

             IF strlen( lv_timestamp ) >= 14.

               ls_response-level1date =
                 |{ lv_timestamp+6(2) }.{ lv_timestamp+4(2) }.{ lv_timestamp+0(4) } { lv_timestamp+8(2) }:{ lv_timestamp+10(2) }:{ lv_timestamp+12(2) }|.

             ENDIF.

           ELSE.

             CLEAR ls_response-level1date.

           ENDIF.

         ENDIF.



         READ TABLE it_appprove_pr
           INTO DATA(wa_approve_pr)
           WITH KEY materialdocument     = wa-materialdocument
                    materialdocumentitem = wa-materialdocumentitem.

         IF sy-subrc = 0.

           ls_response-approvernamelevel2 =
             wa_approve_pr-pr_approver.

           IF wa_approve_pr-pr_approver_date IS NOT INITIAL.

             DATA(lv_pr_timestamp) =
               |{ wa_approve_pr-pr_approver_date }|.

             REPLACE ALL OCCURRENCES OF '.' IN lv_pr_timestamp WITH ''.

             CONDENSE lv_pr_timestamp NO-GAPS.

             IF strlen( lv_pr_timestamp ) >= 14.

               ls_response-level2date =
                 |{ lv_pr_timestamp+6(2) }.{ lv_pr_timestamp+4(2) }.{ lv_pr_timestamp+0(4) } { lv_pr_timestamp+8(2) }:{ lv_pr_timestamp+10(2) }:{ lv_pr_timestamp+12(2) }|.

             ELSEIF strlen( lv_pr_timestamp ) >= 8.

               ls_response-level2date =
                 |{ lv_pr_timestamp+6(2) }.{ lv_pr_timestamp+4(2) }.{ lv_pr_timestamp+0(4) }|.

             ELSE.

               CLEAR ls_response-level2date.

             ENDIF.

           ELSE.

             CLEAR ls_response-level2date.

           ENDIF.

         ENDIF.
       ENDIF.

       lv_postingdate = wa-postingdate.
       lv_year = lv_postingdate+0(4).
       lv_month = lv_postingdate+4(2).
       month = lv_month.

       IF month > 03.
         lv_fiscal_year = lv_year.
       ELSE.
         lv_fiscal_year = lv_year - 1.
       ENDIF.

       ls_response-materialdocument = wa-materialdocument.
       ls_response-materialdocumentitem = wa-materialdocumentitem.
       ls_response-companycode = wa-companycode.
       ls_response-plant = wa-plant.
       ls_response-grnpostingdate = wa-postingdate.
       ls_response-purchaserequisition = wa-purchaserequisition.
       ls_response-requisitiondate = wa-yy1_pr_date_pdi.
       ls_response-purchaserequisitionqty = wa-requestedquantity.
       ls_response-purchaseordertype = wa-purchaseordertype.
       ls_response-purchaseorderno = wa-purchaseorder.
       ls_response-purchaseorderdate = wa-purchaseorderdate.
       ls_response-purchaseorderqty = wa-orderquantity.
       ls_response-orderunit = wa-unitofmeasure_e.
       ls_response-pounit = wa-unitofmeasure_e.
       ls_response-vendorinvoicedate = wa-documentdate.
       ls_response-glaccount = wa-glaccount.
       ls_response-costcenter = wa-costcenter.
       ls_response-deliverynoteno = wa-referencedocument.
       ls_response-deliverydate = wa-deliverydate.
       ls_response-suppliercode = wa-supplier.
       ls_response-suppliername = wa-suppliername.
       ls_response-supplieraddress = wa-bpaddrcityname.
       ls_response-supplierpanno = wa-businesspartnerpannumber.
       ls_response-suppliergstinno = wa-taxnumber3.
       ls_response-supplierstate = wa-region.
       ls_response-materialtype = wa-materialtype.
       ls_response-material = wa-material.
       ls_response-materialdescription = wa-purchaseorderitemtext.
       ls_response-materialgroup = wa-materialgroup.
       ls_response-uom = wa-unitofmeasure_e.
       ls_response-assetcode = wa-yy1_assetcode_pdi.
       ls_response-assetdescription = wa-purchaseorderitemtext.
       ls_response-hsnsaccode = wa-consumptiontaxctrlcode.
       ls_response-ewaybillno = wa-yy1_ewaybillno_mmi.
       ls_response-receivedquantity = wa-quantityinentryunit.
       ls_response-netquantity = wa-quantityinentryunit.
       ls_response-shortquantity = wa-yy1_shortqty_mmi.
       ls_response-servicepostingdate = COND #( WHEN wa-purchaseordertype = 'ZSER' THEN wa-postingdate ELSE '00000000' ) .
       ls_response-goodsmovementtype = wa-goodsmovementtype.
       ls_response-sesapprovedby = wa_sesapprovedby-personfullname.
       DATA(lv_timestamp_string) =
         CONV string( wa_approvedatetime-wrkflwtskcompletionutcdatetime ).

       IF strlen( lv_timestamp_string ) >= 14.

         ls_response-approvaldateandtime =
           |{ lv_timestamp_string+6(2) }.{ lv_timestamp_string+4(2) }.{ lv_timestamp_string+0(4) } { lv_timestamp_string+8(2) }:{ lv_timestamp_string+10(2) }:{ lv_timestamp_string+12(2) }|.

       ENDIF.


*       IF wa-purchaseordertype = 'ZSER'.
*         IF wa_mironumber-postingdate IS NOT INITIAL.
*
*           DATA(lv_miro_date) = wa_mironumber-postingdate.
*
*           ls_response-miropostingdate =
*             |{ lv_miro_date+6(2) }.{ lv_miro_date+4(2) }.{ lv_miro_date+0(4) }|.
*
*         ELSE.
*
*           CLEAR ls_response-miropostingdate.
*
*         ENDIF.
*       ENDIF.


*IF wa-purchaseordertype = 'ZSER'.
*
*  IF wa_mironumber-postingdate IS NOT INITIAL.
*
*    DATA(lv_miro_date) = wa_mironumber-postingdate.
*    DATA(lv_miro_time) = wa_mironumber-creationtime.
*
*    IF lv_miro_time IS NOT INITIAL.
*
*      ls_response-miropostingdate =
*        |{ lv_miro_date+6(2) }.{ lv_miro_date+4(2) }.{ lv_miro_date+0(4) }| &&
*        | { lv_miro_time+0(2) }:{ lv_miro_time+2(2) }:{ lv_miro_time+4(2) }|.
*
*    ELSE.
*
*      ls_response-miropostingdate =
*        |{ lv_miro_date+6(2) }.{ lv_miro_date+4(2) }.{ lv_miro_date+0(4) }|.
*
*    ENDIF.
*
*  ELSE.
*
*    CLEAR ls_response-miropostingdate.
*
*  ENDIF.
*
*ENDIF.



*       IF wa-purchaseordertype = 'ZSER'.

       IF wa_mironumber-postingdate IS NOT INITIAL.

         DATA(lv_miro_date) = wa_mironumber-postingdate.
         DATA(lv_miro_time) = wa_mironumber-creationtime.

         IF lv_miro_time IS NOT INITIAL.

           DATA: lv_time_seconds TYPE i.

           lv_time_seconds =
               CONV i( lv_miro_time+0(2) ) * 3600
             + CONV i( lv_miro_time+2(2) ) * 60
             + CONV i( lv_miro_time+4(2) ).

           " Add 5 hours 30 minutes
           lv_time_seconds = lv_time_seconds + 19800.

           " Handle next day
           IF lv_time_seconds >= 86400.
             lv_time_seconds = lv_time_seconds - 86400.

             " Increase MIRO date by 1 day
             DATA: lv_miro_date_d TYPE d.
             lv_miro_date_d = lv_miro_date.
             lv_miro_date_d = lv_miro_date_d + 1.

             lv_miro_date = lv_miro_date_d.
           ENDIF.

           DATA: lv_miro_hour TYPE i.
           DATA: lv_miro_minute TYPE i.
           DATA: lv_miro_second TYPE i.

           lv_miro_hour   = lv_time_seconds DIV 3600.
           lv_miro_minute = ( lv_time_seconds MOD 3600 ) DIV 60.
           lv_miro_second = lv_time_seconds MOD 60.

           ls_response-miropostingdate =
             |{ lv_miro_date+6(2) }.{ lv_miro_date+4(2) }.{ lv_miro_date+0(4) }| &&
             | { lv_miro_hour WIDTH = 2 PAD = '0' }:{ lv_miro_minute WIDTH = 2 PAD = '0' }:{ lv_miro_second WIDTH = 2 PAD = '0' }|.

         ELSE.

           ls_response-miropostingdate =
             |{ lv_miro_date+6(2) }.{ lv_miro_date+4(2) }.{ lv_miro_date+0(4) }|.

         ENDIF.

       ELSE.

         CLEAR ls_response-miropostingdate.

       ENDIF.

*       ENDIF.


       ls_response-openpoquantity = lv_open_po_qty.

       READ TABLE it_grncreateddateandtimee
         INTO DATA(wa_grncreateddatetime)
         WITH KEY materialdocument     = wa-materialdocument
                  materialdocumentitem = wa-materialdocumentitem.

       IF sy-subrc = 0.

         IF wa_grncreateddatetime-creationdate IS NOT INITIAL
            AND wa_grncreateddatetime-creationtime IS NOT INITIAL.

           DATA(lv_grn_date) =
             wa_grncreateddatetime-creationdate.

           DATA(lv_grn_time) =
             wa_grncreateddatetime-creationtime.

           ls_response-grncreationdateandtime =
             |{ lv_grn_date+0(4) }-{ lv_grn_date+4(2) }-{ lv_grn_date+6(2) }| &&
             | { lv_grn_time+0(2) }:{ lv_grn_time+2(2) }:{ lv_grn_time+4(2) }|.

         ENDIF.

       ENDIF.

       READ TABLE costname
         INTO DATA(wa_item3)
         WITH KEY
           materialdocument     = wa-materialdocument
           materialdocumentitem = wa-materialdocumentitem.

       IF sy-subrc = 0.
         ls_response-costcentername = wa_item3-costcenterdescription.
       ELSE.
         CLEAR ls_response-costcentername.
       ENDIF.

       READ TABLE it_3
         INTO DATA(wa_it3)
         WITH KEY
           materialdocument     = wa-materialdocument
           materialdocumentitem = wa-materialdocumentitem.

       IF sy-subrc = 0.
         ls_response-rfqno = wa_it3-requestforquotation.
         ls_response-rfqdate = wa_it3-rfqpublishingdate.
       ELSE.
         CLEAR ls_response-rfqno.
       ENDIF.

DATA: lv_rfq_timestamp_utc  TYPE timestampl,
      lv_rfq_timestamp_ist  TYPE timestampl,
      lv_rfq_timestamp_char TYPE char30.

IF wa_it3-lastchangedatetime IS NOT INITIAL.

  lv_rfq_timestamp_utc =
    CONV timestampl( wa_it3-lastchangedatetime ).

  " UTC -> IST (+5:30)
  lv_rfq_timestamp_ist =
    cl_abap_tstmp=>add(
      tstmp = lv_rfq_timestamp_utc
      secs  = 19800 ).

  lv_rfq_timestamp_char =
    CONV char30( lv_rfq_timestamp_ist ).

  CONDENSE lv_rfq_timestamp_char NO-GAPS.

  IF strlen( lv_rfq_timestamp_char ) >= 14.

    " Only time: HH:MM:SS
    ls_response-rfqlastchangetime =
      |{ lv_rfq_timestamp_char+8(2) }:{ lv_rfq_timestamp_char+10(2) }:{ lv_rfq_timestamp_char+12(2) }|.

  ENDIF.

ELSE.

  CLEAR ls_response-rfqlastchangetime.

ENDIF.


*READ TABLE it_3
*  INTO DATA(wa_it3)
*  WITH KEY
*    materialdocument     = wa-materialdocument
*    materialdocumentitem = wa-materialdocumentitem.
*
*IF sy-subrc = 0.
*
*  " RFQ Number
*  ls_response-rfqno = wa_it3-requestforquotation.
*
*  " RFQ Date
*  CLEAR ls_response-rfqdate.
*
*  IF wa_it3-rfqpublishingdate IS NOT INITIAL.
*
*    DATA: lv_rfq_date TYPE d.
*
*    lv_rfq_date = wa_it3-rfqpublishingdate.
*
*    IF lv_rfq_date IS NOT INITIAL.
*
*      ls_response-rfqdate =
*        |{ lv_rfq_date+6(2) }/{ lv_rfq_date+4(2) }/{ lv_rfq_date+0(4) }|.
*
*    ENDIF.
*
*  ENDIF.
*
*ELSE.
*
*  CLEAR:
*    ls_response-rfqno,
*    ls_response-rfqdate.
*
*ENDIF.


       READ TABLE it_2 INTO DATA(wa_item2) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem BINARY SEARCH.
*       ls_response-rfqno = wa_item2-requestforquotation.
*       ls_response-costcentername = wa_item2-costcenterdescription.
       ls_response-glaccountname = wa_item2-glaccountname.
       ls_response-materialgroupdescription = wa_item2-productgroupname.
       ls_response-fiscalyear = lv_fiscal_year.

*         READ TABLE lt_vehicle_shown
*           WITH TABLE KEY table_line = wa-purchaseorder
*           TRANSPORTING NO FIELDS.
*
*         IF sy-subrc <> 0.
*
*           SELECT SINGLE FROM zc_gateentryheader AS a
*             FIELDS
*               a~refdocno,
*               a~transportername,
*               a~vehicleno,
*               a~gateentryno,
*               a~gateindate,
*               a~gateintime,
*               a~gateouttime,
*               a~gateoutdate
*             WHERE a~refdocno = @wa-purchaseorder
*             INTO @DATA(wa_transporter).
*
*           IF sy-subrc = 0.
*
*             ls_response-transportername = wa_transporter-transportername.
*             ls_response-vehicleno       = wa_transporter-vehicleno.
*             ls_response-gatepassno      = wa_transporter-gateentryno.
*             ls_response-gateindate      = wa_transporter-gateindate.
*             ls_response-gateintime      = wa_transporter-gateintime.
*             ls_response-gateoutdate     = wa_transporter-gateoutdate.
*             ls_response-gateouttime     = wa_transporter-gateouttime.
*
*           ENDIF.
*
*           INSERT wa-purchaseorder INTO TABLE lt_vehicle_shown.
*
*         ELSE.
*
*           CLEAR:
*             ls_response-transportername,
*             ls_response-vehicleno,
*             ls_response-gatepassno,
*             ls_response-gateindate,
*             ls_response-gateintime,
*             ls_response-gateoutdate,
*             ls_response-gateouttime.
*
*         ENDIF.


       SELECT SINGLE FROM zc_gateentryheader AS a
         FIELDS
           a~refdocno,
           a~transportername,
           a~vehicleno,
           a~gateentryno,
           a~gateindate,
           a~gateintime,
           a~gateouttime,
           a~gateoutdate
         WHERE a~refdocno = @wa-purchaseorder
         INTO @DATA(wa_transporter).

       IF sy-subrc = 0.

         ls_response-transportername = wa_transporter-transportername.
         ls_response-vehicleno       = wa_transporter-vehicleno.
         ls_response-gatepassno      = wa_transporter-gateentryno.
         ls_response-gateindate      = wa_transporter-gateindate.
         ls_response-gateintime      = wa_transporter-gateintime.
         ls_response-gateoutdate     = wa_transporter-gateoutdate.
         ls_response-gateouttime     = wa_transporter-gateouttime.

       ELSE.

         CLEAR:
           ls_response-transportername,
           ls_response-vehicleno,
           ls_response-gatepassno,
           ls_response-gateindate,
           ls_response-gateintime,
           ls_response-gateoutdate,
           ls_response-gateouttime.

       ENDIF.


       READ TABLE it_pricing INTO DATA(wa_basicrate) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem
                                                         conditiontype = 'PMP0' BINARY SEARCH.
       grn_value = wa_basicrate-conditionratevalue * wa-quantityinentryunit.
       ls_response-basicrate = wa_basicrate-conditionratevalue.
       ls_response-grnbasicamount = grn_value.

       READ TABLE it_pricing INTO DATA(wa_discountrate) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem
                                                         conditiontype = 'ZL01' BINARY SEARCH.
       ls_response-discountrate = wa_discountrate-conditionamount.

       READ TABLE it_pricing INTO DATA(wa_discountramt) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem
                                                          conditiontype = 'ZDC2' BINARY SEARCH.
       ls_response-discountamount = wa_discountramt-conditionamount.


       READ TABLE it_pricing INTO DATA(wa_freight) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem
                                                          conditiontype = 'ZFVA' BINARY SEARCH.
       ls_response-freight = wa_freight-conditionamount.


       READ TABLE it_pricing INTO DATA(wa_packing) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem
                                                          conditiontype = 'ZPFC' BINARY SEARCH.
       ls_response-packingforwarding = wa_packing-conditionamount.

       READ TABLE it_pricing INTO DATA(wa_customduty) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem
                                                          conditiontype = 'ZCDB' BINARY SEARCH.
       ls_response-customdutycharges = wa_customduty-conditionamount.


       READ TABLE it_serviceentry INTO DATA(wa_serviceentry) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem BINARY SEARCH.
       ls_response-serviceentrysheetnumber = wa_serviceentry-serviceentrysheet.

       READ TABLE it_challanqty INTO DATA(wa_challanqty) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem BINARY SEARCH.
       ls_response-challaninvoiceqty = wa_challanqty-quantityindeliveryqtyunit.

       IF wa-purchaseordertype = 'ZSUB'.
         READ TABLE it_challanqty INTO DATA(wa_purchamount) WITH KEY materialdocument = wa-materialdocument materialdocumentitem = wa-materialdocumentitem
                                                                     goodsmovementtype = '101' BINARY SEARCH.
         ls_response-totalgrnvalue = wa_purchamount-purchaseorderamount.
       ELSE.
         ls_response-totalgrnvalue = wa-totalgoodsmvtamtincccrcy.
       ENDIF.

       READ TABLE it_grncreatedby INTO DATA(wa_grncreatedby)
        WITH KEY materialdocument     = wa-materialdocument
           materialdocumentitem = wa-materialdocumentitem.
       IF sy-subrc = 0.
         IF wa-purchaseordertype = 'ZSER'.
           ls_response-grncreatedby = wa_grncreatedbyifzser-personfullname.
         ELSE.
           ls_response-grncreatedby = wa_grncreatedby-personfullname.
         ENDIF.

       ENDIF.
       APPEND ls_response TO lt_response.
       CLEAR: wa, ls_response , wa  , wa_basicrate , wa_discountrate , wa_discountramt , lv_year , lv_month , lv_fiscal_year , month , lv_postingdate ,
              wa_freight , wa_packing , wa_customduty , wa_serviceentry , wa_challanqty , wa_item2, grn_value ." poapproverdate , poapproverdate."LV_PO_APPROVER_DATE."
     ENDLOOP.


     IF lt_fiscal_year IS NOT INITIAL.
       LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<fs1>).
         IF <fs1>-fiscalyear NOT IN lt_fiscal_year.
           DELETE lt_response.
         ENDIF.
       ENDLOOP.
     ENDIF.


     lv_max_rows = lv_skip + lv_top.
     IF lv_skip > 0.
       lv_skip = lv_skip + 1.
     ENDIF.

     CLEAR lt_responseout.
     LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<lfs_out_line_item>) FROM lv_skip TO lv_max_rows.
       ls_responseout = <lfs_out_line_item>.
       APPEND ls_responseout TO lt_responseout.
     ENDLOOP.

     io_response->set_total_number_of_records( lines( lt_response ) ).
     io_response->set_data( lt_responseout ).

   ENDMETHOD.
ENDCLASS.
