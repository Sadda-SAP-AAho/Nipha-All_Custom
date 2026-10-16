CLASS zcl_purchase_reg_new DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_rap_query_provider.
    INTERFACES if_oo_adt_classrun .

    TYPES: BEGIN OF ty_response,
             ratecgst TYPE f,
             ratesgst TYPE f,
             rateigst TYPE f,
           END OF ty_response.

    CLASS-METHODS: runjob
      IMPORTING parammiro TYPE c.

    CLASS-METHODS: get_tax_rates
      IMPORTING iv_taxcode       TYPE string
      RETURNING VALUE(rs_result) TYPE ty_response.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PURCHASE_REG_NEW IMPLEMENTATION.


  METHOD get_tax_rates.
    CLEAR rs_result.

    CASE iv_taxcode.
        " CGST + SGST
      WHEN 'I0' OR 'N0' OR 'R0' OR 'O0'.
        rs_result-ratecgst = 0.
        rs_result-ratesgst = 0.
      WHEN 'I1' OR 'N1' OR 'R1' OR 'O1'.
        rs_result-ratecgst = '2.5' .
        rs_result-ratesgst = '2.5' .
      WHEN 'I2' OR 'N2' OR 'R2' OR 'O2'.
        rs_result-ratecgst = 6.
        rs_result-ratesgst = 6.
      WHEN 'I3' OR 'N3' OR 'R3' OR 'O3'.
        rs_result-ratecgst = 9.
        rs_result-ratesgst = 9.
      WHEN 'I4' OR 'N4' OR 'R4' OR 'O4'.
        rs_result-ratecgst = 14.
        rs_result-ratesgst = 14.

        " IGST
      WHEN 'I5' OR 'N5' OR 'R5' OR 'O5' OR 'MA'.
        rs_result-rateigst = 5.
      WHEN 'I6' OR 'N6' OR 'R6' OR 'O6' OR 'MB'.
        rs_result-rateigst = 12.
      WHEN 'I7' OR 'N7' OR 'R7' OR 'O7' OR 'MC'.
        rs_result-rateigst = 18.
      WHEN 'I8' OR 'N8' OR 'R8' OR 'O8' OR 'MD'.
        rs_result-rateigst = 28.
      WHEN 'I9' OR 'N9' OR 'R9' OR 'O9'.
        rs_result-rateigst = 0.
    ENDCASE.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

    et_parameter_def = VALUE #(
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 80 param_text = 'Generate Supplier Invoice No. Parameter'   lowercase_ind = abap_true changeable_ind = abap_true ) ).

    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'Generate Supplier Invoice No. Parameter' )
    ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA p_descr TYPE c LENGTH 80.

    " Getting the actual parameter values
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_DESCR'. p_descr = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    runjob( p_descr ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM zdt_pur_reg_new.
    runjob( '' ).

  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
    ENDIF.
  ENDMETHOD.


  METHOD runjob.

    SELECT FROM i_purorditmpricingelementapi01 AS a
    LEFT JOIN i_supplier AS b ON b~supplier = a~freightsupplier
    FIELDS a~purchaseorder , a~purchaseorderitem, a~conditiontype, a~conditionamount,
    a~freightsupplier, b~addressid
    WHERE a~conditiontype IN ( 'ZBKV', 'ZBKQ' )
    INTO TABLE @DATA(it_brokervendor) PRIVILEGED ACCESS.

    SELECT FROM i_address_2 FIELDS addressid, addresseefullname
    WHERE addresseefullname IS NOT INITIAL
    INTO TABLE @DATA(it_address) PRIVILEGED ACCESS.

    SELECT FROM i_operationalacctgdocitem AS a
    FIELDS a~amountincompanycodecurrency, a~companycode, a~fiscalyear, a~transactiontypedetermination,
    a~originalreferencedocument, a~accountingdocumenttype
    WHERE a~accountingdocumenttype = 'RE'
    INTO TABLE @DATA(it_accounting) PRIVILEGED ACCESS.

    SELECT FROM  i_purchaseorderhistoryapi01 AS a
    FIELDS a~purchasinghistorydocument , a~purchasinghistorycategory, a~debitcreditcode,
    a~referencedocument, a~purchaseorder
    WHERE a~purchasinghistorycategory IN ( 'N' , 'Q' )
    INTO TABLE @DATA(it_transtype) PRIVILEGED ACCESS.

    SELECT FROM i_journalentry
    FIELDS originalreferencedocument, isreversal, isreversed
    WHERE originalreferencedocument IS NOT INITIAL
    INTO TABLE @DATA(it_journalentry) PRIVILEGED ACCESS.

    SELECT FROM i_taxcodetext FIELDS taxcode, taxcodename
    WHERE language = 'E' AND taxcodename IS NOT INITIAL
    INTO TABLE @DATA(it_taxname) PRIVILEGED ACCESS.

    SELECT FROM  i_operationalacctgdocitem
    FIELDS taxitemacctgdocitemref, in_hsnorsaccode, originalreferencedocument, purchasingdocument,
    purchasingdocumentitem, companycode, fiscalyear, profitcenter
    WHERE accountingdocumenttype = 'RE'
    AND taxitemacctgdocitemref IS NOT INITIAL
    INTO TABLE @DATA(it_accdoc) PRIVILEGED ACCESS.

    DATA: ls_response TYPE zdt_pur_reg_new.
    DATA: ls_intgresponse TYPE zintegration_tab.
    DATA localparamno TYPE c LENGTH 20.
    DATA lv_signval TYPE i.
    DATA maxpostingdate TYPE d.
    DATA deletestring TYPE c LENGTH 4.
    DATA: lv_tstamp TYPE timestamp, lv_date TYPE d, lv_time TYPE t, lv_dst TYPE abap_bool.

    SELECT SINGLE intgpath FROM zintegration_tab
    WHERE intgmodule = 'PURCHASEREGISTER'
    INTO @localparamno.
    IF localparamno IS INITIAL.
      localparamno = parammiro.
    ELSE.
      ls_intgresponse-intgmodule = 'PURCHASEREGISTER'.
      ls_intgresponse-intgpath = ''.
      MODIFY zintegration_tab FROM @ls_intgresponse.
      COMMIT WORK.
    ENDIF.

    GET TIME STAMP FIELD lv_tstamp.
    CONVERT TIME STAMP lv_tstamp TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time DAYLIGHT SAVING TIME lv_dst.

    deletestring = |{ lv_date+6(2) }| && |{ lv_time+0(2) }|.
    localparamno = parammiro.

    IF deletestring = localparamno+7(4).
      DELETE FROM zdt_pur_reg_new WHERE supplierinvoice IS NOT INITIAL.
      COMMIT WORK.
      RETURN.
    ENDIF.


    SELECT FROM zdt_pur_reg_new
    FIELDS MAX( postingdate )
    WHERE supplierinvoice IS NOT INITIAL
    INTO @maxpostingdate .
    IF maxpostingdate IS INITIAL.
      maxpostingdate = 20010101.
    ELSE.
      maxpostingdate = maxpostingdate - 31.
    ENDIF.


    IF localparamno = ''.
      SELECT  FROM i_supplierinvoiceapi01 AS c
      LEFT JOIN i_suplrinvcitempurordrefapi01  AS a ON a~supplierinvoice = c~supplierinvoice AND a~fiscalyear = c~fiscalyear
      AND a~suplrinvcdeliverycostcndntype IS INITIAL
      LEFT JOIN i_purchaseorderitemapi01 AS li ON a~purchaseorder = li~purchaseorder AND li~purchaseorderitem = a~purchaseorderitem
      LEFT JOIN zmaterial_table AS li4 ON li~material = li4~mat
      LEFT JOIN i_purchaseorderapi01 AS li6 ON li~purchaseorder = li6~purchaseorder
      LEFT JOIN i_businesspartner AS li7 ON li6~supplier = li7~businesspartner
      LEFT JOIN i_businesspartnerlegalformtext AS li8 ON li7~legalform = li8~legalform AND li8~language = 'E'
      LEFT JOIN i_purchaseorderitemtp_2 AS li9 ON li~purchaseorder = li9~purchaseorder AND li~purchaseorderitem = li9~purchaseorderitem
      LEFT JOIN i_producttext AS p  ON p~product = a~purchaseorderitemmaterial AND p~language = 'E'
      LEFT JOIN i_supplier AS r ON r~supplier = c~invoicingparty
      LEFT JOIN i_product AS s ON s~product = a~purchaseorderitemmaterial
      LEFT JOIN ztable_plant AS t ON t~plant_code = a~plant AND t~comp_code = c~companycode
      LEFT JOIN i_unitofmeasure AS u ON u~unitofmeasure = a~purchaseorderpriceunit
      LEFT JOIN i_unitofmeasure AS v ON v~unitofmeasure = li~baseunit
      LEFT JOIN i_user AS z ON c~lastchangedbyuser = z~userid
      FIELDS  c~companycode , c~fiscalyear, c~createdbyuser,c~lastchangedbyuser , c~supplierinvoice, c~supplierinvoicewthnfiscalyear, c~postingdate , c~invoicegrossamount,
              c~isinvoice,  c~reversedocument, c~exchangerate, c~supplierinvoiceidbyinvcgparty, c~documentcurrency AS invcurr,
              a~purchaseorderitem, a~supplierinvoiceitem, a~purchaseorder, a~supplierinvoiceitemamount, a~taxcode, a~freightsupplier, a~plant,
              a~purchaseorderitemmaterial AS material, a~quantityinpurchaseorderunit, a~qtyinpurchaseorderpriceunit, a~issubsequentdebitcredit,
              a~purchaseorderquantityunit, a~referencedocument , a~referencedocumentitem , a~referencedocumentfiscalyear , c~documentdate ,
              r~businesspartnerpannumber , r~suppliername , r~bppanreferencenumber , r~taxnumber3, r~suppliercorporategroup,
              li~orderquantity, li~documentcurrency, li4~trade_name,
              li8~legalformdescription, li9~supplierquotation,
              li6~purchaseordertype, li6~purchasingorganization, li6~purchasinggroup, li6~paymentterms , li6~supplier AS frsup,
              li6~purchaseordertype AS po_type , li~underdelivtolrtdlmtratioinpct,
              p~productname, s~productgroup, s~producttype,
              t~city , t~address1 , t~address2 ,t~address3, t~pin,t~plant_code, t~plant_name1, t~plant_name2, t~gstin_no,
              u~unitofmeasure_e, v~unitofmeasure_e AS po_unitofmeasure_e, z~userdescription
              WHERE c~supplierinvoicestatus <> 'A' AND a~purchaseorder IS NOT INITIAL
              AND c~postingdate >= @maxpostingdate
              INTO TABLE @DATA(it_header) PRIVILEGED ACCESS.
    ELSE.
      DELETE FROM zdt_pur_reg_new WHERE supplierinvoice = @localparamno.

      SELECT  FROM i_supplierinvoiceapi01 AS c
      LEFT JOIN i_suplrinvcitempurordrefapi01  AS a ON a~supplierinvoice = c~supplierinvoice AND a~fiscalyear = c~fiscalyear
      AND a~suplrinvcdeliverycostcndntype IS INITIAL
      LEFT JOIN i_purchaseorderitemapi01 AS li ON a~purchaseorder = li~purchaseorder AND li~purchaseorderitem = a~purchaseorderitem
      LEFT JOIN zmaterial_table AS li4 ON li~material = li4~mat
      LEFT JOIN i_purchaseorderapi01 AS li6 ON li~purchaseorder = li6~purchaseorder
      LEFT JOIN i_businesspartner AS li7 ON li6~supplier = li7~businesspartner
      LEFT JOIN i_businesspartnerlegalformtext AS li8 ON li7~legalform = li8~legalform AND li8~language = 'E'
      LEFT JOIN i_purchaseorderitemtp_2 AS li9 ON li~purchaseorder = li9~purchaseorder AND li~purchaseorderitem = li9~purchaseorderitem
      LEFT JOIN i_producttext AS p  ON p~product = a~purchaseorderitemmaterial AND p~language = 'E'
      LEFT JOIN i_supplier AS r ON r~supplier = c~invoicingparty
      LEFT JOIN i_product AS s ON s~product = a~purchaseorderitemmaterial
      LEFT JOIN ztable_plant AS t ON t~plant_code = a~plant AND t~comp_code = c~companycode
      LEFT JOIN i_unitofmeasure AS u ON u~unitofmeasure = a~purchaseorderpriceunit
      LEFT JOIN i_unitofmeasure AS v ON v~unitofmeasure = li~baseunit
      LEFT JOIN i_user AS z ON c~lastchangedbyuser = z~userid
      FIELDS  c~companycode , c~fiscalyear, c~supplierinvoice, c~supplierinvoicewthnfiscalyear,c~createdbyuser,c~lastchangedbyuser, c~postingdate , c~invoicegrossamount,
              c~isinvoice,  c~reversedocument, c~exchangerate, c~supplierinvoiceidbyinvcgparty, c~documentcurrency AS invcurr,
              a~purchaseorderitem, a~supplierinvoiceitem, a~purchaseorder, a~supplierinvoiceitemamount, a~taxcode, a~freightsupplier, a~plant,
              a~purchaseorderitemmaterial AS material, a~quantityinpurchaseorderunit, a~qtyinpurchaseorderpriceunit, a~issubsequentdebitcredit,
              a~purchaseorderquantityunit, a~referencedocument , a~referencedocumentitem , a~referencedocumentfiscalyear , c~documentdate ,
              r~businesspartnerpannumber , r~suppliername , r~bppanreferencenumber , r~taxnumber3, r~suppliercorporategroup,
              li~orderquantity, li~documentcurrency, li4~trade_name,
              li8~legalformdescription, li9~supplierquotation,
              li6~purchaseordertype, li6~purchasingorganization, li6~purchasinggroup, li6~paymentterms , li6~supplier AS frsup,
              li6~purchaseordertype AS po_type , li~underdelivtolrtdlmtratioinpct,
              p~productname, s~productgroup, s~producttype,
              t~city , t~address1 , t~address2 ,t~address3, t~pin,t~plant_code, t~plant_name1, t~plant_name2, t~gstin_no,
              u~unitofmeasure_e, v~unitofmeasure_e AS po_unitofmeasure_e, z~userdescription
              WHERE c~supplierinvoicestatus <> 'A' AND a~purchaseorder IS NOT INITIAL
              AND c~supplierinvoice = @localparamno
              INTO TABLE @it_header PRIVILEGED ACCESS.
    ENDIF.

    IF it_header IS NOT INITIAL.

      SELECT  FROM i_suplrinvcitempurordrefapi01 AS a
      LEFT JOIN c_supplierinvoicedex AS b ON b~supplierinvoice = a~supplierinvoice
      LEFT JOIN i_bupaidentification AS c ON c~businesspartner = b~invoicingparty
      FIELDS a~purchaseorder, c~bpidentificationnumber, c~bpidentificationtype, a~supplierinvoice, a~supplierinvoiceitem
      WHERE c~bpidentificationtype = 'TAN'
      INTO TABLE @DATA(it_vtn) PRIVILEGED ACCESS.

      SELECT  FROM i_suplrinvcitempurordrefapi01 AS a
      FIELDS a~supplierinvoice, a~supplierinvoiceitem, a~fiscalyear, a~supplierinvoiceitemamount,
      a~purchaseorder, a~purchaseorderitem, suplrinvcdeliverycostcndntype, a~taxcode, a~qtyinpurchaseorderpriceunit
      WHERE supplierinvoice IS NOT INITIAL
      INTO TABLE @DATA(it_taxitems) PRIVILEGED ACCESS.

      SELECT FROM i_suplrinvcitempurordrefapi01 AS a
      LEFT JOIN i_purchaseorderitemapi01 AS b ON a~purchaseorder = b~purchaseorder AND b~purchaseorderitem = a~purchaseorderitem
      LEFT JOIN i_purchaseorderapi01 AS c ON c~purchaseorder = a~purchaseorder
      FIELDS a~supplierinvoice , a~supplierinvoiceitem , b~purchaseorderitemtext
      WHERE c~purchaseordertype  IN  ( 'ZSRV' , 'ZCAP' , 'NB', 'ZDOM' )
      INTO TABLE @DATA(it_product2new) PRIVILEGED ACCESS.

    ENDIF.


    LOOP AT it_header INTO DATA(waheader).

      ls_response-supplierinvoice          = waheader-supplierinvoice.
      ls_response-companycode              = waheader-companycode.
      ls_response-fiscalyearvalue          = waheader-fiscalyear.
      ls_response-postingdate              = waheader-postingdate.
      ls_response-supplierinvoiceitem      = waheader-supplierinvoiceitem.
      ls_response-vendor_invoice_date      = waheader-documentdate.
      ls_response-product                  = waheader-material.
      ls_response-purchaseorder            = waheader-purchaseorder.
      ls_response-baseunit                 = waheader-po_unitofmeasure_e.
      ls_response-purchasingorganization   = waheader-purchasingorganization.
      ls_response-purchasinggroup          = waheader-purchasinggroup.
      ls_response-productname              = waheader-productname.
      ls_response-vendorname               = waheader-suppliername.
      ls_response-vendorpanno              = waheader-businesspartnerpannumber.
      ls_response-vendor_invoice_no        = waheader-supplierinvoiceidbyinvcgparty.
      ls_response-vendorgstin              = waheader-taxnumber3.
      ls_response-vendortype               = waheader-suppliercorporategroup.
      ls_response-materialgroup            = waheader-productgroup.
      ls_response-materialtype             = waheader-producttype.
      ls_response-pocurrency               = waheader-documentcurrency.
      ls_response-plantcity                = waheader-city.
      ls_response-plantadr                 = |{ waheader-address1 }{ waheader-address2 }{ waheader-address3 }|.
      ls_response-plantpin                 = waheader-pin.
      ls_response-vendorcode               = waheader-frsup.
      ls_response-exchangerate             = waheader-exchangerate.
      ls_response-plantgst                 = waheader-gstin_no.
      ls_response-plant                    = waheader-plant_code.
      ls_response-plantname                = |{ waheader-plant_name1 } { waheader-plant_name2 } |.
      ls_response-miro_item_type           = 'PO Ref. Entry'.
      ls_response-miroquantity             = waheader-qtyinpurchaseorderpriceunit.
      ls_response-rateigst                 = 0.
      ls_response-ratecgst                 = 0.
      ls_response-ratesgst                 = 0.
      ls_response-reverseigst              = 0.
      ls_response-reversecgst              = 0.
      ls_response-reversesgst              = 0.
      ls_response-originalreferencedocument = waheader-supplierinvoicewthnfiscalyear.
      ls_response-createdby                = waheader-userdescription.

      READ TABLE it_accdoc INTO DATA(wa_accdoc) WITH KEY originalreferencedocument = waheader-supplierinvoicewthnfiscalyear
                                                   purchasingdocument = waheader-purchaseorder
                                                   purchasingdocumentitem = waheader-purchaseorderitem
                                                   companycode = waheader-companycode
                                                   fiscalyear = waheader-fiscalyear.
      IF wa_accdoc IS NOT INITIAL.
        ls_response-hsncode             = wa_accdoc-in_hsnorsaccode.
        ls_response-profitcenter        = wa_accdoc-profitcenter.
      ENDIF.

      IF waheader-reversedocument IS NOT INITIAL.
        ls_response-isreversed               = 'X'.
        ls_response-referenceinvoicenumber   = waheader-reversedocument.
      ENDIF.

      READ TABLE it_accounting INTO DATA(wa_accounting) WITH KEY companycode = waheader-companycode fiscalyear = waheader-fiscalyear
                                                           originalreferencedocument = waheader-supplierinvoicewthnfiscalyear.
      IF wa_accounting IS NOT INITIAL.
        ls_response-mirodocumenttype = wa_accounting-accountingdocumenttype.
      ENDIF.

      IF waheader-supplierinvoiceitem = '000001'.
        READ TABLE it_accounting INTO DATA(wa_accounting_wit) WITH KEY companycode = waheader-companycode fiscalyear = waheader-fiscalyear
                                                             originalreferencedocument = waheader-supplierinvoicewthnfiscalyear
                                                             transactiontypedetermination = 'WIT'.
        IF wa_accounting_wit IS NOT INITIAL.
          ls_response-tcsamount = wa_accounting_wit-amountincompanycodecurrency.
        ENDIF.
      ENDIF.


      READ TABLE it_brokervendor INTO DATA(wa_brokervendor) WITH KEY purchaseorder = waheader-purchaseorder purchaseorderitem = waheader-purchaseorderitem.
      IF wa_brokervendor IS NOT INITIAL.
        ls_response-brokervendorcode       = wa_brokervendor-freightsupplier .
        ls_response-brokerchargesval       = ( wa_brokervendor-conditionamount  / waheader-orderquantity ) * waheader-qtyinpurchaseorderpriceunit  .
        ls_response-brokerchargesqty       = waheader-qtyinpurchaseorderpriceunit .
        READ TABLE it_address INTO DATA(wa_address) WITH KEY addressid = wa_brokervendor-addressid.
        IF wa_address IS NOT INITIAL.
          ls_response-brokervendorname     = wa_address-addresseefullname .
        ENDIF.
      ENDIF.


**********        //For TransactionType
      lv_signval = 1.

      READ TABLE it_transtype INTO DATA(wa_transtype2) WITH KEY purchasinghistorydocument = waheader-supplierinvoice.

      READ TABLE it_journalentry INTO DATA(wa_journalentry2) WITH KEY originalreferencedocument = ls_response-originalreferencedocument.
      IF wa_journalentry2 IS NOT INITIAL.
        IF ( waheader-isinvoice = 'X' AND wa_journalentry2-isreversal IS INITIAL
            AND wa_transtype2-purchasinghistorycategory = 'Q' AND wa_transtype2-debitcreditcode = 'S' ) OR
           ( waheader-isinvoice = 'X' AND wa_journalentry2-isreversed IS INITIAL AND wa_transtype2 IS INITIAL ).
          ls_response-transactiontype = 'Invoice'.

        ELSEIF waheader-isinvoice IS INITIAL AND wa_journalentry2-isreversal = 'X' AND
               wa_transtype2-purchasinghistorycategory = 'Q' AND wa_transtype2-debitcreditcode = 'H' .
          ls_response-transactiontype = 'Invoice'.
          lv_signval = -1.

        ELSEIF ( waheader-isinvoice IS INITIAL AND wa_journalentry2-isreversal IS INITIAL ) OR
               ( waheader-isinvoice IS INITIAL AND wa_journalentry2-isreversal = 'X' AND wa_transtype2 IS INITIAL ).
          ls_response-transactiontype = 'Debit Note'.    "credit memo
          lv_signval = -1.

        ELSEIF waheader-isinvoice = 'X' AND wa_journalentry2-isreversal = 'X'.
          ls_response-transactiontype = 'Debit Note'.

        ELSEIF waheader-isinvoice = 'X' AND wa_journalentry2-isreversal IS INITIAL AND
               wa_transtype2-purchasinghistorycategory = 'N' AND wa_transtype2-debitcreditcode = 'S'.
          ls_response-transactiontype = 'Credit Memo'.

        ELSEIF waheader-isinvoice IS INITIAL AND wa_journalentry2-isreversal = 'X' AND
               wa_transtype2-purchasinghistorycategory = 'N' AND wa_transtype2-debitcreditcode = 'H'.
          ls_response-transactiontype = 'Credit Memo'.
          lv_signval = -1.

        ENDIF.
      ENDIF.

      IF waheader-issubsequentdebitcredit = 'X'.
        ls_response-transactiontype = |Sub { ls_response-transactiontype } |.
      ENDIF.

      READ TABLE it_taxname INTO DATA(wa_taxname) WITH KEY taxcode = waheader-taxcode.
      IF wa_taxname IS NOT INITIAL.
        ls_response-taxcodename              = wa_taxname-taxcodename.
      ENDIF.

      IF ls_response-productname IS INITIAL.
        READ TABLE it_product2new INTO DATA(wa_product2new) WITH KEY supplierinvoice = waheader-supplierinvoice supplierinvoiceitem = waheader-supplierinvoiceitem.
        ls_response-productname = wa_product2new-purchaseorderitemtext.
      ENDIF.

      DATA : miqty TYPE p DECIMALS 2.
      miqty = waheader-qtyinpurchaseorderpriceunit.
      ls_response-mirouom = waheader-unitofmeasure_e.

      IF waheader-qtyinpurchaseorderpriceunit <> 0.
        ls_response-basicrate = waheader-supplierinvoiceitemamount / miqty.
      ELSE.
        ls_response-basicrate = 0.
      ENDIF.

      DATA lv_taxcodehdr TYPE string.
      lv_taxcodehdr = waheader-taxcode.
      DATA(wa_taxitemrates) = get_tax_rates( iv_taxcode = lv_taxcodehdr ).
      ls_response-ratecgst = wa_taxitemrates-ratecgst.
      ls_response-ratesgst = wa_taxitemrates-ratesgst.
      ls_response-rateigst = wa_taxitemrates-rateigst.


      DATA lv_taxcode2 TYPE string.
      lv_taxcode2 = waheader-taxcode.
      DATA(wa_taxes2) = get_tax_rates( iv_taxcode = lv_taxcode2 ).

      ls_response-cgst = ( waheader-supplierinvoiceitemamount * wa_taxes2-ratecgst ) / 100.
      ls_response-sgst = ( waheader-supplierinvoiceitemamount * wa_taxes2-ratesgst ) / 100.
      ls_response-igst = ( waheader-supplierinvoiceitemamount * wa_taxes2-rateigst ) / 100.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxfrv>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                              fiscalyear = waheader-fiscalyear
                                                                              purchaseorder = waheader-purchaseorder
                                                                              purchaseorderitem = waheader-purchaseorderitem
                                                                              suplrinvcdeliverycostcndntype = 'ZFRV'.

      IF <wa_taxfrv>  IS ASSIGNED.
        DATA lv_taxcode TYPE string.
        lv_taxcode = <wa_taxfrv>-taxcode.
        DATA(wa_taxes) = get_tax_rates( iv_taxcode = lv_taxcode ).
        ls_response-cgst += ( <wa_taxfrv>-supplierinvoiceitemamount * wa_taxes-ratecgst ) / 100.
        ls_response-sgst += ( <wa_taxfrv>-supplierinvoiceitemamount * wa_taxes-ratesgst ) / 100.
        ls_response-igst += ( <wa_taxfrv>-supplierinvoiceitemamount * wa_taxes-rateigst ) / 100.
        ls_response-freightval = <wa_taxfrv>-supplierinvoiceitemamount.
        ls_response-freightqty = <wa_taxfrv>-qtyinpurchaseorderpriceunit.
        CLEAR: lv_taxcode, wa_taxes.
        UNASSIGN <wa_taxfrv>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxfrq>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                        fiscalyear = waheader-fiscalyear
                                                                        purchaseorder = waheader-purchaseorder
                                                                        purchaseorderitem = waheader-purchaseorderitem
                                                                        suplrinvcdeliverycostcndntype = 'ZFRQ'.

      IF <wa_taxfrq>  IS ASSIGNED.
        DATA lv_taxcodeq TYPE string.
        lv_taxcodeq = <wa_taxfrq>-taxcode.
        DATA(wa_taxesq) = get_tax_rates( iv_taxcode = lv_taxcodeq ).
        ls_response-cgst += ( <wa_taxfrq>-supplierinvoiceitemamount * wa_taxesq-ratecgst ) / 100.
        ls_response-sgst += ( <wa_taxfrq>-supplierinvoiceitemamount * wa_taxesq-ratesgst ) / 100.
        ls_response-igst += ( <wa_taxfrq>-supplierinvoiceitemamount * wa_taxesq-rateigst ) / 100.
        ls_response-freightval = <wa_taxfrq>-supplierinvoiceitemamount.
        ls_response-freightqty = <wa_taxfrq>-qtyinpurchaseorderpriceunit.
        CLEAR: lv_taxcodeq, wa_taxesq.
        UNASSIGN <wa_taxfrq>.
      ENDIF.

      IF ls_response-cgst < 0 OR ls_response-sgst < 0 OR ls_response-igst < 0.
        ls_response-netamount = waheader-supplierinvoiceitemamount * -1.
      ELSE.
        ls_response-netamount = waheader-supplierinvoiceitemamount.
      ENDIF.

      ls_response-netamount = waheader-supplierinvoiceitemamount * waheader-exchangerate.

      IF waheader-taxcode+0(1) = 'R' .
        ls_response-reverseigst = ( ls_response-igst * -1 ).
        ls_response-reversecgst = ( ls_response-cgst * -1 ).
        ls_response-reversesgst = ( ls_response-sgst * -1 ).
      ENDIF.

      ls_response-taxamount                  = ls_response-igst + ls_response-sgst + ls_response-cgst +
                                               ls_response-reverseigst + ls_response-reversesgst + ls_response-reversecgst.
      ls_response-totalamount                = waheader-supplierinvoiceitemamount + ls_response-taxamount + ls_response-freightval .

      IF lv_signval < 0.
        ls_response-miroquantity = ( waheader-qtyinpurchaseorderpriceunit ) * lv_signval.
        ls_response-igst                *= lv_signval.
        ls_response-cgst                *= lv_signval.
        ls_response-sgst                *= lv_signval.
        ls_response-reverseigst         *= lv_signval.
        ls_response-reversecgst         *= lv_signval.
        ls_response-reversesgst         *= lv_signval.
        ls_response-taxamount           *= lv_signval.
        ls_response-netamount           *= lv_signval.
        ls_response-freightval          *= lv_signval.
        ls_response-totalamount         *= lv_signval.
        ls_response-brokerchargesqty    *= lv_signval.
        ls_response-brokerchargesval    *= lv_signval.
      ENDIF.

      READ TABLE it_vtn INTO DATA(wa_vtn) WITH KEY supplierinvoice = waheader-supplierinvoice supplierinvoiceitem = waheader-supplierinvoiceitem .
      ls_response-vendortanno = wa_vtn-bpidentificationnumber.

      READ TABLE it_taxitems ASSIGNING  FIELD-SYMBOL(<wa_taxzaid>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                           fiscalyear = waheader-fiscalyear
                                                                           purchaseorder = waheader-purchaseorder
                                                                           purchaseorderitem = waheader-purchaseorderitem
                                                                           suplrinvcdeliverycostcndntype = 'ZAID'.
      IF <wa_taxzaid> IS ASSIGNED.
        ls_response-aidcper = <wa_taxzaid>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzaid>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzsgp>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                            fiscalyear = waheader-fiscalyear
                                                                            purchaseorder = waheader-purchaseorder
                                                                            purchaseorderitem = waheader-purchaseorderitem
                                                                            suplrinvcdeliverycostcndntype = 'ZSGP'.
      IF <wa_taxzsgp> IS ASSIGNED.
        ls_response-safeguardper = <wa_taxzsgp>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzsgp>.
      ENDIF.
      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_tax_zkkp>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                            fiscalyear = waheader-fiscalyear
                                                                            purchaseorder = waheader-purchaseorder
                                                                            purchaseorderitem = waheader-purchaseorderitem
                                                                            suplrinvcdeliverycostcndntype = 'ZKKP'.
      IF <wa_tax_zkkp> IS ASSIGNED.
        ls_response-kisankalyantax = <wa_tax_zkkp>-supplierinvoiceitemamount.
        UNASSIGN <wa_tax_zkkp>.
      ENDIF.
      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_tax_jswc>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                            fiscalyear = waheader-fiscalyear
                                                                            purchaseorder = waheader-purchaseorder
                                                                            purchaseorderitem = waheader-purchaseorderitem
                                                                            suplrinvcdeliverycostcndntype = 'JSWC'.
      IF <wa_tax_jswc> IS ASSIGNED.
        ls_response-cifandcustomduty = <wa_tax_jswc>-supplierinvoiceitemamount.
        UNASSIGN <wa_tax_jswc>.
      ENDIF.
      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_tax_zpcv>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZPCV'.
      IF <wa_tax_zpcv> IS ASSIGNED.
        ls_response-purchasecomissionval = <wa_tax_zpcv>-supplierinvoiceitemamount.
        UNASSIGN <wa_tax_zpcv>.
      ENDIF.
      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_tax_zpcq>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZPCQ'.
      IF <wa_tax_zpcq> IS ASSIGNED.
        ls_response-purchasecomissionqty = <wa_tax_zpcq>-supplierinvoiceitemamount.
        UNASSIGN <wa_tax_zpcq>.
      ENDIF.
      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_tax_zsvv>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZSVV'.
      IF <wa_tax_zsvv> IS ASSIGNED.
        ls_response-surveyorchargesval = <wa_tax_zsvv>-supplierinvoiceitemamount.
        UNASSIGN <wa_tax_zsvv>.
      ENDIF.
      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_tax_zsvq>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZSVQ'.
      IF <wa_tax_zsvq> IS ASSIGNED.
        ls_response-surveyorchargesqty = <wa_tax_zsvq>-supplierinvoiceitemamount.
        UNASSIGN <wa_tax_zsvq>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzmnp>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZMNP'.
      IF <wa_taxzmnp> IS ASSIGNED.
        ls_response-manditax = <wa_taxzmnp>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzmnp>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzchv>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZCHV'.
      IF <wa_taxzchv> IS ASSIGNED.
        ls_response-chachargesval = <wa_taxzchv>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzchv>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzluq>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZLUQ'.
      IF <wa_taxzluq> IS ASSIGNED.
        ls_response-ldguldgchgsqty = <wa_taxzluq>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzluq>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzluv>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZLUV'.
      IF <wa_taxzluv> IS ASSIGNED.
        ls_response-ldguldgchgsval = <wa_taxzluv>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzluv>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzpkp>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZPKP'.
      IF <wa_taxzpkp> IS ASSIGNED.
        ls_response-packingchargesper = <wa_taxzpkp>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzpkp>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzpkq>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZPKQ'.
      IF <wa_taxzpkq> IS ASSIGNED.
        ls_response-packingchargesqty = <wa_taxzpkq>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzpkq>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzadp>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZADP'.
      IF <wa_taxzadp> IS ASSIGNED.
        ls_response-antidumpingper = <wa_taxzadp>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzadp>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzadv>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZADV'.
      IF <wa_taxzadv> IS ASSIGNED.
        ls_response-antidumpingvalue = <wa_taxzadv>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzadv>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzinp>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZINP'.
      IF <wa_taxzinp> IS ASSIGNED.
        ls_response-insurancechargesper = <wa_taxzinp>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzinp>.
      ENDIF.

      READ TABLE it_taxitems ASSIGNING FIELD-SYMBOL(<wa_taxzinv>) WITH KEY supplierinvoice = waheader-supplierinvoice
                                                                      fiscalyear = waheader-fiscalyear
                                                                      purchaseorder = waheader-purchaseorder
                                                                      purchaseorderitem = waheader-purchaseorderitem
                                                                      suplrinvcdeliverycostcndntype = 'ZINV'.
      IF <wa_taxzinv> IS ASSIGNED.
        ls_response-insurancecost = <wa_taxzinv>-supplierinvoiceitemamount.
        UNASSIGN <wa_taxzinv>.
      ENDIF.

      MODIFY zdt_pur_reg_new FROM @ls_response.
      CLEAR: waheader ,ls_response, wa_vtn, wa_taxitemrates,wa_accounting, wa_accounting_wit,
              lv_taxcodehdr, wa_product2new , miqty, lv_taxcode2, wa_taxes2, wa_brokervendor, wa_address,
              wa_journalentry2, wa_transtype2, lv_signval, wa_accdoc.
    ENDLOOP.









*************************** For Non-Product Entries

    SELECT FROM i_suplrinvcitempurordrefapi01 AS a
    LEFT JOIN i_supplierinvoiceapi01 AS b ON a~supplierinvoice = b~supplierinvoice AND a~fiscalyear = b~fiscalyear
    LEFT JOIN i_supplier AS c ON b~invoicingparty = c~supplier
    LEFT JOIN i_purchaseorderitemapi01 AS d ON d~purchaseorder = a~purchaseorder AND d~purchaseorderitem = a~purchaseorderitem
    LEFT JOIN i_purchaseorderapi01 AS e ON e~purchaseorder = a~purchaseorder
    LEFT JOIN i_producttext AS f ON f~product = a~purchaseorderitemmaterial AND f~language = 'E'
    LEFT JOIN ztable_plant AS g ON g~comp_code = b~companycode AND g~plant_code = a~plant
    LEFT JOIN i_product AS h ON h~product = a~purchaseorderitemmaterial
    LEFT JOIN i_unitofmeasure AS u ON u~unitofmeasure = a~purchaseorderpriceunit
    LEFT JOIN i_unitofmeasure AS v ON v~unitofmeasure = d~baseunit
    LEFT JOIN i_user AS z ON b~lastchangedbyuser = z~userid
    FIELDS a~supplierinvoice, a~supplierinvoiceitem, a~fiscalyear , a~purchaseorderitem,
    a~purchaseorder, a~supplierinvoiceitemamount, a~taxcode, a~plant, a~issubsequentdebitcredit,
    a~freightsupplier, a~taxjurisdiction, a~suplrinvcdeliverycostcndntype,
    a~purchaseorderitemmaterial AS material, a~quantityinpurchaseorderunit, a~qtyinpurchaseorderpriceunit,
    a~purchaseorderquantityunit, a~referencedocument , a~referencedocumentfiscalyear,
    b~companycode, b~supplierinvoiceidbyinvcgparty, b~postingdate, b~documentdate, b~reversedocument, b~isinvoice,
    b~exchangerate, b~supplierinvoicewthnfiscalyear, b~documentcurrency AS invcurr, b~invoicegrossamount, b~supplierinvoicestatus,
    c~supplier, c~taxnumber3, c~suppliername, c~businesspartnerpannumber, c~suppliercorporategroup,
    d~documentcurrency, e~purchasingorganization, e~purchasinggroup,e~createdbyuser,b~lastchangedbyuser, e~supplier AS posupplier, f~productname,
    g~gstin_no, g~plant_name1,g~plant_code, g~plant_name2, g~city, g~address1, g~address2, g~address3, g~pin, g~district,
    h~productgroup, h~producttype, u~unitofmeasure_e, v~unitofmeasure_e AS po_unitofmeasure_e, z~userdescription
*    WHERE NOT EXISTS
*    ( SELECT FROM zdt_pur_reg_new AS zpr
*      FIELDS zpr~supplierinvoice, zpr~fiscalyearvalue
*      WHERE a~supplierinvoice = zpr~supplierinvoice AND a~FiscalYear = zpr~fiscalyearvalue
*    )
    INTO TABLE @DATA(it_lines_nonproduct) PRIVILEGED ACCESS.

    DELETE it_lines_nonproduct WHERE supplierinvoicestatus = 'A'.

    SELECT FROM i_suplrinvcitempurordrefapi01 AS a
    FIELDS SUM( a~supplierinvoiceitemamount ) AS itemamount, a~supplierinvoice, a~fiscalyear
    WHERE a~suplrinvcdeliverycostcndntype IS NOT INITIAL
    GROUP BY a~supplierinvoice, a~fiscalyear
    INTO TABLE @DATA(it_itemamt) PRIVILEGED ACCESS.


    DATA wa_pur_delivery_line TYPE zdt_pur_reg_new.

    LOOP AT it_lines_nonproduct INTO DATA(wa_nonproduct) WHERE suplrinvcdeliverycostcndntype IS NOT INITIAL.

      READ TABLE it_lines_nonproduct INTO DATA(wa_nonproduct2) WITH KEY supplierinvoice = wa_nonproduct-supplierinvoice
                                                                        fiscalyear = wa_nonproduct-fiscalyear
                                                                        suplrinvcdeliverycostcndntype = ''.
      IF wa_nonproduct2 IS INITIAL.
        wa_pur_delivery_line-companycode          = wa_nonproduct-companycode.
        wa_pur_delivery_line-fiscalyearvalue      = wa_nonproduct-fiscalyear.
        wa_pur_delivery_line-supplierinvoice      = wa_nonproduct-supplierinvoice.
        wa_pur_delivery_line-supplierinvoiceitem  = wa_nonproduct-supplierinvoiceitem.
        wa_pur_delivery_line-postingdate          = wa_nonproduct-postingdate.
        wa_pur_delivery_line-product              = wa_nonproduct-material.
        wa_pur_delivery_line-productname          = wa_nonproduct-productname.
        wa_pur_delivery_line-mirouom              = wa_nonproduct-unitofmeasure_e.
        wa_pur_delivery_line-vendorcode           = wa_nonproduct-supplier.
        wa_pur_delivery_line-vendor_invoice_date  = wa_nonproduct-documentdate.
        wa_pur_delivery_line-purchaseorder        = wa_nonproduct-purchaseorder.
        wa_pur_delivery_line-purchasinggroup      = wa_nonproduct-purchasinggroup.
        wa_pur_delivery_line-pocurrency           = wa_nonproduct-documentcurrency.
        wa_pur_delivery_line-vendorgstin          = wa_nonproduct-taxnumber3.
        wa_pur_delivery_line-vendortype           = wa_nonproduct-suppliercorporategroup.
        wa_pur_delivery_line-netamount            = wa_nonproduct-supplierinvoiceitemamount.
        wa_pur_delivery_line-vendorname           = wa_nonproduct-suppliername.
        wa_pur_delivery_line-vendorpanno          = wa_nonproduct-businesspartnerpannumber.
        wa_pur_delivery_line-vendor_invoice_no    = wa_nonproduct-supplierinvoiceidbyinvcgparty.
        wa_pur_delivery_line-miro_item_type       = 'Delivery Cost Entry'.
        wa_pur_delivery_line-plantgst             = wa_nonproduct-gstin_no.
        wa_pur_delivery_line-plant             = wa_nonproduct-plant_code.
        wa_pur_delivery_line-plantname            = |{ wa_nonproduct-plant_name1 } { wa_nonproduct-plant_name2 } |.
        wa_pur_delivery_line-plantadr             = |{ wa_nonproduct-address1 } { wa_nonproduct-address2 } { wa_nonproduct-address3 } |.
        wa_pur_delivery_line-plantcity            = wa_nonproduct-city.
        wa_pur_delivery_line-plantpin             = wa_nonproduct-pin.
        wa_pur_delivery_line-baseunit             = wa_nonproduct-po_unitofmeasure_e.
        wa_pur_delivery_line-exchangerate         = wa_nonproduct-exchangerate.
        wa_pur_delivery_line-materialgroup        = wa_nonproduct-productgroup.
        wa_pur_delivery_line-materialtype         = wa_nonproduct-producttype.
        wa_pur_delivery_line-referenceinvoicenumber    = wa_nonproduct-referencedocument.
        wa_pur_delivery_line-purchasingorganization    = wa_nonproduct-purchasingorganization.
        wa_pur_delivery_line-originalreferencedocument = wa_nonproduct-supplierinvoicewthnfiscalyear.
        wa_pur_delivery_line-createdby                 = wa_nonproduct-userdescription.

        IF wa_nonproduct-posupplier = wa_nonproduct-supplier.
          wa_pur_delivery_line-miroquantity         = wa_nonproduct-qtyinpurchaseorderpriceunit.
        ENDIF.

        IF wa_nonproduct-qtyinpurchaseorderpriceunit <> 0.
          wa_pur_delivery_line-basicrate            = wa_nonproduct-supplierinvoiceitemamount / wa_nonproduct-qtyinpurchaseorderpriceunit.
        ELSE.
          wa_pur_delivery_line-basicrate            = 0.
        ENDIF.

        READ TABLE it_accdoc INTO DATA(wa_accdoc2) WITH KEY originalreferencedocument = wa_nonproduct-supplierinvoicewthnfiscalyear
                                                           purchasingdocument = wa_nonproduct-purchaseorder
                                                           purchasingdocumentitem = wa_nonproduct-purchaseorderitem
                                                           companycode = wa_nonproduct-companycode
                                                           fiscalyear = wa_nonproduct-fiscalyear.
        IF wa_accdoc2 IS NOT INITIAL.
          wa_pur_delivery_line-hsncode             = wa_accdoc2-in_hsnorsaccode.
          wa_pur_delivery_line-profitcenter        = wa_accdoc2-profitcenter.
        ENDIF.

        IF wa_nonproduct-reversedocument IS NOT INITIAL.
          wa_pur_delivery_line-isreversed             = 'X'.
          wa_pur_delivery_line-referenceinvoicenumber = wa_nonproduct-reversedocument.
        ENDIF.

        READ TABLE it_accounting INTO DATA(wa_accounting2) WITH KEY companycode = wa_nonproduct-companycode fiscalyear = wa_nonproduct-fiscalyear
                                                             originalreferencedocument = wa_nonproduct-supplierinvoicewthnfiscalyear.
        IF wa_accounting2 IS NOT INITIAL.
          wa_pur_delivery_line-mirodocumenttype        = wa_accounting2-accountingdocumenttype.
        ENDIF.

**********        //For TransactionType
        lv_signval = 1.

        READ TABLE it_transtype INTO DATA(wa_transtype3) WITH KEY purchasinghistorydocument = wa_nonproduct-supplierinvoice.

        READ TABLE it_journalentry INTO DATA(wa_journalentry3) WITH KEY originalreferencedocument = wa_nonproduct-supplierinvoicewthnfiscalyear.
        IF wa_journalentry3 IS NOT INITIAL.
          IF ( wa_nonproduct-isinvoice = 'X' AND wa_journalentry3-isreversal IS INITIAL
              AND wa_transtype3-purchasinghistorycategory = 'Q' AND wa_transtype3-debitcreditcode = 'S' ) OR
             ( wa_nonproduct-isinvoice = 'X' AND wa_journalentry3-isreversed IS INITIAL AND wa_transtype3 IS INITIAL ).
            wa_pur_delivery_line-transactiontype = 'Invoice'.

          ELSEIF wa_nonproduct-isinvoice IS INITIAL AND wa_journalentry3-isreversal = 'X' AND
                 wa_transtype3-purchasinghistorycategory = 'Q' AND wa_transtype3-debitcreditcode = 'H' .
            wa_pur_delivery_line-transactiontype = 'Invoice'.
            lv_signval = -1.

          ELSEIF ( wa_nonproduct-isinvoice IS INITIAL AND wa_journalentry3-isreversal IS INITIAL ) OR
                 ( wa_nonproduct-isinvoice IS INITIAL AND wa_journalentry3-isreversal = 'X' AND wa_transtype3 IS INITIAL ).
            wa_pur_delivery_line-transactiontype = 'Debit Note'.    "credit memo
            lv_signval = -1.

          ELSEIF wa_nonproduct-isinvoice = 'X' AND wa_journalentry3-isreversal = 'X'.
            wa_pur_delivery_line-transactiontype = 'Debit Note'.

          ELSEIF wa_nonproduct-isinvoice = 'X' AND wa_journalentry3-isreversal IS INITIAL AND
                 wa_transtype3-purchasinghistorycategory = 'N' AND wa_transtype3-debitcreditcode = 'S'.
            wa_pur_delivery_line-transactiontype = 'Credit Memo'.

          ELSEIF wa_nonproduct-isinvoice IS INITIAL AND wa_journalentry3-isreversal = 'X' AND
                 wa_transtype3-purchasinghistorycategory = 'N' AND wa_transtype3-debitcreditcode = 'H'.
            wa_pur_delivery_line-transactiontype = 'Credit Memo'.
            lv_signval = -1.

          ENDIF.
        ENDIF.

        IF wa_nonproduct-issubsequentdebitcredit = 'X'.
          wa_pur_delivery_line-transactiontype = |Sub { wa_pur_delivery_line-transactiontype } |.
        ENDIF.


        READ TABLE it_taxname INTO DATA(wa_taxname2) WITH KEY taxcode = wa_nonproduct-taxcode.
        IF wa_taxname2 IS NOT INITIAL.
          wa_pur_delivery_line-taxcodename = wa_taxname2-taxcodename.
        ENDIF.


        DATA lv_taxcodenp TYPE string.
        lv_taxcodenp = wa_nonproduct-taxcode.
        DATA(wa_taxes3) = get_tax_rates( iv_taxcode = lv_taxcodenp ).
        wa_pur_delivery_line-cgst        = ( wa_nonproduct-supplierinvoiceitemamount * wa_taxes3-ratecgst ) / 100.
        wa_pur_delivery_line-sgst        = ( wa_nonproduct-supplierinvoiceitemamount * wa_taxes3-ratesgst ) / 100.
        wa_pur_delivery_line-igst        = ( wa_nonproduct-supplierinvoiceitemamount * wa_taxes3-rateigst ) / 100.
        wa_pur_delivery_line-ratecgst    = wa_taxes3-ratecgst.
        wa_pur_delivery_line-ratesgst    = wa_taxes3-ratesgst.
        wa_pur_delivery_line-rateigst    = wa_taxes3-rateigst.
        wa_pur_delivery_line-netamount   = wa_nonproduct-supplierinvoiceitemamount.

        IF wa_nonproduct-suplrinvcdeliverycostcndntype = 'JCDB'.
          READ TABLE it_itemamt INTO DATA(wa_itemamtsum) WITH KEY supplierinvoice = wa_nonproduct-supplierinvoice
                                                                  fiscalyear = wa_nonproduct-fiscalyear.
          DATA(lv_igstjcdb) = ( wa_itemamtsum-itemamount * wa_taxes3-rateigst ) / 100.
          lv_igstjcdb += wa_itemamtsum-itemamount.
          DATA(lv_igstdiff)               = wa_nonproduct-invoicegrossamount - lv_igstjcdb.
          wa_pur_delivery_line-igst      += lv_igstdiff.
          wa_pur_delivery_line-taxamount += lv_igstdiff.
          CLEAR : lv_igstjcdb, lv_igstdiff.
        ENDIF.

        wa_pur_delivery_line-netamount   =  wa_nonproduct-supplierinvoiceitemamount * wa_nonproduct-exchangerate.
        wa_pur_delivery_line-taxamount   =  wa_pur_delivery_line-igst + wa_pur_delivery_line-cgst + wa_pur_delivery_line-sgst.
        wa_pur_delivery_line-totalamount =  wa_nonproduct-supplierinvoiceitemamount + wa_pur_delivery_line-taxamount.

        IF lv_signval < 0.
          wa_pur_delivery_line-cgst        *= lv_signval.
          wa_pur_delivery_line-sgst        *= lv_signval.
          wa_pur_delivery_line-igst        *= lv_signval.
          wa_pur_delivery_line-ratecgst    *= lv_signval.
          wa_pur_delivery_line-ratesgst    *= lv_signval.
          wa_pur_delivery_line-rateigst    *= lv_signval.
          wa_pur_delivery_line-netamount   *= lv_signval.
          wa_pur_delivery_line-taxamount   *= lv_signval.
          wa_pur_delivery_line-totalamount *= lv_signval.
        ENDIF.

        MODIFY zdt_pur_reg_new FROM @wa_pur_delivery_line.
      ENDIF.
      CLEAR: wa_nonproduct2, wa_pur_delivery_line, wa_taxname2, wa_taxes3, lv_taxcodenp, wa_taxname,
             wa_accounting2, lv_signval, wa_transtype3, wa_journalentry3, wa_accdoc2, wa_itemamtsum."lv_pricingsum.
    ENDLOOP.









***************************** For G/L Account Entries

    DATA wa_pur_gl_line TYPE zdt_pur_reg_new.

    SELECT FROM i_suplrinvoiceitemglacctapi01 AS a
    LEFT JOIN i_supplierinvoiceapi01 AS b ON a~supplierinvoice = b~supplierinvoice AND a~fiscalyear = b~fiscalyear
    LEFT JOIN i_supplier AS c ON b~invoicingparty = c~supplier
    LEFT JOIN ztable_plant AS d ON d~plant_code = b~businessplace
    LEFT JOIN i_user AS z ON b~lastchangedbyuser = z~userid
    FIELDS a~supplierinvoice, a~supplierinvoiceitem, a~fiscalyear, a~companycode, a~profitcenter, a~supplierinvoiceitemtext,
    a~glaccount, a~supplierinvoiceitemamount, a~taxcode, b~businessplace,b~createdbyuser,b~lastchangedbyuser, b~postingdate, b~supplierinvoicestatus,
    b~supplierinvoiceidbyinvcgparty, b~documentdate, b~reversedocument, b~supplierinvoicewthnfiscalyear,
    b~isinvoice, b~exchangerate, b~documentcurrency, c~supplier, c~taxnumber3, c~suppliername, c~businesspartnerpannumber,
    c~suppliercorporategroup, d~gstin_no, d~plant_name1,d~plant_code, d~plant_name2, d~address1, d~address2, d~address3, d~pin, d~city,
     z~userdescription
    WHERE a~glaccount IS NOT INITIAL
    INTO TABLE @DATA(it_gltab) PRIVILEGED ACCESS.

    DELETE it_gltab WHERE supplierinvoicestatus = 'A'.

    SELECT FROM i_glaccounttext AS a
    FIELDS a~glaccount, a~glaccountname
    WHERE a~language = 'E'
    INTO TABLE @DATA(it_gltext) PRIVILEGED ACCESS.

    LOOP AT it_gltab INTO DATA(wa_gltab).
      wa_pur_gl_line-companycode         = wa_gltab-companycode.
      wa_pur_gl_line-fiscalyearvalue     = wa_gltab-fiscalyear.
      wa_pur_gl_line-supplierinvoice     = wa_gltab-supplierinvoice.
      wa_pur_gl_line-supplierinvoiceitem = wa_gltab-supplierinvoiceitem + 1000 .
      wa_pur_gl_line-postingdate         = wa_gltab-postingdate.
      wa_pur_gl_line-product             = wa_gltab-glaccount.
      wa_pur_gl_line-vendorcode          = wa_gltab-supplier.
      wa_pur_gl_line-vendorname          = wa_gltab-suppliername.
      wa_pur_gl_line-vendortype          = wa_gltab-suppliercorporategroup.
      wa_pur_gl_line-vendorgstin         = wa_gltab-taxnumber3.
      wa_pur_gl_line-vendor_invoice_date = wa_gltab-documentdate.
      wa_pur_gl_line-vendor_invoice_no   = wa_gltab-supplierinvoiceidbyinvcgparty.
      wa_pur_gl_line-vendorpanno         = wa_gltab-businesspartnerpannumber.
      wa_pur_gl_line-plantgst            = wa_gltab-gstin_no.
      wa_pur_gl_line-plant            = wa_gltab-plant_code.
      wa_pur_gl_line-plantname           = |{ wa_gltab-plant_name1 } { wa_gltab-plant_name2 } |.
      wa_pur_gl_line-plantadr            = |{ wa_gltab-address1 } { wa_gltab-address2 } { wa_gltab-address3 } |.
      wa_pur_gl_line-plantpin            =  wa_gltab-pin.
      wa_pur_gl_line-plantcity           =  wa_gltab-city.
      wa_pur_gl_line-netamount           = wa_gltab-supplierinvoiceitemamount.
      wa_pur_gl_line-profitcenter        = wa_gltab-profitcenter.
      wa_pur_gl_line-miro_item_type      = 'G/L Account Entry'.
      wa_pur_gl_line-transactiontype     = 'Invoice'.
      wa_pur_gl_line-supplierinvoiceitemtext       = wa_gltab-supplierinvoiceitemtext.
      wa_pur_gl_line-originalreferencedocument     = |{ wa_gltab-supplierinvoice }{ wa_gltab-fiscalyear }| .
      wa_pur_gl_line-createdby                     = wa_gltab-userdescription.

      IF wa_gltab-reversedocument IS NOT INITIAL.
        wa_pur_gl_line-isreversed             = 'X'.
        wa_pur_gl_line-referenceinvoicenumber = wa_gltab-reversedocument.
      ENDIF.

      READ TABLE it_taxname INTO DATA(wa_taxnamegl) WITH KEY taxcode = wa_gltab-taxcode.
      IF wa_taxnamegl IS NOT INITIAL.
        wa_pur_gl_line-taxcodename = wa_taxnamegl-taxcodename.
      ENDIF.

      READ TABLE it_gltext INTO DATA(wa_gltext) WITH KEY glaccount = wa_gltab-glaccount.
      IF wa_gltext-glaccountname IS NOT INITIAL.
        wa_pur_gl_line-productname = wa_gltext-glaccountname.
      ENDIF.

      wa_pur_gl_line-netamount = wa_gltab-supplierinvoiceitemamount * wa_gltab-exchangerate.

      DATA lv_taxcodegl TYPE string.
      lv_taxcodegl = wa_gltab-taxcode.
      DATA(wa_taxes4) = get_tax_rates( iv_taxcode = lv_taxcodegl ).
      wa_pur_gl_line-cgst        = ( wa_gltab-supplierinvoiceitemamount * wa_taxes4-ratecgst ) / 100.
      wa_pur_gl_line-sgst        = ( wa_gltab-supplierinvoiceitemamount * wa_taxes4-ratesgst ) / 100.
      wa_pur_gl_line-igst        = ( wa_gltab-supplierinvoiceitemamount * wa_taxes4-rateigst ) / 100.
      wa_pur_gl_line-ratecgst    = wa_taxes4-ratecgst.
      wa_pur_gl_line-ratesgst    = wa_taxes4-ratesgst.
      wa_pur_gl_line-rateigst    = wa_taxes4-rateigst.
      wa_pur_gl_line-taxamount   = wa_pur_gl_line-igst + wa_pur_gl_line-cgst + wa_pur_gl_line-sgst.
      wa_pur_gl_line-totalamount = wa_gltab-supplierinvoiceitemamount + wa_pur_gl_line-taxamount.


      lv_signval = 1.
*        //For TransactionType
      READ TABLE it_transtype INTO DATA(wa_transtype4) WITH KEY purchasinghistorydocument = wa_gltab-supplierinvoice.

      READ TABLE it_journalentry INTO DATA(wa_journalentry4) WITH KEY originalreferencedocument = wa_gltab-supplierinvoicewthnfiscalyear.
      IF wa_journalentry4 IS NOT INITIAL.
        IF ( wa_gltab-isinvoice = 'X' AND wa_journalentry4-isreversal IS INITIAL
            AND wa_transtype4-purchasinghistorycategory = 'Q' AND wa_transtype4-debitcreditcode = 'S' ) OR
           ( wa_gltab-isinvoice = 'X' AND wa_journalentry4-isreversed IS INITIAL AND wa_transtype4 IS INITIAL ).
          wa_pur_gl_line-transactiontype = 'Invoice'.
        ELSEIF wa_gltab-isinvoice IS INITIAL AND wa_journalentry4-isreversal = 'X' AND
               wa_transtype4-purchasinghistorycategory = 'Q' AND wa_transtype4-debitcreditcode = 'H' .
          wa_pur_gl_line-transactiontype = 'Invoice'.
          lv_signval = -1.
        ELSEIF ( wa_gltab-isinvoice IS INITIAL AND wa_journalentry4-isreversal IS INITIAL ) OR
               ( wa_gltab-isinvoice IS INITIAL AND wa_journalentry4-isreversal = 'X' AND wa_transtype4 IS INITIAL ).
          wa_pur_gl_line-transactiontype = 'Debit Note'.    "credit memo
          lv_signval = -1.
        ELSEIF wa_gltab-isinvoice = 'X' AND wa_journalentry4-isreversal = 'X'.
          wa_pur_gl_line-transactiontype = 'Debit Note'.
        ELSEIF wa_gltab-isinvoice = 'X' AND wa_journalentry4-isreversal IS INITIAL AND
               wa_transtype4-purchasinghistorycategory = 'N' AND wa_transtype4-debitcreditcode = 'S'.
          wa_pur_gl_line-transactiontype = 'Credit Memo'.
        ELSEIF wa_gltab-isinvoice IS INITIAL AND wa_journalentry4-isreversal = 'X' AND
               wa_transtype4-purchasinghistorycategory = 'N' AND wa_transtype4-debitcreditcode = 'H'.
          wa_pur_gl_line-transactiontype = 'Credit Memo'.
          lv_signval = -1.
        ENDIF.
      ENDIF.

      IF lv_signval < 0.
        wa_pur_gl_line-cgst        *= lv_signval.
        wa_pur_gl_line-sgst        *= lv_signval.
        wa_pur_gl_line-igst        *= lv_signval.
        wa_pur_gl_line-ratecgst    *= lv_signval.
        wa_pur_gl_line-ratesgst    *= lv_signval.
        wa_pur_gl_line-rateigst    *= lv_signval.
        wa_pur_gl_line-netamount   *= lv_signval.
        wa_pur_gl_line-taxamount   *= lv_signval.
        wa_pur_gl_line-totalamount *= lv_signval.
      ENDIF.

      MODIFY zdt_pur_reg_new FROM @wa_pur_gl_line.
      CLEAR: wa_pur_gl_line, wa_taxnamegl, wa_taxes4, lv_taxcodegl, lv_signval, wa_journalentry4,
             wa_transtype4, wa_gltext.
    ENDLOOP.


*     SELECT SINGLE FROM  i_operationalacctgdocitem
*        FIELDS SUM( AmountInCompanyCodeCurrency )
*        WHERE OriginalReferenceDocument = @waheader-SupplierInvoiceWthnFiscalYear
*        AND TaxItemAcctgDocItemRef = @wa_accdoc-TaxItemAcctgDocItemRef
*        AND TransactionTypeDetermination IN ( 'JII', 'JIM' )
*        AND AccountingDocumentItemType = 'T'
*        INTO @DATA(lvvv).
*
*        SELECT SINGLE FROM  i_operationalacctgdocitem
*        FIELDS SUM( AmountInCompanyCodeCurrency )
*        WHERE OriginalReferenceDocument = @waheader-SupplierInvoiceWthnFiscalYear
*        AND TaxItemAcctgDocItemRef = @wa_accdoc-TaxItemAcctgDocItemRef
*        AND TransactionTypeDetermination IN ( 'JIC', 'JRC' )
*        AND AccountingDocumentItemType = 'T'
*        INTO @DATA(lvvv2).
*
*        ls_response-cgst = lvvv2.
*        ls_response-sgst = lvvv2.
*        ls_response-igst = lvvv.


  ENDMETHOD.
ENDCLASS.
