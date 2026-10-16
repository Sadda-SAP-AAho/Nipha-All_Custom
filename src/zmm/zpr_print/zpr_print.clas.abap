CLASS zpr_print DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
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
      END OF struct."

    CLASS-METHODS :

      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,


      read_posts
        IMPORTING prdoc           TYPE string
*                   plant           TYPE string
*                   date            TYPE string
*                   docno           TYPE string
*                   year            TYPE string
*                   checkboxvalue   TYPE STRING
*                   debitcreditnote   TYPE STRING
*                   creditmemo   TYPE STRING
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://devtenant-ux00yyve.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS  lc_template_name TYPE string VALUE 'ZPR_PRINT/ZPR_PRINT'.

ENDCLASS.



CLASS ZPR_PRINT IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(return_data) = read_posts( prdoc = '0987654321' ).
      CATCH cx_static_check INTO DATA(lx_error).
        out->write( 'An error occurred during processing:' ).
        out->write( lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_posts.
    DATA lc_template_name1 TYPE string .

    "VIREN

    SELECT SINGLE purchaserequisition  FROM i_purchaserequisitionapi01 WHERE purchaserequisition = @prdoc INTO @DATA(it) .

    SELECT SINGLE purchaserequisition , plant , purreqcreationdate , requisitionername
    FROM i_purchaserequisitionitemapi01 WHERE purchaserequisition = @prdoc INTO @DATA(it2) .

    SELECT SINGLE plant FROM i_plantstdvh WHERE plant = @it2-plant INTO @DATA(plant) .

    IF
    it2-plant = '1001' .
      DATA(bp) = '1000'.
    ELSEIF
    it2-plant = '2001' .
      bp = '2000' .
    ELSEIF
    it2-plant = '3001' .
      bp = '3000' .
    ELSEIF
    it2-plant = '3002' .
      bp = '3000' .
    ELSEIF
    it2-plant = '3003' .
      bp = '3000' .
    ELSEIF
    it2-plant = '3004' .
      bp = '3000' .
    ELSEIF
    it2-plant = '3005' .
      bp = '3000' .
    ELSEIF
    it2-plant = '4001' .
      bp = '4000' .
    ELSEIF ( it2-plant = '5001' OR it2-plant = '5002' ).
      bp = '5000' .
    ELSEIF
    it2-plant = '6001' .
      bp = '6000' .
    ELSEIF  it2-plant EQ '7001' .
      bp = '7000'.
    ELSEIF  it2-plant EQ '7002' .
      bp = '7001'.
    ELSEIF it2-Plant EQ '6002'.
    bp = '6002'.
    ENDIF.

    SELECT SINGLE * FROM i_kr_businessplace WHERE branch = @bp INTO @DATA(bplace) .


    SELECT SINGLE FROM zplant
    FIELDS
    plant_gstin_no
    WHERE
    Plant = @it2-Plant
    INTO @DATA(GST) PRIVILEGED ACCESS.



*    IF it2-plant = '6001' .
*      gst = '06AAACN9099H1Z2 ' .
*    ELSE .
*      gst = '19AAACN9099H1ZV' .
*    ENDIF.
    DATA lv_xml TYPE string .

    DATA(lv_vs1) =
   |<form1>| &&
 |<Subform1>| &&
    |<add1></add1>| &&
    |<PlantHead>NIPHA LIMITED</PlantHead>| &&
    |<add2>Registered Address:- 48, Ganga jamuna, 28/1 Shakespeare Sarani, Kolkata 700 017, West Bengal, India</add2>| &&
    |<Subform7>| &&
*         |<CINNo>U51909WB1973PTC028897</CINNo>| &&
       |<CINNo>U51909WB1973PLC028897</CINNo>| &&
       |<GSTIN>{ gst }</GSTIN>| &&
       |<PAN>AAACN9099H</PAN>| &&
    |</Subform7>| &&
 |</Subform1>| &&
 |<Subform8>| &&
    |<venadd1>{ prdoc }</venadd1>| &&
    |<venadd2>{ it2-purreqcreationdate+6(2)  }/{ it2-purreqcreationdate+4(2) }/{ it2-purreqcreationdate+0(4) }</venadd2>| &&
    |<venadd3>{ it2-requisitionername }</venadd3>| &&
    |<venadd4></venadd4>| &&
    |<venadd5></venadd5>| &&
    |<venadd6></venadd6>| &&
    |<billadd1>{ bplace-addressname }</billadd1>| &&
    |<billadd2>{ bplace-housenumber }{ bplace-streetname }</billadd2>| &&
    |<billadd3>{ bplace-cityname }{ bplace-postalcode }</billadd3>| &&
    |<billadd4>{ bplace-responsiblepersonemailaddress }{ bplace-phonenumber }</billadd4>| &&
    |<billadd5></billadd5>| &&
    |<billadd6></billadd6>| &&
 |</Subform8>| &&
 |<Subform9>| &&
    |<Table1>| &&
       |<HeaderRow/>| .

    DATA lv_vs2 TYPE string .
    DATA sno TYPE string .
    DATA textdes TYPE string .

    SELECT FROM i_purchaserequisitionitemapi01 AS a
    INNER JOIN i_stockquantityvaluebytype AS b ON a~material = b~material AND a~plant = b~plant
    FIELDS
    b~material,
    b~plant,
    SUM( b~matlwrhsstkqtyinmatlbaseunit ) AS currstock
    WHERE a~purchaserequisition = @prdoc AND a~isdeleted = ''
    GROUP BY b~material, b~plant
    INTO TABLE @DATA(curr) PRIVILEGED ACCESS.


    """"13/04/2026"""""""""
    SELECT FROM i_purchaserequisitionitemapi01  AS a
LEFT  JOIN i_stockquantityvaluebytype  AS b ON a~material = b~material AND a~plant = b~plant  AND b~valuationareatype  = '3'
FIELDS
  b~material,
    b~plant,
 SUM( b~matlwrhsstkqtyinmatlbaseunit ) AS currstock
 WHERE a~purchaserequisition = @prdoc  AND a~isdeleted = ''
  GROUP BY b~material, b~plant
 INTO TABLE @DATA(current_stock) PRIVILEGED ACCESS.
    """""""""""""""""""''''''

    SELECT a~baseunit , a~materialgroup , a~material , a~purchaserequisitionitemtext ,
           a~yy1_itemtext_pri , a~requestedquantity , a~deliverydate, a~plant, a~purchaserequisitionitem, a~purchaserequisition,
           c~safetystockquantity , e~unitofmeasure_e
     FROM i_purchaserequisitionitemapi01 AS a
*     LEFT JOIN I_StockQuantityValueByType AS B ON A~Material = B~Material AND A~Plant = B~Plant
     LEFT JOIN i_productplantbasic AS c ON a~material = c~product AND a~plant = c~plant
     LEFT JOIN i_product  AS d ON   a~material = d~product
     LEFT JOIN i_unitofmeasure  AS e ON   e~unitofmeasuresapcode   = d~baseunit
      WHERE a~purchaserequisition = @prdoc AND a~isdeleted = '' INTO TABLE @DATA(it_tab) .
*

*DATA: lv_nbsp TYPE char1,
*      lv_code TYPE x LENGTH 1.
*
*lv_code = 'A0'. " Hex for Unicode U+00A0
*lv_nbsp = CONV char1( lv_code ).
    DATA(newline) = cl_abap_char_utilities=>newline.
    DATA currentstocks TYPE p LENGTH  15 DECIMALS  3.


    LOOP AT it_tab INTO DATA(wa_tab) .




      sno = 1 + sno .
      DATA pc  TYPE c LENGTH 3.
      IF wa_tab-baseunit = 'ST' .
        pc = 'PC' .
      ELSE .
        pc = wa_tab-unitofmeasure_e .
      ENDIF .

      SELECT SINGLE productgroup FROM i_productgrouptext_2 WHERE productgroup = @wa_tab-materialgroup AND language = 'E' INTO @DATA(text) .
      DATA(var1) =   |{  wa_tab-material ALPHA = OUT }| .
      REPLACE ALL OCCURRENCES OF '”' IN wa_tab-purchaserequisitionitemtext WITH '"' .
      CONDENSE wa_tab-purchaserequisitionitemtext  .
*SHIFT wa_tab-PurchaseRequisitionItemText LEFT DELETING LEADING space .

      READ ENTITIES OF i_purchaserequisitiontp
      ENTITY purchaserequisitionitemtext
      FROM VALUE #( ( purchaserequisition = wa_tab-purchaserequisition
      purchaserequisitionitem = wa_tab-purchaserequisitionitem
      textobjecttype = 'B01'
      language = 'E' )
      )
      RESULT DATA(lt_pr_details).

      IF lt_pr_details IS NOT INITIAL.
        IF lt_pr_details IS NOT INITIAL.
          LOOP AT lt_pr_details INTO DATA(ls_text).
            DATA(itemtext) = ls_text-plainlongtext.
          ENDLOOP.
        ENDIF.
      ENDIF.

*      READ TABLE curr INTO DATA(curstocks) WITH KEY material = wa_tab-material plant = wa_tab-plant .
*      IF sy-subrc = 0.
*        currentstocks = curstocks-currstock.
*      ENDIF.

*      LOOP AT current_stock INTO DATA(curstocks).
*        currentstocks = curstocks-matlwrhsstkqtyinmatlbaseunit.
*      ENDLOOP.
      READ TABLE current_stock INTO DATA(curstocks) WITH KEY material = wa_tab-material plant = wa_tab-plant .
      IF sy-subrc = 0.
        currentstocks = curstocks-currstock.
      ENDIF.

      """"""last purchase price""""""""""""
      DATA: lv_po    TYPE ebeln,
            lv_po_it TYPE ebelp,
            lv_price TYPE p LENGTH 15 DECIMALS 2,
            lv_matnr TYPE matnr,
            lv_plant TYPE werks_d.

      lv_matnr = wa_tab-material.
      lv_plant = wa_tab-plant.

      CLEAR: lv_po, lv_po_it, lv_price.

      SELECT
      FROM  i_materialdocumentitem_2  AS a
      FIELDS  a~material  , a~purchaseorder  , a~purchaseorderitem
      WHERE a~material    = @lv_matnr
        AND a~plant  = @lv_plant
        AND a~goodsmovementtype = '101'
        AND a~purchaseorder  IS NOT INITIAL
        ORDER BY a~postingdate    DESCENDING,
            a~materialdocument  DESCENDING

        INTO  TABLE @DATA(lt_matdoc)
      UP TO 1 ROWS.
      READ TABLE lt_matdoc INTO DATA(ls_matdoc) INDEX 1.
      IF sy-subrc = 0.

        lv_po    = ls_matdoc-purchaseorder.
        lv_po_it = ls_matdoc-purchaseorderitem.

        SELECT SINGLE
         FROM i_purchaseorderitemapi01
         FIELDS netpriceamount
         WHERE purchaseorder     = @lv_po
        AND purchaseorderitem = @lv_po_it
      INTO @lv_price.
      ENDIF.
      """"""""""
      """"""""""total quantity
      DATA: lv_total_qty TYPE  p  LENGTH 15 DECIMALS 2.
      lv_total_qty  +=  wa_tab-requestedquantity.
      DATA(lv_vs_tab) =
      |<Row1>| &&
         |<sno>{ sno }</sno>| &&
         |<itemcode>{ var1 }</itemcode>| &&
         |<itemdes>{ wa_tab-purchaserequisitionitemtext }{ newline }{ itemtext }</itemdes>| &&
        |<currstock>{ currentstocks }</currstock>| &&

      |<saftstock>{ wa_tab-safetystockquantity }</saftstock>| &&
      |<itemText>{ wa_tab-yy1_itemtext_pri }</itemText>| &&                                    " ++Sudip on 10122024 Suggested by Shalu Varma
      |<unit>{ pc }</unit>| &&
      |<quantity>{ wa_tab-requestedquantity }</quantity>| &&
      |<rate>{  wa_tab-deliverydate+6(2) }/{  wa_tab-deliverydate+4(2) }/{  wa_tab-deliverydate+0(4) }</rate>| &&
       |<lastpurchaseprice>{ lv_price }</lastpurchaseprice>| &&
*            |<total>{ TEXT-ProductGroupText }</total>| &&
      |</Row1>| .

      CONCATENATE lv_vs2 lv_vs_tab INTO lv_vs2 .
      CLEAR : lv_vs_tab,itemtext,currentstocks .

    ENDLOOP.

    SELECT SINGLE FROM i_purchaserequisitionitemapi01 AS a
    INNER JOIN i_businessuserbasic AS b ON a~createdbyuser = b~userid
    FIELDS
    b~personfullname
    WHERE a~purchaserequisition = @prdoc AND a~isdeleted = ''
    INTO @DATA(prepby) PRIVILEGED ACCESS.
    """""""""""""""""""""""""""""""""""
    DATA: lt_wf_id TYPE TABLE OF string,
          lv_app   TYPE string.

    SELECT c~personfullname
      FROM i_workflowstatusoverview  AS a
      LEFT  JOIN  i_workflowstatusdetails  AS b ON a~workflowinternalid  = b~workflowinternalid
      LEFT JOIN i_businessuserbasic AS c ON b~workflowtaskprocessor = c~userid
      WHERE a~sapbusinessobjectnodekey1 = @prdoc
      AND a~sapobjectnoderepresentation  = 'PurchaseRequisition'
      ORDER BY b~wrkflwtskcompletionutcdatetime  DESCENDING
         INTO TABLE  @lt_wf_id
      PRIVILEGED ACCESS
     UP TO 1 ROWS.

    READ TABLE lt_wf_id INTO lv_app INDEX 1.


    DATA(lv_vs3) =
    |<FooterRow/>| &&
  |</Table1>| &&
|</Subform9>| &&
|<Subform10>| &&
      |<totalqty>{ lv_total_qty }</totalqty>| &&
    |<appby>{ lv_app }</appby>| &&
  |<preparedby>{ prepby }</preparedby>| &&
|</Subform10>| &&
|</form1>| .

    CONCATENATE lv_vs1 lv_vs2 lv_vs3 INTO lv_xml .

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


    REPLACE ALL OCCURRENCES OF '€' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '‚' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ƒ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '„' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '…' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '†' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '‡' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ˆ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '‰' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Š' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '‹' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Œ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ž' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '‘' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '’' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '“' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '”' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '•' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '–' IN lv_xml WITH '&#150'.
    REPLACE ALL OCCURRENCES OF '—' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '˜' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '™' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'š' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '›' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'œ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ž' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ÿ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¡' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¢' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '£' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¤' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¥' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¦' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '§' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¨' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '©' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ª' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '«' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¬' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '®' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¯' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '°' IN lv_xml WITH '&#176'.
    REPLACE ALL OCCURRENCES OF '±' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '²' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '³' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '´' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'µ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¶' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '·' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¸' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¹' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'º' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '»' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¼' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '½' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¾' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '¿' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'À' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Á' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Â' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ã' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ä' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Å' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Æ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ç' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'È' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'É' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ê' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ë' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ì' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Í' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Î' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ï' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ð' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ñ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ò' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ó' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ô' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Õ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ö' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '×' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ø' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ù' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ú' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Û' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ü' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Ý' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'Þ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ß' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'à' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'á' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'â' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ã' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ä' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'å' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'æ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ç' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'è' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'é' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ê' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ë' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ì' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'í' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'î' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ï' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ð' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ñ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ò' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ó' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ô' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'õ' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ö' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '÷' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ø' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ù' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ú' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'û' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ü' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '✓' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF 'ý' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '&' IN lv_xml WITH 'And'.
    REPLACE ALL OCCURRENCES OF '༯' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF '\u00A0' IN lv_xml WITH space.
    REPLACE ALL OCCURRENCES OF PCRE '[\x00-\x08\x0B\x0C\x0E-\x1F]' IN lv_xml WITH ''.
    REPLACE ALL OCCURRENCES OF PCRE '\xA0' IN lv_xml WITH ''.


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
