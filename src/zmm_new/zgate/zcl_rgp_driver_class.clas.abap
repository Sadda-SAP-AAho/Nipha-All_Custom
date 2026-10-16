CLASS zcl_rgp_driver_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    INTERFACES if_oo_adt_classrun.


    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .

    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct.



    CLASS-METHODS    :
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check ,

      read_posts
        IMPORTING
                  lv_po2          TYPE string
*                  company_code     TYPE string
        RETURNING VALUE(result12) TYPE string





        RAISING   cx_static_check .




  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.jp10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://dev-tcul4uw9.authentication.jp10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'zmm_rgp_print/zmm_rgp_print'.


ENDCLASS.



CLASS ZCL_RGP_DRIVER_CLASS IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.


  METHOD read_posts.

    "  HEADER FIELDS
    SELECT   SINGLE
    FROM  zgate_rgp_hdr  AS a LEFT OUTER JOIN  i_supplier AS b ON a~partner_code  = b~supplier
    LEFT OUTER JOIN ztable_irn  AS c
    ON a~document_no  = c~billingdocno
     LEFT OUTER JOIN ztable_plant  AS d
      ON a~plant  = d~plant_code
    LEFT OUTER JOIN i_address_2   AS e
    ON b~addressid  = e~addressid

    FIELDS
     a~document_no,
     a~document_date,
     a~partner_name  ,
     a~address1,
     a~address2,
     a~plant,
     a~expected_date,
     a~description1,
     a~description2,
     "c~transporter,
     c~vehiclenum,
     d~company_name,
*     d~address1,
     d~state_name,
     d~pin,
     d~gstin_no,
     d~pan_no,
     d~email,
     d~mob_no,
     b~taxnumber3,
     e~streetname,
     e~streetprefixname1,
     e~streetprefixname2,
     e~cityname,
     e~region,
     e~country,
     e~postalcode
    " c~name
     WHERE a~document_no   = @lv_po2
     INTO @DATA(wa_header)
     PRIVILEGED ACCESS.
    CONCATENATE  wa_header-streetprefixname1  wa_header-streetprefixname2   INTO     DATA(lv_address)  SEPARATED BY ' ' .
    CONCATENATE  wa_header-address1  wa_header-state_name  wa_header-pin   INTO     DATA(lv_address_plant)  SEPARATED BY ' ' .
    CONCATENATE  wa_header-cityname  wa_header-postalcode  wa_header-region  wa_header-country    INTO     DATA(lv_address2)  SEPARATED BY ' ' .

    DATA : lv_document_date TYPE string,

           lv_expected_date TYPE string.
    IF     wa_header-document_date IS INITIAL.
      lv_document_date = ''.

    ELSE  .
      lv_document_date  = wa_header-document_date.
    ENDIF.


    IF     wa_header-expected_date IS INITIAL.
      lv_expected_date = ''.

    ELSE  .
      lv_expected_date  = wa_header-expected_date.
    ENDIF.


    DATA(plant) = wa_header-plant.

    "  ITEM FILDS
    SELECT FROM zgate_rgp_item AS a
    LEFT OUTER JOIN i_productplantbasic AS b ON
    a~item_code = b~product
    AND b~plant  = @plant
    LEFT OUTER JOIN i_taxcoderate  AS c
    ON a~tax_code  = c~taxcode
    AND c~cndnrecordvalidityenddate = '99991231'
     AND ( c~vatconditiontype = 'JOIG'
    OR c~vatconditiontype = 'JOCG'
    OR c~vatconditiontype = 'JOSG' )

    FIELDS
    a~document_no,
    a~qty,
    a~description,
     a~item_name,
    a~unit,
    a~rate,
    b~consumptiontaxctrlcode,
    a~net_amount,
    a~tax_percent,
    a~tax_amount,
    c~conditionrateratio,
    c~vatconditiontype

    WHERE document_no  = @lv_po2
*    AND ( c~vatconditiontype = 'JOIG'
*    OR c~vatconditiontype = 'JOCG'
*    OR c~vatconditiontype = 'JOSG' )

    INTO TABLE @DATA(it_item)
    PRIVILEGED ACCESS.

    DATA(lv_xml) =
      |<FORM>| &&
      |<Header>| &&
      |<PlantName>{ wa_header-company_name }</PlantName>| &&
      |<PlantAddress>{ lv_address_plant }</PlantAddress>| &&
      |<GSTNo>{ wa_header-gstin_no }</GSTNo>| &&
      |<PANNo>{ wa_header-pan_no }</PANNo>| &&
      |<PHoneNum>{ wa_header-mob_no }</PHoneNum>| &&
      |<PlantEmail>{ wa_header-email }</PlantEmail>| &&
      |<GatePassNo>{ wa_header-document_no }</GatePassNo>| &&
      |<GatePassDate>{ lv_document_date }</GatePassDate>| &&
      |<Plant>{ wa_header-plant }</Plant>| &&
 "      |<GateOutTime>{ }</GateOutTime>| &&
      |<VendorName>{ wa_header-partner_name }</VendorName>| &&
      |<VendorAddress1>{ wa_header-streetname }</VendorAddress1>| &&
      |<VendorAddress2>{ lv_address }</VendorAddress2>| &&

      |<VendorAddress3>{ lv_address2 }</VendorAddress3>| &&

      |<ExpReturnDate>{ lv_expected_date }</ExpReturnDate>| &&
    "  |<GR/LR No>{  }</GR/LR No>| &&
     "   |<GR/LR Date>{  }</GR/LR Date>| &&
       " |<DriverName>{ wa_header-name }</DriverName>| &&
      " |<DriverNumber>{  }</DriverNumber>| &&
       " |<TransporterID>{ wa_header-transporter  }</TransporterID>| &&
    "    |<Operator>{ wa_header-transporter  }</Operator>| &&
        " |<Purpose>{ wa_header-transporter  }</Purpose>| &&
        |<VehicalNo>{ wa_header-vehiclenum  }</VehicalNo>| &&
*        |<GrossWt>{ wa_header-  }</GrossWt>| &&
*        |<TareWt>{ wa_header-  }</TareWt>| &&
*          |<NetWt>{ wa_header-  }</NetWt>| &&
        |<VendorGST>{ wa_header-taxnumber3  }</VendorGST>| &&
         "|<RequestedBy>{ wa_header-taxnumber3  }</RequestedBy>| &&
        " |<PLANT>{ wa_header-plant }</PLANT>| &&
        |<Remark1>{ wa_header-description1 }</Remark1>| &&
        |<Remark2>{ wa_header-description2 }</Remark2>| &&

        |</Header>| &&
        |<ITEMS>|.

    DATA: total_overall TYPE p LENGTH 16 DECIMALS 2,
          igst          TYPE p LENGTH 15 DECIMALS 2,
          sgst          TYPE p LENGTH 15 DECIMALS 2,
          cgst          TYPE p LENGTH 15 DECIMALS 2.

    SORT it_item BY document_no.
    LOOP AT it_item INTO DATA(wa_item).
      "Base AMOUNT

      total_overall += wa_item-net_amount.

*      SELECT SINGLE
*      FROM  i_taxcoderate AS  a
*      FIELDS
*          c~conditionrateratio,
*          c~vatconditiontype
*              WHERE taxcode  = @
*     AND ( c~vatconditiontype = 'JOIG'
*     OR c~vatconditiontype = 'JOCG'
*     OR c~vatconditiontype = 'JOSG' )





      IF  wa_item-vatconditiontype = 'JOIG'.
        igst += wa_item-tax_amount .
      ELSEIF wa_item-vatconditiontype = 'JOCG'.

        cgst += wa_item-tax_amount.
      ELSEIF wa_item-vatconditiontype = 'JOSG'.
        sgst  += wa_item-tax_amount .


      ENDIF.










      lv_xml = lv_xml &&
      |<Item>| &&
      |<MatDescription>{ wa_item-item_name }</MatDescription>| &&
      |<Qty>{ wa_item-qty }</Qty>| &&
      |<UOM>{ wa_item-unit }</UOM>| &&
      |<Rate>{ wa_item-rate }</Rate>| &&
      |<Amount>{ wa_item-net_amount }</Amount>| &&
      |<HSN>{ wa_item-consumptiontaxctrlcode }</HSN>| &&

      |<TAX_RATE>{ wa_item-tax_percent }</TAX_RATE>| &&
      |</Item>|.
    ENDLOOP.

    lv_xml = lv_xml &&
    |<GrandTotal>{ total_overall }</GrandTotal>| &&
    |<IGST>{ igst }</IGST>| &&
    |<CGST>{ sgst }</CGST>| &&
    |<SGST>{ cgst }</SGST>| &&

    |</ITEMS>| &&
    |</FORM>|.
*
*    CALL METHOD zcl_ads_print=>getpdf(
*      EXPORTING
*        xmldata  = lv_xml
*        template = lc_template_name
*      RECEIVING
*        result   = result12 ).

*    out->write( lv_xml ).
  ENDMETHOD.
ENDCLASS.
