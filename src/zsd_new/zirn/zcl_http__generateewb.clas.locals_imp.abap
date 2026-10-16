*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_generateewb DEFINITION CREATE PRIVATE.

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
        VALUE(ro_instance) TYPE REF TO lcl_generateewb.

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
                lcl_class      TYPE REF TO lcl_generateewb.


ENDCLASS.

CLASS lcl_generateewb IMPLEMENTATION.

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


  ENDMETHOD.

  METHOD validatedocument.

    SELECT SINGLE FROM zr_irn
       FIELDS ewaystatus, ewaybillno
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
      IF lv_irnstatus-ewaybillno IS NOT INITIAL.
        rv_message = 'EWB already generated for this document'.
        rv_is_valid = abap_false.
        RETURN.
      ELSEIF lv_irnstatus-ewaystatus IS NOT INITIAL.
        rv_message = 'Document is already processed for EWB generation'.
        rv_is_valid = abap_false.
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD generatejson.

    DATA: wa_final    TYPE ty_main_document,
          wa_itemlist TYPE ty_item_list,
          itemlist    TYPE TABLE OF ty_item_list.

    SELECT SINGLE FROM i_billingdocument AS a
       INNER JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
       FIELDS a~billingdocument, a~billingdocumenttype, a~billingdocumentdate, a~payerparty, b~plant,a~companycode,
              a~documentreferenceid
       WHERE a~billingdocument = @mv_document AND a~companycode = @mv_companycode
       INTO @DATA(lv_document_details) PRIVILEGED ACCESS.


    wa_final-documentnumber = lv_document_details-documentreferenceid.
    wa_final-documentdate = lv_document_details-billingdocumentdate+6(2) && '/' && lv_document_details-billingdocumentdate+4(2) && '/' && lv_document_details-billingdocumentdate(4).

    wa_final-supplytype = 'O'.
    IF lv_document_details-billingdocumenttype = 'JDC' OR lv_document_details-billingdocumenttype = 'JSN' OR lv_document_details-billingdocumenttype = 'JVR'
       OR lv_document_details-billingdocumenttype = 'JSP' OR lv_document_details-billingdocumenttype = 'JSTO'.
      wa_final-subsupplytype = '5'.
      wa_final-documenttype = 'CHL'.
    ELSE.
      wa_final-subsupplytype = '1'.
      wa_final-documenttype = 'INV'.
    ENDIF.


*   ***********************************seller detials

    SELECT SINGLE FROM zr_table_plant000
    FIELDS gstinno, city, address1, address2, pin, statecode1, plantname1, statename, companyname
    WHERE plantcode = @lv_document_details-plant AND compcode = @lv_document_details-companycode INTO @DATA(sellerplantaddress) PRIVILEGED ACCESS.

    wa_final-sellerdtls-gstin       =  sellerplantaddress-gstinno.
    wa_final-sellerdtls-lglnm       =  sellerplantaddress-companyname.
    wa_final-sellerdtls-trdnm       =  sellerplantaddress-companyname.
    wa_final-sellerdtls-addr1       =  sellerplantaddress-address1.
    wa_final-sellerdtls-addr2       =  sellerplantaddress-address2 .
    wa_final-sellerdtls-loc         =  sellerplantaddress-address2 .
    IF sellerplantaddress-city IS NOT INITIAL.
      wa_final-sellerdtls-loc       =  sellerplantaddress-city .
    ENDIF.
    wa_final-sellerdtls-stcd        =  sellerplantaddress-statecode1.
    wa_final-sellerdtls-pin         =  sellerplantaddress-pin.



*******************************    buyer details
    SELECT SINGLE FROM i_billingdocumentpartner AS a
            INNER JOIN i_customer AS b ON ( a~customer = b~customer  )
            INNER JOIN i_businesspartner AS d ON ( b~customer = d~businesspartner )
            INNER JOIN i_address_2 AS c ON ( b~addressid = c~addressid )
            FIELDS a~*,b~*,c~*,d~businesspartnergrouping
                WHERE a~billingdocument = @mv_document
                AND a~partnerfunction = 'RE' INTO  @DATA(buyeradd)
                    PRIVILEGED ACCESS.

    IF buyeradd-businesspartnergrouping = 'ZSTO'.

      DATA(plant) = buyeradd-b-customer.
      REPLACE ALL OCCURRENCES OF 'CV' IN plant WITH ''.

      SELECT SINGLE FROM ztable_plant
      FIELDS company_name
      WHERE plant_code = @plant AND comp_code = @lv_document_details-companycode
      INTO @DATA(buyer_name) PRIVILEGED ACCESS.



      wa_final-buyerdtls-lglnm = buyer_name.
      wa_final-buyerdtls-trdnm = buyer_name.
    ELSE.
      wa_final-buyerdtls-lglnm = buyeradd-b-customername.
      wa_final-buyerdtls-trdnm = buyeradd-b-customername.
    ENDIF.

    DATA(buyer_full_addr) = buyeradd-c-housenumber && ' ' && buyeradd-c-streetname && ' ' && buyeradd-c-streetprefixname1 && ' ' && buyeradd-c-streetprefixname2
                                  && ' ' && buyeradd-c-streetsuffixname1 && ' ' && buyeradd-c-streetsuffixname2 && ' ' && buyeradd-c-districtname && ' ' && buyeradd-c-villagename.

    CALL METHOD split_addr_line
      EXPORTING
        addr_line = buyer_full_addr
      IMPORTING
        part1     = wa_final-buyerdtls-addr1
        part2     = wa_final-buyerdtls-addr2.

    wa_final-buyerdtls-gstin = buyeradd-b-taxnumber3.
    wa_final-buyerdtls-loc   = buyeradd-b-cityname .
    wa_final-buyerdtls-pin   = buyeradd-b-postalcode  .
    wa_final-buyerdtls-stcd  = buyeradd-b-taxnumber3+0(2)  .



***********************************************************************************

    SELECT SINGLE FROM i_billingdocitempartner AS a
               INNER JOIN i_customer AS b ON ( a~customer = b~customer  )
               INNER JOIN i_businesspartner AS d ON ( b~customer = d~businesspartner )
               INNER JOIN i_address_2 AS c ON ( b~addressid = c~addressid )
               FIELDS a~*,b~*,c~*,d~businesspartnergrouping
                   WHERE a~billingdocument = @mv_document
                   AND a~partnerfunction = 'WE' INTO  @DATA(shipperadd)
                       PRIVILEGED ACCESS.


    IF buyeradd-businesspartnergrouping = 'ZSTO'.

      plant = shipperadd-b-customer.
      REPLACE ALL OCCURRENCES OF 'CV' IN plant WITH ''.

      SELECT SINGLE FROM ztable_plant
      FIELDS company_name
      WHERE plant_code = @plant AND comp_code = @lv_document_details-companycode
      INTO @buyer_name PRIVILEGED ACCESS.



      wa_final-shipdtls-lglnm = buyer_name.
      wa_final-shipdtls-trdnm = buyer_name.
    ELSE.
      wa_final-shipdtls-lglnm = shipperadd-b-customername.
      wa_final-shipdtls-trdnm = shipperadd-b-customername.
    ENDIF.

    buyer_full_addr = shipperadd-c-housenumber && ' ' && shipperadd-c-streetname && ' ' && shipperadd-c-streetprefixname1 && ' ' && shipperadd-c-streetprefixname2
                                  && ' ' && shipperadd-c-streetsuffixname1 && ' ' && shipperadd-c-streetsuffixname2 && ' ' && shipperadd-c-districtname && ' ' && shipperadd-c-villagename.

    CALL METHOD split_addr_line
      EXPORTING
        addr_line = buyer_full_addr
      IMPORTING
        part1     = wa_final-shipdtls-addr1
        part2     = wa_final-shipdtls-addr2.

    wa_final-shipdtls-gstin = COND #( WHEN shipperadd-b-taxnumber3 IS NOT INITIAL THEN shipperadd-b-taxnumber3 ELSE 'URP' ).
    wa_final-shipdtls-loc   = shipperadd-b-cityname .
    wa_final-shipdtls-pin   = shipperadd-b-postalcode  .
    wa_final-shipdtls-stcd  = shipperadd-b-taxnumber3+0(2)  .



***********************************************************************************

    SELECT FROM i_billingdocumentitem FIELDS billingdocument, billingdocumentitem, billingdocumentitemtext,
    product, plant, billingquantity, billingquantityunit
    WHERE billingdocument = @mv_document AND companycode = @mv_companycode
    INTO TABLE @DATA(lt_item) PRIVILEGED ACCESS.



**********************************************************************************

    SELECT SINGLE FROM zr_irn
    FIELDS transportername, vehiclenum, grdate, grno, transportergstin, distance , ewaytranstype, address, place, pincode, state
    WHERE billingdocument = @mv_document AND companycode = @mv_companycode
    INTO @DATA(eway).

    wa_final-vehno = eway-vehiclenum.
    wa_final-transname = eway-transportername .
    wa_final-transdocdt = eway-grdate+6(2) && '/' && eway-grdate+4(2) && '/' && eway-grdate(4).
    wa_final-transdocno = eway-grno .
    wa_final-transid = eway-transportergstin .
    wa_final-transmode = '1'.
    IF eway-distance = 0.
      wa_final-distance = 0.
    ELSE.
      wa_final-distance = eway-distance.
    ENDIF.
    wa_final-vehtype = 'R'.


****************************    dispatch details
    IF eway-address IS NOT INITIAL.
      wa_final-dispdtls-nm    =  eway-address.

      DATA dispatch_full_addr TYPE string.
      dispatch_full_addr = eway-place.

      CALL METHOD split_addr_line
        EXPORTING
          addr_line = dispatch_full_addr
        IMPORTING
          part1     = wa_final-dispdtls-addr1
          part2     = wa_final-dispdtls-addr2.


      wa_final-dispdtls-loc       =  eway-state .
      IF wa_final-dispdtls-loc IS INITIAL.
        wa_final-dispdtls-loc       =  sellerplantaddress-city .
      ENDIF.
      wa_final-dispdtls-stcd     =  sellerplantaddress-statecode1.
      wa_final-dispdtls-pin      =  eway-pincode.
    ELSE.

      wa_final-dispdtls-nm    =  sellerplantaddress-companyname.
      wa_final-dispdtls-addr1    =  sellerplantaddress-address1.
      wa_final-dispdtls-addr2    =  sellerplantaddress-address2.
      wa_final-dispdtls-loc      =  sellerplantaddress-address2 .
      IF sellerplantaddress-city IS NOT INITIAL.
        wa_final-dispdtls-loc      =  sellerplantaddress-city .
      ENDIF.
      wa_final-dispdtls-stcd     =  sellerplantaddress-statecode1.
      wa_final-dispdtls-pin      =  sellerplantaddress-pin.

    ENDIF.



    SELECT SINGLE FROM zc_ewaytranstype
    FIELDS value
    WHERE description = @eway-ewaytranstype
    INTO @wa_final-transactiontype.


    SELECT FROM i_billingdocumentitem AS item
        LEFT JOIN i_productdescription AS pd ON item~product = pd~product AND pd~languageisocode = 'EN'
        LEFT JOIN i_productplantbasic AS c ON item~product = c~product AND item~plant = c~plant
        FIELDS item~billingdocument, item~billingdocumentitem, item~plant, item~profitcenter, item~product, item~billingquantity,
               item~baseunit, item~billingquantityunit, item~netamount, item~taxamount, item~transactioncurrency, c~consumptiontaxctrlcode,
               item~cancelledbillingdocument, item~billingquantityinbaseunit, item~billingdocumenttype, pd~productdescription
        WHERE item~billingdocument = @mv_document AND consumptiontaxctrlcode IS NOT INITIAL
           INTO TABLE @DATA(ltlines) PRIVILEGED ACCESS.

    SELECT FROM i_billingdocitemprcgelmntbasic
        FIELDS billingdocument , billingdocumentitem, conditionratevalue, conditionamount, conditiontype,
        transactioncurrency AS d_transactioncurrency
      WHERE billingdocument = @mv_document
      INTO TABLE @DATA(it_price).

    LOOP AT ltlines INTO DATA(wa_lines).
      wa_itemlist-hsncd = wa_lines-consumptiontaxctrlcode.
      wa_itemlist-qty = wa_lines-billingquantity.
      wa_itemlist-prodname = wa_lines-productdescription.
      wa_itemlist-proddesc = wa_lines-productdescription.

      REPLACE ALL OCCURRENCES OF '"' IN wa_itemlist-prodname WITH ' '.
      REPLACE ALL OCCURRENCES OF '"' IN wa_itemlist-proddesc WITH ' '.

      SELECT SINGLE FROM zr_gstuom000
          FIELDS gstuom
          WHERE uom = @wa_lines-billingquantityunit
          INTO @DATA(uom).

      IF uom IS INITIAL.
        wa_itemlist-unit = wa_lines-billingquantityunit.
      ELSE.
        wa_itemlist-unit = uom.
      ENDIF.


      READ TABLE it_price INTO DATA(wa_price1) WITH KEY billingdocument = wa_lines-billingdocument
                                                      billingdocumentitem = wa_lines-billingdocumentitem
                                                      conditiontype = 'JOIG'.
      IF wa_price1 IS NOT INITIAL.
        wa_itemlist-igstrt                       = wa_price1-conditionratevalue.
        wa_itemlist-igstamt                       = wa_price1-conditionamount.
        CLEAR wa_price1.

      ELSE.


        READ TABLE it_price INTO DATA(wa_price2) WITH KEY billingdocument = wa_lines-billingdocument
                                                         billingdocumentitem = wa_lines-billingdocumentitem
                                                         conditiontype = 'JOSG'.
        wa_itemlist-sgstamt                    = wa_price2-conditionamount.
        wa_itemlist-sgstrt                    = wa_price2-conditionratevalue.

        IF wa_price2 IS INITIAL.

          READ TABLE it_price INTO wa_price2 WITH KEY billingdocument = wa_lines-billingdocument
                                                           billingdocumentitem = wa_lines-billingdocumentitem
                                                           conditiontype = 'JOUG'.
          wa_itemlist-sgstamt                    = wa_price2-conditionamount.
          wa_itemlist-sgstrt                    = wa_price2-conditionratevalue.
        ENDIF.

        READ TABLE it_price INTO DATA(wa_price3) WITH KEY billingdocument = wa_lines-billingdocument
                                                        billingdocumentitem = wa_lines-billingdocumentitem
                                                        conditiontype = 'JOCG'.
        wa_itemlist-cgstrt                    = wa_price3-conditionratevalue.
        wa_itemlist-cgstamt                    = wa_price3-conditionamount.

        IF wa_lines-billingdocumenttype = 'JSTO'.
          wa_itemlist-sgstrt        = 0.
          wa_itemlist-sgstamt       = 0.
          wa_itemlist-cgstrt        = 0.
          wa_itemlist-cgstamt       = 0.
        ENDIF.

        IF wa_lines-billingdocumenttype = 'F8'.
          wa_itemlist-sgstrt        = 0.
          wa_itemlist-sgstamt       = 0.
          wa_itemlist-cgstrt        = 0.
          wa_itemlist-cgstamt       = 0.
          wa_itemlist-igstrt        = 0.
          wa_itemlist-igstamt       = 0.
        ENDIF.
        CLEAR : wa_price2,wa_price3.
      ENDIF.


      SELECT FROM i_billingdocumentitemprcgelmnt AS a
         FIELDS SUM( a~conditionamount ) AS conditionamount
         WHERE conditiontype IN ( 'JTC1','JTC2','JTC3','ZTCS' ) AND billingdocument = @wa_lines-billingdocument
                AND billingdocumentitem = @wa_lines-billingdocumentitem
         INTO @DATA(tcs) .

      IF tcs IS NOT INITIAL .
        DATA(tcsamt) = tcs .
      ENDIF.

      SELECT SUM( conditionamount ) FROM i_billingdocumentitemprcgelmnt
         WHERE conditiontype IN (  'ZDM1','ZDIS','ZRAB','D100', 'ZMDP' )
               AND billingdocument = @wa_lines-billingdocument AND billingdocumentitem = @wa_lines-billingdocumentitem
         INTO @DATA(discount) .

      IF discount < 0.
        discount                     =      discount * -1.
      ENDIF.

*******************        BASE PRICE        ***********************************************

      SELECT FROM i_billingdocumentitemprcgelmnt AS a
        FIELDS SUM( a~conditionrateamount ) AS unitprice, SUM( a~conditionamount ) AS totamt
        WHERE conditiontype IN ( 'ZBSV' ) AND billingdocument = @wa_lines-billingdocument
              AND billingdocumentitem = @wa_lines-billingdocumentitem
        INTO @DATA(unitprice) .


      IF unitprice IS INITIAL.
        SELECT FROM i_billingdocumentitemprcgelmnt AS a
           FIELDS SUM( a~conditionrateamount ) AS unitprice, SUM( a~conditionamount ) AS totamt
           WHERE conditiontype IN ( 'ZPR1', 'ZPR2', 'ZPR0', 'ZPEX' ) AND billingdocument = @wa_lines-billingdocument
                 AND billingdocumentitem = @wa_lines-billingdocumentitem
           INTO @unitprice .
      ENDIF.

      SELECT FROM i_billingdocumentitemprcgelmnt AS a
      FIELDS SUM( a~conditionrateamount ) AS unitprice, SUM( a~conditionamount ) AS totamt,
             COUNT( conditiontype ) AS datacount
       WHERE conditiontype IN ( 'ZASS', 'ZEXF' ) AND billingdocument = @wa_lines-billingdocument
             AND billingdocumentitem = @wa_lines-billingdocumentitem
        INTO @DATA(lt_assamt) .


      wa_itemlist-othchrg = tcsamt.
      IF lt_assamt IS NOT INITIAL.
        wa_itemlist-assamt = lt_assamt-totamt.
      ELSE.
        wa_itemlist-assamt = unitprice-totamt - discount.
      ENDIF.

*      Tax Exempt
      SELECT SINGLE FROM i_billingdocumentitemprcgelmnt AS a
               FIELDS  a~conditionrateamount  AS unitprice, a~conditionamount  AS totamt
               WHERE conditiontype IN ( 'ZOIG' ) AND billingdocument = @wa_lines-billingdocument
                     AND billingdocumentitem = @wa_lines-billingdocumentitem
             INTO @DATA(exempt) .
      IF exempt IS NOT INITIAL.
        wa_itemlist-igstamt = '0'.
        wa_itemlist-cgstamt = '0'.
        wa_itemlist-sgstamt = '0'.
      ENDIF.


      wa_final-totalassessableamount   +=   + wa_itemlist-assamt.
      wa_final-totaligstamount +=  wa_itemlist-igstamt .
      wa_final-totalcgstamount +=  wa_itemlist-cgstamt.
      wa_final-totalsgstamount +=  wa_itemlist-sgstamt.
      wa_final-othertcsamount +=  tcsamt.

      APPEND wa_itemlist TO itemlist.
      CLEAR :  wa_itemlist.
    ENDLOOP.

    wa_final-totalinvoiceamount = wa_final-totalassessableamount + wa_final-totaligstamount + wa_final-totalcgstamount + wa_final-totalsgstamount + wa_final-othertcsamount.
    wa_final-itemlist = itemlist.


    SELECT SINGLE FROM ztable_plant
    FIELDS  ewbusername , ewbpassword
    WHERE plant_code = @lv_document_details-plant AND comp_code = @lv_document_details-companycode
    INTO @DATA(lv_id_pass) PRIVILEGED ACCESS.

    SELECT SINGLE FROM i_billingdocument AS a
    FIELDS a~billingdocument , a~distributionchannel , a~salesorganization
    WHERE a~billingdocument = @wa_lines-billingdocument
    INTO @DATA(wa_expo).


    DATA:res_payload      TYPE TABLE OF ty_payload,
         res_payload_item TYPE ty_payload.
    DATA: BEGIN OF ls_wrapper,
            push_data_list TYPE STANDARD TABLE OF ty_payload WITH EMPTY KEY,
            year           TYPE i,
            month          TYPE i,
            efusername     TYPE string,
            efpassword     TYPE string,
            cdkey          TYPE string,
          END OF ls_wrapper.


    LOOP AT wa_final-itemlist INTO DATA(item).

*      res_payload_item-irn                    = ''.
      res_payload_item-gstin                  = wa_final-sellerdtls-gstin.
      res_payload_item-year                   = lv_document_details-billingdocumentdate(4).
      res_payload_item-month                  = lv_document_details-billingdocumentdate+4(2).

      IF wa_final-sellerdtls-gstin EQ wa_final-buyerdtls-gstin.
        res_payload_item-supplytype = 'I'.
      ELSE.
        res_payload_item-supplytype = 'O'.
      ENDIF.

      res_payload_item-supplytype             = wa_final-supplytype.
      res_payload_item-doctype                = wa_final-documenttype.
      res_payload_item-docno                  = wa_final-documentnumber.
      res_payload_item-docdate                = lv_document_details-billingdocumentdate.
      res_payload_item-supgstin               = wa_final-sellerdtls-gstin.
      res_payload_item-supname                = wa_final-sellerdtls-lglnm.
      res_payload_item-supadd1                = wa_final-sellerdtls-addr1.
      res_payload_item-supadd2                = wa_final-sellerdtls-addr2.
      res_payload_item-supcity                = wa_final-sellerdtls-loc.
      res_payload_item-supstate               = wa_final-sellerdtls-stcd.
      res_payload_item-suppincode             = wa_final-sellerdtls-pin.
      res_payload_item-recname                = wa_final-buyerdtls-lglnm.
      res_payload_item-recadd1                = wa_final-buyerdtls-addr1.
      res_payload_item-recadd2                = wa_final-buyerdtls-addr2.
      res_payload_item-reccity                = wa_final-buyerdtls-loc.

      SELECT SINGLE FROM zr_irn
      FIELDS billingdocument , trans_ship_pin
      WHERE billingdocument = @mv_document
      INTO @DATA(lv_trans_ship_pin).

      IF wa_expo-distributionchannel EQ '33' AND wa_expo-salesorganization EQ '1001'.
        res_payload_item-recgstin               = 'URP'.
        res_payload_item-recstate               = '99'.
        res_payload_item-shiptostatecode        = '97'.
        res_payload_item-recpincode             = lv_trans_ship_pin-trans_ship_pin.
        res_payload_item-subtype                = '3'.
      ELSE .
        res_payload_item-recgstin               = wa_final-buyerdtls-gstin.
        res_payload_item-recstate               = wa_final-buyerdtls-stcd.
        res_payload_item-shiptostatecode        = shipperadd-b-taxnumber3+0(2).
        res_payload_item-recpincode             = wa_final-buyerdtls-pin.
        res_payload_item-subtype                = wa_final-subsupplytype.
      ENDIF.

      wa_final-buyerdtls-gstin = buyeradd-b-taxnumber3.
      wa_final-buyerdtls-loc   = buyeradd-b-cityname .
      wa_final-buyerdtls-pin   = buyeradd-b-postalcode  .
      wa_final-buyerdtls-stcd  = buyeradd-b-taxnumber3+0(2)  .


      IF res_payload_item-shiptostatecode IS INITIAL.
        res_payload_item-shiptostatecode   = shipperadd-c-region.
      ENDIF.

      res_payload_item-transmode              = wa_final-transmode.
      IF wa_final-transid IS NOT INITIAL.
        res_payload_item-transporterid          = wa_final-transid.
      ELSE.
        res_payload_item-transporterid = 'URP'.
      ENDIF.
      res_payload_item-transportername        = wa_final-transname.
      res_payload_item-transdistance          = wa_final-distance.
      res_payload_item-transdocno             = wa_final-transdocno.
      res_payload_item-transdocdate           = eway-grdate.
      res_payload_item-vehicletype            = wa_final-vehtype.
      res_payload_item-vehicleno              = wa_final-vehno.
      res_payload_item-productname            = item-prodname.
      res_payload_item-productdesc            = item-proddesc.
      res_payload_item-hsncode                = item-hsncd.
      res_payload_item-quantity               = item-qty.
      res_payload_item-qtyunit                = item-unit.
      res_payload_item-taxablevalue           = item-assamt.
      res_payload_item-totalvalue             = item-assamt + item-igstamt + item-cgstamt + item-sgstamt.
      res_payload_item-sgstrate               = item-sgstrt.
      res_payload_item-sgstvalue              = item-sgstamt.
      res_payload_item-cgstrate               = item-cgstrt.
      res_payload_item-cgstvalue              = item-cgstamt.
      res_payload_item-igstrate               = item-igstrt.
      res_payload_item-igstvalue              = item-igstamt.
      res_payload_item-totalinvoicevalue      = wa_final-totalinvoiceamount.
      res_payload_item-othervalue             = item-othchrg.
      res_payload_item-dispatchfromgstin      = wa_final-sellerdtls-gstin.
      res_payload_item-dispatchfromtradename  = COND #( WHEN wa_final-dispdtls-nm IS NOT INITIAL THEN wa_final-dispdtls-nm ELSE wa_final-sellerdtls-lglnm ).
      IF wa_final-sellerdtls-gstin NE wa_final-buyerdtls-gstin.
        res_payload_item-shiptogstin            = wa_final-shipdtls-gstin.
        res_payload_item-shiptotradename        = wa_final-shipdtls-lglnm.
      ELSE.
        res_payload_item-shiptogstin            = wa_final-buyerdtls-gstin.
        res_payload_item-shiptotradename        = wa_final-buyerdtls-lglnm.
      ENDIF.

      IF eway-ewaytranstype EQ 'Bill to-ship to' .

        CLEAR : res_payload_item-recadd1 , res_payload_item-recadd2.
        DATA(shipper_full_addr) = shipperadd-c-housenumber && ' ' && shipperadd-c-streetname && ' ' && shipperadd-c-streetprefixname1 && ' ' && shipperadd-c-streetprefixname2
                                && ' ' && shipperadd-c-streetsuffixname1 && ' ' && shipperadd-c-streetsuffixname2 && ' ' && shipperadd-c-districtname && ' ' && shipperadd-c-villagename.

        CALL METHOD split_addr_line
          EXPORTING
            addr_line = shipper_full_addr
          IMPORTING
            part1     = res_payload_item-recadd1
            part2     = res_payload_item-recadd2.

        res_payload_item-recname                = shipperadd-b-customername.
        res_payload_item-reccity                = shipperadd-b-cityname.
        res_payload_item-recgstin               = shipperadd-b-taxnumber3.
        res_payload_item-recstate               = shipperadd-b-taxnumber3+0(2).
        res_payload_item-recpincode             = shipperadd-b-postalcode.
        res_payload_item-shiptogstin            = shipperadd-b-taxnumber3.
        res_payload_item-shiptotradename        = shipperadd-b-customername.

      ENDIF.

      res_payload_item-isbillfromshipfromsame = '1'.
      res_payload_item-isbilltoshiptosame     = '1'.
      res_payload_item-isgstinsez             = 0.
      res_payload_item-shipfromstatecode      = wa_final-sellerdtls-stcd.
      res_payload_item-ewbpassword            = lv_id_pass-ewbpassword.
      res_payload_item-ewbusername            = lv_id_pass-ewbusername.

      IF res_payload_item-supgstin = res_payload_item-recgstin.
        res_payload_item-supplytype = 'I'.
        res_payload_item-subtype = '5'.
        res_payload_item-doctype = 'CHL'.
      ENDIF.

      APPEND res_payload_item TO res_payload.
      CLEAR res_payload_item.

    ENDLOOP.
    ls_wrapper-month = res_payload[ 1 ]-month.
    ls_wrapper-year = res_payload[ 1 ]-year.

    SELECT SINGLE FROM zr_integration_tab000
    FIELDS intgpath
    WHERE intgmodule = 'EWB-EFUNAME-EFPASS-CDKEY'
    INTO @DATA(efusercreds).

    SPLIT efusercreds AT '/' INTO ls_wrapper-efusername ls_wrapper-efpassword ls_wrapper-cdkey.

    ls_wrapper-push_data_list = res_payload.


    DATA:json TYPE REF TO if_xco_cp_json_data.

    xco_cp_json=>data->from_abap(
      EXPORTING
        ia_abap      = ls_wrapper
      RECEIVING
        ro_json_data = json   ).
    json->to_string(
      RECEIVING
        rv_string =   DATA(lv_string) ).


    REPLACE ALL OCCURRENCES OF '"PUSH_DATA_LIST"'       IN lv_string WITH '"Push_Data_List"'.
    REPLACE ALL OCCURRENCES OF '"EFUSERNAME"'           IN lv_string WITH '"EFUserName"'.
    REPLACE ALL OCCURRENCES OF '"EFPASSWORD"'           IN lv_string WITH '"EFPassword"'.
    REPLACE ALL OCCURRENCES OF '"CDKEY"'                IN lv_string WITH '"CDKey"'.
    REPLACE ALL OCCURRENCES OF '"YEAR"'                 IN lv_string WITH '"Year"'.
    REPLACE ALL OCCURRENCES OF '"MONTH"'                IN lv_string WITH '"Month"'.
    REPLACE ALL OCCURRENCES OF '"IRN"'                  IN lv_string WITH '"Irn"'.
    REPLACE ALL OCCURRENCES OF '"GSTIN"'                IN lv_string WITH '"GSTIN"'.
    REPLACE ALL OCCURRENCES OF '"SUPPLYTYPE"'           IN lv_string WITH '"SupplyType"'.
    REPLACE ALL OCCURRENCES OF '"SUBTYPE"'              IN lv_string WITH '"SubType"'.
    REPLACE ALL OCCURRENCES OF '"DOCTYPE"'              IN lv_string WITH '"DocType"'.
    REPLACE ALL OCCURRENCES OF '"DOCNO"'                IN lv_string WITH '"DocNo"'.
    REPLACE ALL OCCURRENCES OF '"DOCDATE"'              IN lv_string WITH '"DocDate"'.
    REPLACE ALL OCCURRENCES OF '"SUPGSTIN"'             IN lv_string WITH '"SupGSTIN"'.
    REPLACE ALL OCCURRENCES OF '"SUPNAME"'              IN lv_string WITH '"SupName"'.
    REPLACE ALL OCCURRENCES OF '"SUPADD1"'              IN lv_string WITH '"SupAdd1"'.
    REPLACE ALL OCCURRENCES OF '"SUPADD2"'              IN lv_string WITH '"SupAdd2"'.
    REPLACE ALL OCCURRENCES OF '"SUPCITY"'              IN lv_string WITH '"SupCity"'.
    REPLACE ALL OCCURRENCES OF '"SUPSTATE"'             IN lv_string WITH '"SupState"'.
    REPLACE ALL OCCURRENCES OF '"SUPPINCODE"'           IN lv_string WITH '"SupPincode"'.
    REPLACE ALL OCCURRENCES OF '"RECGSTIN"'             IN lv_string WITH '"RecGSTIN"'.
    REPLACE ALL OCCURRENCES OF '"RECNAME"'              IN lv_string WITH '"RecName"'.
    REPLACE ALL OCCURRENCES OF '"RECADD1"'              IN lv_string WITH '"RecAdd1"'.
    REPLACE ALL OCCURRENCES OF '"RECADD2"'              IN lv_string WITH '"RecAdd2"'.
    REPLACE ALL OCCURRENCES OF '"RECCITY"'              IN lv_string WITH '"Reccity"'.
    REPLACE ALL OCCURRENCES OF '"RECSTATE"'             IN lv_string WITH '"RecState"'.
    REPLACE ALL OCCURRENCES OF '"RECPINCODE"'           IN lv_string WITH '"Recpincode"'.
    REPLACE ALL OCCURRENCES OF '"TRANSMODE"'            IN lv_string WITH '"TransMode"'.
    REPLACE ALL OCCURRENCES OF '"TRANSPORTERID"'        IN lv_string WITH '"TransporterId"'.
    REPLACE ALL OCCURRENCES OF '"TRANSPORTERNAME"'      IN lv_string WITH '"TransporterName"'.
    REPLACE ALL OCCURRENCES OF '"TRANSDISTANCE"'        IN lv_string WITH '"TransDistance"'.
    REPLACE ALL OCCURRENCES OF '"TRANSDOCNO"'           IN lv_string WITH '"TransDocNo"'.
    REPLACE ALL OCCURRENCES OF '"TRANSDOCDATE"'         IN lv_string WITH '"TransDocDate"'.
    REPLACE ALL OCCURRENCES OF '"VEHICLETYPE"'          IN lv_string WITH '"VehicleType"'.
    REPLACE ALL OCCURRENCES OF '"VEHICLENO"'            IN lv_string WITH '"VehicleNo"'.
    REPLACE ALL OCCURRENCES OF '"PRODUCTNAME"'          IN lv_string WITH '"ProductName"'.
    REPLACE ALL OCCURRENCES OF '"PRODUCTDESC"'          IN lv_string WITH '"ProductDesc"'.
    REPLACE ALL OCCURRENCES OF '"HSNCODE"'              IN lv_string WITH '"HSNCode"'.
    REPLACE ALL OCCURRENCES OF '"QUANTITY"'             IN lv_string WITH '"Quantity"'.
    REPLACE ALL OCCURRENCES OF '"QTYUNIT"'              IN lv_string WITH '"QtyUnit"'.
    REPLACE ALL OCCURRENCES OF '"TAXABLEVALUE"'         IN lv_string WITH '"TaxableValue"'.
    REPLACE ALL OCCURRENCES OF '"TOTALVALUE"'           IN lv_string WITH '"TotalValue"'.
    REPLACE ALL OCCURRENCES OF '"TOTALINVOICEVALUE"'    IN lv_string WITH '"TotalInvoiceValue"'.
    REPLACE ALL OCCURRENCES OF '"SGSTRATE"'             IN lv_string WITH '"SGSTRate"'.
    REPLACE ALL OCCURRENCES OF '"SGSTVALUE"'            IN lv_string WITH '"SGSTValue"'.
    REPLACE ALL OCCURRENCES OF '"CGSTRATE"'             IN lv_string WITH '"CGSTRate"'.
    REPLACE ALL OCCURRENCES OF '"CGSTVALUE"'            IN lv_string WITH '"CGSTValue"'.
    REPLACE ALL OCCURRENCES OF '"IGSTRATE"'             IN lv_string WITH '"IGSTRate"'.
    REPLACE ALL OCCURRENCES OF '"IGSTVALUE"'            IN lv_string WITH '"IGSTValue"'.
    REPLACE ALL OCCURRENCES OF '"CESSRATE"'             IN lv_string WITH '"CessRate"'.
    REPLACE ALL OCCURRENCES OF '"CESSVALUE"'            IN lv_string WITH '"CessValue"'.
    REPLACE ALL OCCURRENCES OF '"CESSNONADVOL"'         IN lv_string WITH '"CessNonAdvol"'.
    REPLACE ALL OCCURRENCES OF '"CESSNONADVOLVALUE"'    IN lv_string WITH '"CessNonAdvolValue"'.
    REPLACE ALL OCCURRENCES OF '"OTHERVALUE"'           IN lv_string WITH '"OtherValue"'.
    REPLACE ALL OCCURRENCES OF '"EWBUSERNAME"'          IN lv_string WITH '"EWBUserName"'.
    REPLACE ALL OCCURRENCES OF '"EWBPASSWORD"'          IN lv_string WITH '"EWBPassword"'.
    REPLACE ALL OCCURRENCES OF '"SUBSUPPLYDESC"'        IN lv_string WITH '"SubSupplyDesc"'.
    REPLACE ALL OCCURRENCES OF '"SHIPFROMSTATECODE"'    IN lv_string WITH '"ShipFromStateCode"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTOSTATECODE"'      IN lv_string WITH '"ShipToStateCode"'.
    REPLACE ALL OCCURRENCES OF '"DISPATCHFROMGSTIN"'    IN lv_string WITH '"dispatchFromGSTIN"'.
    REPLACE ALL OCCURRENCES OF '"DISPATCHFROMTRADENAME"' IN lv_string WITH '"dispatchFromTradeName"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTOGSTIN"'          IN lv_string WITH '"ShipToGSTIN"'.
    REPLACE ALL OCCURRENCES OF '"SHIPTOTRADENAME"'      IN lv_string WITH '"ShipToTradeName"'.
    REPLACE ALL OCCURRENCES OF '"ISBILLFROMSHIPFROMSAME"' IN lv_string WITH '"IsBillFromShipFromSame"'.
    REPLACE ALL OCCURRENCES OF '"ISBILLTOSHIPTOSAME"'   IN lv_string WITH '"IsBillToShipToSame"'.
    REPLACE ALL OCCURRENCES OF '"ISGSTINSEZ"'           IN lv_string WITH '"IsGSTINSEZ"'.

    result = lv_string.

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
