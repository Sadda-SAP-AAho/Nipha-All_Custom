*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS salesorderdriver DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS salesorder
      IMPORTING
        request       TYPE REF TO if_web_http_request
        response      TYPE REF TO if_web_http_response
      RETURNING
        VALUE(result) TYPE string .

  PRIVATE SECTION.

    CONSTANTS lc_template_teaxinv TYPE string VALUE 'ZSO_PRINT/ZSO_PRINT'.

ENDCLASS.



CLASS salesorderdriver IMPLEMENTATION.

  METHOD salesorder.

    DATA: lv_salesorder TYPE i_salesorder-salesorder,
          lv_xml        TYPE string.

    lv_salesorder = request->get_form_field( 'SalesOrder' ).

    DATA: lv_shiptoadd  TYPE string,
          lv_billtoadd  TYPE string,
          lv_statecodeb TYPE string,
          lv_statecodes TYPE string,
          lv_plantadd   TYPE string.

    TYPES:BEGIN OF ty_item,
            productlongtext        TYPE i_productbasictexttp_2-productlongtext,
            productdescription     TYPE i_productdescription-productdescription,
            productoldid           TYPE i_product-productoldid,
            consumptiontaxctrlcode TYPE i_productplantbasic-consumptiontaxctrlcode,
*            schedulelineorderquantity TYPE i_salesdocumentscheduleline-schedulelineorderquantity,
            orderquantity          TYPE i_salesdocumentitem-orderquantity,
            orderquantityunit      TYPE i_salesdocumentitem-orderquantityunit,
            conditionamount        TYPE i_salesdocitempricingelement-conditionamount,
            disc                   TYPE i_salesdocitempricingelement-conditionamount,
            ratval                 TYPE p LENGTH 15 DECIMALS 2,
            conditionratevalue     TYPE i_salesdocitempricingelement-conditionratevalue,
            conditionrateamount    TYPE i_salesdocitempricingelement-conditionrateamount,
            freight                TYPE i_salesdocitempricingelement-conditionamount,
            igstamount             TYPE i_salesdocitempricingelement-conditionamount,
            conditiontype          TYPE i_salesdocitempricingelement-conditiontype,
            rate                   TYPE i_salesdocitempricingelement-conditionamount,
            totalval_rate          TYPE p LENGTH 15 DECIMALS 2,
            igstrate               TYPE i_salesdocitempricingelement-conditionratevalue,
            taxablevalue           TYPE i_salesdocitempricingelement-conditionamount,
            totalamountigst        TYPE p LENGTH 15 DECIMALS 2,
            cgstamount             TYPE p LENGTH 15 DECIMALS 2,
            cgstrate               TYPE i_salesdocitempricingelement-conditionratevalue,
            sgstamount             TYPE p LENGTH 15 DECIMALS 2,
            sgstrate               TYPE i_salesdocitempricingelement-conditionratevalue,
            product                TYPE i_salesdocumentitem-product,
            totalamountsgst        TYPE p LENGTH 15 DECIMALS 2,
            salesdocument          TYPE i_salesdocument-salesdocument,
            salesdocumentitem      TYPE i_salesdocumentitem-salesdocumentitem,
          END OF ty_item.

    DATA lt_item TYPE TABLE OF ty_item.

    """""""""""""""""""""Header""""""""""""""""""""""""""""""""""""""

    SELECT SINGLE FROM i_salesdocument AS a

    LEFT JOIN zcompanycode AS b
    ON a~billingcompanycode = b~company_code
    LEFT JOIN i_salesdocumentitem AS c
    ON c~salesdocument = a~salesdocument
    LEFT JOIN ztable_plant AS d
    ON d~plant_code = c~plant
    LEFT JOIN zr_table_plant000 AS d1 ON d1~plantcode = d~plant_code
    LEFT JOIN i_salesdocumentpartner AS e
    ON e~partnerfunction = 'AG'
    AND e~salesdocument = a~salesdocument
    LEFT JOIN i_customer AS f
    ON f~customer = e~customer
    FIELDS
    d1~plantname1,
    b~company_name,
    a~salesdocument,
    a~salesdocumentdate,
    d~address1,
    d~address2,
    d~address3,
    d~city,
    d~pin,
    d~state_name,
    d~state_code1,
    d~pan_no ,
    d~mob_no ,
    d~email,
    d~gstin_no ,
    d~cin_no,
    c~requesteddeliverydate,
    f~telephonenumber1,
    a~purchaseorderbycustomer
    WHERE a~salesdocument = @lv_salesorder
    INTO @DATA(wa_header) PRIVILEGED ACCESS.


    READ ENTITIES OF i_salesordertp
      ENTITY salesordertext
      FIELDS ( longtext )
      WITH VALUE #(
            (
              %key = VALUE #(
                  salesorder = wa_header-salesdocument
                  language   = 'E'
                  longtextid = 'ZBL1'
              )
            )
      )
      RESULT DATA(lt_text_data)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

    DATA : lv_remark TYPE string.
    IF lt_text_data IS NOT INITIAL.
      lv_remark = lt_text_data[ 1 ]-longtext.
    ELSE .
      lv_remark = ''.
    ENDIF.


    IF wa_header-address1 IS NOT INITIAL.
      lv_plantadd = wa_header-address1.
    ENDIF.

    IF wa_header-address2 IS NOT INITIAL.
      IF lv_plantadd IS INITIAL.
        lv_plantadd = wa_header-address2.
      ELSE.
        CONCATENATE lv_plantadd wa_header-address2 INTO lv_plantadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_header-address3 IS NOT INITIAL.
      IF lv_plantadd IS INITIAL.
        lv_plantadd = wa_header-address3.
      ELSE.
        CONCATENATE lv_plantadd wa_header-address3 INTO lv_plantadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_header-city IS NOT INITIAL.
      IF lv_plantadd IS INITIAL.
        lv_plantadd = wa_header-city.
      ELSE.
        CONCATENATE lv_plantadd wa_header-city INTO lv_plantadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_header-pin IS NOT INITIAL.
      IF lv_plantadd IS INITIAL.
        lv_plantadd = wa_header-pin.
      ELSE.
        CONCATENATE lv_plantadd wa_header-pin INTO lv_plantadd SEPARATED BY ','.
      ENDIF.
    ENDIF.


    """""""""""""""""""""Header""""""""""""""""""""""""""""""""""""""

    """"""""""""""""""""""BILL TO""""""""""""""""""""""""""""""""""""""""
    SELECT SINGLE FROM i_salesdocument AS a
    LEFT JOIN i_customer AS b
    ON b~customer = a~soldtoparty

    LEFT JOIN i_address_2 AS c
    ON c~addressid = b~addressid
    LEFT JOIN i_regiontext AS d
    ON d~region = c~region
    AND d~language = 'E'
    LEFT JOIN i_countrytext AS e
    ON e~country = c~country
    AND e~language = 'E'
    LEFT JOIN i_regiontext AS f
    ON f~region = c~region
    AND f~country = c~country
    AND f~language = 'E'
    LEFT JOIN i_addressemailaddress_2 AS g
    ON g~addressid = c~addressid
    FIELDS
    b~customername,
    c~streetname,
    c~streetprefixname1,
    c~streetprefixname2,
    c~streetsuffixname1,
    c~streetsuffixname2,
    c~districtname,
    c~cityname,
    c~postalcode,
    d~regionname,
    e~countryname,
    f~regionname AS statenameb,
    b~taxnumber3,
    g~emailaddress
    WHERE a~salesdocument = @lv_salesorder
    INTO @DATA(wa_billto) PRIVILEGED ACCESS.

    IF wa_billto-streetname IS NOT INITIAL.
      lv_billtoadd = wa_billto-streetname.
    ENDIF.

    IF wa_billto-streetprefixname1 IS NOT INITIAL.
      IF lv_billtoadd IS INITIAL.
        lv_billtoadd = wa_billto-streetprefixname1.
      ELSE.
        CONCATENATE lv_billtoadd wa_billto-streetprefixname1 INTO lv_billtoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_billto-streetprefixname2 IS NOT INITIAL.
      IF lv_billtoadd IS INITIAL.
        lv_billtoadd = wa_billto-streetprefixname2.
      ELSE.
        CONCATENATE lv_billtoadd wa_billto-streetprefixname2 INTO lv_billtoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_billto-streetsuffixname1 IS NOT INITIAL.
      IF lv_billtoadd IS INITIAL.
        lv_billtoadd = wa_billto-streetsuffixname1.
      ELSE.
        CONCATENATE lv_billtoadd wa_billto-streetsuffixname1 INTO lv_billtoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_billto-streetsuffixname2 IS NOT INITIAL.
      IF lv_billtoadd IS INITIAL.
        lv_billtoadd = wa_billto-streetsuffixname2.
      ELSE.
        CONCATENATE lv_billtoadd wa_billto-streetsuffixname2 INTO lv_billtoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_billto-districtname IS NOT INITIAL.
      IF lv_billtoadd IS INITIAL.
        lv_billtoadd = wa_billto-districtname.
      ELSE.
        CONCATENATE lv_billtoadd wa_billto-districtname INTO lv_billtoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_billto-cityname IS NOT INITIAL.
      IF lv_billtoadd IS INITIAL.
        lv_billtoadd = wa_billto-cityname.
      ELSE.
        CONCATENATE lv_billtoadd wa_billto-cityname INTO lv_billtoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_billto-postalcode IS NOT INITIAL.
      IF lv_billtoadd IS INITIAL.
        lv_billtoadd = wa_billto-postalcode.
      ELSE.
        CONCATENATE lv_billtoadd wa_billto-postalcode INTO lv_billtoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    lv_statecodeb = wa_billto-taxnumber3+0(2).


    """"""""""""""""""""""BILL TO"""""""""""""""""""""""""""""""""""""""""

    """""""""""""""""""""SHIP TO"""""""""""""""""""""""""""""""""""""""""""""""
    SELECT SINGLE FROM i_salesdocument AS a
    LEFT JOIN i_salesdocumentpartner AS bi
    ON bi~salesdocument = a~salesdocument
    AND bi~partnerfunction = 'WE'
    LEFT JOIN i_customer AS b
    ON b~customer = bi~customer
    LEFT JOIN i_address_2 AS c
    ON c~addressid = b~addressid
    LEFT JOIN i_regiontext AS d
    ON d~region = c~region
    AND d~language = 'E'
    LEFT JOIN i_countrytext AS e
    ON e~country = c~country
    AND e~language = 'E'
    LEFT JOIN i_regiontext AS f
    ON f~region = c~region
    AND f~country = c~country
    AND f~language = 'E'
    FIELDS
    bi~fullname,
    c~streetname,
    c~streetprefixname1,
    c~streetprefixname2,
    c~streetsuffixname1,
    c~streetsuffixname2,
    c~districtname,
    c~cityname,
    c~postalcode,
    d~regionname,
    e~countryname,
    f~regionname AS statenames,
    b~taxnumber3
    WHERE a~salesdocument = @lv_salesorder
    INTO @DATA(wa_shipto) PRIVILEGED ACCESS.

    IF wa_shipto-streetname IS NOT INITIAL.
      lv_shiptoadd = wa_shipto-streetname.
    ENDIF.

    IF wa_shipto-streetprefixname1 IS NOT INITIAL.
      IF lv_shiptoadd IS INITIAL.
        lv_shiptoadd = wa_shipto-streetprefixname1.
      ELSE.
        CONCATENATE lv_shiptoadd wa_shipto-streetprefixname1 INTO lv_shiptoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_shipto-streetprefixname2 IS NOT INITIAL.
      IF lv_shiptoadd IS INITIAL.
        lv_shiptoadd = wa_shipto-streetprefixname2.
      ELSE.
        CONCATENATE lv_shiptoadd wa_shipto-streetprefixname2 INTO lv_shiptoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_shipto-streetsuffixname1 IS NOT INITIAL.
      IF lv_shiptoadd IS INITIAL.
        lv_shiptoadd = wa_shipto-streetsuffixname1.
      ELSE.
        CONCATENATE lv_shiptoadd wa_shipto-streetsuffixname1 INTO lv_shiptoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_shipto-streetsuffixname2 IS NOT INITIAL.
      IF lv_shiptoadd IS INITIAL.
        lv_shiptoadd = wa_shipto-streetsuffixname2.
      ELSE.
        CONCATENATE lv_shiptoadd wa_shipto-streetsuffixname2 INTO lv_shiptoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_shipto-districtname IS NOT INITIAL.
      IF lv_shiptoadd IS INITIAL.
        lv_shiptoadd = wa_shipto-districtname.
      ELSE.
        CONCATENATE lv_shiptoadd wa_shipto-districtname INTO lv_shiptoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_shipto-cityname IS NOT INITIAL.
      IF lv_shiptoadd IS INITIAL.
        lv_shiptoadd = wa_shipto-cityname.
      ELSE.
        CONCATENATE lv_shiptoadd wa_shipto-cityname INTO lv_shiptoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    IF wa_shipto-postalcode IS NOT INITIAL.
      IF lv_shiptoadd IS INITIAL.
        lv_shiptoadd = wa_shipto-postalcode.
      ELSE.
        CONCATENATE lv_shiptoadd wa_shipto-postalcode INTO lv_shiptoadd SEPARATED BY ','.
      ENDIF.
    ENDIF.

    lv_statecodes = wa_shipto-taxnumber3+0(2).


    """""""""""""""""""""SHip TO""""""""""""""""""""""""""""""""""""""""""""""""""

    """""""""""""""""""""""""""Item""""""""""""""""""""""""""""""""""""""""""""""
    SELECT FROM i_salesdocument AS a
    LEFT JOIN i_salesdocumentitem AS b
    ON b~salesdocument = a~salesdocument
    LEFT JOIN i_productbasictexttp_2 AS bi ON bi~product = b~product AND bi~language EQ 'E'
    LEFT JOIN i_productdescription AS c
    ON c~product = b~product
    AND c~language EQ 'E'
    LEFT JOIN i_product AS d
    ON d~product = c~product
    LEFT JOIN i_productplantbasic AS e
    ON e~product = b~product
    AND e~plant = b~plant
*    LEFT JOIN i_salesdocumentscheduleline AS f
*    ON f~salesdocument = b~salesdocument
*    AND f~salesdocumentitem = b~salesdocumentitem
    LEFT JOIN i_unitofmeasuretext AS g
    ON g~unitofmeasure = b~orderquantityunit
    AND g~language EQ 'E'
    LEFT JOIN i_salesdocitempricingelement AS h ON b~salesdocument = h~salesdocument
    AND b~salesdocumentitem = h~salesdocumentitem
    FIELDS
    bi~productlongtext,
    c~productdescription,
    d~productoldid,
    e~consumptiontaxctrlcode,
*    f~schedulelineorderquantity,
b~orderquantity,
    g~unitofmeasure_e AS orderquantityunit ,
    h~conditiontype,
    h~conditionamount,
    h~conditionratevalue,
    h~conditionrateamount,
    b~product,
    a~salesdocument,
    b~salesdocumentitem
    WHERE a~salesdocument = @lv_salesorder
    ORDER BY a~salesdocument , b~salesdocumentitem
    INTO  CORRESPONDING FIELDS OF TABLE @lt_item PRIVILEGED ACCESS.



    """""""""""""""""""""""""""Item"""""""""""""""""""""""""""""""""""""""""""""""

    """""""""""""""""""""""""""Footer"""""""""""""""""""""""""""""""""""""""""""
    SELECT SINGLE FROM i_salesdocument AS a
    LEFT JOIN i_paymenttermstext AS b
    ON b~paymentterms = a~customerpaymentterms
    AND b~language = 'E'
    FIELDS
    b~paymenttermsname,
    a~createdbyuser

    INTO @DATA(wa_footer).
    """""""""""""""""""""""""""Footer"""""""""""""""""""""""""""""""""""""""""""

    DATA: lt_final TYPE TABLE OF ty_item,
          wa_final TYPE ty_item.

    LOOP AT lt_item INTO DATA(wa_item).



      IF wa_item-productlongtext IS INITIAL.
        wa_item-productlongtext = wa_item-productdescription.

      ENDIF.
      DATA(lv_cond) = wa_item-conditiontype.
      CONDENSE lv_cond.

      READ TABLE lt_final INTO wa_final
        WITH KEY salesdocument = wa_item-salesdocument salesdocumentitem = wa_item-salesdocumentitem.

      IF sy-subrc <> 0.
        CLEAR wa_final.
        MOVE-CORRESPONDING wa_item TO wa_final.


        CASE lv_cond.
          WHEN 'ZPR1' OR 'ZPEX' OR 'ZTRP'.
            wa_final-rate = wa_item-conditionrateamount.

          WHEN 'ZFRE'.
            wa_final-freight = wa_item-conditionamount.

          WHEN 'ZDIS' OR 'ZDM1'.
            wa_final-disc = wa_item-conditionamount.
            wa_final-ratval = wa_item-conditionratevalue.
          WHEN 'JOIG'.
            wa_final-igstrate   = wa_item-conditionratevalue.
            wa_final-igstamount = wa_item-conditionamount.
          WHEN 'ZASS' OR 'ZEXF'.
            wa_final-taxablevalue = wa_item-conditionamount.
          WHEN 'JOCG' OR 'JOSG'.
            wa_final-cgstrate   = wa_item-conditionratevalue.
            wa_final-cgstamount = wa_item-conditionamount.
            wa_final-sgstrate   = wa_item-conditionratevalue.
            wa_final-sgstamount = wa_item-conditionamount.
        ENDCASE.

        APPEND wa_final TO lt_final.

      ELSE.

        CASE lv_cond.
          WHEN 'ZPR1' OR 'ZPEX' OR 'ZTRP'.
*            wa_final-rate = wa_final-rate + wa_item-conditionamount.
            wa_final-rate = wa_final-rate + wa_item-conditionrateamount.

          WHEN 'ZFRE'.
            wa_final-freight = wa_item-conditionamount.

          WHEN 'ZDIS' OR 'ZDM1'.
            wa_final-disc = wa_final-disc + wa_item-conditionamount.
            wa_final-ratval = wa_item-conditionratevalue.
          WHEN 'JOIG'.
            wa_final-igstrate   = wa_item-conditionratevalue.
            wa_final-igstamount = wa_item-conditionamount.
          WHEN 'ZASS' OR 'ZEXF' .
            wa_final-taxablevalue = wa_item-conditionamount.
          WHEN 'JOCG' OR 'JOSG'.
            wa_final-cgstrate   = wa_item-conditionratevalue.
            wa_final-cgstamount = wa_item-conditionamount.
            wa_final-sgstrate   = wa_item-conditionratevalue.
            wa_final-sgstamount = wa_item-conditionamount.
        ENDCASE.

        wa_final-totalamountigst = wa_final-taxablevalue + wa_final-igstamount.
        wa_final-totalamountsgst = wa_final-taxablevalue + wa_final-cgstamount + wa_final-sgstamount.
        MODIFY lt_final FROM wa_final INDEX sy-tabix.

      ENDIF.


    ENDLOOP.

    SELECT SINGLE FROM i_salesdocitempricingelement AS a
        FIELDS
        a~salesdocument,
*        a~salesdocumentitem,
        SUM( conditionamount ) AS freight_amt
        WHERE salesdocument = @lv_salesorder AND conditiontype IN ('ZFFS','ZFRE')
        GROUP BY a~salesdocument ", a~salesdocumentitem
        INTO @DATA(ls_freight) PRIVILEGED ACCESS.

    SELECT SINGLE FROM i_salesdocitempricingelement AS a
  FIELDS
    SUM( conditionamount ) AS round_off
  WHERE a~salesdocument = @lv_salesorder AND conditiontype = 'ZDIF'
  INTO @DATA(ls_roundoff) PRIVILEGED ACCESS.

    """""""TCS AMOUNT
    SELECT SINGLE FROM i_salesdocitempricingelement AS a
    FIELDS
    a~salesdocument,
   " a~billingdocumentitem,
    SUM( conditionamount ) AS tcs_amt
    WHERE salesdocument = @lv_salesorder  AND conditiontype IN ('JTC2')
    GROUP BY a~salesdocument ", a~billingdocumentitem
    INTO @DATA(ls_tcs) PRIVILEGED ACCESS.



    DATA : lv_count TYPE i .
    lv_count = 1.

    lv_xml =
   |<Form>| &&
   |<Header>| &&
   |<CompanyName>{ wa_header-plantname1 }</CompanyName>| &&
   |<CompanyAddress>{ lv_plantadd }</CompanyAddress>| &&
   |<PLANTPHONE>{ wa_header-mob_no }</PLANTPHONE>| &&
   |<PLANTGSTIN>{ wa_header-gstin_no }</PLANTGSTIN>| &&
   |<PLANTPAN>{ wa_header-pan_no }</PLANTPAN>| &&
   |<PLANTCIN>{ wa_header-cin_no }</PLANTCIN>| &&
   |<OrderNo>{ wa_header-salesdocument }</OrderNo>| &&
   |<OrderDate>{ wa_header-salesdocumentdate }</OrderDate>| &&
   |<Statename>{ wa_header-state_name }</Statename>| &&
   |<StateCode1>{ wa_header-state_code1 }</StateCode1>| &&
   |<PlaceOfSupply>{ wa_header-state_name }</PlaceOfSupply>| &&
   |<DocumentDate>{ wa_header-salesdocumentdate }</DocumentDate>| &&
   |<DeliveryDate>{ wa_header-requesteddeliverydate }</DeliveryDate>| &&
   |<PhoneNo>{ wa_header-telephonenumber1 }</PhoneNo>| &&
   |<CustomerRefNo>{ wa_header-purchaseorderbycustomer }</CustomerRefNo>| &&
   |<billtoCustomerName>{ wa_billto-customername }</billtoCustomerName>| &&
   |<billtoadd>{ lv_billtoadd }</billtoadd>| &&
   |<billTostatename>{ wa_billto-regionname }</billTostatename>| &&
   |<billtocountry>{ wa_billto-countryname }</billtocountry>| &&
   |<billtostatename2>{ wa_billto-statenameb }</billtostatename2>| &&
   |<billtostateCode>{ lv_statecodeb }</billtostateCode>| &&
   |<billtoGSTIN>{ wa_billto-taxnumber3 }</billtoGSTIN>| &&
   |<shiptoCustomerName>{ wa_shipto-fullname }</shiptoCustomerName>| &&
   |<shiptoaddress>{ lv_shiptoadd }</shiptoaddress>| &&
   |<shiptoStateName>{ wa_shipto-regionname }</shiptoStateName>| &&
   |<shiptoCountry>{ wa_shipto-countryname }</shiptoCountry>| &&
   |<shiptoStateName2>{ wa_shipto-statenames }</shiptoStateName2>| &&
   |<shiptoStateCode>{ lv_statecodes }</shiptoStateCode>| &&
   |<shiptoGSTIN>{ wa_shipto-taxnumber3 }</shiptoGSTIN>| &&
*   |<emailaddress>{ wa_billto-emailaddress }</emailaddress>| &&
   |<emailaddress>{ wa_header-email }</emailaddress>| &&
   |<FOOTERREMARKS>{ lv_remark }</FOOTERREMARKS>| &&
   |</Header>|.


    LOOP AT lt_final INTO DATA(wa_item1).

      wa_item1-totalval_rate = ( wa_item1-orderquantity * wa_item1-rate ) - abs( wa_item1-disc ).

      READ ENTITIES OF i_salesordertp
          ENTITY salesorderitemtext
          FIELDS ( longtext )
          WITH VALUE #(
                (
                  %key = VALUE #(
                      salesorder     = wa_item1-salesdocument
                      salesorderitem = wa_item1-salesdocumentitem
                      language       = 'E'
                      longtextid     = 'Z007'
                  )
                )
          )
          RESULT DATA(lt_text_dataitem)
          FAILED DATA(ls_faileditem)
          REPORTED DATA(ls_reporteditem).

      DATA : lv_remarkitem TYPE string.
      IF lt_text_dataitem IS NOT INITIAL.
        lv_remarkitem = lt_text_dataitem[ 1 ]-longtext.
      ELSE .
        lv_remarkitem = ''.
      ENDIF.



      DATA(lv_xml2) =
        |<Item>| &&
        |<SRNO>{ lv_count }</SRNO>| &&
      |<Itemdetails>{ wa_item1-productlongtext }\n{ lv_remarkitem } { wa_item1-product ALPHA = OUT }</Itemdetails>| &&
        |<Partcode>{ wa_item1-productoldid }</Partcode>| &&
        |<hsn>{ wa_item1-consumptiontaxctrlcode }</hsn>| &&
*        |<QUANTITY>{ wa_item1-schedulelineorderquantity }</QUANTITY>| &&
        |<QUANTITY>{ wa_item1-orderquantity }</QUANTITY>| &&
        |<UNIT>{ wa_item1-orderquantityunit }</UNIT>| &&
        |<RATE>{ wa_item1-rate }</RATE>| &&
        |<Discount>{ wa_item1-ratval DECIMALS = 2 }%\n{ wa_item1-disc }</Discount>| &&
        |<iGSTrate>{ wa_item1-igstrate }</iGSTrate>| &&
        |<iGSTamount>{ wa_item1-igstamount }</iGSTamount>| &&
        |<cGSTrate>{ wa_item1-cgstrate }</cGSTrate>| &&
        |<cGSTamount>{ wa_item1-cgstamount }</cGSTamount>| &&
        |<sGSTrate>{ wa_item1-sgstrate }</sGSTrate>| &&
        |<sGSTamount>{ wa_item1-sgstamount }</sGSTamount>| &&
        |<TOTALFREIGHT>{ ls_freight-freight_amt }</TOTALFREIGHT>| &&
        |<TaxableVal>{ wa_item1-taxablevalue }</TaxableVal>| &&
        |<TotalAmountigst>{ wa_item1-totalamountigst }</TotalAmountigst>| &&
        |<TotalAmountsgst>{ wa_item1-totalamountsgst }</TotalAmountsgst>| &&
        |<ItemCode>{ wa_item1-freight  }</ItemCode>| &&
        |<totalval_rate>{ wa_item1-totalval_rate }</totalval_rate>| &&
        |</Item>|.

      lv_xml = lv_xml && lv_xml2.
      lv_count += 1.
      CLEAR : lv_remarkitem .
    ENDLOOP.

    DATA(lv_xml3) =
      |<FOOTER>| &&
      |<total_tcs>{ ls_tcs-tcs_amt }</total_tcs>| &&
      |<RoundingOff>{ ls_roundoff }</RoundingOff>| &&
      |<Paymentterms>{ wa_footer-paymenttermsname }</Paymentterms>| &&
      |<Preparedby>{ wa_footer-createdbyuser }</Preparedby>| &&
      |</FOOTER>|.


    CONCATENATE lv_xml lv_xml3 '</Form>' INTO lv_xml.

    REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH 'and'.

    CALL METHOD ycl_test_adobe1=>getpdf
      EXPORTING
        template = lc_template_teaxinv
        xmldata  = lv_xml
      RECEIVING
        result   = result.

    RETURN result .

  ENDMETHOD.

ENDCLASS.
