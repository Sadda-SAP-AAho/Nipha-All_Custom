CLASS zcomparison_price DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.




    INTERFACES if_oo_adt_classrun .
    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .
    CLASS-DATA : template TYPE string .
    CLASS-DATA : tot_sum  TYPE string.



    TYPES : BEGIN OF struct,
              xdp_template TYPE string,
              xml_data     TYPE string,
              form_type    TYPE string,
              form_locale  TYPE string,
              tagged_pdf   TYPE string,
              embed_font   TYPE string,
            END OF struct."

    CLASS-METHODS :
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,

      read_posts
        IMPORTING VALUE(pricedocument) TYPE string




        RETURNING VALUE(result12)      TYPE string
        RAISING   cx_static_check .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://devtenant-ux00yyve.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS  lc_template_name TYPE string VALUE 'ZCOMPARISON_STATEMENT/ZCOMPARISON_STATEMENT'.
ENDCLASS.



CLASS ZCOMPARISON_PRICE IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.
    TRY.
    ENDTRY.
  ENDMETHOD.


  METHOD read_posts .

    DATA xsml TYPE string.



    SELECT a~supplier FROM  i_supplierquotation_api01 AS a WHERE a~requestforquotation = @pricedocument INTO TABLE @DATA(supname1) .
    READ TABLE supname1 INTO DATA(supline1) INDEX 1 .
    SELECT SINGLE a~suppliername FROM  i_supplier AS a WHERE a~supplier = @supline1-supplier INTO  @DATA(name1) .

    READ TABLE supname1 INTO DATA(supline2) INDEX 2 .
    SELECT SINGLE a~suppliername FROM  i_supplier AS a WHERE a~supplier = @supline2-supplier INTO  @DATA(name2) .

    READ TABLE supname1 INTO DATA(supline3) INDEX 3 .
    SELECT SINGLE a~suppliername FROM  i_supplier AS a WHERE a~supplier = @supline3-supplier INTO  @DATA(name3) .

    DATA(lv_xml) =



    |<form1>| &&
       |<BodyMain>| &&
          |<Subform2>| &&
             |<Table1>| &&
                |<Row1>| &&


*               |<Table2>| &&
*                  |<Row1>| &&
*                     |<Text1>{ name1 }{ supLINE1-Supplier }</Text1>| &&
*                  |</Row1>| &&
*                  |<Row2>| &&
*                     |<Table5>| &&
*                        |<Row1/>| &&
*                     |</Table5>| &&
*                  |</Row2>| &&
*               |</Table2>| &&
*               |<Table3>| &&
*                  |<Row1>| &&
*                     |<Text2>{ name2 }{ supLINE2-Supplier }</Text2>| &&
*                  |</Row1>| &&
*                  |<Row2>| &&
*                     |<Table6>| &&
*                        |<Row1/>| &&
*                     |</Table6>| &&
*                  |</Row2>| &&
*               |</Table3>| &&
*               |<Table3>| &&
*                  |<Row1>| &&
*                     |<Text3>{ name3 }{ supLINE3-Supplier }</Text3>| &&
*                  |</Row1>| &&
*                  |<Row2>| &&
*                     |<Table6>| &&
*                        |<Row1/>| &&
*                     |</Table6>| &&
*                  |</Row2>| &&
*               |</Table3>| &&


                  |<Table2>| &&
                      |<Row1>| &&
                         |<Table16>| &&
                            |<Row1>| &&
                               |<HEAD11>{ name1 }</HEAD11>| &&
                            |</Row1>| &&
                            |<Row2>| &&
                               |<HEAD12>{ supline1-supplier }</HEAD12>| &&
                            |</Row2>| &&
                         |</Table16>| &&
                      |</Row1>| &&
                      |<Row2>| &&
                         |<Table5>| &&
                            |<Row1/>| &&
                         |</Table5>| &&
                      |</Row2>| &&
                   |</Table2>| &&
                   |<Table3>| &&
                      |<Row1>| &&
                         |<Table17>| &&
                            |<Row1>| &&
                               |<HEAD21>{ name2 }</HEAD21>| &&
                            |</Row1>| &&
                            |<Row2>| &&
                               |<HEAD22>{ supline2-supplier }</HEAD22>| &&
                            |</Row2>| &&
                         |</Table17>| &&
                      |</Row1>| &&
                      |<Row2>| &&
                         |<Table6>| &&
                            |<Row1/>| &&
                         |</Table6>| &&
                      |</Row2>| &&
                   |</Table3>| &&
                   |<Table3>| &&
                      |<Row1>| &&
                         |<Table18>| &&
                            |<Row1>| &&
                               |<HEAD31>{ name3 }</HEAD31>| &&
                            |</Row1>| &&
                            |<Row2>| &&
                              |<HEAD32>{ supline3-supplier }</HEAD32>| &&
                            |</Row2>| &&
                         |</Table18>| &&
                      |</Row1>| &&
                      |<Row2>| &&
                         |<Table6>| &&
                            |<Row1/>| &&
                         |</Table6>| &&
                      |</Row2>| &&
                   |</Table3>| &&


                |</Row1>| &&
             |</Table1>| &&
             |<Table7>| .


    SELECT a~supplierquotation FROM  i_supplierquotation_api01 AS a WHERE a~requestforquotation = @pricedocument INTO TABLE @DATA(loop) .
    READ TABLE loop INTO DATA(line1) INDEX 1 .

    IF line1 <> '' .
      READ TABLE loop INTO DATA(line2) INDEX 2 .
    ENDIF.
    IF line2 <> '' .
      READ TABLE loop INTO DATA(line3) INDEX 3 .
    ENDIF.

***********************************************************************************************************
    IF line1-supplierquotation IS NOT INITIAL.
      SELECT supplierquotation,
           supplierquotationitem,
           conditiontype,
           ConditionAmount,
           conditionbasevalue,
           conditionratevalue FROM i_supplierquotationprcelmnttp
                                   WHERE supplierquotation = @line1-supplierquotation
                                   AND conditiontype = 'ZL01'
                                   INTO TABLE @DATA(lt_dis).
    ENDIF.
    IF line2-supplierquotation IS NOT INITIAL.
      SELECT supplierquotation,
           supplierquotationitem,
           conditiontype,
           ConditionAmount,
           conditionbasevalue,
           conditionratevalue FROM i_supplierquotationprcelmnttp
                                   WHERE supplierquotation = @line2-supplierquotation
                                   AND conditiontype = 'ZL01'
                                   INTO TABLE @DATA(lt_dis1).
    ENDIF.
    IF line3-supplierquotation IS NOT INITIAL.
      SELECT supplierquotation,
           supplierquotationitem,
           conditiontype,
           ConditionAmount,
           conditionbasevalue,
           conditionratevalue FROM i_supplierquotationprcelmnttp
                                   WHERE supplierquotation = @line3-supplierquotation
                                   AND conditiontype = 'ZL01'
                                   INTO TABLE @DATA(lt_dis2).
    ENDIF.
*    IF line1-supplierquotation IS NOT INITIAL.
*      SELECT SUM( conditionamount ) FROM i_supplierquotationprcelmnttp
*                                    WHERE supplierquotation = @line1-supplierquotation
*                                    AND conditiontype = 'ZFVA'
*                                    INTO @DATA(freight).
*
*      SELECT SUM( conditionamount ) FROM i_supplierquotationprcelmnttp
*                                WHERE supplierquotation = @line1-supplierquotation
*                                AND conditiontype = 'ZPFC'
*                                INTO @DATA(other).
*    ENDIF.
*
*    IF line2-supplierquotation IS NOT INITIAL.
*      SELECT SUM( conditionamount ) FROM i_supplierquotationprcelmnttp
*                                      WHERE supplierquotation = @line2-supplierquotation
*                                      AND conditiontype = 'ZFVA'
*                                      INTO @DATA(freight1).
*
*      SELECT SUM( conditionamount ) FROM i_supplierquotationprcelmnttp
*                                      WHERE supplierquotation = @line2-supplierquotation
*                                      AND conditiontype = 'ZPFC'
*                                      INTO @DATA(other1).
*
*    ENDIF.
*
*
*    IF line3-supplierquotation IS NOT INITIAL.
*      SELECT SUM( conditionamount ) FROM i_supplierquotationprcelmnttp
*                                      WHERE supplierquotation = @line3-supplierquotation
*                                      AND conditiontype = 'ZFVA'
*                                      INTO @DATA(freight2).
*
*      SELECT SUM( conditionamount ) FROM i_supplierquotationprcelmnttp
*                                  WHERE supplierquotation = @line3-supplierquotation
*                                  AND conditiontype = 'ZPFC'
*                                  INTO @DATA(other2).
*
*    ENDIF.
*****************************************************************************************************************


    SELECT * FROM  i_supplierquotation_api01 AS a
                LEFT OUTER JOIN i_supplierquotationitem_api01 AS b ON ( b~supplierquotation = a~supplierquotation )
*                      LEFT OUTER JOIN I_ProductPlantBasic as c on ( c~Product = b~Material  )
*                     LEFT OUTER JOIN I_Supplier as D on ( D~Supplier = C~Supplier )
                 WHERE a~requestforquotation = @pricedocument INTO TABLE @DATA(table) .
    SELECT  supplierquotation ,  netpriceamount,netamount,supplierquotationitem,material,purchasingdocumentitemtext,orderquantity,orderquantityunit
    FROM  i_supplierquotationitem_api01 WHERE supplierquotation = @line1-supplierquotation INTO TABLE @DATA(loop1) .

    DATA tot1 TYPE string .
    DATA tot2 TYPE string .
    DATA tot3 TYPE string .
    DATA sn TYPE string .
    DATA uom TYPE string .

    DATA amt_tab TYPE TABLE OF i_supplierquotationitem_api01-netamount .


    LOOP AT loop1 INTO DATA(tab) .

      SELECT SINGLE consumptiontaxctrlcode FROM  i_productplantbasic WHERE product = @tab-material INTO  @DATA(hsn) .

      SELECT SINGLE schedulelineorderquantity FROM  i_suplrqtnscheduleline_api01 WHERE supplierquotation = @tab-supplierquotation AND supplierquotationitem = @tab-supplierquotationitem INTO  @DATA(qty) .

      sn = sn + 1 .

      SHIFT tab-material LEFT DELETING LEADING '0'.

******************************added on 14.05.2025 by Riya****************************************
DATA(lv_dis) = VALUE #( lt_dis[ SupplierQuotation = tab-SupplierQuotation
                               SupplierQuotationItem = tab-SupplierQuotationItem ] OPTIONAL ).

  IF lv_dis IS NOT INITIAL .
  IF lv_dis-ConditionAmount > 0 .
  tab-netamount = tab-netamount - lv_dis-ConditionAmount.
  ELSE.
  tab-netamount = tab-netamount + lv_dis-ConditionAmount.
  ENDIF.
  Endif.
*****************************************************************************************************

      tot1 = tot1 + tab-netamount .
      IF
      tab-orderquantityunit = 'ST' .
        uom = 'PC' .
      ELSE .
        uom = tab-orderquantityunit .
      ENDIF.

DATA : lv_disrate TYPE p DECIMALS 2.

       lv_disrate = lv_dis-ConditionRateValue.



      DATA(lv_xml1)   =
             |<Row1>| &&
                |<SlNo>{ sn }</SlNo>| &&
*               |<ItemDesc>{ tab-Material }     { tab-PurchasingDocumentItemText }</ItemDesc>| &&
                |<Table15>| &&
                   |<Row1>| &&
                      |<ItemDesc>{ tab-material }</ItemDesc>| &&
                   |</Row1>| &&
                   |<Row2>| &&
                      |<ItemDesc2>{ tab-purchasingdocumentitemtext }</ItemDesc2>| &&
                   |</Row2>| &&
                |</Table15>| &&
                |<Qty>{ qty }</Qty>| &&
                |<UOM>{ uom }</UOM>| &&
                |<HSN>{ hsn }</HSN>| &&
                |<Rate1>{ tab-netpriceamount }</Rate1>| &&
**********************************************************************
                |<Table19>| &&
                |<disper>| &&
                |<Cell1>{ lv_disrate }{ '%' }</Cell1>| &&
                |</disper>| &&
                |<disamt>| &&
                |<Cell1>{ lv_dis-ConditionAmount }</Cell1>| &&
                |</disamt>| &&
                |</Table19>| &&
**********************************************************************
                |<Amt1>{ tab-netamount }</Amt1>| &&

                |</Row1>| .

      CONCATENATE : xsml lv_xml1 INTO xsml .
      CLEAR : lv_xml1 .

    ENDLOOP.

    APPEND tot1 TO amt_tab .

    DATA(tab_xml1)   =
                 |</Table7>| &&

       |<Table12>| .

    CONCATENATE : xsml tab_xml1 INTO xsml .
    SELECT supplierquotation,                                    "SupplierQuotation, SupplierQuotationItem, added on 15.05.2025 by Riya
           supplierquotationitem,
           netpriceamount,netamount FROM  i_supplierquotationitem_api01
                                    WHERE supplierquotation = @line2-supplierquotation
                                    INTO TABLE @DATA(loop2) .

    LOOP AT loop2 INTO DATA(wa2) .

******************************added on 14.05.2025 by Riya****************************************
DATA(lv_dis1) = VALUE #( lt_dis1[ SupplierQuotation = wa2-SupplierQuotation
                               SupplierQuotationItem = wa2-SupplierQuotationItem ] OPTIONAL ).

  IF lv_dis1 IS NOT INITIAL .
  IF lv_dis1-ConditionAmount > 0 .
  wa2-netamount = wa2-netamount - lv_dis1-ConditionAmount.
  ELSE.
  wa2-netamount = wa2-netamount + lv_dis1-ConditionAmount.
  ENDIF.
  Endif.

*****************************************************************************************************

      tot2 = tot2 + wa2-netamount .

*      DATA(tab_xml2)   =
*                 |<Row1>| &&
*                |<sup2rate>{ wa2-netpriceamount }</sup2rate>| &&
*                |<sup2amt>{ wa2-netamount }</sup2amt>| &&
*             |</Row1>| .

***************************added on 15.05.2025 by Riya********************************************

DATA : lv_disrate1 TYPE p DECIMALS 2.

       lv_disrate1 = lv_dis1-ConditionRateValue.
  DATA(tab_xml2)   =
                   |<Row1>| &&
                   |<Cell1>{ wa2-netpriceamount }</Cell1>| &&
                   |<Table20>| &&
                   |<disper1>| &&
                   |<Cell1>{ lv_disrate1 }{ '%' }</Cell1>| &&
                   |</disper1>| &&
                   |<disamt1>| &&
                   |<Cell1>{ lv_dis1-ConditionAmount }</Cell1>| &&
                   |</disamt1>| &&
                   |</Table20>| &&
                   |<Cell3>{ wa2-netamount }</Cell3>| &&
                   |</Row1>|.
**********************************************************************
      CONCATENATE : xsml tab_xml2 INTO xsml .
      CLEAR : tab_xml2,wa2 .
    ENDLOOP.
    IF tot2 IS NOT  INITIAL .
      APPEND tot2 TO amt_tab .
    ENDIF.

    DATA(tab_xml3)   =
          |</Table12>| &&
          |<Table13>| .
    CONCATENATE : xsml tab_xml3 INTO xsml .

    SELECT supplierquotation,                                    "SupplierQuotation, SupplierQuotationItem, added on 15.05.2025 by Riya
           supplierquotationitem,
            netpriceamount,
            netamount FROM  i_supplierquotationitem_api01
                      WHERE supplierquotation = @line3-supplierquotation
                      INTO TABLE @DATA(loop3) .

    IF loop3 IS NOT INITIAL .

      LOOP AT loop3 INTO DATA(wa3) .

******************************added on 14.05.2025 by Riya****************************************
DATA(lv_dis2) = VALUE #( lt_dis2[ SupplierQuotation = wa3-SupplierQuotation
                               SupplierQuotationItem = wa3-SupplierQuotationItem ] OPTIONAL ).

  IF lv_dis2 IS NOT INITIAL .
  IF lv_dis2-ConditionAmount > 0 .
  wa3-netamount = wa3-netamount - lv_dis2-ConditionAmount.
  ELSE.
  wa3-netamount = wa3-netamount + lv_dis2-ConditionAmount.
  ENDIF.
  Endif.
*****************************************************************************************************

        tot3 = tot3 + wa3-netamount .

******************************added on 15.05.2025 by Riya****************************************
*        DATA(tab_xml4)   =
*             |<Row1>| &&
*                   |<sup3rate>{ wa3-netpriceamount }</sup3rate>| &&
*                   |<sup3amt>{ wa3-netamount }</sup3amt>| &&
*                |</Row1>| .

DATA : lv_disrate2 TYPE p DECIMALS 2.

       lv_disrate2 = lv_dis2-ConditionRateValue.
  DATA(tab_xml4)   =
                    |<Row1>| &&
                    |<Cell1>{ wa3-netpriceamount }</Cell1>| &&
                    |<Table22>| &&
                    |<disper2>| &&
                    |<Cell1>{ lv_disrate2 }{ '%' }</Cell1>| &&
                    |</disper2>| &&
                    |<disamt2>| &&
                    |<Cell1>{ lv_dis2-ConditionAmount }</Cell1>| &&
                    |</disamt2>| &&
                    |</Table22>| &&
                    |<Cell3>{ wa3-netamount }</Cell3>| &&
                    |</Row1>| .
**********************************************************************
        CONCATENATE : xsml tab_xml4 INTO xsml .
        CLEAR : tab_xml4,wa3 .

      ENDLOOP.

      IF tot3 IS NOT  INITIAL .
        APPEND tot3 TO amt_tab .
      ENDIF.


*///////////////////////////////////////////////////////////////////////////////////// JUST TO GIVE BORDER TO PRINT
    ELSE .

      LOOP AT loop2 INTO DATA(wa4) .

******************************added on 14.05.2025 by Riya****************************************
 lv_dis2 = VALUE #( lt_dis2[ SupplierQuotation = wa4-SupplierQuotation
                               SupplierQuotationItem = wa4-SupplierQuotationItem ] OPTIONAL ).

  IF lv_dis2 IS NOT INITIAL .
  IF lv_dis2-ConditionAmount > 0 .
  wa3-netamount = wa3-netamount - lv_dis2-ConditionAmount.
  ELSE.
  wa3-netamount = wa3-netamount + lv_dis2-ConditionAmount.
  ENDIF.
  Endif.
*****************************************************************************************************

****************************added on 15.05.2025 by Riya******************************************
        tab_xml4   =
               |<Row1>| &&
                    |<Cell1></Cell1>| &&
                    |<Table22>| &&
                    |<disper2>| &&
                    |<Cell1></Cell1>| &&
                    |</disper2>| &&
                    |<disamt2>| &&
                    |<Cell1></Cell1>| &&
                    |</disamt2>| &&
                    |</Table22>| &&
                    |<Cell3></Cell3>| &&
                    |</Row1>| .

*             |<Row1>| &&
*                   |<sup3rate></sup3rate>| &&
*                   |<sup3amt></sup3amt>| &&
*                |</Row1>| .
**********************************************************************
        CONCATENATE : xsml tab_xml4 INTO xsml .
        CLEAR : tab_xml4 .

      ENDLOOP.

    ENDIF.
*///////////////////////////////////////////////////////////////////////////////////// JUST TO GIVE BORDER TO PRINT



    SELECT SINGLE b~purreqcreationdate ,a~purchaserequisition FROM  i_supplierquotationitem_api01 AS a
    LEFT OUTER JOIN i_purchaserequisitionitemapi01 AS b ON ( b~purchaserequisition = a~purchaserequisition )  WHERE supplierquotation = @line1-supplierquotation INTO  @DATA(indant) .


    SORT amt_tab ASCENDING.


    DATA rank1 TYPE string .
    DATA rank2 TYPE string .
    DATA rank3 TYPE string .


    READ TABLE amt_tab INTO DATA(amt1) INDEX 1 .
    READ TABLE amt_tab INTO DATA(amt2) INDEX 2 .
    READ TABLE amt_tab INTO DATA(amt3) INDEX 3 .

*     IF AMT1 <> '' .
*     rank1 = 'L1 ' .
**     CONCATENATE  rank1 supLINE1-Supplier INTO RANK1 .
*     ENDIF.
*     IF AMT2 <> '' .
*     rank2 = 'L2 '  .
*     ENDIF.
*     IF AMT3 <> '' .
*     rank3 = 'L3 '  .
*     ENDIF .
*

    DATA:st1   TYPE string,
         strl1 TYPE string,
         st2   TYPE string,
         strl2 TYPE string,
         st3   TYPE string,
         strl3 TYPE string.

    st1 = tot1.
    st2 = tot2.
    st3 = tot3.




    IF st1 <> '' AND st2 <> '' AND st3 <> ''.
      IF st1 <= st2 AND st1 <= st3.
        CONCATENATE 'L1' st1 INTO strl1 SEPARATED BY ''.
        IF st2 <= st3.
          CONCATENATE 'L2 ' st2 INTO strl2 SEPARATED BY ''.
          CONCATENATE 'L3 ' st3 INTO strl3 SEPARATED BY ''.

        ELSE.
          CONCATENATE 'L3 ' st2 INTO strl2 SEPARATED BY ''.
          CONCATENATE 'L2 ' st3 INTO strl3 SEPARATED BY ''.
        ENDIF.
      ELSEIF st2 <= st1 AND st2 <= st3.
        CONCATENATE 'L1 ' st2 INTO strl2 SEPARATED BY ''.
*         CONCATENATE 'L1' st2 INTO strl1 SEPARATED BY ''.           "Added on 15.05.2025 by riya
        IF st1 <= st3.
         CONCATENATE 'L2' st1 INTO strl1 SEPARATED BY ''.
*         CONCATENATE 'L2 ' st1 INTO strl1 SEPARATED BY ''.
          CONCATENATE 'L3 ' st3 INTO strl3 SEPARATED BY ''.        ""Added on 15.05.2025 by riya
        ELSE.
*          CONCATENATE 'L3' st3 INTO strl3 SEPARATED BY ''.
*          CONCATENATE 'L2 ' st3 INTO strl2 SEPARATED BY ''.
          CONCATENATE 'L2 ' st3 INTO strl3 SEPARATED BY ''.            "Added on 15.05.2025 by riya
          CONCATENATE 'L3' st1 INTO strl1 SEPARATED BY ''.              "Added on 15.05.2025 by riya
        ENDIF.
**********************************************************************
        ELSEIF st2 <= st1 AND st3 <= st2.
        CONCATENATE 'L3' st1 INTO strl1 SEPARATED BY ''.
        IF st2 <= st3.
        CONCATENATE 'L1' st2 INTO strl2 SEPARATED BY ''.
        CONCATENATE 'L2' st3 INTO strl3 SEPARATED BY ''.
        ELSE.
        CONCATENATE 'L2' st2 INTO strl2 SEPARATED BY ''.
        CONCATENATE 'L1' st3 INTO strl3 SEPARATED BY ''.
        ENDIF.
**********************************************************************
      ENDIF.

    ELSEIF st1 <> '' AND st2 <> '' AND st3 = ''.
      IF st1 <= st2.
        CONCATENATE 'L1' st1 INTO strl1 SEPARATED BY ''.
        CONCATENATE 'L2' st2 INTO strl2 SEPARATED BY ''.
      ELSE.
        CONCATENATE 'L2' st1 INTO strl1 SEPARATED BY ''.
        CONCATENATE 'L1' st2 INTO strl2 SEPARATED BY ''.
      ENDIF.

    ELSEIF st1 <> '' AND st2 = '' AND st3 = ''.
      IF st1 <= st2.
        CONCATENATE 'L1' st1 INTO strl1 SEPARATED BY ''.
      ENDIF.

    ENDIF.







    DATA(lv_xml2)   =



        |</Table13>| &&
        |<Table14>| &&
           |<Row1>| &&
              |<tot1>{ tot1 }</tot1>| &&
              |<tot2>{ tot2 }</tot2>| &&
              |<tot3>{ tot3 }</tot3>| &&
           |</Row1>| &&
        |</Table14>| &&
        |<BasicMat></BasicMat>| &&
        |<Disc></Disc>| &&
        |<NetMatCost></NetMatCost>| &&
        |<Freight></Freight>| &&
        |<Mcharges></Mcharges>| &&
        |<TotLandCost></TotLandCost>| &&

*****************************************************************************
*       |<freightCharges>| &&
*       |<Freight>{ freight }</Freight>| &&
*       |<Freight1>{ freight1 }</Freight1>| &&
*       |<Freight2>{ freight2 }</Freight2>| &&
*       |</freightCharges>| &&
*       |<OtherCharges>| &&
*       |<Other>{ other }</Other>| &&
*       |<Other1>{ other1 }</Other1>| &&
*       |<Other2>{ other2 }</Other2>| &&
*       |</OtherCharges>| &&
******************************************************************************

        |<Quotation>{ tab-supplierquotation }</Quotation>| &&
        |<Quotation2>{ line2-supplierquotation }</Quotation2>| &&
        |<Quotation3>{ line3-supplierquotation }</Quotation3>| &&
        |<DATEHED>{ indant-purreqcreationdate+6(2) }/{ indant-purreqcreationdate+4(2) }/{ indant-purreqcreationdate+0(4) }</DATEHED>| &&
        |<indnoo>{ indant-purchaserequisition }</indnoo>| &&
|<ad1>Registered Address:- 48, Ganga Jamuna, 28/1 Shakespeare Sarani, Kolkata-700017, West Bengal, India,</ad1>| &&
        |<ad2>Phone : 91 33 4021 4300 fax : 91 33 2287 5104 / 2287 0780, Email : nipha@niphaindia.com</ad2>| &&
        |<rfq>{ pricedocument }</rfq>| &&
*         |<l1>{ rank1 }   { AMT1 }</l1>| &&
*         |<l2>{ rank2 }   { AMT2 }</l2>| &&
*         |<l3>{ rank3 }   { AMT3 }</l3>| &&
        |<l1>   { strl1  }</l1>| &&
        |<l2>   { strl2 }</l2>| &&
        |<l3>   { strl3 }</l3>| &&
        |</Subform2>| &&
        |</BodyMain>| &&
        |</form1>| .

    CONCATENATE lv_xml xsml lv_xml2 INTO lv_xml .






    DATA(url) = |{ lv2_url }|.
    DATA(client) = create_client( url ).
    DATA(req) = client->get_http_request(  ).

    req->set_authorization_basic( i_username = 'sb-b68f47a1-4d84-4660-ae27-4b0389a8cd50!b260781|ads-xsappname!b102452'
      i_password = 'e4b90d62-af57-42ea-bd2b-b2c26db47cde$jdawARRtqDdYn-Q-bpnMFxqrM9oIp_YuD6d5C9c7C8I=')    .
    req->set_content_type( 'application/x-www-form-urlencoded'  ).
    req->set_form_field( EXPORTING i_name  = 'grant_type'
                                   i_value = 'client_credentials' ) .

    DATA(response) = client->execute( if_web_http_client=>post )->get_text(  ).

    REPLACE ALL OCCURRENCES OF '{"access_token":"' IN response WITH ''.
    SPLIT response AT '","token_type' INTO DATA(v1) DATA(v2) .
    DATA(access_token) = v1 .
    client->close(  ).

    REPLACE ALL OCCURRENCES OF '\t' IN lv_xml WITH '&#9;'.
    REPLACE ALL OCCURRENCES OF '\n' IN lv_xml WITH '&#10;'.
    REPLACE ALL OCCURRENCES OF '\r' IN lv_xml WITH '&#13;'.
    REPLACE ALL OCCURRENCES OF '!' IN lv_xml WITH '&#33;'.
*    REPLACE ALL OCCURRENCES OF '"' IN lv_xml WITH '&#34;'.
*    REPLACE ALL OCCURRENCES OF '#' IN lv_xml WITH '&#35;'.
    REPLACE ALL OCCURRENCES OF '$' IN lv_xml WITH '&#36;'.
*    REPLACE ALL OCCURRENCES OF '%' IN lv_xml WITH '&#37;'.
    REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH '&#38;'.
*    REPLACE ALL OCCURRENCES OF |'| IN lv_xml WITH '&#39;'.
    REPLACE ALL OCCURRENCES OF '(' IN lv_xml WITH '&#40;'.
    REPLACE ALL OCCURRENCES OF ')' IN lv_xml WITH '&#41;'.
    REPLACE ALL OCCURRENCES OF '*' IN lv_xml WITH '&#42;'.
    REPLACE ALL OCCURRENCES OF '+' IN lv_xml WITH '&#43;'.
*    REPLACE ALL OCCURRENCES OF ',' IN lv_xml WITH '&#44;'.
*    REPLACE ALL OCCURRENCES OF '-' IN lv_xml WITH '&#45;'.
*    REPLACE ALL OCCURRENCES OF '.' IN lv_xml WITH '&#46;'.
*    REPLACE ALL OCCURRENCES OF '/' IN lv_xml WITH '&#47;'.
    REPLACE ALL OCCURRENCES OF ':' IN lv_xml WITH '&#58;'.
*    REPLACE ALL OCCURRENCES OF ';' IN lv_xml WITH '&#59;'.
*    REPLACE ALL OCCURRENCES OF '<' IN lv_xml WITH '&#60;'.
    REPLACE ALL OCCURRENCES OF '=' IN lv_xml WITH '&#61;'.
*    REPLACE ALL OCCURRENCES OF '>' IN lv_xml WITH '&#62;'.
    REPLACE ALL OCCURRENCES OF '?' IN lv_xml WITH '&#63;'.
    REPLACE ALL OCCURRENCES OF '@' IN lv_xml WITH '&#64;'.
    REPLACE ALL OCCURRENCES OF '[' IN lv_xml WITH '&#91;'.
*    REPLACE ALL OCCURRENCES OF '\' IN lv_xml WITH '&#92;'.
    REPLACE ALL OCCURRENCES OF ']' IN lv_xml WITH '&#93;'.
    REPLACE ALL OCCURRENCES OF '^' IN lv_xml WITH '&#94;'.
*    REPLACE ALL OCCURRENCES OF '_' IN lv_xml WITH '&#95;'.
    REPLACE ALL OCCURRENCES OF '`' IN lv_xml WITH '&#96;'.
    REPLACE ALL OCCURRENCES OF '{' IN lv_xml WITH '&#123;'.
    REPLACE ALL OCCURRENCES OF '|' IN lv_xml WITH '&#124;'.
    REPLACE ALL OCCURRENCES OF '}' IN lv_xml WITH '&#125;'.
    REPLACE ALL OCCURRENCES OF '~' IN lv_xml WITH '&#126;'.
    REPLACE ALL OCCURRENCES OF '€' IN lv_xml WITH '&#128;'.
    REPLACE ALL OCCURRENCES OF '‚' IN lv_xml WITH '&#130;'.
    REPLACE ALL OCCURRENCES OF 'ƒ' IN lv_xml WITH '&#131;'.
    REPLACE ALL OCCURRENCES OF '„' IN lv_xml WITH '&#132;'.
    REPLACE ALL OCCURRENCES OF '…' IN lv_xml WITH '&#133;'.
    REPLACE ALL OCCURRENCES OF '†' IN lv_xml WITH '&#134;'.
    REPLACE ALL OCCURRENCES OF '‡' IN lv_xml WITH '&#135;'.
    REPLACE ALL OCCURRENCES OF 'ˆ' IN lv_xml WITH '&#136;'.
    REPLACE ALL OCCURRENCES OF '‰' IN lv_xml WITH '&#137;'.
    REPLACE ALL OCCURRENCES OF 'Š' IN lv_xml WITH '&#138;'.
    REPLACE ALL OCCURRENCES OF '‹' IN lv_xml WITH '&#139;'.
    REPLACE ALL OCCURRENCES OF 'Œ' IN lv_xml WITH '&#140;'.
    REPLACE ALL OCCURRENCES OF 'Ž' IN lv_xml WITH '&#142;'.
    REPLACE ALL OCCURRENCES OF '‘' IN lv_xml WITH '&#145;'.
    REPLACE ALL OCCURRENCES OF '’' IN lv_xml WITH '&#146;'.
    REPLACE ALL OCCURRENCES OF '“' IN lv_xml WITH '&#147;'.
    REPLACE ALL OCCURRENCES OF '”' IN lv_xml WITH '&#148;'.
    REPLACE ALL OCCURRENCES OF '•' IN lv_xml WITH '&#149;'.
    REPLACE ALL OCCURRENCES OF '–' IN lv_xml WITH '&#150;'.
    REPLACE ALL OCCURRENCES OF '—' IN lv_xml WITH '&#151;'.
    REPLACE ALL OCCURRENCES OF '˜' IN lv_xml WITH '&#152;'.
    REPLACE ALL OCCURRENCES OF '™' IN lv_xml WITH '&#153;'.
    REPLACE ALL OCCURRENCES OF 'š' IN lv_xml WITH '&#154;'.
    REPLACE ALL OCCURRENCES OF '›' IN lv_xml WITH '&#155;'.
    REPLACE ALL OCCURRENCES OF 'œ' IN lv_xml WITH '&#156;'.
    REPLACE ALL OCCURRENCES OF 'ž' IN lv_xml WITH '&#158;'.
    REPLACE ALL OCCURRENCES OF 'Ÿ' IN lv_xml WITH '&#159;'.
    REPLACE ALL OCCURRENCES OF '¡' IN lv_xml WITH '&#161;'.
    REPLACE ALL OCCURRENCES OF '¢' IN lv_xml WITH '&#162;'.
    REPLACE ALL OCCURRENCES OF '£' IN lv_xml WITH '&#163;'.
    REPLACE ALL OCCURRENCES OF '¤' IN lv_xml WITH '&#164;'.
    REPLACE ALL OCCURRENCES OF '¥' IN lv_xml WITH '&#165;'.
    REPLACE ALL OCCURRENCES OF '¦' IN lv_xml WITH '&#166;'.
    REPLACE ALL OCCURRENCES OF '§' IN lv_xml WITH '&#167;'.
    REPLACE ALL OCCURRENCES OF '¨' IN lv_xml WITH '&#168;'.
    REPLACE ALL OCCURRENCES OF '©' IN lv_xml WITH '&#169;'.
    REPLACE ALL OCCURRENCES OF 'ª' IN lv_xml WITH '&#170;'.
    REPLACE ALL OCCURRENCES OF '«' IN lv_xml WITH '&#171;'.
    REPLACE ALL OCCURRENCES OF '¬' IN lv_xml WITH '&#172;'.
    REPLACE ALL OCCURRENCES OF '®' IN lv_xml WITH '&#174;'.
    REPLACE ALL OCCURRENCES OF '¯' IN lv_xml WITH '&#175;'.
    REPLACE ALL OCCURRENCES OF '°' IN lv_xml WITH '&#176;'.
    REPLACE ALL OCCURRENCES OF '±' IN lv_xml WITH '&#177;'.
    REPLACE ALL OCCURRENCES OF '²' IN lv_xml WITH '&#178;'.
    REPLACE ALL OCCURRENCES OF '³' IN lv_xml WITH '&#179;'.
    REPLACE ALL OCCURRENCES OF '´' IN lv_xml WITH '&#180;'.
    REPLACE ALL OCCURRENCES OF 'µ' IN lv_xml WITH '&#181;'.
    REPLACE ALL OCCURRENCES OF '¶' IN lv_xml WITH '&#182;'.
    REPLACE ALL OCCURRENCES OF '·' IN lv_xml WITH '&#183;'.
    REPLACE ALL OCCURRENCES OF '¸' IN lv_xml WITH '&#184;'.
    REPLACE ALL OCCURRENCES OF '¹' IN lv_xml WITH '&#185;'.
    REPLACE ALL OCCURRENCES OF 'º' IN lv_xml WITH '&#186;'.
    REPLACE ALL OCCURRENCES OF '»' IN lv_xml WITH '&#187;'.
    REPLACE ALL OCCURRENCES OF '¼' IN lv_xml WITH '&#188;'.
    REPLACE ALL OCCURRENCES OF '½' IN lv_xml WITH '&#189;'.
    REPLACE ALL OCCURRENCES OF '¾' IN lv_xml WITH '&#190;'.
    REPLACE ALL OCCURRENCES OF '¿' IN lv_xml WITH '&#191;'.
    REPLACE ALL OCCURRENCES OF 'À' IN lv_xml WITH '&#192;'.
    REPLACE ALL OCCURRENCES OF 'Á' IN lv_xml WITH '&#193;'.
    REPLACE ALL OCCURRENCES OF 'Â' IN lv_xml WITH '&#194;'.
    REPLACE ALL OCCURRENCES OF 'Ã' IN lv_xml WITH '&#195;'.
    REPLACE ALL OCCURRENCES OF 'Ä' IN lv_xml WITH '&#196;'.
    REPLACE ALL OCCURRENCES OF 'Å' IN lv_xml WITH '&#197;'.
    REPLACE ALL OCCURRENCES OF 'Æ' IN lv_xml WITH '&#198;'.
    REPLACE ALL OCCURRENCES OF 'Ç' IN lv_xml WITH '&#199;'.
    REPLACE ALL OCCURRENCES OF 'È' IN lv_xml WITH '&#200;'.
    REPLACE ALL OCCURRENCES OF 'É' IN lv_xml WITH '&#201;'.
    REPLACE ALL OCCURRENCES OF 'Ê' IN lv_xml WITH '&#202;'.
    REPLACE ALL OCCURRENCES OF 'Ë' IN lv_xml WITH '&#203;'.
    REPLACE ALL OCCURRENCES OF 'Ì' IN lv_xml WITH '&#204;'.
    REPLACE ALL OCCURRENCES OF 'Í' IN lv_xml WITH '&#205;'.
    REPLACE ALL OCCURRENCES OF 'Î' IN lv_xml WITH '&#206;'.
    REPLACE ALL OCCURRENCES OF 'Ï' IN lv_xml WITH '&#207;'.
    REPLACE ALL OCCURRENCES OF 'Ð' IN lv_xml WITH '&#208;'.
    REPLACE ALL OCCURRENCES OF 'Ñ' IN lv_xml WITH '&#209;'.
    REPLACE ALL OCCURRENCES OF 'Ò' IN lv_xml WITH '&#210;'.
    REPLACE ALL OCCURRENCES OF 'Ó' IN lv_xml WITH '&#211;'.
    REPLACE ALL OCCURRENCES OF 'Ô' IN lv_xml WITH '&#212;'.
    REPLACE ALL OCCURRENCES OF 'Õ' IN lv_xml WITH '&#213;'.
    REPLACE ALL OCCURRENCES OF 'Ö' IN lv_xml WITH '&#214;'.
    REPLACE ALL OCCURRENCES OF '×' IN lv_xml WITH '&#215;'.
    REPLACE ALL OCCURRENCES OF 'Ø' IN lv_xml WITH '&#216;'.
    REPLACE ALL OCCURRENCES OF 'Ù' IN lv_xml WITH '&#217;'.
    REPLACE ALL OCCURRENCES OF 'Ú' IN lv_xml WITH '&#218;'.
    REPLACE ALL OCCURRENCES OF 'Û' IN lv_xml WITH '&#219;'.
    REPLACE ALL OCCURRENCES OF 'Ü' IN lv_xml WITH '&#220;'.
    REPLACE ALL OCCURRENCES OF 'Ý' IN lv_xml WITH '&#221;'.
    REPLACE ALL OCCURRENCES OF 'Þ' IN lv_xml WITH '&#222;'.
    REPLACE ALL OCCURRENCES OF 'ß' IN lv_xml WITH '&#223;'.
    REPLACE ALL OCCURRENCES OF 'à' IN lv_xml WITH '&#224;'.
    REPLACE ALL OCCURRENCES OF 'á' IN lv_xml WITH '&#225;'.
    REPLACE ALL OCCURRENCES OF 'â' IN lv_xml WITH '&#226;'.
    REPLACE ALL OCCURRENCES OF 'ã' IN lv_xml WITH '&#227;'.
    REPLACE ALL OCCURRENCES OF 'ä' IN lv_xml WITH '&#228;'.
    REPLACE ALL OCCURRENCES OF 'å' IN lv_xml WITH '&#229;'.
    REPLACE ALL OCCURRENCES OF 'æ' IN lv_xml WITH '&#230;'.
    REPLACE ALL OCCURRENCES OF 'ç' IN lv_xml WITH '&#231;'.
    REPLACE ALL OCCURRENCES OF 'è' IN lv_xml WITH '&#232;'.
    REPLACE ALL OCCURRENCES OF 'é' IN lv_xml WITH '&#233;'.
    REPLACE ALL OCCURRENCES OF 'ê' IN lv_xml WITH '&#234;'.
    REPLACE ALL OCCURRENCES OF 'ë' IN lv_xml WITH '&#235;'.
    REPLACE ALL OCCURRENCES OF 'ì' IN lv_xml WITH '&#236;'.
    REPLACE ALL OCCURRENCES OF 'í' IN lv_xml WITH '&#237;'.
    REPLACE ALL OCCURRENCES OF 'î' IN lv_xml WITH '&#238;'.
    REPLACE ALL OCCURRENCES OF 'ï' IN lv_xml WITH '&#239;'.
    REPLACE ALL OCCURRENCES OF 'ð' IN lv_xml WITH '&#240;'.
    REPLACE ALL OCCURRENCES OF 'ñ' IN lv_xml WITH '&#241;'.
    REPLACE ALL OCCURRENCES OF 'ò' IN lv_xml WITH '&#242;'.
    REPLACE ALL OCCURRENCES OF 'ó' IN lv_xml WITH '&#243;'.
    REPLACE ALL OCCURRENCES OF 'ô' IN lv_xml WITH '&#244;'.
    REPLACE ALL OCCURRENCES OF 'õ' IN lv_xml WITH '&#245;'.
    REPLACE ALL OCCURRENCES OF 'ö' IN lv_xml WITH '&#246;'.
    REPLACE ALL OCCURRENCES OF '÷' IN lv_xml WITH '&#247;'.
    REPLACE ALL OCCURRENCES OF 'ø' IN lv_xml WITH '&#248;'.
    REPLACE ALL OCCURRENCES OF 'ù' IN lv_xml WITH '&#249;'.
    REPLACE ALL OCCURRENCES OF 'ú' IN lv_xml WITH '&#250;'.
    REPLACE ALL OCCURRENCES OF 'û' IN lv_xml WITH '&#251;'.
    REPLACE ALL OCCURRENCES OF 'ü' IN lv_xml WITH '&#252;'.
    REPLACE ALL OCCURRENCES OF '✓' IN lv_xml WITH 'a'.
    REPLACE ALL OCCURRENCES OF 'ý' IN lv_xml WITH '&#253;'.


    DATA(gv) = 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2' .
    DATA(ls_data_xml) = cl_web_http_utility=>encode_base64( lv_xml ).

    url = |{ gv }|.
    client = create_client( url ).
    req = client->get_http_request(  ).
    req->set_authorization_bearer( access_token ) .

    DATA(ls_body) = VALUE struct( xdp_template = lc_template_name
                                     xml_data = ls_data_xml
                                     form_type = 'print'
                                     form_locale = 'en_US   '
                                     tagged_pdf = '0'
                                     embed_font = '0' ).
    DATA(lv_json) = /ui2/cl_json=>serialize( data = ls_body compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    req->append_text(
              EXPORTING
                data   = lv_json
            ).
    req->set_content_type( 'application/json' ).


    DATA: result9 TYPE string.
*    DATA(result2) = client->execute( if_web_http_client=>post )->get_status( ) .
    result9 = client->execute( if_web_http_client=>post )->get_text( ).



    result12 = result9 .

    FIELD-SYMBOLS:
      <data>                TYPE data,
      <field>               TYPE any,
      <pdf_based64_encoded> TYPE any.
    DATA : lr_d TYPE string .

    DATA(lr_d1) = /ui2/cl_json=>generate( json = result9 ).

    IF lr_d1 IS BOUND.
      ASSIGN lr_d1->* TO <data>.
      ASSIGN COMPONENT `fileContent` OF STRUCTURE <data> TO <field>.
      IF sy-subrc EQ 0.
        ASSIGN <field>->* TO <pdf_based64_encoded>.
        result12 = <pdf_based64_encoded> .
**            out->write( <pdf_based64_encoded> ).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
