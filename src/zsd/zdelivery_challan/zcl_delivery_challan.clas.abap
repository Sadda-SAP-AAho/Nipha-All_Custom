CLASS zcl_delivery_challan DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-DATA : accesses_token TYPE string.
    CLASS-DATA: xml_file TYPE string.
    TYPES :
      BEGIN OF struct,
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
        RAISING   cx_static_check ,

      read_posts
        IMPORTING
                  lv_po2          TYPE string
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check.




  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.jp10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://dev-tcul4uw9.authentication.jp10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'ZDELIVERY_CHALLAN/ZDELIVERY_CHALLAN'.


ENDCLASS.



CLASS ZCL_DELIVERY_CHALLAN IMPLEMENTATION.


  METHOD read_posts.

    DATA bill_doc TYPE c LENGTH 10.
    bill_doc =  lv_po2.

    bill_doc = |{ bill_doc ALPHA = IN }|.

    SELECT SINGLE FROM i_billingdocument AS a
    LEFT JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
    LEFT JOIN ztable_plant AS c ON b~plant = c~plant_code AND b~companycode = c~comp_code
    LEFT JOIN i_salesorder AS d ON d~salesorder = b~salesdocument
    LEFT JOIN zr_irn AS e ON a~billingdocument = e~billingdocument
    LEFT JOIN i_paymenttermstext AS f ON f~paymentterms = a~customerpaymentterms AND f~language = 'E'
    LEFT JOIN i_billingdocumenttp AS g ON g~billingdocument = a~billingdocument
    FIELDS
      a~billingdocument,
      a~documentreferenceid,
      a~creationdate,
      a~customerpaymentterms,
      a~billingdocumenttype,
      a~yy1_ewaybill_bdh,
      a~yy1_ewaybill_date_bdh,
      b~plant,
      b~salesdocument,
      a~incotermsclassification,
      c~plant_name1,
      c~cin_no,
      c~address1,
      c~address2,
      c~address3,
      c~city,
      c~pin,
      c~state_name,
      c~country,
      c~gstin_no,
      c~state_code1,
      c~pan_no,
      c~email,
      c~mob_no,
      c~company_name,
      d~purchaseorderbycustomer,
      d~customerpurchaseorderdate,
      e~transportername,
      e~vehiclenum,
      e~ewaybillno,
      e~transportmode,
      e~transportergstin,
      e~ackno,
      e~ackdate,
      e~ewaydate,
      e~address,
      e~place,
      e~pincode,
      e~grno,
      e~grdate,
      f~paymenttermsname,
      g~yy1_cnoteno_bdh,
      g~yy1_esealno_bdh,
      g~yy1_cnotedate_bdh,
      g~yy1_salestype_bdh
    WHERE a~billingdocument = @bill_doc
    INTO @DATA(ls_header)
    PRIVILEGED ACCESS.





    DATA: lt_plant_addr TYPE TABLE OF string.
    IF ls_header-address1   IS NOT INITIAL. APPEND ls_header-address1   TO lt_plant_addr. ENDIF.
    IF ls_header-address2   IS NOT INITIAL. APPEND ls_header-address2   TO lt_plant_addr. ENDIF.
    IF ls_header-address3   IS NOT INITIAL. APPEND ls_header-address3   TO lt_plant_addr. ENDIF.
    IF ls_header-city       IS NOT INITIAL. APPEND ls_header-city       TO lt_plant_addr. ENDIF.
    IF ls_header-pin        IS NOT INITIAL. APPEND ls_header-pin        TO lt_plant_addr. ENDIF.
    IF ls_header-state_name IS NOT INITIAL. APPEND ls_header-state_name TO lt_plant_addr. ENDIF.
    IF ls_header-country    IS NOT INITIAL. APPEND ls_header-country    TO lt_plant_addr. ENDIF.

    DATA(lv_plant_address) = concat_lines_of( table = lt_plant_addr sep = ', ' ).




    SELECT SINGLE
    FROM i_billingdocumentitem  AS a
    LEFT JOIN i_deliverydocument  AS b ON  a~referencesddocument = b~deliverydocument
    LEFT JOIN i_shippingtypetext  AS c ON   b~shippingtype  = c~shippingtypename  AND language     = 'E'
    FIELDS
    a~referencesddocument,
    b~actualgoodsmovementdate,
    b~shippingtype,
    c~shippingtypename
       WHERE billingdocument = @bill_doc
      INTO @DATA(lv_mode_of_transport)
      PRIVILEGED ACCESS.


    IF lv_mode_of_transport-shippingtypename IS INITIAL.
      lv_mode_of_transport-shippingtypename =  ls_header-transportmode .
    ENDIF.


    SELECT SINGLE FROM i_billingdocitempartner AS a
    LEFT JOIN i_customer AS b ON a~customer = b~customer
    LEFT JOIN i_address_2 AS c ON b~addressid = c~addressid
    LEFT JOIN i_countrytext AS d ON  c~country  = d~country AND d~language = 'E'
    LEFT JOIN i_regiontext AS e ON  c~country  = e~country AND c~region   = e~region AND e~language = 'E'
    FIELDS
        a~customer,
        b~customername,
        b~addressid,
        b~taxnumber3    AS gstin,
        b~telephonenumber1,
        b~cityname AS to_place,
        c~streetname,
        c~streetprefixname1,
        c~streetprefixname2,
        c~cityname,
        c~postalcode,
        c~region,
        c~country,
        d~countryname,
        e~regionname
      WHERE a~billingdocument = @bill_doc
        AND a~partnerfunction = 'WE'
      INTO @DATA(ls_consignee)
      PRIVILEGED ACCESS.

    DATA: lt_consignee_addr TYPE TABLE OF string.
    IF ls_consignee-streetname        IS NOT INITIAL. APPEND ls_consignee-streetname        TO lt_consignee_addr. ENDIF.
    IF ls_consignee-streetprefixname1 IS NOT INITIAL. APPEND ls_consignee-streetprefixname1 TO lt_consignee_addr. ENDIF.
    IF ls_consignee-streetprefixname2 IS NOT INITIAL. APPEND ls_consignee-streetprefixname2 TO lt_consignee_addr. ENDIF.
    IF ls_consignee-cityname          IS NOT INITIAL. APPEND ls_consignee-cityname          TO lt_consignee_addr. ENDIF.
    IF ls_consignee-postalcode        IS NOT INITIAL. APPEND ls_consignee-postalcode        TO lt_consignee_addr. ENDIF.
    IF ls_consignee-regionname        IS NOT INITIAL. APPEND ls_consignee-regionname        TO lt_consignee_addr. ENDIF.
    IF ls_consignee-countryname       IS NOT INITIAL. APPEND ls_consignee-countryname       TO lt_consignee_addr. ENDIF.
*     IF ls_header-Address        IS NOT INITIAL. APPEND ls_header-Address        TO lt_consignee_addr. ENDIF.
*     IF ls_header-Place        IS NOT INITIAL. APPEND ls_header-Place        TO lt_consignee_addr. ENDIF.
*     IF ls_header-PinCode        IS NOT INITIAL. APPEND ls_header-PinCode        TO lt_consignee_addr. ENDIF.

    DATA(lv_consignee_address)   = concat_lines_of( table = lt_consignee_addr sep = ', ' ).
    " AFTER (safe)
    DATA lv_consignee_statecode TYPE c LENGTH 2.
    IF ls_consignee-gstin IS NOT INITIAL.
      lv_consignee_statecode = ls_consignee-gstin(2).
    ENDIF.

    DATA: lt_state_code TYPE TABLE OF string.
    IF lv_consignee_statecode IS NOT INITIAL.
      APPEND lv_consignee_statecode TO lt_state_code.
    ENDIF.
    IF ls_consignee-regionname IS NOT INITIAL.
      APPEND ls_consignee-regionname TO lt_state_code.
    ENDIF.
    DATA(lv_state_code)   = concat_lines_of( table = lt_state_code sep = ', ' ).

    SELECT SINGLE FROM i_billingdocumentpartner AS a
    LEFT JOIN i_customer AS b ON a~customer = b~customer
    LEFT JOIN i_address_2 AS c ON b~addressid = c~addressid
    LEFT JOIN i_countrytext AS d ON  c~country  = d~country AND d~language = 'E'
    LEFT JOIN i_regiontext AS e ON  c~country  = e~country AND c~region   = e~region AND e~language = 'E'
    FIELDS
        a~customer,
        b~customername,
        b~addressid,
        b~taxnumber3    AS gstin,
        b~telephonenumber1,
        c~streetname,
        c~streetprefixname1,
        c~streetprefixname2,
        c~cityname,
        c~postalcode,
        c~region,
        c~country,
        d~countryname,
        e~regionname
      WHERE a~billingdocument = @bill_doc
        AND a~partnerfunction = 'RE'
      INTO @DATA(ls_indentor)
      PRIVILEGED ACCESS.

    DATA: lt_indentor_addr TYPE TABLE OF string.
    IF ls_indentor-streetname        IS NOT INITIAL. APPEND ls_indentor-streetname        TO lt_indentor_addr. ENDIF.
    IF ls_indentor-streetprefixname1 IS NOT INITIAL. APPEND ls_indentor-streetprefixname1 TO lt_indentor_addr. ENDIF.
    IF ls_indentor-streetprefixname2 IS NOT INITIAL. APPEND ls_indentor-streetprefixname2 TO lt_indentor_addr. ENDIF.
    IF ls_indentor-cityname          IS NOT INITIAL. APPEND ls_indentor-cityname          TO lt_indentor_addr. ENDIF.
    IF ls_indentor-postalcode        IS NOT INITIAL. APPEND ls_indentor-postalcode        TO lt_indentor_addr. ENDIF.
    IF ls_indentor-regionname        IS NOT INITIAL. APPEND ls_indentor-regionname        TO lt_indentor_addr. ENDIF.
    IF ls_indentor-countryname       IS NOT INITIAL. APPEND ls_indentor-countryname       TO lt_indentor_addr. ENDIF.

    DATA(lv_indentor_address)   = concat_lines_of( table = lt_indentor_addr sep = ', ' ).

    DATA: lv_indentor_statecode TYPE c LENGTH 2,
          lv_indentor_pan       TYPE c LENGTH 10.

    IF ls_indentor-gstin IS NOT INITIAL.
      lv_indentor_statecode = ls_indentor-gstin(2).
      lv_indentor_pan = ls_indentor-gstin+2(10).
    ENDIF.

    DATA: lt_state_code1 TYPE TABLE OF string.
    IF lv_consignee_statecode IS NOT INITIAL.
      APPEND lv_indentor_statecode TO lt_state_code1.
    ENDIF.
    IF ls_indentor-regionname IS NOT INITIAL.
      APPEND ls_indentor-regionname TO lt_state_code1.
    ENDIF.
    DATA(lv_state_code1)   = concat_lines_of( table = lt_state_code1 sep = ', ' ).

    SELECT FROM i_billingdocumentitem AS a
    LEFT JOIN i_productplantbasic AS b ON a~plant = b~plant AND a~product = b~product
*    LEFT JOIN I_MATERIALDOCUMENTITEM_2 as c ON a~SalesDocument = c~MaterialDocument AND a~BillingDocumentItem = c~MaterialDocumentItem
    LEFT OUTER JOIN i_purchaseorderapi01 AS d ON a~salesdocument = d~purchaseorder
    LEFT OUTER JOIN i_salesorder AS e ON a~salesdocument = e~salesorder
    LEFT JOIN i_unitofmeasure AS f ON f~unitofmeasure = a~billingquantityunit
      FIELDS
        a~taxamount,
        a~salesdocumentitem,
        a~billingdocument,
        a~billingdocumentitem,
        a~product,
        a~billingdocumentitemtext,
        a~billingquantity,
        a~billingquantityunit,
        a~itemnetweight,
        f~unitofmeasure_e,
        b~consumptiontaxctrlcode AS hsncode,
        d~purchaseorder,
        d~creationdate AS po_creation_date,
        a~salesdocument,
        e~creationdate AS so_creation_date
      WHERE a~billingdocument = @bill_doc
      ORDER BY a~billingdocumentitem
      INTO TABLE @DATA(lt_items)
      PRIVILEGED ACCESS.



    SELECT FROM i_billingdocumentitemprcgelmnt
      FIELDS
        billingdocument,
        billingdocumentitem,
        conditionratevalue,
        conditionquantity,
        conditiontype,
        conditionamount
      WHERE billingdocument = @bill_doc
        AND conditiontype IN ( 'JOIG','ZOIG','JOCG','ZOIG','JOSG','ZOSG','DRD1' )
        ORDER BY billingdocument
      INTO TABLE @DATA(lt_pricing)
      PRIVILEGED ACCESS.


    SELECT FROM i_billingdocumentitemprcgelmnt
          FIELDS
            billingdocument,
            billingdocumentitem,
            conditiontype,
            conditionamount,
            conditionrateamount
          WHERE billingdocument = @bill_doc
            AND conditiontype IN ( 'ZFRT', 'ZPR0', 'ZPR1' )
            ORDER BY billingdocument
          INTO TABLE @DATA(lt_other_charges)
          PRIVILEGED ACCESS.


    DATA: lv_items_xml       TYPE string,
          lv_freight_total   TYPE p LENGTH 16 DECIMALS 2,
          lv_insurance_total TYPE p LENGTH 16 DECIMALS 2,
          lv_packing_total   TYPE p LENGTH 16 DECIMALS 2,
          lv_nav_total       TYPE p LENGTH 16 DECIMALS 2,
          lv_total_amount    TYPE p LENGTH 16 DECIMALS 2,
          lv_sr_no           TYPE i VALUE 1,
          lv_qty_total       TYPE p LENGTH 16 DECIMALS 2,
          lv_str_no          TYPE string,
          lv_str_date        TYPE string,



          lv_tax_percent     TYPE p LENGTH 8 DECIMALS 2,
          lv_tax_condition   TYPE string.

    DATA: lv_total_qty                  TYPE p LENGTH 16 DECIMALS 2,
          lv_total_txv                  TYPE p LENGTH 16 DECIMALS 2,
          lv_total_amt                  TYPE p LENGTH 16 DECIMALS 2,
          lv_total_net_wt               TYPE p LENGTH 16 DECIMALS 3,
          lv_total_transfer_price       TYPE p LENGTH 16 DECIMALS 2,
          lv_grand_total_transfer_price TYPE p LENGTH 16 DECIMALS 2,
          lv_total_tax_amount           TYPE p LENGTH 16 DECIMALS 2.

    DATA: ls_rate  LIKE LINE OF lt_pricing,
          ls_price LIKE LINE OF lt_other_charges.

    DATA: lv_rate                    TYPE p LENGTH 16 DECIMALS 2,

          lv_frt                     TYPE p LENGTH 13 DECIMALS 2,
          lv_ins                     TYPE p LENGTH 13 DECIMALS 2,
          lv_pkg                     TYPE p LENGTH 13 DECIMALS 2,
          lv_cgst                    TYPE p LENGTH 5  DECIMALS 2,
          lv_sgst                    TYPE p LENGTH 5  DECIMALS 2,
          lv_igst                    TYPE p LENGTH 5  DECIMALS 2,
          lv_cgst_amt                TYPE p LENGTH 13  DECIMALS 2,
          lv_sgst_amt                TYPE p LENGTH 13  DECIMALS 2,
          lv_igst_amt                TYPE p LENGTH 13  DECIMALS 2,
          lv_txv                     TYPE p LENGTH 13 DECIMALS 2,
          lv_total_gst_amt           TYPE p LENGTH 13 DECIMALS 2,
          lv_total_cgst_amt          TYPE p LENGTH 13 DECIMALS 2,
          lv_total_sgst_amt          TYPE p LENGTH 13 DECIMALS 2,
          lv_total_igst_amt          TYPE p LENGTH 13 DECIMALS 2,
          lv_roundoff                TYPE p LENGTH 13 DECIMALS 2,
          lv_total_roundoff          TYPE p LENGTH 13 DECIMALS 2,
          lv_total_inv_val           TYPE p LENGTH 13 DECIMALS 2,
          lv_net_balance             TYPE p LENGTH 13 DECIMALS 2,
          lv_prev_balance            TYPE p LENGTH 13 DECIMALS 2,
          lv_transfer_price_per_unit TYPE p LENGTH 13 DECIMALS 2.

    READ TABLE lt_items INTO DATA(ls_first_item) INDEX 1.

    IF sy-subrc = 0.

      IF ls_first_item-purchaseorder IS INITIAL.
        lv_str_no   = ls_first_item-salesdocument.
        lv_str_date = ls_first_item-so_creation_date.
*        lv_str_date = |{ lv_str_date+6(2) }-{ lv_str_date+4(2) }-{ lv_str_date(4) }|.
      ELSE.
        lv_str_no   = ls_first_item-purchaseorder.
        lv_str_date = ls_first_item-po_creation_date.
*        lv_str_date = |{ lv_str_date+6(2) }-{ lv_str_date+4(2) }-{ lv_str_date(4) }|.
      ENDIF.

    ENDIF.


    LOOP AT lt_items INTO DATA(ls_item).

      CLEAR: lv_cgst,
       lv_sgst,
       lv_igst,
       lv_tax_percent,
       lv_tax_condition.

      LOOP AT lt_pricing INTO DATA(ls_tax)
        WHERE billingdocument     = ls_item-billingdocument
          AND billingdocumentitem = ls_item-billingdocumentitem.

        CASE ls_tax-conditiontype.

          WHEN 'JOIG' OR 'ZOIG'.

            lv_igst += ls_tax-conditionratevalue.

          WHEN 'JOCG' OR 'ZOCG'.

            lv_cgst += ls_tax-conditionratevalue.

          WHEN 'JOSG' OR 'ZOSG'.

            lv_sgst += ls_tax-conditionratevalue.

        ENDCASE.

      ENDLOOP.

      IF lv_igst IS NOT INITIAL.


        lv_tax_condition = 'JOIG'.
        lv_tax_percent   = lv_igst.

      ELSE.


        CLEAR lv_tax_percent.
        CLEAR lv_tax_condition.

        IF lv_cgst IS NOT INITIAL.

          lv_tax_condition = 'JOCG'.
          lv_tax_percent   += lv_cgst.

        ENDIF.

        IF lv_sgst IS NOT INITIAL.

          IF lv_tax_condition IS NOT INITIAL.
            lv_tax_condition = |{ lv_tax_condition } JOSG|.
          ELSE.
            lv_tax_condition = 'JOSG'.
          ENDIF.

          lv_tax_percent += lv_sgst.

        ENDIF.

      ENDIF.

      "CLEAR: ls_item, ls_rate, ls_price, lv_rate, lv_frt, lv_ins, lv_pkg, lv_txv, lv_transfer_price_per_unit.


*      lv_total_net_wt   += ls_item-itemnetweight.

      READ TABLE lt_pricing INTO DATA(wa_rate) WITH KEY billingdocument = ls_item-billingdocument
                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZCIP'.
      READ TABLE lt_pricing INTO DATA(wa_rate2) WITH KEY billingdocument = ls_item-billingdocument
                billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZINP'.

      IF wa_rate-conditionratevalue IS NOT INITIAL .
        lv_rate = wa_rate-conditionratevalue / wa_rate-conditionquantity.
      ELSE.
        lv_rate = wa_rate2-conditionratevalue / wa_rate-conditionquantity.
      ENDIF.

*      CLEAR ls_price.
*      READ TABLE lt_pricing INTO ls_price
*        WITH KEY billingdocument     = ls_item-billingdocument
*                 billingdocumentitem = ls_item-billingdocumentitem
*                 conditiontype       = 'ZTXV'.
*      IF sy-subrc = 0. lv_nav = ls_price-conditionamount. ENDIF.

      CLEAR ls_price.
      READ TABLE lt_other_charges INTO ls_price WITH KEY billingdocument = ls_item-billingdocument
                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZPR0'.
      IF sy-subrc = 0.
        lv_transfer_price_per_unit = ls_price-conditionrateamount.
      ELSE.

        READ TABLE lt_other_charges INTO ls_price
          WITH KEY billingdocument     = ls_item-billingdocument
                   billingdocumentitem = ls_item-billingdocumentitem
                   conditiontype       = 'ZPR1'.

        IF sy-subrc = 0.
          lv_transfer_price_per_unit = ls_price-conditionrateamount.
        ENDIF.
      ENDIF.

      lv_total_transfer_price = lv_transfer_price_per_unit * ls_item-billingquantity.
      lv_grand_total_transfer_price += lv_total_transfer_price.

      CLEAR ls_price.
      READ TABLE lt_other_charges INTO ls_price WITH KEY billingdocument = ls_item-billingdocument
                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZFRT'.
      IF sy-subrc = 0. lv_frt = ls_price-conditionamount. ENDIF.

*      CLEAR ls_price.
*      READ TABLE lt_other_charges INTO ls_price WITH KEY billingdocument = ls_item-billingdocument
*                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZINS'.
*      IF sy-subrc = 0. lv_ins = ls_price-conditionamount. ENDIF.
*
*      CLEAR ls_price.
*      READ TABLE lt_other_charges INTO ls_price WITH KEY billingdocument = ls_item-billingdocument
*                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZPKG'.
*      IF sy-subrc = 0. lv_pkg = ls_price-conditionamount. ENDIF.

*      lv_nav_total       += lv_nav.
      lv_freight_total   += lv_frt.
*      lv_insurance_total += lv_ins.
*      lv_packing_total   += lv_pkg.
      lv_total_net_wt   += ls_item-itemnetweight.
      lv_total_tax_amount += ls_item-taxamount.
      lv_qty_total       += ls_item-billingquantity.

      READ TABLE lt_pricing INTO DATA(ls_cgst) WITH KEY billingdocument = ls_item-billingdocument
                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'JOCG' BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE lt_pricing INTO ls_cgst WITH KEY billingdocument = ls_item-billingdocument
                   billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZOCG' BINARY SEARCH.
      ENDIF.
      IF sy-subrc = 0.
        lv_cgst = ls_cgst-conditionratevalue.
        lv_cgst_amt = ls_cgst-conditionamount.
        lv_total_cgst_amt += lv_cgst_amt.
      ENDIF.
      CLEAR ls_cgst.

      READ TABLE lt_pricing INTO DATA(ls_sgst) WITH KEY billingdocument = ls_item-billingdocument
                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'JOSG' BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE lt_pricing INTO ls_cgst WITH KEY billingdocument = ls_item-billingdocument
                   billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZOSG' BINARY SEARCH.
      ENDIF.
      IF sy-subrc = 0.
        lv_sgst = ls_sgst-conditionratevalue.
        lv_sgst_amt = ls_cgst-conditionamount.
        lv_total_sgst_amt += lv_sgst_amt.
      ENDIF.
      CLEAR ls_sgst.

      READ TABLE lt_pricing INTO DATA(ls_igst) WITH KEY billingdocument = ls_item-billingdocument
                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'JOIG' BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE lt_pricing INTO ls_cgst WITH KEY billingdocument = ls_item-billingdocument
                   billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'ZOIG' BINARY SEARCH.
      ENDIF.
      IF sy-subrc = 0.
        "lv_igst_condition = ls_igst-conditiontype.
        lv_igst = ls_igst-conditionratevalue.
        lv_igst_amt = ls_cgst-conditionamount.
        lv_total_igst_amt += lv_igst_amt.
      ENDIF.
      CLEAR ls_igst.

      READ TABLE lt_pricing INTO DATA(ls_roundoff) WITH KEY billingdocument = ls_item-billingdocument
                 billingdocumentitem = ls_item-billingdocumentitem conditiontype       = 'DRD1' BINARY SEARCH.
      IF sy-subrc = 0.
        lv_roundoff = ls_roundoff-conditionamount.
        lv_total_roundoff += lv_roundoff.
      ENDIF.
      CLEAR ls_igst.

*      lv_txv = lv_rate * ls_item-billingquantity.
      lv_txv = ls_item-billingquantity * lv_transfer_price_per_unit.
      lv_total_txv += lv_txv.
      lv_total_amt += lv_txv.

      DATA: lt_quantity TYPE TABLE OF string.
      IF ls_item-billingquantity IS NOT INITIAL.
        APPEND ls_item-billingquantity TO lt_quantity.
      ENDIF.
      IF ls_item-unitofmeasure_e IS NOT INITIAL.
        APPEND ls_item-unitofmeasure_e TO lt_quantity.
      ENDIF.
      DATA(lv_quantity)   = concat_lines_of( table = lt_quantity sep = ' ' ).

      DATA: rate_type TYPE c LENGTH 3.

      ls_item-product = |{ ls_item-product ALPHA = OUT }|.

      DATA : lv_item_text      TYPE string,
             lv_bill_item_text TYPE string.

      READ ENTITIES OF i_billingdocumenttp
      ENTITY billingdocumentitemtext
      FIELDS ( longtext )
      WITH VALUE #(
            (
              %key = VALUE #(
                  billingdocument     = bill_doc
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

      lv_items_xml = lv_items_xml &&
        |<Item>| &&
        |<SNNO>{ lv_sr_no }</SNNO>| &&
        |<DESCRIPTION>{ ls_item-billingdocumentitemtext }\n({ ls_item-product })\n{ lv_item_text }</DESCRIPTION>| &&
        |<HSN>{ ls_item-hsncode }</HSN>| &&
        |<QUANTITY>{ ls_item-billingquantity DECIMALS = 0 }{ cl_abap_char_utilities=>newline }{ ls_item-unitofmeasure_e }</QUANTITY>| &&

        |<FREIGHT_CHARGES>{ lv_frt }</FREIGHT_CHARGES>| &&
        |<WEIGHT>{ ls_item-itemnetweight }</WEIGHT>| &&
        |<TRANSFER_PRICE_PER_UNIT>{ lv_transfer_price_per_unit }</TRANSFER_PRICE_PER_UNIT>| &&
        |<TAXABLE_VALUE>{ lv_txv }</TAXABLE_VALUE>| &&
        |<TAX_TYPE_PERCENT>{ lv_tax_condition } { lv_tax_percent }%</TAX_TYPE_PERCENT>| &&
        |<TAX_AMOUNT>{ ls_item-taxamount }</TAX_AMOUNT>| &&

        |</Item>|.

      lv_sr_no = lv_sr_no + 1.
      CLEAR: ls_item, ls_rate, ls_price, lv_rate, lv_frt, lv_quantity, wa_rate , wa_rate2, lv_txv, lv_transfer_price_per_unit, lv_tax_condition, lv_tax_percent.

    ENDLOOP.

    lv_total_gst_amt = lv_total_cgst_amt +
               lv_total_sgst_amt +
               lv_total_igst_amt.

    lv_total_amount = lv_total_tax_amount + lv_total_txv.

    lv_total_inv_val = lv_total_txv + lv_total_gst_amt + lv_total_roundoff.

    lv_net_balance = lv_prev_balance + lv_total_inv_val.

    DATA : footer_text TYPE string.

    footer_text = 'Certified that the particulars given above are true and correct and the amount indicated represents the price actually charged and that there is no flow of additional consideration directly or indirectly from the buyer.'.

    DATA:lv_pagename TYPE string.

    IF sy-index = 1.
      lv_pagename = 'Original for Buyer'.
    ENDIF.
    IF sy-index = 2.
      lv_pagename = 'Duplicate of Transporter'.
    ENDIF.
    IF sy-index = 3.
      lv_pagename = 'Triplicate of Supplier'.
    ENDIF.
    IF sy-index = 4.
      lv_pagename = 'Extra Copy'.
    ENDIF.

    DATA(lv_po_date) = CONV string( ls_header-customerpurchaseorderdate ).
    IF ls_header-customerpurchaseorderdate IS INITIAL
       OR ls_header-customerpurchaseorderdate = '00000000'.

      CLEAR lv_po_date.

    ENDIF.

    DATA(lv_cnote_date) = CONV string( ls_header-yy1_cnotedate_bdh ).
    IF ls_header-yy1_cnotedate_bdh IS INITIAL
       OR ls_header-yy1_cnotedate_bdh = '00000000'.

      CLEAR lv_cnote_date.

    ENDIF.

    DATA: lv_salesdoc    TYPE vbeln_va,
          remarks        TYPE string,
          lv_header_text TYPE string,
          lv_bill_text   TYPE string.





    READ ENTITIES OF i_billingdocumenttp
    ENTITY billingdocumenttext
    FIELDS ( longtext )
    WITH VALUE #(
          (
            %key = VALUE #(
                billingdocument = bill_doc
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
                  salesorder = ls_item-salesdocument
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

    ls_indentor-customer = |{ ls_indentor-customer ALPHA = OUT }|.
    ls_consignee-customer = |{ ls_consignee-customer ALPHA = OUT }|.

    DATA lv_document_type TYPE string.

    CASE ls_header-yy1_salestype_bdh.

      WHEN 'AST'.
        lv_document_type = 'Asset Sales'.

      WHEN 'CRD'.
        lv_document_type = 'Credit for Sales Return (Dom)'.

      WHEN 'CRE'.
        lv_document_type = 'Credit for Sales Return (Exp)'.

      WHEN 'CRM'.
        lv_document_type = 'Credit Memo'.

      WHEN 'CSR'.
        lv_document_type = 'N/A'.

      WHEN 'DEX'.
        lv_document_type = 'Deemed Export'.

      WHEN 'DOM'.
        lv_document_type = 'Domestic Sales'.

      WHEN 'DRM'.
        lv_document_type = 'Debit Memo'.

      WHEN 'EXP'.
        lv_document_type = 'Export Sales'.

      WHEN 'FGS'.
        lv_document_type = 'Free Goods Sales'.

      WHEN 'HSE'.
        lv_document_type = 'High Sea Sales'.

      WHEN 'INC'.
        lv_document_type = 'Inter Company Sales'.

      WHEN 'ING'.
        lv_document_type = 'Inter-Company Sale Purchase'.

      WHEN 'INP'.
        lv_document_type = 'Intra-Company Sale Purchase'.

      WHEN 'LUT'.
        lv_document_type = 'Export Sale (LUT)'.

      WHEN 'RAW'.
        lv_document_type = 'Replacement Against Warranty'.

      WHEN 'RMS'.
        lv_document_type = 'RM Sales'.

      WHEN 'SCR'.
        lv_document_type = 'Scrap Sales'.

      WHEN 'SMD'.
        lv_document_type = 'Sample Sales (Dom)'.

      WHEN 'SME'.
        lv_document_type = 'Sample Sales (Exp)'.

      WHEN 'SRS'.
        lv_document_type = 'Service Sales'.

      WHEN 'TOL'.
        lv_document_type = 'Tolling Sales'.

      WHEN 'TRD'.
        lv_document_type = 'Trading Sales'.

      WHEN OTHERS.
        CLEAR lv_document_type.

    ENDCASE.

    DATA(lv_total_net_wt_str) = |{ lv_total_net_wt DECIMALS = 3 }|.

    REPLACE ALL OCCURRENCES OF REGEX '\.?0+$'
      IN lv_total_net_wt_str
      WITH ''.

    DATA: lv_ewaybill_no   TYPE string,
          lv_ewaybill_date TYPE string.

    IF ls_header-ewaybillno IS NOT INITIAL.

      lv_ewaybill_no   = ls_header-ewaybillno.
      lv_ewaybill_date = ls_header-ewaydate.

    ELSE.

      lv_ewaybill_no   = ls_header-yy1_ewaybill_bdh.
      lv_ewaybill_date = ls_header-yy1_ewaybill_date_bdh.

    ENDIF.

    "lv_ewaybill_date = CONV string( ls_header-yy1_ewaybill_date_bdh ).
    IF lv_ewaybill_date IS INITIAL
       OR lv_ewaybill_date = '00000000'.

      CLEAR lv_ewaybill_date.

    ENDIF.

    DATA(lv_xml) =
      |<Form>| &&
      |<Header>| &&
      |<COMPANY_NAME>{ ls_header-company_name }</COMPANY_NAME>| &&
      |<BILLING_DOCUMENT_TYPE>{ lv_document_type }</BILLING_DOCUMENT_TYPE>| &&

      |<INTERNAL_DOCUMENT_NO>{ lv_po2 }</INTERNAL_DOCUMENT_NO>| &&
      |<PARTY_PO_NO>{ ls_header-purchaseorderbycustomer }</PARTY_PO_NO>| &&
      |<PARTY_PO_DATE>{ lv_po_date }</PARTY_PO_DATE>| &&
      |<CHALLAN_NO>{ ls_header-documentreferenceid }</CHALLAN_NO>| &&
      |<CHALLAN_DATE>{ ls_header-creationdate }</CHALLAN_DATE>| &&
      |<DELIVERY_NO>{ lv_mode_of_transport-referencesddocument }</DELIVERY_NO>| &&

      |<TRANSPORTER_GSTIN>{ ls_header-transportergstin }</TRANSPORTER_GSTIN>| &&
      |<MODE_OF_TRANSPORTER>{ ls_header-transportmode }</MODE_OF_TRANSPORTER>| &&
      |<TRANSPORTER_NAME>{ ls_header-transportername }</TRANSPORTER_NAME>| &&
      |<VEHICLE_REGN_NO>{ ls_header-vehiclenum }</VEHICLE_REGN_NO>| &&
      |<C_NOTE_NO>{ ls_header-yy1_cnoteno_bdh }</C_NOTE_NO>| &&
      |<C_NOTE_DATE>{ lv_cnote_date }</C_NOTE_DATE>| &&

      |<EWAY_BILL_NO>{ lv_ewaybill_no }</EWAY_BILL_NO>| &&
      |<EWAY_BILL_DATE>{ lv_ewaybill_date }</EWAY_BILL_DATE>| &&

      |<PLANT_ADDRESS>{ lv_plant_address }</PLANT_ADDRESS>| &&
      |<GST_NO>{ ls_header-gstin_no }</GST_NO>| &&
      |<CIN>{ ls_header-cin_no }</CIN>| &&
      |<PAN>{ ls_header-pan_no }</PAN>| &&
      |</Header>| &&

      |<Consignee>| &&
      |<COMPANY_CODE>{ ls_consignee-customer }</COMPANY_CODE>| &&

      |<ADDRESS>{ ls_consignee-customername }{ cl_abap_char_utilities=>newline }{ lv_consignee_address }</ADDRESS>| &&
      |<GSTIN>{ ls_consignee-gstin }</GSTIN>| &&
      |<PHONE_NO>{ ls_consignee-telephonenumber1 }</PHONE_NO>| &&
      |<STATE>{ ls_consignee-regionname }</STATE>| &&
      |<STATE_CODE>{ lv_state_code }</STATE_CODE>| &&
      |<CUSTOMER_COUNTRY>{ ls_consignee-country }</CUSTOMER_COUNTRY>| &&
      |</Consignee>| &&

      |<Indentor>| &&
      |<COMPANY_CODE>{ ls_indentor-customer }</COMPANY_CODE>| &&

      |<ADDRESS>{ ls_indentor-customername }{ cl_abap_char_utilities=>newline }{ lv_indentor_address }</ADDRESS>| &&
      |<GSTIN>{ ls_indentor-gstin }</GSTIN>| &&
      |<PHONE_NO>{ ls_indentor-telephonenumber1 }</PHONE_NO>| &&
      |<STATE>{ ls_indentor-regionname }</STATE>| &&
      |<STATE_CODE>{ lv_state_code }</STATE_CODE>| &&
      |<CUSTOMER_COUNTRY>{ ls_indentor-country }</CUSTOMER_COUNTRY>| &&
      |</Indentor>| &&

      |<Items>{ lv_items_xml }</Items>| &&

      |<Items_total>| &&
      |<Item_total_qty>{ lv_qty_total DECIMALS = 0 }</Item_total_qty>| &&
      |<IGST_VALUE>{ lv_total_tax_amount }</IGST_VALUE>| &&
      |<ROUNDING_OFF>{ lv_total_roundoff }</ROUNDING_OFF>| &&
      |<FREIGHT>{ ls_header-incotermsclassification }</FREIGHT>| &&
      |<TOTAL_WEIGHT>{ lv_total_net_wt_str }</TOTAL_WEIGHT>| &&
      |<TOTAL_TRANSFER_PRICE>{ lv_total_transfer_price }</TOTAL_TRANSFER_PRICE>| &&
      |<GRAND_TOTAL_TRANSFER_PRICE>{ lv_grand_total_transfer_price }</GRAND_TOTAL_TRANSFER_PRICE>| &&
      |<TOTAL_TAX_AMOUNT>{ lv_total_tax_amount }</TOTAL_TAX_AMOUNT>| &&

      |</Items_total>| &&

      |<Footer>| &&
      |<BASIC_VALUE>{ lv_total_txv }</BASIC_VALUE>| &&
      |<FREIGHT_CHARGES>{ lv_freight_total }</FREIGHT_CHARGES>| &&
      |<TOTAL_TAXABLE_VALUE>{ lv_total_txv }</TOTAL_TAXABLE_VALUE>| &&

      |<TOTAL_AMOUNT>{ lv_total_amount }</TOTAL_AMOUNT>| &&
      |<FOOTER_TEXT>{ footer_text }</FOOTER_TEXT>| &&

      |<E_SEAL_NO>{ ls_header-yy1_esealno_bdh }</E_SEAL_NO>| &&
      |<JURISDICTION>{ ls_header-city }</JURISDICTION>| &&
      |<REMARKS>{ remarks }</REMARKS>| &&
      |<PHONE>{ ls_header-mob_no }</PHONE>| &&
      |<EMAIL>{ ls_header-email }</EMAIL>| &&
      |</Footer>| &&
      |</Form>|.


    REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH 'and'.
    REPLACE ALL OCCURRENCES OF PCRE '\s{2,}' IN lv_xml WITH ` `.




    CALL METHOD zcl_adobe=>getpdf(
      EXPORTING
        xmldata  = lv_xml
        template = lc_template_name
      RECEIVING
        result   = result12 ).

  ENDMETHOD.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD .
ENDCLASS.
