
CLASS lcl_generateirn DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS validatedocument
      IMPORTING
        checkdetails TYPE abap_boolean OPTIONAL
      EXPORTING
        rv_is_valid  TYPE abap_bool
        rv_message   TYPE string.

    CLASS-METHODS checkconfigs
      EXPORTING
        rv_is_valid TYPE abap_bool
        rv_message  TYPE string.

    CLASS-METHODS getinstance
      IMPORTING
        !iv_body           TYPE ty_request
      RETURNING
        VALUE(ro_instance) TYPE REF TO lcl_generateirn.

    CLASS-METHODS generatejson
      EXPORTING
        error         TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
    METHODS constructor
      IMPORTING
        !iv_body TYPE ty_request.

    CLASS-METHODS split_addr_line
      IMPORTING
        addr_line TYPE string
      EXPORTING
        part1     TYPE string
        part2     TYPE string.

    CLASS-DATA: mv_companycode TYPE bukrs,
                mv_document    TYPE vbeln,
                lcl_class      TYPE REF TO lcl_generateirn.


ENDCLASS.

CLASS lcl_generateirn IMPLEMENTATION.

  METHOD getinstance.
    IF lcl_class IS NOT BOUND.
      CREATE OBJECT lcl_class
        EXPORTING
          iv_body = iv_body.
    ENDIF.
    ro_instance = lcl_class.
  ENDMETHOD.

  METHOD constructor.
    mv_companycode = iv_body-companycode.
    mv_document    = iv_body-billingdocument.
  ENDMETHOD.

  METHOD checkconfigs.

    SELECT SINGLE FROM zr_table_plant000 AS a
        INNER JOIN i_billingdocumentitem AS b ON a~plantcode = b~plant AND a~compcode = b~companycode
        FIELDS a~gstinno
        WHERE b~companycode = @mv_companycode AND b~billingdocument = @mv_document
        INTO @DATA(plant_gstin).

    IF plant_gstin IS INITIAL.
      rv_message = 'GSTIN not maintained for the plant'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM zr_integration_tab000
        FIELDS intgpath
        WHERE intgmodule = @header_key
        INTO @DATA(header_value).

    IF header_value IS INITIAL.
      rv_message = 'Header Value is not maintained for IRN Generation'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD validatedocument.

    SELECT SINGLE FROM zr_irn
       FIELDS irnstatus, irnno
       WHERE companycode = @mv_companycode
           AND billingdocument = @mv_document
       INTO @DATA(lv_irnstatus).
    rv_is_valid = abap_true.
    IF mv_companycode IS INITIAL OR mv_document IS INITIAL.
      rv_message = 'Company code and document number are required'.
      rv_is_valid = abap_false.
      RETURN.
    ELSEIF sy-subrc <> 0.
      rv_message = 'Document not found'.
      rv_is_valid = abap_false.
      RETURN.
    ENDIF.
    IF checkdetails IS NOT INITIAL.
      IF lv_irnstatus-irnno IS NOT INITIAL.
        rv_message = 'IRN already generated for this document'.
        rv_is_valid = abap_false.
        RETURN.
      ELSEIF lv_irnstatus-irnstatus IS NOT INITIAL.
        rv_message = 'Document is already processed for IRN generation'.
        rv_is_valid = abap_false.
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD generatejson.

    DATA : wa_final TYPE ty_einv_request.
    DATA: it_itemlist TYPE TABLE OF ty_item_list_new,
          wa_itemlist TYPE ty_item_list_new.


************************EXPORT DETAILS************************


**************************    transaction details

    SELECT SINGLE FROM i_billingdocument AS a
        INNER JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
        FIELDS a~distributionchannel, a~billingdocumenttype, a~billingdocumentdate, b~plant,a~companycode, a~documentreferenceid,
               a~billingdocumentiscancelled, a~salesorganization , a~accountingexchangerate
        WHERE a~billingdocument = @mv_document
              AND a~companycode = @mv_companycode
        INTO @DATA(lv_trans_details).

    IF lv_trans_details-salesorganization EQ '1001'.
      wa_final-trandtls-suptyp = 'EXPWOP'.
    ELSE.
      wa_final-trandtls-suptyp = 'B2B'.
    ENDIF.
    wa_final-trandtls-regrev = 'N'.
    wa_final-trandtls-igstonintra = 'N'.


********************************document details

    IF lv_trans_details-billingdocumenttype =  'S1'.
      error = 'S1 billing document type is not supported for IRN generation.'.
      RETURN.
    ELSEIF lv_trans_details-billingdocumenttype =  'JSN' .
      error = 'JSN billing document type is not supported for IRN generation.'.
      RETURN.
    ELSEIF lv_trans_details-billingdocumentiscancelled = 'X'.
      error = 'Billing document is cancelled, IRN generation is not allowed.'.
      RETURN.
    ENDIF.

    IF lv_trans_details-billingdocumenttype = 'F2' OR lv_trans_details-billingdocumenttype = 'JSTO'
      OR lv_trans_details-billingdocumenttype = 'S2'.
      wa_final-docdtls-typ = 'INV'.
    ELSEIF lv_trans_details-billingdocumenttype = 'G2' OR lv_trans_details-billingdocumenttype = 'CBRE'.
      wa_final-docdtls-typ = 'CRN'.
    ELSEIF lv_trans_details-billingdocumenttype = 'L2'.
      wa_final-docdtls-typ = 'DBN'.
    ENDIF.

    wa_final-docdtls-no = lv_trans_details-documentreferenceid.
    wa_final-docdtls-dt = lv_trans_details-billingdocumentdate+6(2) && '/' && lv_trans_details-billingdocumentdate+4(2) && '/' && lv_trans_details-billingdocumentdate(4).


    SELECT SINGLE FROM zr_irn
        FIELDS ewaytranstype, transportername, vehiclenum, grdate, grno, transportergstin, distance, address, place, pincode, state, statecode,
               shipbno , shipbdt , port , refclm , forcur , cntcode , expduty
        WHERE billingdocument = @mv_document
              AND companycode = @mv_companycode
        INTO @DATA(transtype).


    IF transtype-ewaytranstype IS INITIAL.
      transtype-ewaytranstype = 'Regular'.
    ENDIF.

    IF transtype-ewaytranstype = 'Regular' OR transtype-ewaytranstype = 'Bill to-ship to' OR transtype-ewaytranstype = 'Bill from-dispatch from' OR transtype-ewaytranstype = 'Combination'.
***************************************seller detials

      SELECT SINGLE FROM ztable_plant
      FIELDS gstin_no, city, address1, address2, pin, state_code1,plant_name1, state_name, company_name, gsppassword, gspusername
      WHERE plant_code = @lv_trans_details-plant AND comp_code = @lv_trans_details-companycode INTO @DATA(sellerplantaddress) PRIVILEGED ACCESS.

      wa_final-sellerdtls-gstin =  sellerplantaddress-gstin_no.
      wa_final-sellerdtls-lglnm  =  sellerplantaddress-company_name.
      wa_final-sellerdtls-trdnm =  sellerplantaddress-company_name.
      wa_final-sellerdtls-addr1    =  sellerplantaddress-address1.
      wa_final-sellerdtls-addr2    =  sellerplantaddress-address2 .
      wa_final-sellerdtls-loc      =  sellerplantaddress-address2 .
      IF sellerplantaddress-city IS NOT INITIAL.
        wa_final-sellerdtls-loc      =  sellerplantaddress-city .
      ENDIF.
      wa_final-sellerdtls-stcd     =  sellerplantaddress-state_code1.
      wa_final-sellerdtls-pin      =  sellerplantaddress-pin.

      wa_final-einvusername = sellerplantaddress-gspusername.
      wa_final-einvpassword = sellerplantaddress-gsppassword.
      wa_final-gstin =  sellerplantaddress-gstin_no.
      wa_final-getqrimg = '0'.
      wa_final-getsignedinvoice = '1'.

    ENDIF.

    IF transtype-ewaytranstype = 'Regular' OR transtype-ewaytranstype = 'Bill to-ship to' OR transtype-ewaytranstype = 'Bill from-dispatch from' OR transtype-ewaytranstype = 'Combination'.
*******************************    buyer details

      SELECT SINGLE * FROM i_billingdocumentpartner AS a
      INNER JOIN i_customer AS b ON ( a~customer = b~customer  )
      INNER JOIN i_address_2 AS c ON ( b~addressid = c~addressid )
      WHERE a~billingdocument = @mv_document AND a~partnerfunction = 'RE'
      INTO  @DATA(buyeradd) PRIVILEGED ACCESS.

      wa_final-buyerdtls-gstin = buyeradd-b-taxnumber3.
      wa_final-buyerdtls-lglnm = buyeradd-b-customername.
      wa_final-buyerdtls-trdnm = buyeradd-b-customername.
      IF wa_final-buyerdtls-gstin <> ''.
        wa_final-buyerdtls-pos = wa_final-buyerdtls-gstin+0(2).
      ENDIF.

      DATA(buyer_full_addr) = buyeradd-c-housenumber && ' ' && buyeradd-c-streetname && ' ' && buyeradd-c-streetprefixname1 && ' ' && buyeradd-c-streetprefixname2
                                && ' ' && buyeradd-c-streetsuffixname1 && ' ' && buyeradd-c-streetsuffixname2 && ' ' && buyeradd-c-districtname && ' ' && buyeradd-c-villagename.

      split_addr_line(
        EXPORTING
          addr_line = buyer_full_addr
        IMPORTING
          part1     = wa_final-buyerdtls-addr1
          part2     = wa_final-buyerdtls-addr2 ).

      SELECT SINGLE FROM i_regiontext
      FIELDS regionname
      WHERE region = @buyeradd-b-region AND country = @buyeradd-b-country
      INTO @wa_final-buyerdtls-loc.

      wa_final-buyerdtls-pin   = buyeradd-b-postalcode  .
      wa_final-buyerdtls-stcd  = buyeradd-b-taxnumber3+0(2)  .

    ENDIF.

    IF transtype-ewaytranstype = 'Bill to-ship to' OR transtype-ewaytranstype = 'Combination'.


********************************* SHIP TO PARTY *********************
      SELECT SINGLE * FROM i_billingdocitempartner AS a
           INNER JOIN i_customer AS b ON ( a~customer = b~customer  )
           INNER JOIN i_address_2 AS c ON ( b~addressid = c~addressid )
           WHERE a~billingdocument = @mv_document AND a~partnerfunction = 'WE'
           INTO  @DATA(shiptoadd) PRIVILEGED ACCESS.

      wa_final-shipdtls-gstin = COND #( WHEN shiptoadd-b-taxnumber3 IS NOT INITIAL THEN shiptoadd-b-taxnumber3 ELSE 'URP' ).
      wa_final-shipdtls-lglnm = shiptoadd-b-customername.
      wa_final-shipdtls-trdnm = shiptoadd-b-customername.

      DATA(shipper_full_addr) = shiptoadd-c-housenumber && ' ' && shiptoadd-c-streetname && ' ' && shiptoadd-c-streetprefixname1 && ' ' && shiptoadd-c-streetprefixname2
                                && ' ' && shiptoadd-c-streetsuffixname1 && ' ' && shiptoadd-c-streetsuffixname2 && ' ' && shiptoadd-c-districtname && ' ' && shiptoadd-c-villagename.

      split_addr_line(
        EXPORTING
          addr_line = shipper_full_addr
        IMPORTING
          part1     = wa_final-shipdtls-addr1
          part2     = wa_final-shipdtls-addr2 ).

      SELECT SINGLE FROM i_regiontext
       FIELDS regionname
       WHERE region = @shiptoadd-b-region AND country = @shiptoadd-b-country
       INTO @wa_final-shipdtls-loc.
      wa_final-shipdtls-pin   = shiptoadd-b-postalcode  .
      wa_final-shipdtls-stcd  = shiptoadd-b-taxnumber3+0(2)  .

      IF wa_final-shipdtls-gstin = ''.
        IF wa_final-shipdtls-stcd = 'Gujarat'.
          wa_final-shipdtls-stcd = '24'.
        ENDIF.
      ENDIF.

      IF wa_final-trandtls-suptyp = 'EXPWOP'.
        wa_final-expdtls-shipbno = transtype-shipbno.
        wa_final-expdtls-shipbdt = transtype-shipbdt.
        wa_final-expdtls-port = transtype-port.
        wa_final-expdtls-refclm = 'N'.
        wa_final-expdtls-forcur = transtype-forcur  .
        wa_final-expdtls-expduty = transtype-expduty.

        IF buyeradd-b-country IS NOT INITIAL.
          wa_final-expdtls-cntcode = buyeradd-b-country .
        ELSE .
          wa_final-expdtls-cntcode = transtype-cntcode.
        ENDIF.

        wa_final-shipdtls-gstin = 'URP'.
        wa_final-shipdtls-stcd = '96'. "TO be discussed
        IF shiptoadd-b-country = 'IN'.
          wa_final-shipdtls-loc   = shiptoadd-b-cityname .
          wa_final-shipdtls-pin   = shiptoadd-b-postalcode  .
        ELSE.

          SELECT SINGLE FROM i_countrytext
              FIELDS countryshortname
              WHERE country = @shiptoadd-b-country
              INTO @DATA(shipcountry).
          wa_final-shipdtls-loc   = shipcountry .
          wa_final-shipdtls-pin   = '999999'  .
        ENDIF.

        wa_final-buyerdtls-gstin = 'URP'.
        wa_final-buyerdtls-pin   = '999999'  .
        wa_final-buyerdtls-stcd  = '96'  .
        wa_final-buyerdtls-pos = '96'.

        SELECT SINGLE FROM i_countrytext
            FIELDS countryshortname
            WHERE country = @buyeradd-b-country
            INTO @DATA(country).

        wa_final-buyerdtls-loc   = country .

      ENDIF.

    ENDIF.

**********************************************************************HANDLE SHIP TO IN CASE OF EMPTY
    IF wa_final-shipdtls-stcd IS INITIAL.
      wa_final-shipdtls-stcd  = shiptoadd-c-region.
    ENDIF.
***************************ewaybill_details

*    wa_final-ewbdtls-vehno = transtype-vehiclenum .
*    wa_final-ewbdtls-transname = transtype-transportername .
*    wa_final-ewbdtls-transdocdt = transtype-grdate+6(2) && '/' && transtype-grdate+4(2) && '/' && transtype-grdate(4)  .
*    wa_final-ewbdtls-transdocno = transtype-grno .
*    wa_final-ewbdtls-transid = transtype-transportergstin .
*    wa_final-ewbdtls-transmode = '1'.
*    IF transtype-distance = 0.
*      wa_final-ewbdtls-distance = 0.
*    ELSE.
*      wa_final-ewbdtls-distance = transtype-distance.
*    ENDIF.
*    wa_final-ewbdtls-vehtype = 'R'.
*

    IF transtype-ewaytranstype = 'Bill from-dispatch from' OR transtype-ewaytranstype = 'Combination'.



****************************    dispatch details
      IF transtype-address IS NOT INITIAL.
        wa_final-dispdtls-nm    =  transtype-address.

        DATA dispatch_full_addr TYPE string.
        dispatch_full_addr = transtype-place.

        split_addr_line(
          EXPORTING
            addr_line = dispatch_full_addr
          IMPORTING
            part1     = wa_final-dispdtls-addr1
            part2     = wa_final-dispdtls-addr2 ).

        wa_final-dispdtls-loc      =  transtype-state .
        IF wa_final-dispdtls-loc IS INITIAL.
          wa_final-dispdtls-loc      =  sellerplantaddress-city .
        ENDIF.
        wa_final-dispdtls-stcd     =  transtype-statecode.
        wa_final-dispdtls-stcd     =  transtype-state.
        wa_final-dispdtls-pin      =  transtype-pincode.

      ELSE.

        wa_final-dispdtls-nm    =  sellerplantaddress-company_name.
        wa_final-dispdtls-addr1    =  sellerplantaddress-address1.
        wa_final-dispdtls-addr2    =  sellerplantaddress-address2.
        wa_final-dispdtls-loc      =  sellerplantaddress-address2 .
        IF sellerplantaddress-city IS NOT INITIAL.
          wa_final-dispdtls-loc      =  sellerplantaddress-city .
        ENDIF.
        wa_final-dispdtls-stcd     =  sellerplantaddress-state_code1.
        wa_final-dispdtls-stcd     =  sellerplantaddress-state_name.
        wa_final-dispdtls-pin      =  sellerplantaddress-pin.

      ENDIF.

    ENDIF.



    SELECT FROM i_billingdocumentitem
       FIELDS billingdocument, billingdocumentitem, billingdocumentitemtext, product, plant, billingquantity,
              billingquantityunit
       WHERE billingdocument = @mv_document AND companycode = @mv_companycode
       INTO TABLE @DATA(lt_item) PRIVILEGED ACCESS.


    SELECT FROM i_billingdocumentitem AS item
       LEFT JOIN i_productdescription AS pd ON item~product = pd~product AND pd~languageisocode = 'EN'
       LEFT JOIN i_productplantbasic AS c ON item~product = c~product AND item~plant = c~plant
       LEFT JOIN i_product AS d ON item~product = d~product
       FIELDS item~billingdocument, item~billingdocumentitem, item~plant, item~profitcenter, item~product,
              item~billingquantity, item~baseunit, item~billingquantityunit, item~netamount, item~taxamount,
              item~transactioncurrency, item~cancelledbillingdocument, item~billingquantityinbaseunit, pd~productdescription,
              c~consumptiontaxctrlcode, item~companycode, d~producttype
       WHERE item~billingdocument = @mv_document AND consumptiontaxctrlcode IS NOT INITIAL
       INTO TABLE @DATA(ltlines) PRIVILEGED ACCESS.

    SELECT FROM i_billingdocitemprcgelmntbasic
      FIELDS billingdocument , billingdocumentitem, conditionratevalue, conditionamount, conditiontype,
             transactioncurrency AS d_transactioncurrency
      WHERE billingdocument = @mv_document
      INTO TABLE @DATA(it_price).

    LOOP AT ltlines INTO DATA(wa_lines).
      wa_itemlist-slno = wa_lines-billingdocumentitem.
      wa_itemlist-hsncd = wa_lines-consumptiontaxctrlcode.
      wa_itemlist-qty = wa_lines-billingquantity.
      wa_itemlist-prddesc = wa_lines-productdescription.

      REPLACE ALL OCCURRENCES OF '"' IN wa_itemlist-prddesc WITH ' '.

      SELECT SINGLE FROM zr_gstuom000
      FIELDS gstuom
      WHERE uom = @wa_lines-billingquantityunit
      INTO @DATA(uom).

      IF uom IS INITIAL.
        wa_itemlist-unit = wa_lines-billingquantityunit.
      ELSE.
        wa_itemlist-unit = uom.
      ENDIF.

******************         CONDITION TYPES        ***********************************************

***********************         IGST        ***********************************************
      READ TABLE it_price INTO DATA(wa_price1) WITH KEY billingdocument = wa_lines-billingdocument
                                                      billingdocumentitem = wa_lines-billingdocumentitem
                                                      conditiontype = 'JOIG'.
      IF wa_price1 IS NOT INITIAL.
        wa_itemlist-igstamt                      = wa_price1-conditionamount * lv_trans_details-accountingexchangerate.
        wa_itemlist-gstrt                         = wa_price1-conditionratevalue.
        CLEAR wa_price1.
      ELSE.

***********************         SGST        ***********************************************
        READ TABLE it_price INTO DATA(wa_price2) WITH KEY billingdocument = wa_lines-billingdocument
                                                             billingdocumentitem = wa_lines-billingdocumentitem
                                                             conditiontype = 'JOSG'.
        IF wa_price2 IS INITIAL.
          READ TABLE it_price INTO DATA(wa_price9) WITH KEY billingdocument = wa_lines-billingdocument
                                                            billingdocumentitem = wa_lines-billingdocumentitem
                                                            conditiontype = 'JOUG'.
          wa_itemlist-sgstamt                    = wa_price9-conditionamount * lv_trans_details-accountingexchangerate .
        ELSE.
          wa_itemlist-sgstamt                    = wa_price2-conditionamount * lv_trans_details-accountingexchangerate .
        ENDIF.

***********************         CGST        ***********************************************
        READ TABLE it_price INTO DATA(wa_price3) WITH KEY billingdocument = wa_lines-billingdocument
                                                            billingdocumentitem = wa_lines-billingdocumentitem
                                                            conditiontype = 'JOCG'.
        wa_itemlist-cgstamt                      = wa_price3-conditionamount * lv_trans_details-accountingexchangerate .
        wa_itemlist-gstrt                         = wa_price3-conditionratevalue + wa_price2-conditionratevalue.
        CLEAR : wa_price2,wa_price3.
      ENDIF.
      DATA tcsamt TYPE p DECIMALS 2.
      SELECT FROM i_billingdocumentitemprcgelmnt AS a
       FIELDS SUM( a~conditionamount ) AS conditionamount
       WHERE  conditiontype IN ( 'JTC1','JTC2','JTC3', 'ZTCS' ) AND billingdocument = @wa_lines-billingdocument
               AND billingdocumentitem = @wa_lines-billingdocumentitem
       INTO @DATA(tcs) .

      IF tcs IS NOT INITIAL .
        tcsamt = tcs * lv_trans_details-accountingexchangerate .
      ENDIF.


***********************         DISCOUNT        ***********************************************

      SELECT SUM( conditionamount )
          FROM i_billingdocumentitemprcgelmnt
          WHERE conditiontype IN (  'ZDM1','ZDIS','ZRAB','D100', 'ZMDP' ) AND billingdocument = @wa_lines-billingdocument
                AND billingdocumentitem = @wa_lines-billingdocumentitem
          INTO @DATA(discount) .
      IF discount < 0.
        wa_itemlist-discount                           =      discount * -1.
      ELSE.
        wa_itemlist-discount                     =      discount.
      ENDIF.

***********************         FOC        ***********************************************
      READ TABLE it_price INTO DATA(wa_price_foc) WITH KEY billingdocument = wa_lines-billingdocument
                                                          billingdocumentitem = wa_lines-billingdocumentitem
                                                          conditiontype = 'ZFST'.
      IF wa_price_foc IS NOT INITIAL.
        wa_itemlist-discount = 0.
        discount = 0.
      ENDIF.



*******************        BASE PRICE        ***********************************************

      SELECT FROM i_billingdocumentitemprcgelmnt AS a
      FIELDS SUM( a~conditionrateamount ) AS unitprice, SUM( a~conditionamount ) AS totamt,
             COUNT( conditiontype ) AS datacount
       WHERE conditiontype IN ( 'ZBSV' ) AND billingdocument = @wa_lines-billingdocument
             AND billingdocumentitem = @wa_lines-billingdocumentitem
        INTO @DATA(unitprice) .


      SELECT FROM i_billingdocumentitemprcgelmnt AS a
      FIELDS SUM( a~conditionrateamount ) AS unitprice, SUM( a~conditionamount ) AS totamt,
             COUNT( conditiontype ) AS datacount
       WHERE conditiontype IN ( 'ZASS', 'ZEXF' ) AND billingdocument = @wa_lines-billingdocument
             AND billingdocumentitem = @wa_lines-billingdocumentitem
        INTO @DATA(lt_assamt) .


      IF unitprice-unitprice IS NOT INITIAL.
        wa_itemlist-unitprice = unitprice-unitprice * lv_trans_details-accountingexchangerate.
        wa_itemlist-totamt = unitprice-totamt * lv_trans_details-accountingexchangerate.
      ELSE.

        SELECT SINGLE FROM i_billingdocumentitemprcgelmnt AS a
           FIELDS  a~conditionrateamount  AS unitprice, a~conditionamount  AS totamt
           WHERE conditiontype IN ( 'ZPR1', 'ZPR2', 'ZPR0', 'ZPEX' ) AND billingdocument = @wa_lines-billingdocument
                 AND billingdocumentitem = @wa_lines-billingdocumentitem
         INTO @DATA(unitprice2) .

        wa_itemlist-unitprice = unitprice2-unitprice * lv_trans_details-accountingexchangerate.

        IF wa_itemlist-qty IS NOT INITIAL.
          wa_itemlist-totamt = unitprice2-totamt * lv_trans_details-accountingexchangerate.
        ELSE.
          wa_itemlist-totamt = '0'.
        ENDIF.


      ENDIF.

      wa_itemlist-othchrg = tcsamt.
      IF lt_assamt IS NOT INITIAL.
        wa_itemlist-assamt = lt_assamt-totamt * lv_trans_details-accountingexchangerate.
        wa_itemlist-totamt = ( lt_assamt-totamt + wa_itemlist-discount ) * lv_trans_details-accountingexchangerate.
      ELSE.
        wa_itemlist-assamt = ( wa_itemlist-totamt - wa_itemlist-discount ) * lv_trans_details-accountingexchangerate.
      ENDIF.


*      Tax Exempt
*      SELECT SINGLE FROM i_billingdocumentitemprcgelmnt AS a
*               FIELDS  a~conditionrateamount  AS unitprice, a~conditionamount  AS totamt
*               WHERE conditiontype IN ( 'ZOIG' ) AND billingdocument = @wa_lines-billingdocument
*                     AND billingdocumentitem = @wa_lines-billingdocumentitem
*             INTO @DATA(exempt) .
*      IF exempt IS NOT INITIAL.
*        wa_itemlist-igstamt = '0'.
*        wa_itemlist-cgstamt = '0'.
*        wa_itemlist-sgstamt = '0'.
*        wa_itemlist-gstrt = '0'.
*      ENDIF.


      IF wa_itemlist-cgstamt IS INITIAL.
        wa_itemlist-cgstamt = '0'.
      ENDIF.
      IF wa_itemlist-sgstamt IS INITIAL.
        wa_itemlist-sgstamt = '0'.
      ENDIF.
      IF wa_itemlist-igstamt IS INITIAL.
        wa_itemlist-igstamt = '0'.
      ENDIF.
      IF wa_itemlist-othchrg IS INITIAL.
        wa_itemlist-othchrg = '0'.
      ENDIF.
      IF wa_itemlist-cesnonadlvlamt IS INITIAL.
        wa_itemlist-cesnonadlvlamt = '0'.
      ENDIF.


******************         ROUND-OFF        ***********************************************
      READ TABLE it_price INTO DATA(wa_price4) WITH KEY billingdocument = wa_lines-billingdocument
                                                        billingdocumentitem = wa_lines-billingdocumentitem
*                                                        conditiontype = 'DRD1'.
                                                        conditiontype = 'ZDIF'.




****************         OVERALL VALUES        ***********************************************
      wa_final-valdtls-rndoffamt += wa_price4-conditionamount .

      wa_itemlist-totitemval          += wa_itemlist-assamt + ( wa_price4-conditionamount * lv_trans_details-accountingexchangerate ) +
                                         wa_itemlist-igstamt + wa_itemlist-cgstamt +
                                         wa_itemlist-sgstamt + wa_itemlist-othchrg.
      wa_final-valdtls-assval         += wa_itemlist-assamt.
      wa_final-valdtls-sgstval        += wa_itemlist-sgstamt .
      wa_final-valdtls-cgstval        += wa_itemlist-cgstamt .
      wa_final-valdtls-igstval        += wa_itemlist-igstamt .
      wa_final-valdtls-totinvval      += wa_itemlist-totitemval .

      IF wa_lines-producttype = 'ZSRV'.
        wa_itemlist-isservc = 'Y'.
      ELSE.
        wa_itemlist-isservc = 'N'.
      ENDIF.

      APPEND wa_itemlist TO it_itemlist.
      CLEAR :  wa_itemlist ,tcsamt,discount, wa_price_foc.
    ENDLOOP.

    IF wa_final-trandtls-suptyp EQ 'EXPWOP' AND NOT (  wa_final-valdtls-cgstval IS INITIAL AND wa_final-valdtls-igstval IS INITIAL ).
      wa_final-trandtls-suptyp = 'EXPWP'.
    ENDIF.

    SELECT SINGLE FROM zr_integration_tab000
    FIELDS intgpath
    WHERE intgmodule = 'IRN-EFUNAME-EFPASS-CDKEY'
    INTO @DATA(efusercreds).

    SPLIT efusercreds AT '/' INTO wa_final-efusername wa_final-efpassword wa_final-cdkey.

    wa_final-itemlist = it_itemlist.

    DATA:json TYPE REF TO if_xco_cp_json_data.

    xco_cp_json=>data->from_abap(
      EXPORTING
        ia_abap      = wa_final
      RECEIVING
        ro_json_data = json   ).
    json->to_string(
      RECEIVING
        rv_string =   DATA(lv_string) ).

    REPLACE ALL OCCURRENCES OF '"TRANSACTION"' IN lv_string WITH '"transaction"'.
    REPLACE ALL OCCURRENCES OF '"VERSION"' IN lv_string WITH '"Version"'.
    REPLACE ALL OCCURRENCES OF '"TRANSACTION_DETAILS"' IN lv_string WITH '"TranDtls"'.
    REPLACE ALL OCCURRENCES OF '"SUPPLY_TYPE"' IN lv_string WITH '"SupTyp"'.
    REPLACE ALL OCCURRENCES OF '"TAX_SCH"' IN lv_string WITH '"TaxSch"'.
    REPLACE ALL OCCURRENCES OF '"REG_REV"' IN lv_string WITH '"RegRev"'.
    REPLACE ALL OCCURRENCES OF '"IGSTONINTRA"' IN lv_string WITH '"IgstOnIntra"'.
    REPLACE ALL OCCURRENCES OF '"ECOMMERCE_GSTIN":""' IN lv_string WITH '"EcmGstin":null'.

    REPLACE ALL OCCURRENCES OF '"DOCUMENT_DETAILS"' IN lv_string WITH '"DocDtls"'.
    REPLACE ALL OCCURRENCES OF '"DOCUMENT_TYPE"' IN lv_string WITH '"Typ"'.
    REPLACE ALL OCCURRENCES OF '"DOCUMENT_NUMBER"' IN lv_string WITH '"No"'.
    REPLACE ALL OCCURRENCES OF '"DOCUMENT_DATE"' IN lv_string WITH '"Dt"'.

    REPLACE ALL OCCURRENCES OF '"SELLER_DETAILS"' IN lv_string WITH '"SellerDtls"'.
    REPLACE ALL OCCURRENCES OF '"GSTIN"' IN lv_string WITH '"Gstin"'.
    REPLACE ALL OCCURRENCES OF '"LEGAL_NAME"' IN lv_string WITH '"LglNm"'.
    REPLACE ALL OCCURRENCES OF '"TRADE_NAME"' IN lv_string WITH '"TrdNm"'.
    REPLACE ALL OCCURRENCES OF '"ADDRESS1"' IN lv_string WITH '"Addr1"'.
    REPLACE ALL OCCURRENCES OF '"ADDRESS2":"",' IN lv_string WITH ''.
    REPLACE ALL OCCURRENCES OF '"ADDRESS2"' IN lv_string WITH '"Addr2"'.
    REPLACE ALL OCCURRENCES OF '"LOCATION"' IN lv_string WITH '"Loc"'.
    REPLACE ALL OCCURRENCES OF '"PINCODE"' IN lv_string WITH '"Pin"'.
    REPLACE ALL OCCURRENCES OF '"STATE_CODE"' IN lv_string WITH '"Stcd"'.
    REPLACE ALL OCCURRENCES OF '"STATE"' IN lv_string WITH '"State"'.

    REPLACE ALL OCCURRENCES OF '"BUYER_DETAILS"' IN lv_string WITH '"BuyerDtls"'.
    REPLACE ALL OCCURRENCES OF '"PLACE_OF_SUPPLY"' IN lv_string WITH '"Pos"'.

    REPLACE ALL OCCURRENCES OF '"DISPATCH_DETAILS"' IN lv_string WITH '"DispDtls"'.
    REPLACE ALL OCCURRENCES OF '"NAME"' IN lv_string WITH '"Nm"'.

    REPLACE ALL OCCURRENCES OF '"SHIP_DETAILS"' IN lv_string WITH '"ShipDtls"'.


    IF wa_final-shipdtls-lglnm = ''.
      REPLACE ALL OCCURRENCES OF '"ShipDtls":{"Gstin":"","LglNm":"","TrdNm":"","Addr1":"","Loc":"","Pin":"","Stcd":"","State":""}' IN lv_string WITH '"ShipDtls":null'.
    ENDIF.

    IF wa_final-expdtls-shipbno EQ ''.
      REPLACE ALL OCCURRENCES OF '"EXPORT_DETAILS":{"SHIPPING_BILLNO":"","SHIPPING_BILLDATE":"","PORT":"","REFUND_CLAIM":"","FOREIGN_CURRENCY":"","COUNTRY_CODE":"","EXPORT_DUTY":""}' IN lv_string WITH '"ExpDtls":null'.

    ELSE.
      REPLACE ALL OCCURRENCES OF '"EXPORT_DETAILS"' IN lv_string WITH '"ExpDtls"'.
      REPLACE ALL OCCURRENCES OF '"SHIPPING_BILLNO"' IN lv_string WITH '"ShipBNo"'.
      REPLACE ALL OCCURRENCES OF '"SHIPPING_BILLDATE"' IN lv_string WITH '"ShipBDt"'.
      REPLACE ALL OCCURRENCES OF '"PORT"' IN lv_string WITH '"Port"'.
      REPLACE ALL OCCURRENCES OF '"REFUND_CLAIM"' IN lv_string WITH '"RefClm"'.
      REPLACE ALL OCCURRENCES OF '"FOREIGN_CURRENCY"' IN lv_string WITH '"ForCur"'.
      REPLACE ALL OCCURRENCES OF '"COUNTRY_CODE"' IN lv_string WITH '"CntCode"'.
      REPLACE ALL OCCURRENCES OF '"EXPORT_DUTY"' IN lv_string WITH '"ExpDuty"'.
    ENDIF.



    " --- Root & Authentication ---
    REPLACE ALL OCCURRENCES OF '"CDKEY"'             IN lv_string WITH '"CDKey"'.
    REPLACE ALL OCCURRENCES OF '"EINVUSERNAME"'      IN lv_string WITH '"EInvUserName"'.
    REPLACE ALL OCCURRENCES OF '"EINVPASSWORD"'      IN lv_string WITH '"EInvPassword"'.
    REPLACE ALL OCCURRENCES OF '"EFUSERNAME"'        IN lv_string WITH '"EFUserName"'.
    REPLACE ALL OCCURRENCES OF '"EFPASSWORD"'        IN lv_string WITH '"EFPassword"'.
    REPLACE ALL OCCURRENCES OF '"GSTIN"'             IN lv_string WITH '"GSTIN"'.
    REPLACE ALL OCCURRENCES OF '"GETQRIMG"'          IN lv_string WITH '"GetQRImg"'.
    REPLACE ALL OCCURRENCES OF '"GETSIGNEDINVOICE"'   IN lv_string WITH '"GetSignedInvoice"'.

    " --- Transaction Details (TranDtls) ---
    REPLACE ALL OCCURRENCES OF '"TRANDTLS"'          IN lv_string WITH '"TranDtls"'.
    REPLACE ALL OCCURRENCES OF '"SUPTYP"'            IN lv_string WITH '"SupTyp"'.
    REPLACE ALL OCCURRENCES OF '"REGREV"'            IN lv_string WITH '"RegRev"'.
    REPLACE ALL OCCURRENCES OF '"ECMGSTIN"'          IN lv_string WITH '"EcmGstin"'.
    REPLACE ALL OCCURRENCES OF '"IGSTONINTRA"'       IN lv_string WITH '"IgstOnIntra"'.

    " --- Document Details (DocDtls) ---
    REPLACE ALL OCCURRENCES OF '"DOCDTLS"'           IN lv_string WITH '"DocDtls"'.
    REPLACE ALL OCCURRENCES OF '"TYP"'               IN lv_string WITH '"Typ"'.
    REPLACE ALL OCCURRENCES OF '"NO"'                IN lv_string WITH '"No"'.
    REPLACE ALL OCCURRENCES OF '"DT"'                IN lv_string WITH '"Dt"'.

    " --- Seller Details (SellerDtls) ---
    REPLACE ALL OCCURRENCES OF '"SELLERDTLS"'        IN lv_string WITH '"SellerDtls"'.
    REPLACE ALL OCCURRENCES OF '"LGLNM"'             IN lv_string WITH '"LglNm"'.
    REPLACE ALL OCCURRENCES OF '"TRDNM"'             IN lv_string WITH '"TrdNm"'.
    REPLACE ALL OCCURRENCES OF '"ADDR1"'             IN lv_string WITH '"Addr1"'.
    REPLACE ALL OCCURRENCES OF '"ADDR2"'             IN lv_string WITH '"Addr2"'.
    REPLACE ALL OCCURRENCES OF '"LOC"'               IN lv_string WITH '"Loc"'.
    REPLACE ALL OCCURRENCES OF '"PIN"'               IN lv_string WITH '"Pin"'.
    REPLACE ALL OCCURRENCES OF '"STCD"'              IN lv_string WITH '"Stcd"'.
    REPLACE ALL OCCURRENCES OF '"PH"'                IN lv_string WITH '"Ph"'.
    REPLACE ALL OCCURRENCES OF '"EM"'                IN lv_string WITH '"Em"'.

    " --- Buyer / Dispatch / Ship Details ---
    REPLACE ALL OCCURRENCES OF '"BUYERDTLS"'         IN lv_string WITH '"BuyerDtls"'.
    REPLACE ALL OCCURRENCES OF '"POS"'               IN lv_string WITH '"Pos"'.
    REPLACE ALL OCCURRENCES OF '"DISPDTLS"'          IN lv_string WITH '"DispDtls"'.
    REPLACE ALL OCCURRENCES OF '"NM"'                IN lv_string WITH '"Nm"'.
    REPLACE ALL OCCURRENCES OF '"SHIPDTLS"'          IN lv_string WITH '"ShipDtls"'.

    " --- Item List (ItemList) ---
    REPLACE ALL OCCURRENCES OF '"ITEMLIST"'          IN lv_string WITH '"ItemList"'.
    REPLACE ALL OCCURRENCES OF '"ITEM_SERIAL_NUMBER"'     IN lv_string WITH '"SlNo"'.
    REPLACE ALL OCCURRENCES OF '"SLNO"'              IN lv_string WITH '"SlNo"'.
    REPLACE ALL OCCURRENCES OF '"PRDDESC"'           IN lv_string WITH '"PrdDesc"'.
    REPLACE ALL OCCURRENCES OF '"ISSERVC"'           IN lv_string WITH '"IsServc"'.
    REPLACE ALL OCCURRENCES OF '"HSNCD"'             IN lv_string WITH '"HsnCd"'.
    REPLACE ALL OCCURRENCES OF '"BARCDE"'            IN lv_string WITH '"Barcde"'.
    REPLACE ALL OCCURRENCES OF '"QTY"'               IN lv_string WITH '"Qty"'.
    REPLACE ALL OCCURRENCES OF '"FREEQTY"'           IN lv_string WITH '"FreeQty"'.
    REPLACE ALL OCCURRENCES OF '"UNIT"'              IN lv_string WITH '"Unit"'.
    REPLACE ALL OCCURRENCES OF '"UNITPRICE"'         IN lv_string WITH '"UnitPrice"'.
    REPLACE ALL OCCURRENCES OF '"TOTAMT"'            IN lv_string WITH '"TotAmt"'.
    REPLACE ALL OCCURRENCES OF '"DISCOUNT"'          IN lv_string WITH '"Discount"'.
    REPLACE ALL OCCURRENCES OF '"PRETAXVAL"'         IN lv_string WITH '"PreTaxVal"'.
    REPLACE ALL OCCURRENCES OF '"ASSAMT"'            IN lv_string WITH '"AssAmt"'.
    REPLACE ALL OCCURRENCES OF '"GSTRT"'             IN lv_string WITH '"GstRt"'.
    REPLACE ALL OCCURRENCES OF '"IGSTAMT"'           IN lv_string WITH '"IgstAmt"'.
    REPLACE ALL OCCURRENCES OF '"CGSTAMT"'           IN lv_string WITH '"CgstAmt"'.
    REPLACE ALL OCCURRENCES OF '"SGSTAMT"'           IN lv_string WITH '"SgstAmt"'.
    REPLACE ALL OCCURRENCES OF '"CESRT"'             IN lv_string WITH '"CesRt"'.
    REPLACE ALL OCCURRENCES OF '"CESAMT"'            IN lv_string WITH '"CesAmt"'.
    REPLACE ALL OCCURRENCES OF '"CESNONADLVLAMT"'    IN lv_string WITH '"CesNonAdvlAmt"'.
    REPLACE ALL OCCURRENCES OF '"STATECESRT"'        IN lv_string WITH '"StateCesRt"'.
    REPLACE ALL OCCURRENCES OF '"STATECESAMT"'       IN lv_string WITH '"StateCesAmt"'.
    REPLACE ALL OCCURRENCES OF '"STATECESNONADLVLAMT"' IN lv_string WITH '"StateCesNonAdvlAmt"'.
    REPLACE ALL OCCURRENCES OF '"OTHCHRG"'           IN lv_string WITH '"OthChrg"'.
    REPLACE ALL OCCURRENCES OF '"TOTITEMVAL"'        IN lv_string WITH '"TotItemVal"'.
    REPLACE ALL OCCURRENCES OF '"ORDLINEREF"'        IN lv_string WITH '"OrdLineRef"'.
    REPLACE ALL OCCURRENCES OF '"ORGCNTRY"'          IN lv_string WITH '"OrgCntry"'.
    REPLACE ALL OCCURRENCES OF '"PRDSLNO"'           IN lv_string WITH '"PrdSlNo"'.

    " --- Item Batch & Attributes ---
    REPLACE ALL OCCURRENCES OF '"BCHDTLS"'           IN lv_string WITH '"BchDtls"'.
    REPLACE ALL OCCURRENCES OF '"EXPDT"'             IN lv_string WITH '"ExpDt"'.
    REPLACE ALL OCCURRENCES OF '"WRDT"'              IN lv_string WITH '"WrDt"'.
    REPLACE ALL OCCURRENCES OF '"ATTRIBDTLS"'        IN lv_string WITH '"AttribDtls"'.

    " --- Value Details (ValDtls) ---
    REPLACE ALL OCCURRENCES OF '"VALDTLS"'           IN lv_string WITH '"ValDtls"'.
    REPLACE ALL OCCURRENCES OF '"ASSVAL"'            IN lv_string WITH '"AssVal"'.
    REPLACE ALL OCCURRENCES OF '"CGSTVAL"'           IN lv_string WITH '"CgstVal"'.
    REPLACE ALL OCCURRENCES OF '"SGSTVAL"'           IN lv_string WITH '"SgstVal"'.
    REPLACE ALL OCCURRENCES OF '"IGSTVAL"'           IN lv_string WITH '"IgstVal"'.
    REPLACE ALL OCCURRENCES OF '"CESVAL"'            IN lv_string WITH '"CesVal"'.
    REPLACE ALL OCCURRENCES OF '"STCESVAL"'          IN lv_string WITH '"StCesVal"'.
    REPLACE ALL OCCURRENCES OF '"RNDOFFAMT"'         IN lv_string WITH '"RndOffAmt"'.
    REPLACE ALL OCCURRENCES OF '"TOTINVVAL"'         IN lv_string WITH '"TotInvVal"'.
    REPLACE ALL OCCURRENCES OF '"TOTINVVALFC"'       IN lv_string WITH '"TotInvValFc"'.

    " --- Payment Details (PayDtls) ---
    REPLACE ALL OCCURRENCES OF '"PAYDTLS"'           IN lv_string WITH '"PayDtls"'.
    REPLACE ALL OCCURRENCES OF '"ACCDET"'            IN lv_string WITH '"Accdet"'.
    REPLACE ALL OCCURRENCES OF '"MODE"'              IN lv_string WITH '"Mode"'.
    REPLACE ALL OCCURRENCES OF '"FININSBR"'          IN lv_string WITH '"Fininsbr"'.
    REPLACE ALL OCCURRENCES OF '"PAYTERM"'           IN lv_string WITH '"Payterm"'.
    REPLACE ALL OCCURRENCES OF '"PAYINSTR"'          IN lv_string WITH '"Payinstr"'.
    REPLACE ALL OCCURRENCES OF '"CRTRN"'             IN lv_string WITH '"Crtrn"'.
    REPLACE ALL OCCURRENCES OF '"DIRDR"'             IN lv_string WITH '"Dirdr"'.
    REPLACE ALL OCCURRENCES OF '"CRDAY"'             IN lv_string WITH '"Crday"'.
    REPLACE ALL OCCURRENCES OF '"PAIDAMT"'           IN lv_string WITH '"Paidamt"'.
    REPLACE ALL OCCURRENCES OF '"PAYMTDUE"'          IN lv_string WITH '"Paymtdue"'.

    " --- Reference Details (RefDtls) ---
    REPLACE ALL OCCURRENCES OF '"REFDTLS"'           IN lv_string WITH '"RefDtls"'.
    REPLACE ALL OCCURRENCES OF '"INVRM"'             IN lv_string WITH '"InvRm"'.
    REPLACE ALL OCCURRENCES OF '"DOCPERDDTLS"'       IN lv_string WITH '"DocPerdDtls"'.
    REPLACE ALL OCCURRENCES OF '"INVSTDT"'           IN lv_string WITH '"InvStDt"'.
    REPLACE ALL OCCURRENCES OF '"INVENDDT"'          IN lv_string WITH '"InvEndDt"'.
    REPLACE ALL OCCURRENCES OF '"PRECDOCDTLS"'       IN lv_string WITH '"PrecDocDtls"'.
    REPLACE ALL OCCURRENCES OF '"CONTRDTLS"'         IN lv_string WITH '"ContrDtls"'.

    " --- Export & E-Way Bill Details ---
    REPLACE ALL OCCURRENCES OF '"EXPDTLS"'           IN lv_string WITH '"ExpDtls"'.
    REPLACE ALL OCCURRENCES OF '"SHIPBNO"'           IN lv_string WITH '"ShipBNo"'.
    REPLACE ALL OCCURRENCES OF '"SHIPBDT"'           IN lv_string WITH '"ShipBDt"'.
    REPLACE ALL OCCURRENCES OF '"PORT"'               IN lv_string WITH '"Port"'.
    REPLACE ALL OCCURRENCES OF '"REFCLM"'            IN lv_string WITH '"RefClm"'.
    REPLACE ALL OCCURRENCES OF '"FORCUR"'            IN lv_string WITH '"ForCur"'.
    REPLACE ALL OCCURRENCES OF '"CNTCODE"'           IN lv_string WITH '"CntCode"'.
    REPLACE ALL OCCURRENCES OF '"EXPDUTY"'           IN lv_string WITH '"ExpDuty"'.
    REPLACE ALL OCCURRENCES OF '"EWBDTLS"'           IN lv_string WITH '"EwbDtls"'.
    REPLACE ALL OCCURRENCES OF '"TRANSID"'           IN lv_string WITH '"TransId"'.
    REPLACE ALL OCCURRENCES OF '"TRANSNAME"'         IN lv_string WITH '"TransName"'.
    REPLACE ALL OCCURRENCES OF '"DISTANCE"'          IN lv_string WITH '"Distance"'.
    REPLACE ALL OCCURRENCES OF '"TRANSDOCNO"'        IN lv_string WITH '"TransDocNo"'.
    REPLACE ALL OCCURRENCES OF '"TRANSDOCDT"'        IN lv_string WITH '"TransDocDt"'.
    REPLACE ALL OCCURRENCES OF '"VEHNO"'             IN lv_string WITH '"VehNo"'.
    REPLACE ALL OCCURRENCES OF '"VEHTYPE"'           IN lv_string WITH '"VehType"'.
    REPLACE ALL OCCURRENCES OF '"TRANSMODE"'         IN lv_string WITH '"TransMode"'.
    REPLACE ALL OCCURRENCES OF '"EwbDtls":""'         IN lv_string WITH '"EwbDtls":null'.
    REPLACE ALL OCCURRENCES OF '"ExpDtls":{"ShipBNo":"","ShipBDt":"","Port":"","RefClm":"","ForCur":"","CntCode":"","ExpDuty":""}'
                    IN lv_string WITH '"ExpDtls":null'.
    REPLACE ALL OCCURRENCES OF '"PayDtls":"","RefDtls":"","AddlDocDtls":""' IN lv_string WITH  '"PayDtls":null,"RefDtls":null,"AddlDocDtls":null'.
    REPLACE ALL OCCURRENCES OF '"BchDtls":"","AttribDtls":""' IN lv_string WITH  '"BchDtls":null,"AttribDtls":null'.
    REPLACE ALL OCCURRENCES OF '"DispDtls":{"Nm":"","Addr1":"","Addr2":"","Loc":"","Pin":"","Stcd":""}' IN lv_string WITH  '"DispDtls":null'.
    REPLACE ALL OCCURRENCES OF '"ShipDtls":{"Gstin":"","LglNm":"","TrdNm":"","Addr1":"","Addr2":"","Loc":"","Pin":"","Stcd":""}' IN lv_string WITH  '"ShipDtls":null'.

    " --- Additional Documents ---
    REPLACE ALL OCCURRENCES OF '"ADDLDOCDTLS"'       IN lv_string WITH '"AddlDocDtls"'.

    result = lv_string .

  ENDMETHOD.


  METHOD split_addr_line.
    DATA: lt_words    TYPE STANDARD TABLE OF string WITH EMPTY KEY,
          lv_word     TYPE string,
          part2_start TYPE abap_boolean.


    SPLIT addr_line AT space INTO TABLE lt_words.
    DATA(counter) = 1.
    part2_start = abap_false.
    LOOP AT lt_words INTO lv_word.

      IF ( part2_start = 'X' ) OR ( strlen( part1 ) >= 90 ) OR ( strlen( lv_word ) + strlen( part1 ) > 98 )  OR ( lines( lt_words ) - 2 < counter AND lines( lt_words ) > 2 ).
        CONCATENATE part2 lv_word INTO part2 SEPARATED BY space.
        part2_start = abap_true.
      ELSE.
        CONCATENATE part1 lv_word INTO part1 SEPARATED BY space.
      ENDIF.

      counter += 1.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
