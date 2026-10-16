*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS taxinvoiceclass DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS taxinvoice
      IMPORTING
        request       TYPE REF TO if_web_http_request
        response      TYPE REF TO if_web_http_response
      RETURNING
        VALUE(result) TYPE string .


  PRIVATE SECTION.


ENDCLASS.

CLASS taxinvoiceclass IMPLEMENTATION.


  METHOD taxinvoice.
    DATA lt_xml TYPE string.

    DATA billingdoc TYPE ty_request.
    xco_cp_json=>data->from_string( request->get_text(  ) )->write_to( REF #( billingdoc ) ).
    billingdoc-billingdocument = |{ billingdoc-billingdocument ALPHA = IN }| .
    billingdoc-print = request->get_form_field( 'print' ).
    DATA : lv_flag TYPE c LENGTH 4.


    SELECT SINGLE FROM i_billingdocument
    FIELDS  distributionchannel, salesorganization
    WHERE billingdocument = @billingdoc-billingdocument
    INTO @DATA(lv_trans_details).

    IF lv_trans_details-distributionchannel EQ '33' AND lv_trans_details-salesorganization EQ '1001'.
      result = 'Error: Select Domestic Tax Invoice'.
      RETURN.
    ENDIF.


************HEADER LEVEL *****************

    SELECT SINGLE FROM i_billingdocumentitem AS a
    INNER JOIN zr_table_plant000 AS b ON a~plant = b~plantcode
    LEFT JOIN i_salesordertp AS c ON a~salesdocument = c~salesorder
    LEFT JOIN i_salesdocument AS d ON d~salesdocument = a~salesdocument
    FIELDS
    a~plant,
    b~companyname,
    b~address1,
    b~address2,
    b~address3,
    b~plantname1,
    b~city,b~pin,b~cinno,b~gstinno,b~statename,b~statecode1,b~panno,b~email,b~mobno ,
    c~purchaseorderbycustomer,c~customerpurchaseorderdate,
    d~purchaseorderbycustomer AS order_no , d~customerpurchaseorderdate AS order_date ",c~yy1_contactpersonname_sdh,
   " c~yy1_contactpersonnumbe_sdh,c~yy1_vendorcode_sdh
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO @DATA(header) PRIVILEGED ACCESS .

    SELECT SINGLE FROM i_billingdocument AS a
    LEFT JOIN ztable_irn AS b ON b~billingdocument = a~billingdocument
    FIELDS a~billingdocument ,
           b~ewaybillno , b~ewaydate , b~billingdocumenttype
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO @DATA(wa_ewaybill).

    SELECT SINGLE FROM i_billingdocumentitem AS a
    INNER JOIN ztable_irn AS b ON a~billingdocument = b~billingdocument
    FIELDS
    b~signedqrcode
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO @DATA(qrcode) PRIVILEGED ACCESS.

    DATA address TYPE string.

    DATA: lt_parts1   TYPE STANDARD TABLE OF string,
          lv_address1 TYPE string.

    IF header-address1 IS NOT INITIAL.
      APPEND header-address1 TO lt_parts1.
    ENDIF.

    IF header-address2 IS NOT INITIAL.
      APPEND header-address2 TO lt_parts1.
    ENDIF.

    IF header-address3 IS NOT INITIAL.
      APPEND header-address3 TO lt_parts1.
    ENDIF.

    IF header-city IS NOT INITIAL.
      APPEND header-city TO lt_parts1.
    ENDIF.

    IF header-pin IS NOT INITIAL.
      APPEND header-pin TO lt_parts1.
    ENDIF.

    CONCATENATE LINES OF lt_parts1 INTO lv_address1 SEPARATED BY ', '.

    address = lv_address1.

    TRANSLATE header-companyname TO UPPER CASE.

    lt_xml = |<Form>| &&
             |<OrderNo>{ header-order_no }</OrderNo>| &&
             |<OrderDate>{ header-order_date }</OrderDate>| &&
             |<Plantname>{ header-plantname1 }</Plantname>| &&
             |<Cinno>{ header-cinno } </Cinno>| &&
             |<billAdd>Bill From: { address }</billAdd>| &&
             |<GstNo>{ header-gstinno }</GstNo>| &&
             |<Dispatch>{ header-plant }</Dispatch>| &&
             |<PartyrefNo>{ header-purchaseorderbycustomer }</PartyrefNo>| &&
             |<PartyrefDt>{ header-customerpurchaseorderdate }</PartyrefDt>| &&
             |<Statecode>{ header-statecode1 }</Statecode>| &&
             |<Statename>{ header-statename }</Statename>| &&
             |<Pannoh>{ header-panno }</Pannoh>| &&
             |<Vendorcode></Vendorcode>| &&
             |<INVOICE_TYPE>{ wa_ewaybill-billingdocumenttype }</INVOICE_TYPE>| &&
             |<EWAYBILLNO>{ wa_ewaybill-ewaybillno }</EWAYBILLNO>| &&
             |<EWAYBILL_DATE>{ wa_ewaybill-ewaydate }</EWAYBILL_DATE>| &&
             |<QRCODE>{ qrcode }</QRCODE>| &&
             |<email> { header-email }</email>| &&
             |<PhoneNum>{ header-mobno }</PhoneNum>|.


**********MIDDLE SECIION *****************

    SELECT SINGLE FROM i_billingdocument AS a
    LEFT JOIN zcompanycode AS b ON a~salesorganization = b~company_code
    LEFT JOIN i_customer AS c ON a~soldtoparty = c~customer
    FIELDS
    a~documentreferenceid,
    a~billingdocumentdate,
    a~purchaseorderbycustomer,
    a~soldtoparty,
   " b~lut_no,
    b~address,
    "b~pin,
    c~supplier
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO @DATA(middle) PRIVILEGED ACCESS.

    DATA regd_address TYPE string.

    DATA: lt_parts3       TYPE STANDARD TABLE OF string,
          lv_regd_address TYPE string.

    IF middle-address IS NOT INITIAL.
      APPEND middle-address TO lt_parts3.
    ENDIF.


    CONCATENATE LINES OF lt_parts3 INTO lv_regd_address SEPARATED BY ', '.

    regd_address = lv_regd_address.



    DATA: lv_salesdoc    TYPE vbeln_va,
          remarks        TYPE string,
          lv_header_text TYPE string,
          lv_bill_text   TYPE string.


    SELECT SINGLE
           salesdocument
    FROM i_billingdocumentitem
    WHERE billingdocument = @billingdoc-billingdocument
    INTO @lv_salesdoc.


    READ ENTITIES OF i_billingdocumenttp
    ENTITY billingdocumenttext
    FIELDS ( longtext )
    WITH VALUE #(
          (
            %key = VALUE #(
                billingdocument = billingdoc-billingdocument
                language        = 'E'
                longtextid      = 'ZBL1'
            )
          )
    )
    RESULT DATA(lt_bill_text)
    FAILED DATA(ls_bill_failed)
    REPORTED DATA(ls_bill_reported).

    IF line_exists( lt_bill_text[ 1 ] ).
      lv_bill_text = lt_bill_text[ 1 ]-longtext.
    ENDIF.

    IF lv_bill_text IS INITIAL.

      READ ENTITIES OF i_salesordertp
      ENTITY salesordertext
      FIELDS ( longtext )
      WITH VALUE #(
            (
              %key = VALUE #(
                  salesorder = lv_salesdoc
                  language   = 'E'
                  longtextid = 'ZBL1'
              )
            )
      )
      RESULT DATA(lt_text_data)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

      IF line_exists( lt_text_data[ 1 ] ).
        lv_header_text = lt_text_data[ 1 ]-longtext.
      ENDIF.

    ENDIF.

    IF lv_bill_text IS NOT INITIAL.
      remarks = lv_bill_text.
    ELSEIF lv_header_text IS NOT INITIAL.
      remarks = lv_header_text.
    ELSE .
      remarks = ''.
    ENDIF.


    DATA:lv_pagename TYPE string.

    IF billingdoc-print EQ 'DOM1'.
      lv_pagename = 'ORIGINAL FOR RECIPIENT'.
    ENDIF.
    IF billingdoc-print EQ 'DOM2'.
      lv_pagename = 'DUPLICATE FOR TRANSPORTER'.
    ENDIF.
    IF billingdoc-print EQ 'DOM3'.
      lv_pagename = 'TRIPLICATE FOR SUPPLIER'.
    ENDIF.


    lt_xml = lt_xml &&
             |<RegdAddress>Regd Off: { regd_address }</RegdAddress>| &&
             |<Invoiceno>{ middle-documentreferenceid }</Invoiceno>| &&
             |<Invoicedate>{ middle-billingdocumentdate }</Invoicedate>| &&
             |<UomNo></UomNo>| &&
             |<Vendorcode>{ middle-soldtoparty }</Vendorcode>| &&
             |<REMARKS>{ remarks }</REMARKS>| &&
             |<PAGENAME>{ lv_pagename }</PAGENAME>|.



**************RECIPIENT DETAILS ****************
    SELECT SINGLE FROM i_billingdocumentpartner AS a
    LEFT JOIN i_customer AS b ON a~customer = b~customer
    LEFT JOIN i_address_2 AS c ON b~addressid = c~addressid
    "INNER JOIN I_CountryText AS D ON C~Country = D~Country AND D~Language EQ 'E'
    LEFT JOIN i_regiontext  AS e ON c~country = e~country AND c~region = e~region AND e~language EQ 'E'
    LEFT JOIN i_addressemailaddress_2 AS f ON b~addressid = f~addressid
    FIELDS
    a~customer AS code,
    b~addressid,
    b~businesspartnername1 AS name1,
    substring( b~taxnumber3,1,2 ) AS statecode,
    b~taxnumber3,
    substring( b~taxnumber3,3,10 ) AS panno,
    b~telephonenumber1,
    c~streetname,
    c~streetprefixname1,
    c~streetprefixname2,
    c~districtname,
    c~cityname,
    c~country,
    c~postalcode,
    e~regionname,
    f~emailaddress
    WHERE a~billingdocument = @billingdoc-billingdocument AND a~partnerfunction EQ 'RE'
    INTO @DATA(bottom) PRIVILEGED ACCESS.

    DATA address1 TYPE string.

    DATA: lt_parts   TYPE STANDARD TABLE OF string,
          lv_address TYPE string.

    IF bottom-streetname IS NOT INITIAL.
      APPEND bottom-streetname TO lt_parts.
    ENDIF.

    IF bottom-streetprefixname1 IS NOT INITIAL.
      APPEND bottom-streetprefixname1 TO lt_parts.
    ENDIF.

    IF bottom-streetprefixname2 IS NOT INITIAL.
      APPEND bottom-streetprefixname2 TO lt_parts.
    ENDIF.

    IF bottom-districtname IS NOT INITIAL.
      APPEND bottom-districtname TO lt_parts.
    ENDIF.

    IF bottom-cityname IS NOT INITIAL.
      APPEND bottom-cityname TO lt_parts.
    ENDIF.

    IF bottom-postalcode IS NOT INITIAL.
      APPEND bottom-postalcode TO lt_parts.
    ENDIF.

    CONCATENATE LINES OF lt_parts INTO lv_address SEPARATED BY ', '.

    address1 = lv_address.

    CONCATENATE bottom-streetname bottom-streetprefixname1 bottom-streetprefixname2 bottom-districtname
    bottom-cityname bottom-postalcode INTO address1 SEPARATED BY ', '.

    lt_xml = lt_xml &&
             |<billto>| &&
             |<Name_bill>{ bottom-name1 }</Name_bill>| &&
             |<bill_code>{ bottom-code }</bill_code>| &&
             |<billAdd>{ address1 }</billAdd>| &&
             |<Statename>{ bottom-regionname }</Statename>| &&
             |<Statecode>{ bottom-statecode }</Statecode>| &&
             |<gstno_bill>{ bottom-taxnumber3 }</gstno_bill>| &&
             |<PannoB>{ bottom-panno }</PannoB>| &&
             |<Contact_bill>{ bottom-telephonenumber1 }</Contact_bill>| &&
             |</billto>|.

************** CONSIGNEE DETAIL *****************
    SELECT SINGLE FROM i_billingdocitempartner AS a
    LEFT JOIN i_customer AS b ON a~customer = b~customer
    LEFT JOIN i_address_2 AS c ON b~addressid = c~addressid
    "INNER JOIN I_CountryText AS D ON C~Country = D~Country AND D~Language EQ 'E'
    LEFT JOIN i_regiontext AS e ON c~country = e~country AND c~region = e~region AND  e~language EQ 'E'
    "LEFT JOIN I_AddressEmailAddress_2 AS F ON B~AddressID = F~AddressID
    FIELDS
    a~customer AS code1,
    b~businesspartnername1 AS name2,
    substring( b~taxnumber3 ,1,2 ) AS statecode,
    b~taxnumber3 AS gstin,
    substring( b~taxnumber3,3,10 ) AS panno,
    b~telephonenumber1,
    b~cityname AS transcity,
    c~streetname,
    c~streetprefixname1,
    c~streetprefixname2,
    c~districtname,
    c~cityname,
    c~postalcode,
    c~country,
    e~regionname
    "F~EmailAddress
    WHERE a~billingdocument = @billingdoc-billingdocument AND a~partnerfunction EQ 'WE'
    INTO @DATA(bottom1) PRIVILEGED ACCESS.

    DATA address2 TYPE string .

    DATA: lt_parts2   TYPE STANDARD TABLE OF string,
          lv_address2 TYPE string.

    IF bottom1-streetname IS NOT INITIAL.
      APPEND bottom1-streetname TO lt_parts2.
    ENDIF.

    IF bottom1-streetprefixname1 IS NOT INITIAL.
      APPEND bottom1-streetprefixname1 TO lt_parts2.
    ENDIF.

    IF bottom1-streetprefixname2 IS NOT INITIAL.
      APPEND bottom1-streetprefixname2 TO lt_parts2.
    ENDIF.

    IF bottom1-districtname IS NOT INITIAL.
      APPEND bottom1-districtname TO lt_parts2.
    ENDIF.

    IF bottom1-cityname IS NOT INITIAL.
      APPEND bottom1-cityname TO lt_parts2.
    ENDIF.

    IF bottom1-postalcode IS NOT INITIAL.
      APPEND bottom1-postalcode TO lt_parts2.
    ENDIF.

    CONCATENATE LINES OF lt_parts2 INTO lv_address2 SEPARATED BY ', '.

    address2 = lv_address2.

*CONCATENATE bottom1-StreetName bottom1-StreetPrefixName1 bottom1-StreetPrefixName2 bottom1-DistrictName
*bottom1-CityName bottom1-PostalCode INTO address2 SEPARATED BY ', '.

    lt_xml = lt_xml &&
             |<shipto>| &&
             |<Name_ship>{ bottom1-name2 }</Name_ship>| &&
             |<ship_code>{ bottom1-code1 }</ship_code>| &&
             |<Location>Location</Location>| &&
             |<shipAdd>{ address2 }</shipAdd>| &&
             |<Statename>{ bottom1-regionname }</Statename>| &&
             |<Statecode>{ bottom1-statecode }</Statecode>| &&
             |<gstno_ship>{ bottom1-gstin }</gstno_ship>| &&
             |<Panno_con>{ bottom1-panno }</Panno_con>| &&
             |<Contactdetails_ship>{ bottom1-telephonenumber1 }</Contactdetails_ship>| &&
             |<contactperson></contactperson>| &&
             |<contactnum></contactnum>| &&
             |</shipto>|  .


**************** 4th section of tax inv  **********************

    SELECT SINGLE FROM ztable_irn AS a
    INNER JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
    INNER JOIN zr_table_plant000 AS c ON b~plant = c~plantcode
    FIELDS
    a~irnno,
    a~address,
    a~place,a~pincode,a~state,a~statecode,
    a~ackno, a~ackdate, a~ewaybillno,a~ewaydate
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO @DATA(dispatch) PRIVILEGED ACCESS.

    DATA dis_add TYPE string.

    DATA: lt_dispatch TYPE STANDARD TABLE OF string,
          lv_dis_add  TYPE string.

    IF dispatch-address IS NOT INITIAL.
      APPEND dispatch-address TO lt_dispatch.
    ENDIF.

    IF dispatch-place IS NOT INITIAL.
      APPEND dispatch-place TO lt_dispatch.
    ENDIF.

    IF dispatch-pincode IS NOT INITIAL.
      APPEND dispatch-pincode TO lt_dispatch.
    ENDIF.


    CONCATENATE LINES OF lt_dispatch INTO lv_dis_add SEPARATED BY ','.

    dis_add = lv_dis_add.

    CONCATENATE dispatch-address dispatch-place dispatch-pincode INTO dis_add SEPARATED BY ','.


    SELECT SINGLE FROM i_billingdocument AS a
    FIELDS a~billingdocument , a~yy1_irn_bdh , a~yy1_ewaybill_bdh , a~yy1_ewaybill_date_bdh ,
           a~yy1_acknowledgement_bdh , a~yy1_acknowledgement_dt_bdh
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO @DATA(wa_customirn).

    DATA: lv_irnno    TYPE string,
          lv_ackno    TYPE string,
          lv_ackdate  TYPE string,
          lv_ewayno   TYPE string,
          lv_ewaydate TYPE string.

    IF dispatch-irnno IS INITIAL.

      lv_irnno    = wa_customirn-yy1_irn_bdh.
      lv_ackno    = wa_customirn-yy1_acknowledgement_bdh.
      lv_ackdate  = wa_customirn-yy1_acknowledgement_dt_bdh.
      lv_ewayno   = wa_customirn-yy1_ewaybill_bdh.
      lv_ewaydate = wa_customirn-yy1_ewaybill_date_bdh.

    ELSE.

      lv_irnno    = dispatch-irnno.
      lv_ackno    = dispatch-ackno.
      lv_ackdate  = dispatch-ackdate.
      lv_ewayno   = dispatch-ewaybillno.
      lv_ewaydate = dispatch-ewaydate.

    ENDIF.

    lt_xml = lt_xml &&
             |<dispatch>| &&
             |<IRNO>{ lv_irnno }</IRNO>| &&
             |<ACKNO>{ lv_ackno }</ACKNO>| &&
             |<ACKDATE>{ lv_ackdate }</ACKDATE>| &&
             |<EWAYNO>{ lv_ewayno }</EWAYNO>| &&
             |<EWAYDATE>{ lv_ewaydate }</EWAYDATE>| &&
             |<DISADD>{ dis_add }</DISADD>| &&
             |</dispatch>| &&
             |<it_items>| .



*********************IT ITEM*************************

    SELECT FROM i_billingdocumentitemprcgelmnt
    FIELDS
    billingdocument,
    billingdocumentitem,
    conditiontype,
    conditionratevalue,
    conditionquantity,
    conditionamount
    WHERE billingdocument = @billingdoc-billingdocument AND conditiontype IN ('ZEXF' , 'ZASS' ,'ZPEX' , 'ZTRP' , 'ZPR1', 'ZDIS' ,'JOSG' ,'JOCG' ,'JOIG', 'JOUG' ,'ZFRT' ,'ZPAC' , 'ZINS' ,'ZDIF' , 'ZOCG' , 'ZOSG', 'ZFST' )
    INTO TABLE @DATA(ls_it) PRIVILEGED ACCESS.


    SELECT SINGLE FROM i_billingdocumentitemprcgelmnt AS a
    FIELDS
    a~billingdocument,
    a~billingdocumentitem,
    SUM( conditionamount ) AS freight_amt
    WHERE billingdocument = @billingdoc-billingdocument AND conditiontype IN ('ZFRN','ZFRT','ZFFS')
    GROUP BY a~billingdocument , a~billingdocumentitem
    INTO @DATA(ls_freight) PRIVILEGED ACCESS.

    SELECT SINGLE FROM i_billingdocumentitemprcgelmnt AS a
    FIELDS
    a~billingdocument,
   " a~billingdocumentitem,
    SUM( conditionamount ) AS tcs_amt
    WHERE billingdocument = @billingdoc-billingdocument AND conditiontype IN ('JTC2')
    GROUP BY a~billingdocument ", a~billingdocumentitem
    INTO @DATA(ls_tcs) PRIVILEGED ACCESS.

    SELECT FROM i_billingdocumentitem AS a
    INNER JOIN i_productdescription AS b ON a~product = b~product
    INNER JOIN i_productplantbasic AS c ON a~product = c~product AND a~plant = c~plant
    INNER JOIN i_unitofmeasure AS e ON a~billingquantityunit = e~unitofmeasure
    INNER JOIN i_product AS f ON f~product = a~product
    LEFT JOIN i_productbasictexttp_2 AS g ON g~product = a~product
    FIELDS
    a~billingdocument,
    a~billingdocumentitem,
    a~billingquantity,
    a~baseunit,
    a~product,
    a~salesdocumentitemcategory,
    a~salesdocument,
    a~salesdocumentitem,
    b~productdescription,
    c~consumptiontaxctrlcode,
    e~unitofmeasure_e,
    f~productoldid,
    g~productlongtext
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO TABLE  @DATA(it_item)  PRIVILEGED ACCESS.

    SORT it_item BY billingdocumentitem ASCENDING.

    DATA: rate         TYPE p DECIMALS 2,
          taxable_amt  TYPE p DECIMALS 2,
          otherchr     TYPE p DECIMALS 2 VALUE 0,
          frightchr    TYPE p DECIMALS 2 VALUE 0,
          packchr      TYPE p DECIMALS 2 VALUE 0,
          insurchr     TYPE p DECIMALS 2 VALUE 0,
          net_mat      TYPE p DECIMALS 2 VALUE 0,
          cgst         TYPE i_billingdocumentprcgelmnt-conditionratevalue VALUE 0,
          cgst_amt     TYPE i_billingdocumentprcgelmnt-conditionamount VALUE 0,
          sgst         TYPE i_billingdocumentprcgelmnt-conditionratevalue VALUE 0,
          sgst_amt     TYPE i_billingdocumentprcgelmnt-conditionamount VALUE 0,
          igst         TYPE i_billingdocumentprcgelmnt-conditionratevalue VALUE 0,
          igst_amt     TYPE i_billingdocumentprcgelmnt-conditionamount VALUE 0,
          ugst         TYPE i_billingdocumentprcgelmnt-conditionratevalue VALUE 0,
          ugst_amt     TYPE i_billingdocumentprcgelmnt-conditionamount VALUE 0,
          smpldis      TYPE i_billingdocumentprcgelmnt-conditionamount VALUE 0,
          tot_mat      TYPE p DECIMALS 2,
          discount     TYPE p DECIMALS 2,
          discountrate TYPE p DECIMALS 2,
          temp         TYPE p DECIMALS 2 VALUE 0,
          qty          TYPE i_billingdocumentitem-billingquantity,
          unit         TYPE i_billingdocumentitem-baseunit,
          hsn          TYPE i_productplantbasic-consumptiontaxctrlcode,
          roundoff     TYPE p DECIMALS 2 VALUE 0,
          tot_tax_amt  TYPE p DECIMALS 2 VALUE 0,
          icgsttemp    TYPE string VALUE 'IGST',
          sugsttemp    TYPE string VALUE 'SGST',
          temprate     TYPE i_billingdocumentprcgelmnt-conditionratevalue,
          tempamt      TYPE i_billingdocumentprcgelmnt-conditionamount,
          temprate_su  TYPE i_billingdocumentprcgelmnt-conditionratevalue,
          tempamt_su   TYPE i_billingdocumentprcgelmnt-conditionamount,
          taxableamt   TYPE p DECIMALS 2.

    SELECT FROM i_billingdocument AS a
          LEFT JOIN i_billingdocumentitem AS b ON b~billingdocument = a~billingdocument
          LEFT JOIN i_serialnumberdeliverydocument AS c ON c~deliverydocument = b~referencesddocument
                                                       AND c~deliverydocumentitem = b~referencesddocumentitem
          LEFT JOIN i_serialnumbermaterialdoc_2 AS d ON d~serialnumber = c~serialnumber AND d~equipment = c~equipment
          LEFT JOIN i_materialdocumentitemtp AS e ON e~materialdocument = d~materialdocument AND e~materialdocumentitem = d~materialdocumentitem
                                             AND e~materialdocumentyear = d~materialdocumentyear
          LEFT JOIN i_customer AS f ON f~customer = a~soldtoparty
          LEFT JOIN zdbmanusrspp AS g ON g~serialno = c~serialnumber
          LEFT JOIN zmnufctresermm AS h ON h~serial_no = c~serialnumber
          FIELDS a~billingdocument ,
                 b~billingdocumentitem ,
                 c~serialnumber  ,
                 e~yy1_mfrserialno_mmi ,
                 f~region,
                 g~serialno AS pp_sernum ,  g~place , g~model , g~make , g~yers , g~machineno , g~state ,
                 h~mfr_serialno
          WHERE a~billingdocument = @billingdoc-billingdocument
          AND c~serialnumber IS NOT INITIAL
          INTO TABLE @DATA(it_serial_num)
          PRIVILEGED ACCESS.

    SORT it_serial_num BY serialnumber yy1_mfrserialno_mmi DESCENDING.
    DELETE ADJACENT DUPLICATES FROM it_serial_num COMPARING serialnumber.


    LOOP AT it_item INTO DATA(ls_item).


      IF ls_item-salesdocumentitemcategory EQ 'CB99'.
        CONTINUE.
      ENDIF.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZDIF' INTO DATA(drd1_ls_price).

      roundoff = roundoff + drd1_ls_price-conditionamount .



      READ TABLE ls_it INTO DATA(zpr0_ls_price) WITH KEY billingdocument     = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZPR1'.
      READ TABLE ls_it INTO DATA(zpr0_ls_price2) WITH KEY billingdocument     = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZPEX'.
      READ TABLE ls_it INTO DATA(zpr0_ls_price3) WITH KEY billingdocument     = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZTRP'.
      IF zpr0_ls_price-conditionratevalue <> 0.
        rate = zpr0_ls_price-conditionratevalue.
      ELSEIF zpr0_ls_price2-conditionratevalue <> 0.
        rate = zpr0_ls_price2-conditionratevalue.
      ELSEIF zpr0_ls_price3-conditionratevalue <> 0.
        rate = zpr0_ls_price3-conditionratevalue.
      ELSE.
        rate = 0.
      ENDIF.



      READ TABLE ls_it INTO DATA(ls_taxable) WITH KEY billingdocument     = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZASS'.
      READ TABLE ls_it INTO DATA(ls_taxable2) WITH KEY billingdocument     = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZEXF'.

      DATA : tax_val_amt TYPE i_billingdocumentitemprcgelmnt-conditionamount.
      IF ls_taxable-conditionamount <> 0.
        tax_val_amt = ls_taxable-conditionamount .
      ELSE .
        tax_val_amt = ls_taxable2-conditionamount .
      ENDIF.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZDIS' INTO DATA(zdis_ls_price).
      discount = zdis_ls_price-conditionamount.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZDIS' INTO DATA(zdis_ls_amt).
      discountrate = zdis_ls_price-conditionratevalue.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZFRT' INTO DATA(zfrt_ls_price).
      frightchr = frightchr + zfrt_ls_price-conditionamount .
      otherchr = otherchr + zfrt_ls_price-conditionamount .

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZPAC' INTO DATA(zpac_ls_price).
      packchr = packchr + zpac_ls_price-conditionamount .
      otherchr = otherchr + zpac_ls_price-conditionamount .

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZINS' INTO DATA(zins_ls_price).
      insurchr = insurchr + zins_ls_price-conditionamount .
      otherchr = otherchr + zins_ls_price-conditionamount .

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'JOIG'   INTO DATA(joig_ls_price).
      igst = igst + joig_ls_price-conditionratevalue.
      igst_amt = igst_amt + joig_ls_price-conditionamount.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'JOCG' INTO DATA(jocg_ls_price).
      cgst = cgst + jocg_ls_price-conditionratevalue.
      cgst_amt = cgst_amt + jocg_ls_price-conditionamount.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZOCG' INTO DATA(jocg_ls_price4).
      cgst = cgst + jocg_ls_price4-conditionratevalue.
      cgst_amt = cgst_amt + jocg_ls_price4-conditionamount.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'JOSG' INTO DATA(josg_ls_price).
      sgst = sgst + josg_ls_price-conditionratevalue.
      sgst_amt = sgst_amt + josg_ls_price-conditionamount.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZOSG' INTO DATA(josg_ls_price4).
      sgst = sgst + josg_ls_price4-conditionratevalue.
      sgst_amt = sgst_amt + josg_ls_price4-conditionamount.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'JOUG' INTO DATA(joug_ls_price).
      ugst = ugst + joug_ls_price-conditionratevalue.
      ugst_amt = ugst_amt + joug_ls_price-conditionamount.

      READ TABLE ls_it WITH KEY billingdocument = ls_item-billingdocument billingdocumentitem = ls_item-billingdocumentitem conditiontype = 'ZOUG' INTO DATA(joug_ls_price4).
      ugst = ugst + joug_ls_price4-conditionratevalue.
      ugst_amt = ugst_amt + joug_ls_price4-conditionamount.


*READ TABLE ls_it WITH KEY BillingDocument = ls_item-BillingDocument BillingDocumentItem = ls_item-BillingDocumentItem ConditionType = 'ZFST' INTO DATA(SAMPLEDIS).
*IF SY-subrc = 0.
*SMPLDIS = SMPLDIS + sampledis-ConditionAmount.
*ENDIF.

      tot_tax_amt = tot_tax_amt + igst_amt + sgst_amt + cgst_amt .

      IF igst_amt > 0.
        DATA : igstr TYPE p DECIMALS 2,
               igsta TYPE p DECIMALS 2.
        icgsttemp = 'IGST'.
        igstr = igst.
        igsta = igst_amt.
        lv_flag = 'IGST'.
      ENDIF.

      IF cgst_amt > 0 .
        icgsttemp = 'CGST'.
        temprate = cgst.
        tempamt = cgst_amt.
        lv_flag = 'CGST'.
      ENDIF.

      IF sgst_amt > 0.
        sugsttemp = 'SGST'.
        temprate_su = sgst.
        tempamt_su = sgst_amt.
      ENDIF.

      IF ugst_amt > 0.
        sugsttemp = 'UGST'.
        temprate_su = ugst.
        tempamt_su = ugst_amt.
      ENDIF.

      ls_item-product = |{ ls_item-product ALPHA = OUT }|.

      tot_mat = tax_val_amt.


      DATA : lv_desc TYPE string.
      IF ls_item-productlongtext IS NOT INITIAL.
        lv_desc = ls_item-productlongtext.
      ELSE.
        lv_desc = ls_item-productdescription.
      ENDIF.


      DATA : lv_item_text      TYPE string,
             lv_bill_item_text TYPE string.

      READ ENTITIES OF i_billingdocumenttp
      ENTITY billingdocumentitemtext
      FIELDS ( longtext )
      WITH VALUE #(
            (
              %key = VALUE #(
                  billingdocument     = billingdoc-billingdocument
                  billingdocumentitem = ls_item-billingdocumentitem
                  language            = 'E'
                  longtextid          = '0001'
              )
            )
      )
      RESULT DATA(lt_bill_item_text)
      FAILED DATA(ls_failed_bill_item)
      REPORTED DATA(ls_reported_bill_item).

      IF line_exists( lt_bill_item_text[ 1 ] ).
        lv_bill_item_text = lt_bill_item_text[ 1 ]-longtext.
      ENDIF.

      IF lv_bill_item_text IS INITIAL.

        READ ENTITIES OF i_salesordertp
        ENTITY salesorderitemtext
        FIELDS ( longtext )
        WITH VALUE #(
              (
                %key = VALUE #(
                    salesorder     = ls_item-salesdocument
                    salesorderitem = ls_item-salesdocumentitem
                    language       = 'E'
                    longtextid     = 'Z007'
                )
              )
        )
        RESULT DATA(lt_text_dataitem)
        FAILED DATA(ls_faileditem)
        REPORTED DATA(ls_reporteditem).

        IF line_exists( lt_text_dataitem[ 1 ] ).
          lv_item_text = lt_text_dataitem[ 1 ]-longtext.
        ENDIF.

      ENDIF.

      IF lv_bill_item_text IS NOT INITIAL.
        lv_item_text = lv_bill_item_text.
      ENDIF.


      lt_xml = lt_xml &&
               |<body_item>| &&
               |<itemcode>{ ls_item-product }</itemcode>| &&
               |<PartCode>{ ls_item-productoldid }</PartCode>| &&
               |<desciption>{ ls_item-product }\n{ lv_desc }\n{ lv_item_text }</desciption>| &&
               |<hsncode>{ ls_item-consumptiontaxctrlcode }</hsncode>| &&
               |<qty>{ ls_item-billingquantity }</qty>| &&
               |<uNIT>{ ls_item-unitofmeasure_e }</uNIT>| &&
               |<rate>{ rate }</rate>| &&
               |<discount>{ discountrate }%\n{ discount }</discount>| &&
               |<SERNO>|.

      DATA: lv_mfr_ser_num TYPE string,
            lv_last5       TYPE string,
            lv_len         TYPE i,
            lv_offset      TYPE i,
            lv_mfr_year    TYPE string,
            lt_xml2        TYPE string.

      CLEAR lt_xml2.

**********************************************************************SERIAL NUMBER STARTS

      LOOP AT it_serial_num INTO DATA(wa_serial_num)
     WHERE billingdocumentitem = ls_item-billingdocumentitem.
        IF wa_serial_num-yers IS NOT INITIAL.
          lv_mfr_year = wa_serial_num-yers.
        ELSE .
          lv_mfr_year = ''.
        ENDIF.

        IF wa_serial_num-serialnumber IS NOT INITIAL.
          lv_len = strlen( wa_serial_num-serialnumber ).

          IF lv_len > 5.
            lv_offset = lv_len - 5.
            lv_last5 = wa_serial_num-serialnumber+lv_offset(5).
          ELSE.
            lv_last5 = wa_serial_num-serialnumber.
          ENDIF.

        ENDIF.

        IF wa_serial_num-yy1_mfrserialno_mmi IS NOT INITIAL.
          CONCATENATE wa_serial_num-yy1_mfrserialno_mmi lv_last5 INTO lv_mfr_ser_num.
        ELSEIF wa_serial_num-pp_sernum IS NOT INITIAL AND wa_serial_num-region EQ 'UP'.
          CONCATENATE wa_serial_num-place '/' wa_serial_num-model '/' wa_serial_num-make '/'
             lv_mfr_year '/' wa_serial_num-machineno '/' wa_serial_num-state INTO lv_mfr_ser_num.
        ELSEIF wa_serial_num-pp_sernum IS NOT INITIAL AND wa_serial_num-region NE 'UP' .
          CONCATENATE wa_serial_num-place '/' wa_serial_num-model '/' wa_serial_num-make '/'
              lv_mfr_year '/' wa_serial_num-machineno INTO lv_mfr_ser_num.
        ELSE.
          lv_mfr_ser_num = wa_serial_num-mfr_serialno.
        ENDIF.

        SHIFT wa_serial_num-serialnumber LEFT DELETING LEADING '0'.

        lt_xml2 =
            |<row>| &&
               |<MFR_SER_NO>{ lv_mfr_ser_num }</MFR_SER_NO>| &&
               |<ser_num>{ wa_serial_num-serialnumber }</ser_num>| &&
           |</row>|.
        CONCATENATE lt_xml lt_xml2 INTO lt_xml.
        CLEAR:  wa_serial_num , lv_mfr_ser_num , lv_offset , lv_len , lv_last5 , lv_mfr_year.
      ENDLOOP.

      IF lt_xml2 IS INITIAL.
        lt_xml = lt_xml &&
        |<row>| &&
        |<MFR_SER_NO></MFR_SER_NO>| &&
        |<ser_num></ser_num>| &&
        |</row>|.
      ENDIF.

**********************************************************************SERIAL NUMBER END

      lt_xml = lt_xml &&
            |</SERNO>| &&
            |<net_mat_rate>{ rate - discount }</net_mat_rate>| &&
            |<total_mat>{ tot_mat }</total_mat>| &&
            |<taxableamount>{ tax_val_amt }</taxableamount>| &&
            |<otherchr>{ otherchr }</otherchr>| &&
            |<igstrate>{ igstr }</igstrate>| &&
            |<igstamt>{ igsta }</igstamt>| &&
            |<cgstrate>{ temprate }</cgstrate>| &&
            |<cgstamount>{ tempamt }</cgstamount>| &&
            |<sgstrate>{ temprate_su }</sgstrate>| &&
            |<sgstamount>{ tempamt_su }</sgstamount>| &&
            |</body_item>|.
      temp = temp + otherchr .


      CLEAR: otherchr, cgst , cgst_amt, igst, igst_amt ,sgst, sgst_amt, temprate ,tempamt, temprate_su,tempamt_su,taxableamt ,
             tax_val_amt , lv_desc , lv_item_text  , lv_bill_item_text , discount.
      CLEAR: zdis_ls_price, zdis_ls_amt, zfrt_ls_price, zpac_ls_price, zins_ls_price,
       joig_ls_price, jocg_ls_price, jocg_ls_price4, josg_ls_price, josg_ls_price4,
       joug_ls_price, joug_ls_price4.

    ENDLOOP.

*********bank footer and transport details*************************


    SELECT SINGLE FROM i_billingdocument AS a
    INNER JOIN ztable_irn AS b ON a~billingdocument = b~billingdocument
    LEFT JOIN i_billingdocumenttp AS c ON a~billingdocument = c~billingdocument
    LEFT JOIN i_paymenttermstext AS d ON d~paymentterms = a~customerpaymentterms AND d~language EQ 'E'
*    LEFT JOIN zdt_bnkdetls as d on d~accountno =
*    LEFT JOIN
    FIELDS
    a~incotermsclassification,
    b~vehiclenum,
    b~transportername,
    b~transportmode,
    b~grno,
    b~grdate ,
    d~paymenttermsname
   " c~yy1_billingremarks_bdh,
    "c~yy1_freightbasis_bdh
    WHERE a~billingdocument = @billingdoc-billingdocument
    INTO @DATA(transport) PRIVILEGED ACCESS.


    SELECT SINGLE FROM zdt_bnkdetls AS a
    FIELDS a~accountno , a~bankdetails , a~ifsc , a~micr , a~rtgs
    INTO @DATA(wa_bankdet).


    lt_xml = lt_xml && |</it_items>| &&
             |<bank_transport>| &&
             |<icgst>{ icgsttemp }</icgst>| &&
             |<usgst>{ sugsttemp }</usgst>| &&
             |<otherchr>{ temp }</otherchr>| &&
             |<packchr>{ packchr }</packchr>| &&
             |<insurchr>{ insurchr }</insurchr>| &&
             |<transporter>{ transport-transportername }</transporter>| &&
             |<vehicle>{ transport-vehiclenum }</vehicle>| &&
             |<fromplace>{ header-city }</fromplace>| &&
             |<toplace>{ bottom1-transcity }</toplace>| &&
             |<firghtchr></firghtchr>| &&
             |<lrno>{ transport-grno }</lrno>| &&
             |<lrdt>{ transport-grdate }</lrdt>| &&
             |<packagedetail></packagedetail>| &&
             |<totgstamt>{ tot_tax_amt }</totgstamt>| &&
             |<roundoff>{ roundoff }</roundoff>| &&
             |<total_freight>{ ls_freight-freight_amt }</total_freight>| &&
             |<total_tcs>{ ls_tcs-tcs_amt }</total_tcs>| &&
             |<bankname>{ wa_bankdet-bankdetails }</bankname>| &&
             |<ifsc>{ wa_bankdet-ifsc }</ifsc>| &&
             |<ACno>{ wa_bankdet-accountno }</ACno>| &&
             |<RTGS>{ wa_bankdet-rtgs }</RTGS>| &&
             |<MICR>{ wa_bankdet-micr }</MICR>| &&
             |<PaymentDueOn></PaymentDueOn>| &&
             |<PaymentTerms>{ transport-paymenttermsname }</PaymentTerms>| &&
             |<deliveryterms>Delivery Terms: { transport-incotermsclassification }</deliveryterms>| &&
             |<transmode>Mode of Transport{ transport-transportmode }</transmode>| &&
             |<cartonNO>No. of Cartons: </cartonNO>| &&
             |</bank_transport>| &&
             |<it_item2>|.

    CLEAR: frightchr , otherchr , packchr , insurchr, roundoff ,ls_item , lv_pagename.


************************bank details *************************


    lt_xml = lt_xml &&
             |</it_item2>| &&
             |<lutno></lutno>| &&
             |<lutdt></lutdt>| &&
             |</Form>|.

    REPLACE ALL OCCURRENCES OF '&' IN lt_xml WITH 'AND'.
    REPLACE ALL OCCURRENCES OF '༯' IN lt_xml WITH '/'.
    REPLACE ALL OCCURRENCES OF '\u00A0' IN lt_xml WITH space.
    REPLACE ALL OCCURRENCES OF PCRE '[\x00-\x08\x0B\x0C\x0E-\x1F]' IN lt_xml WITH ''.
    REPLACE ALL OCCURRENCES OF PCRE '\xA0' IN lt_xml WITH ' '.


    DATA : lc_template_teaxinv TYPE string.

    IF lv_flag = 'IGST'.
      lc_template_teaxinv = 'ZSD_TAX_INV_IGST/ZSD_TAX_INV_IGST'.
    ELSEIF lv_flag = 'CGST'.
      lc_template_teaxinv = 'ZSD_TAX_INV_CGST/ZSD_TAX_INV_CGST'.
    ELSE.
      lc_template_teaxinv = 'ZSD_TAX_INV_IGST/ZSD_TAX_INV_IGST'.
    ENDIF.

    CALL METHOD ycl_test_adobe1=>getpdf(
      EXPORTING
        template = lc_template_teaxinv
        xmldata  = lt_xml
      RECEIVING
        result   = result
    ).

    RETURN result .


  ENDMETHOD.

ENDCLASS.
