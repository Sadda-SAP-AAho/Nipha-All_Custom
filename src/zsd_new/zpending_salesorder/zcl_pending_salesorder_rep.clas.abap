CLASS zcl_pending_salesorder_rep DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PENDING_SALESORDER_REP IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA(lv_top)   =   io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)  =   io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

    DATA(lt_parameters)  = io_request->get_parameters( ).
    DATA(lt_fileds)  = io_request->get_requested_elements( ).
    DATA(lt_sort)  = io_request->get_sort_elements( ).

    DATA: lt_response    TYPE TABLE OF zce_pending_so,
          ls_response    LIKE LINE OF lt_response,
          lt_responseout LIKE lt_response,
          ls_responseout LIKE LINE OF lt_responseout.

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
        CLEAR lt_filter_cond.
    ENDTRY.


    LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).

      IF ls_filter_cond-name = 'SALESORDER'.
        DATA(lt_salesorder) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'SOLDTOPARTY'.
        DATA(lt_customer) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'PLANT'.
        DATA(lt_plant) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'DISTRIBUTIONCHANNELNAME'.
        DATA(lt_distributionchannelname) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'DIVISION'.
        DATA(lt_division) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'CREATIONDATE'.
        DATA(lt_creationdate) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'PRODUCTGROUP'.
        DATA(lt_productgroup) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'COUNTRY'.
        DATA(lt_country) = ls_filter_cond-range[].
      ELSEIF ls_filter_cond-name = 'REGION'.
        DATA(lt_region) = ls_filter_cond-range[].
      ENDIF.

    ENDLOOP.


    SELECT FROM i_salesdocumentitem AS a
    LEFT JOIN i_salesdocument AS b ON a~salesdocument = b~salesdocument
    LEFT JOIN i_salesordertypetext AS c ON c~salesordertype = b~salesdocumenttype AND c~language = 'E'
    LEFT JOIN i_salesorganizationtext AS d ON d~salesorganization = a~salesorganization AND d~language = 'E'
    LEFT JOIN i_distributionchanneltext AS e ON e~distributionchannel = a~distributionchannel AND e~language = 'E'
    LEFT JOIN i_product AS f ON f~product = a~product
    LEFT JOIN i_productgrouptext_2 AS n  ON n~productgroup = f~productgroup  AND n~language = 'E'
    LEFT JOIN i_productplantbasic   AS m ON a~plant = m~plant  AND a~product  = m~product
    LEFT JOIN i_divisiontext AS g ON g~division = f~division AND g~language = 'E'
    LEFT JOIN i_customer AS h ON h~customer = a~soldtoparty
    LEFT JOIN i_regiontext AS i ON i~region = h~region AND i~country = 'IN' AND i~language = 'E'
    LEFT JOIN i_salesdocumentpartner AS j ON j~salesdocument = a~salesdocument AND j~partnerfunction = 'ZA'
    LEFT JOIN i_salesdocumentrjcnreasontext AS k ON k~salesdocumentrjcnreason = a~salesdocumentrjcnreason AND k~language = 'E'
    LEFT JOIN i_businesspartner AS l ON l~businesspartner = a~soldtoparty
    FIELDS a~salesdocument, a~salesdocumentitem, a~salesorganization, a~distributionchannel, a~creationdate,
    a~soldtoparty, a~purchaseorderbycustomer, a~customerpurchaseorderdate, a~plant, a~product,
    a~salesdocumentitemtext,   a~transactioncurrency ,  " a~YY1_ItemRemarks_SDI ,
    a~orderquantity, a~orderquantityunit,
    a~netpriceamount, a~createdbyuser, a~salesdocumentrjcnreason, a~taxamount,
    b~salesdocumenttype, c~salesordertypename, d~salesorganizationname, e~distributionchannelname,
    f~division,    "f~yy1_itemattribute11_prd, f~yy1_itemattribute2_prd, f~yy1_itemattribute3_prd, f~yy1_itemattribute4_prd, f~yy1_itemattribute5_prd,
   " f~yy1_productgroup1_prd, f~yy1_productgroup2_prd, f~yy1_productgroup3_prd, f~yy1_productgroup4_prd,
    g~divisionname, h~addresssearchterm1, h~customername, i~regionname,
    j~customer AS asm_code,
    k~salesdocumentrjcnreasonname, l~businesspartnertype,
    m~consumptiontaxctrlcode,
    n~productgroupname
    WHERE a~salesdocument IN @lt_salesorder AND b~salesdocumenttype IN ( 'TA', 'CBFD', 'CCFU' )
    AND a~soldtoparty IN @lt_customer
    AND a~plant IN @lt_plant
    AND a~creationdate IN @lt_creationdate
     AND f~productgroup    IN @lt_productgroup
        AND h~country  IN @lt_country
        AND h~region  IN  @lt_region
    INTO TABLE @DATA(it_salesorder) PRIVILEGED ACCESS.


    SELECT FROM i_salesdocitempricingelement AS a
    FIELDS a~salesdocument, a~salesdocumentitem, a~conditiontype, a~conditionamount, a~conditionrateamount
    WHERE a~salesdocument IN @lt_salesorder AND a~conditiontype IN ( 'ZPR0', 'ZPR1', 'ZPR2', 'ZPEX' )
    INTO TABLE @DATA(it_sales_pricing) PRIVILEGED ACCESS.

    SELECT FROM i_salesdocumentitem AS a
    FIELDS a~salesdocument, a~salesdocumentitem, SUM( a~netamount ) AS netamtsum
    WHERE a~salesdocument IN @lt_salesorder GROUP BY a~salesdocument, a~salesdocumentitem
    INTO TABLE @DATA(it_salesamt_sum) PRIVILEGED ACCESS.

    SELECT FROM i_customer AS a FIELDS a~customer, a~customername
    WHERE a~customername IS NOT INITIAL
    INTO TABLE @DATA(it_customer) PRIVILEGED ACCESS.

    SELECT FROM i_businessuserbasic AS a FIELDS a~userid, a~personfullname
    WHERE a~personfullname IS NOT INITIAL
    INTO TABLE @DATA(it_user) PRIVILEGED ACCESS.

    SELECT FROM i_deliverydocumentitem AS a
    FIELDS a~referencesddocument, a~referencesddocumentitem, SUM( a~actualdeliveryquantity ) AS qtysum
    WHERE a~referencesddocument IS NOT INITIAL
    GROUP BY a~referencesddocument, a~referencesddocumentitem
    INTO TABLE @DATA(it_deliverysum) PRIVILEGED ACCESS.

    SELECT FROM i_deliverydocumentitem AS a
    FIELDS a~referencesddocument, a~referencesddocumentitem, SUM( a~actualdeliveryquantity ) AS qtysum
    WHERE a~referencesddocument IS NOT INITIAL AND a~goodsmovementstatus = 'C' AND a~referencesddocument IN @lt_salesorder
    GROUP BY a~referencesddocument, a~referencesddocumentitem
    INTO TABLE @DATA(it_pgisum) PRIVILEGED ACCESS.

    SELECT FROM i_billingdocumentitem AS a INNER JOIN i_billingdocument AS b
                                            ON a~billingdocument = b~billingdocument
    FIELDS a~salesdocument, a~salesdocumentitem, SUM( a~billingquantity ) AS bdqtysum
    WHERE a~salesdocument IS NOT INITIAL AND a~salesdocument IN @lt_salesorder
    AND b~billingdocumenttype IN ( 'F2', 'CFD2' ) AND b~billingdocumentiscancelled IS INITIAL
    GROUP BY a~salesdocument, a~salesdocumentitem
    INTO TABLE @DATA(it_bdqtysum) PRIVILEGED ACCESS.

    SELECT FROM i_billingdocumentitem AS a LEFT JOIN i_billingdocumentpartner AS b
                                           ON a~billingdocument = b~billingdocument
    FIELDS a~referencesddocument, a~referencesddocumentitem, a~billingdocument, b~partnerfunction, b~customer
    WHERE b~partnerfunction IN ( 'ZR', 'ZT' ) AND a~referencesddocument IN @lt_salesorder
    INTO TABLE @DATA(it_billing_parvw) PRIVILEGED ACCESS.


    """""gst rate
    SELECT FROM i_salesdocitempricingelement FIELDS salesdocument , salesdocumentitem, conditionratevalue, conditionamount, conditiontype,
        transactioncurrency AS d_transactioncurrency
        WHERE salesdocument IN @lt_salesorder

        INTO TABLE @DATA(it_price).


    """"""""""credit amount and indicator

    SORT it_salesorder BY salesdocument salesdocumentitem.
    DATA : lv_freight TYPE p LENGTH 13 DECIMALS 2.
    DATA : lv_packing TYPE p LENGTH 13 DECIMALS 2.
    LOOP AT it_salesorder INTO DATA(wa).
      " CLEAR: lv_freight, lv_packing.
      ls_response-salesorder                = wa-salesdocument.
      ls_response-salesorderitem            = wa-salesdocumentitem.
      ls_response-creationdate              = wa-creationdate.
      ls_response-soldtoparty               = wa-soldtoparty.
      ls_response-division                  = |{ wa-division } { wa-divisionname }|.
      ls_response-addresssearchterm1        = wa-addresssearchterm1.
      ls_response-customername              = wa-customername.
      ls_response-regionname                = wa-regionname.
      ls_response-plant                     = wa-plant.
      ls_response-product                   = |{ wa-product ALPHA = OUT }|.
      ls_response-uom                       = wa-orderquantityunit.
*      ls_response-yy1_itemattribute11_prd   = wa-yy1_itemattribute11_prd.
*      ls_response-yy1_itemattribute2_prd    = wa-yy1_itemattribute2_prd.
*      ls_response-yy1_itemattribute3_prd    = wa-yy1_itemattribute3_prd.
*      ls_response-yy1_itemattribute4_prd    = wa-yy1_itemattribute4_prd.
*      ls_response-yy1_itemattribute5_prd    = wa-yy1_itemattribute5_prd.
      ls_response-salesdocumentitemtext     = wa-salesdocumentitemtext.
*     ls_response-itemremarks               = .
      ls_response-orderquantity             = wa-orderquantity.
      ls_response-purchaseorderbycustomer   = wa-purchaseorderbycustomer.
      ls_response-customerpurchaseorderdate = |{ wa-customerpurchaseorderdate+6(2) }.{ wa-customerpurchaseorderdate+4(2) }.{ wa-customerpurchaseorderdate+0(4) }|.
      ls_response-salesordertypename        = |{ wa-salesdocumenttype } { wa-salesordertypename }|.
      ls_response-salesorganizationname     = |{ wa-salesorganization } { wa-salesorganizationname }|.
      ls_response-distributionchannelname   = |{ wa-distributionchannel } { wa-distributionchannelname }|.
      ls_response-asm_code                  = wa-asm_code.
      ls_response-businesspartnertype       = wa-businesspartnertype.
      ls_response-taxamount                 = wa-taxamount.
      ls_response-salesdocumentrjcnreasontext = wa-salesdocumentrjcnreasonname.
      ls_response-rate               = wa-netpriceamount.
      ls_response-hsn_code  = wa-consumptiontaxctrlcode.
      ls_response-customer_currency  = wa-transactioncurrency.
      ls_response-product_group_id  = |{ wa-product ALPHA =  OUT }|.
      ls_response-product_group_description  = wa-productgroupname.
      """"""""""GST RATE

      READ TABLE it_price INTO DATA(wa_price1) WITH KEY salesdocument = wa-salesdocument
                                                      salesdocumentitem = wa-salesdocumentitem
                                                      conditiontype = 'JOIG'.
      IF wa_price1 IS NOT INITIAL.
        "  wa_itemlist-igst_amount                    = ( wa_price1-ConditionAmount ) * lv_trans_details-AccountingExchangeRate.
        ls_response-gst_rate                 = wa_price1-conditionratevalue.
        CLEAR wa_price1.

      ELSE.

        READ TABLE it_price INTO DATA(wa_price2) WITH KEY salesdocument = wa-salesdocument
                                                      salesdocumentitem = wa-salesdocumentitem
                                                         conditiontype = 'JOSG'.
        "  wa_itemlist-sgst_amount                    = ( wa_price2-ConditionAmount ) * lv_trans_details-AccountingExchangeRate.

        READ TABLE it_price INTO DATA(wa_price3) WITH KEY salesdocument = wa-salesdocument
                                                      salesdocumentitem = wa-salesdocumentitem
                                                        conditiontype = 'JOCG'.
        "  wa_itemlist-cgst_amount                    = ( wa_price3-ConditionAmount ) * lv_trans_details-AccountingExchangeRate.

        ls_response-gst_rate                    = wa_price3-conditionratevalue + wa_price2-conditionratevalue.
        CLEAR : wa_price2,wa_price3.
      ENDIF.

      READ TABLE it_price INTO DATA(wa_price4) WITH KEY salesdocument = wa-salesdocument
                                                         salesdocumentitem = wa-salesdocumentitem
                                                         conditiontype = 'ZFRT'  .
      IF wa_price4 IS NOT INITIAL.
        "  wa_itemlist-igst_amount                    = ( wa_price1-ConditionAmount ) * lv_trans_details-AccountingExchangeRate.
        lv_freight  = wa_price4-conditionamount.
        CLEAR wa_price4.
      ENDIF.

      READ TABLE it_price INTO DATA(wa_price5) WITH KEY salesdocument = wa-salesdocument
                                                         salesdocumentitem = wa-salesdocumentitem
                                                         conditiontype = 'ZPAC'.
      IF wa_price5 IS NOT INITIAL.
        "  wa_itemlist-igst_amount                    = ( wa_price1-ConditionAmount ) * lv_trans_details-AccountingExchangeRate.
        lv_packing  = wa_price5-conditionamount.
        CLEAR wa_price5.
      ENDIF.

      ls_response-freight_packing  = lv_freight  +  lv_packing .



      READ TABLE it_sales_pricing INTO DATA(wa_salespricing) WITH KEY salesdocument = wa-salesdocument salesdocumentitem = wa-salesdocumentitem.
      IF wa_salespricing IS NOT INITIAL.
        ls_response-salesrate                     = wa_salespricing-conditionrateamount.
      ENDIF.

      READ TABLE it_sales_pricing INTO DATA(wa_salespricing2) WITH KEY salesdocument = wa-salesdocument salesdocumentitem = wa-salesdocumentitem.
      IF wa_salespricing2 IS NOT INITIAL.
        ls_response-amount                      = wa_salespricing2-conditionamount.
      ENDIF.

      READ TABLE it_salesamt_sum INTO DATA(wa_salesamt_sum) WITH KEY salesdocument = wa-salesdocument salesdocumentitem = wa-salesdocumentitem.
      IF wa_salesamt_sum IS NOT INITIAL.
        ls_response-netamount = wa_salesamt_sum-netamtsum.
        ls_response-totalamount = wa_salesamt_sum-netamtsum + wa-taxamount.
      ENDIF.

      READ TABLE it_billing_parvw INTO DATA(wa_zr) WITH KEY referencesddocument = wa-salesdocument
                                                            referencesddocumentitem = wa-salesdocumentitem partnerfunction = 'ZR'.
      IF wa_zr IS NOT INITIAL.
        ls_response-rsm_code                  = wa_zr-customer.
      ENDIF.
      READ TABLE it_billing_parvw INTO DATA(wa_zt) WITH KEY referencesddocument = wa-salesdocument
                                                            referencesddocumentitem = wa-salesdocumentitem partnerfunction = 'ZT'.
      IF wa_zt IS NOT INITIAL.
        ls_response-tsm_code                  = wa_zt-customer.
      ENDIF.

      IF ls_response-uom = 'ST'.
        ls_response-uom = 'PC'.
      ENDIF.


      READ TABLE it_user INTO DATA(wa_user) WITH KEY userid = wa-createdbyuser.
      IF wa_user IS NOT INITIAL.
        ls_response-personfullname = wa_user-personfullname.
      ENDIF.

      READ TABLE it_deliverysum INTO DATA(wa_deliverysum) WITH KEY referencesddocument = wa-salesdocument referencesddocumentitem = wa-salesdocumentitem.
      IF wa_deliverysum IS NOT INITIAL.
        ls_response-delivery_qty = wa_deliverysum-qtysum.
      ENDIF.

      READ TABLE it_pgisum INTO DATA(wa_pgisum) WITH KEY referencesddocument = wa-salesdocument referencesddocumentitem = wa-salesdocumentitem.
      IF wa_pgisum IS NOT INITIAL.
        ls_response-pgi_qty = wa_pgisum-qtysum.
      ENDIF.

      READ TABLE it_bdqtysum INTO DATA(wa_bdqtysum) WITH KEY salesdocument = wa-salesdocument salesdocumentitem = wa-salesdocumentitem.
      IF wa_bdqtysum IS NOT INITIAL.
        ls_response-invoiced_qty = wa_bdqtysum-bdqtysum.
      ENDIF.


      READ TABLE it_customer INTO DATA(wa_asm) WITH KEY customer = wa-asm_code.
      IF wa_asm IS NOT INITIAL.
        ls_response-asm_name = wa_asm-customername.
      ENDIF.

      READ TABLE it_customer INTO DATA(wa_rsm) WITH KEY customer = ls_response-rsm_code.
      IF wa_rsm IS NOT INITIAL.
        ls_response-rsm_name = wa_rsm-customername.
      ENDIF.

      READ TABLE it_customer INTO DATA(wa_tsm) WITH KEY customer = ls_response-tsm_code.
      IF wa_tsm IS NOT INITIAL.
        ls_response-tsm_name = wa_tsm-customername.
      ENDIF.


      " Discount Value
      READ TABLE it_price INTO DATA(wa_disc) WITH KEY salesdocument = wa-salesdocument
                                                      salesdocumentitem = wa-salesdocumentitem
                                                      conditiontype = 'ZDIS'.
      IF wa_disc IS NOT INITIAL.
        ls_response-discount      = wa_disc-conditionamount.
        ls_response-discount_per = wa_disc-conditionratevalue.
        CLEAR wa_disc.
      ENDIF.




      IF wa-salesdocumentrjcnreason IS NOT INITIAL.
        ls_response-qty_short_closed = ls_response-orderquantity - ls_response-delivery_qty.
      ENDIF.

      ls_response-pending_for_pkg       = ls_response-delivery_qty - ls_response-pgi_qty.
      ls_response-pending_for_invoicing = ls_response-pgi_qty - ls_response-invoiced_qty.
      ls_response-pending_for_sale      = ls_response-orderquantity - ls_response-pending_for_pkg
                                        - ls_response-pending_for_invoicing - ls_response-invoiced_qty
                                        - ls_response-qty_short_closed.

      IF ls_response-pending_for_sale = 0.
        ls_response-status                = 'COMPLETED'.
      ELSEIF ls_response-orderquantity = ls_response-pending_for_sale.
        ls_response-status                = 'OPEN'.
      ELSE.
        ls_response-status                = 'IN PROCESS'.
      ENDIF.


      IF wa-orderquantity IS NOT INITIAL AND wa-orderquantity > 0.
        ls_response-pendingsalesamount =
            ( ls_response-totalamount / wa-orderquantity ) * ls_response-pending_for_sale.
      ELSE.
        ls_response-pendingsalesamount = 0.
      ENDIF.


      APPEND ls_response TO lt_response.
      CLEAR: wa, ls_response, wa_asm, wa_user, wa_deliverysum, wa_zr, wa_zt, wa_rsm, wa_tsm,
             wa_pgisum, wa_bdqtysum, wa_salespricing, wa_salespricing2, wa_salesamt_sum .
    ENDLOOP.


    IF lt_distributionchannelname IS NOT INITIAL.
      LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<fs1>).
        IF <fs1>-distributionchannelname NOT IN lt_distributionchannelname.
          DELETE lt_response.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF lt_division IS NOT INITIAL.
      LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<fs2>).
        IF <fs2>-division NOT IN lt_division.
          DELETE lt_response.
        ENDIF.
      ENDLOOP.
    ENDIF.

    LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<fs3>).
      IF <fs3>-status EQ 'COMPLETED'.
        DELETE lt_response.
      ENDIF.
    ENDLOOP.

    SORT lt_response BY salesorder salesorderitem.

    lv_max_rows = lv_skip + lv_top.
    IF lv_skip > 0.
      lv_skip = lv_skip + 1.
    ENDIF.

    CLEAR: lt_responseout, it_salesorder.
    LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<lfs_out_line_item>) FROM lv_skip TO lv_max_rows.
      ls_responseout = <lfs_out_line_item>.
      APPEND ls_responseout TO lt_responseout.
    ENDLOOP.

    io_response->set_total_number_of_records( lines( lt_response ) ).
    io_response->set_data( lt_responseout ).



  ENDMETHOD.
ENDCLASS.
