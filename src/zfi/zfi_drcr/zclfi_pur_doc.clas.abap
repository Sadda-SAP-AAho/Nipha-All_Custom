CLASS zclfi_pur_doc DEFINITION

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
        IMPORTING comcode         TYPE string
                  plant           TYPE string
                  date            TYPE string
                  docno           TYPE string
                  year            TYPE string
                  checkboxvalue   TYPE string
                  debitcreditnote TYPE string
                  creditmemo      TYPE string
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://devtenant-ux00yyve.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS  lc_template_name TYPE string VALUE 'ZFI_PURCHASE_FIN/ZFI_PURCHASE_FIN'.

ENDCLASS.



CLASS ZCLFI_PUR_DOC IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.
    TRY.
        DATA(return_data) = read_posts(
          comcode         = 'NE01'
          plant           = ''
          date            = ''
          docno           = ''
          year            = ''
          checkboxvalue   = ''
          debitcreditnote = ''
          creditmemo      = ''
        ).

      CATCH cx_static_check INTO DATA(lx_error).
        out->write( 'An error occurred during execution:' ).
        out->write( lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_posts.
    DATA lc_template_name1 TYPE string .




    SELECT  * FROM  i_supplierinvoiceapi01 AS a
           LEFT OUTER JOIN i_suplrinvcitempurordrefapi01 AS b ON ( b~supplierinvoice = a~supplierinvoice AND b~fiscalyear = a~fiscalyear )
           LEFT OUTER JOIN zsd_journal_entry AS c ON ( c~originalreferencedocument = b~supplierinvoice AND c~accountingdocumenttype = 'RE' AND c~fiscalyear = b~fiscalyear )
*                             left OUTER join I_OperationalAcctgDocItem as d on ( d~AccountingDocument = c~AccountingDocument and d~FiscalYear = c~FiscalYear   )
           LEFT OUTER JOIN i_plant AS e ON ( e~plant = b~plant  )
           LEFT OUTER JOIN i_purchaseorderapi01 AS f ON ( f~purchaseorder = b~purchaseorder  )
           LEFT OUTER JOIN i_businesspartner AS g ON ( g~businesspartner = a~invoicingparty  )
           LEFT OUTER JOIN i_supplier AS h ON ( h~supplier = a~invoicingparty  )
           LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS AS hh ON ( hh~addressid = h~addressid  )

           LEFT OUTER JOIN i_regiontext AS i ON ( i~region = h~region AND i~language = 'E' AND i~country = h~country   )
           WHERE a~supplierinvoice = @docno AND a~fiscalyear = @year AND a~companycode = @comcode  INTO TABLE @DATA(tab1) .

*DELETE ADJACENT DUPLICATES FROM tab1 COMPARING B-SupplierInvoice  .

    SELECT  * FROM  i_supplierinvoiceapi01 AS a
                                 LEFT OUTER JOIN i_suplrinvcitempurordrefapi01 AS b ON ( b~supplierinvoice = a~supplierinvoice AND b~fiscalyear = a~fiscalyear )
                                 LEFT OUTER JOIN zsd_journal_entry AS c ON ( c~originalreferencedocument = b~supplierinvoice
                                 AND c~accountingdocumenttype = 'RE' AND c~fiscalyear = b~fiscalyear )

                                 LEFT OUTER JOIN i_pricingconditiontypetext AS e ON ( e~conditiontype = b~suplrinvcdeliverycostcndntype AND e~language = 'E'
                                                                                       AND e~conditionapplication = 'M' AND b~suplrinvcdeliverycostcndntype <> '' )
                                 LEFT OUTER JOIN i_purchaseorderitemapi01 AS d ON ( d~purchaseorder = b~purchaseorder AND d~purchaseorderitem = b~purchaseorderitem
                                      AND b~suplrinvcdeliverycostcndntype = '' )

                                  """SS
*                             left OUTER join I_OperationalAcctgDocItem as z on ( z~OriginalReferenceDocument = a~SupplierInvoiceWthnFiscalYear
*                             AND z~TransactionTypeDetermination in ('WRX','FR1','FR2','FR3') AND z~PurchasingDocument = d~PurchaseOrder AND
*                             z~PurchasingDocumentItem = d~PurchaseOrderItem )
*
*                             """SS
                                  WHERE a~supplierinvoice = @docno AND a~fiscalyear = @year AND a~companycode = @comcode
                                 INTO TABLE @DATA(tab12) .

*DELETE ADJACENT DUPLICATES FROM tab12 COMPARING d-PurchaseOrderItem .

    """"""""""""""""""""""""""""""""""""""""""""""""""""Plant Wise Address, GST & PAN"""""""""""""""""""""""""""""""""""
    DATA(gst1)  = '23AAPCS1247M1Z1'.
    DATA(pan1)  = 'AAACN9099H'.
    DATA(register1) = 'NIPHA LIMITED'.
    DATA(register2) = 'Registered Address : Nipha Exports Private Limited, 48, Ganga Jamuna, 28/1, Shakespeare Sarani, West Bengal' .
    DATA(register3) = 'FACTORY ADDRESS : ' .
*Serampore Unit (Rolling Div), Nh2, Delhi Road, Dakshin Rajyadharpur, West Bengal, India'.
*DATA(cin1) = 'U51909WB1973PTC028897'.
    DATA(cin1) = 'U51909WB1973PLC028897'.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    READ TABLE tab1 INTO DATA(bsplc) INDEX 1 .
    SELECT SINGLE accountingdocument , businessplace , amountintransactioncurrency , glaccount
    FROM i_operationalacctgdocitem WHERE accountingdocument = @bsplc-c-accountingdocument AND fiscalyear = @bsplc-c-fiscalyear
                                                     AND businessplace <> ''  INTO @DATA(bp).

    SELECT SINGLE branch , housenumber , cityname , streetname , postalcode , taxnumber1
    FROM i_kr_businessplace WHERE  branch = @bp-businessplace INTO @DATA(headdet) .

    DATA purchaseinvoice TYPE string .
    DATA purchaseinvoice1 TYPE string .

    IF checkboxvalue IS NOT INITIAL .
      IF bsplc-f-purchaseordertype = 'ZSER' .
*    PURCHASEINVOICE = 'Service Invoice' .
        purchaseinvoice = 'Service Invoice' .
        purchaseinvoice1  =  'Service' .
      ELSEIF
      bsplc-f-purchaseordertype = 'ZSUB' .
*    PURCHASEINVOICE = 'Jobwork Invoice' .
        purchaseinvoice1 = 'Jobwork' .
        purchaseinvoice  =  'Jobwork Invoice' .
      ELSE.
        purchaseinvoice  =  'Purchase Invoice' .
        purchaseinvoice1  =  'Purchase' .
      ENDIF.
*****************************************************************
    ELSEIF
    debitcreditnote IS NOT INITIAL .
      IF
      bsplc-f-purchaseordertype = 'ZSUB' .
        purchaseinvoice  =  'Debit/Credit Note' .
        purchaseinvoice1  =  'Purchase' .

      ELSE .
        purchaseinvoice = 'Debit/Credit Note' .
        purchaseinvoice1  =  'Purchase'  .
      ENDIF.
******************************************************************
    ELSEIF
     creditmemo IS NOT INITIAL .
      IF
     bsplc-f-purchaseordertype = 'ZSUB' .
        purchaseinvoice  =  'Credit Memo' .
        purchaseinvoice1  =  'Purchase' .

      ELSE.
        purchaseinvoice  =  'Credit Memo' .
        purchaseinvoice1  =  'Purchase' .
      ENDIF.

    ENDIF.

    DATA state TYPE string .
    IF
    headdet-branch = '6000' .
      state = 'HARYANA' .
    ELSE .
      state = 'WEST BENGAL' .
    ENDIF.


    READ TABLE tab1 INTO DATA(plantadc) INDEX 1.
    IF sy-subrc = 0.
      DATA(plant1) = plantadc-e-plant.
    ENDIF.






    DATA(kv_pan) = bsplc-h-taxnumber3+2(10).
    IF kv_pan IS INITIAL.
      kv_pan = bsplc-h-businesspartnerpannumber.
    ENDIF.

    DATA(lv_xml) =
     |<form1>| &&
 |<Page1>| &&
 |<Subform1>| &&
 |<PlantHead>{ register1 }</PlantHead>| &&
 |<add1>{ register2 }</add1>| &&
 |<add2>{ register3 }- { bsplc-e-plantname }, { headdet-housenumber  }{ headdet-streetname }, { headdet-cityname }-{ headdet-postalcode }, { state }, INDIA</add2>| &&
 |<Subform7>| &&
 |<CINNo>{ cin1 }</CINNo>| &&
 |<GSTIN>{ headdet-taxnumber1 }</GSTIN>| &&
 |<PAN>{ pan1 }</PAN>| &&
 |</Subform7>| &&
 |</Subform1>| &&
 |<Subform2>| &&
|<DOCUMENT>{ purchaseinvoice }</DOCUMENT>| &&
|</Subform2>| &&
 |<Subform3>| &&
 |<CreditDetails>| &&
*  |<DOCUMENT>Invoice</DOCUMENT>| &&
|<DOCUMENT>{ purchaseinvoice1 }</DOCUMENT>| &&
*  |<DOCUMENT>Invoice</DOCUMENT>| &&
|<DOCUMENT>{   purchaseinvoice1 }</DOCUMENT>| &&
 |<DebitNoteNo>{ bsplc-a-supplierinvoice }</DebitNoteNo>| &&
 |<DebitNoteNoHIDE></DebitNoteNoHIDE>| &&
*  |<DebitNoteDateHIDDEN></DebitNoteDateHIDDEN>| &&
 |<DebitNoteDate>{ bsplc-a-postingdate+6(2) }/{ bsplc-a-postingdate+4(2) }/{ bsplc-a-postingdate+0(4) }</DebitNoteDate>| &&
*  |<DocumentNo>Invoice</DocumentNo>| &&
 |<DocumentNo></DocumentNo>| &&
 |<ReferenceNo.>{ bsplc-a-supplierinvoiceidbyinvcgparty }</ReferenceNo.>| &&
 |<Referencedate>{ bsplc-a-documentdate+6(2) }/{ bsplc-a-documentdate+4(2) }/{ bsplc-a-documentdate+0(4) }</Referencedate>| &&
*  |<Referencedate>{ supdet-a-DocumentDate+6(2) }/{ supdet-a-DocumentDate+4(2) }/{ supdet-a-DocumentDate+0(4) }</Referencedate>| &&
 |<PurchaseNo>{ bsplc-b-purchaseorder }</PurchaseNo>| &&
 |<PurchaseDate>{ bsplc-f-purchaseorderdate+6(2) }/{ bsplc-f-purchaseorderdate+4(2) }/{ bsplc-f-purchaseorderdate+0(4) }</PurchaseDate>| &&
 |<CURRENCY>{ bsplc-a-documentcurrency }</CURRENCY>| &&
*  |<plant_no></plant_no>| &&
 |<PREPAREBYY></PREPAREBYY>| &&
 |<DOCUMENT>{ purchaseinvoice1 }</DOCUMENT>| &&
*  |<DebitNoteDate>{ bsplc-a-postingdate+6(2) }/{ bsplc-a-postingdate+4(2) }/{ bsplc-a-postingdate+0(4) }</DebitNoteDate>| &&
  |<PurchaseNo></PurchaseNo>| &&
  |<DOCUMENT>{ purchaseinvoice1 }</DOCUMENT>| &&
  |<PurchaseDate>{ bsplc-a-postingdate+6(2) }/{ bsplc-a-postingdate+4(2) }/{ bsplc-a-postingdate+0(4) }</PurchaseDate>| &&
   |<DOCUMENT>{ purchaseinvoice1 }</DOCUMENT>| &&
    |<Plant>{ plant1 }</Plant>| &&





 |</CreditDetails>| &&
 |<SupplierDetails>| &&
 |<DetailsofSupplier>Party Details</DetailsofSupplier>| &&
 |<Name>  { bsplc-g-businesspartnername }</Name>| &&
 |<Address>{ bsplc-h-streetname }</Address>| &&   " { bsplc-h-BPAddrStreetName }
 |<City>{  bsplc-h-bpaddrcityname }</City>| &&
 |<PinCode>{  bsplc-h-postalcode }</PinCode>| &&
 |<State>{  bsplc-i-regionname }</State>| &&
 |<Phone>{  bsplc-h-phonenumber1 }</Phone>| &&
 |<GSTIN>{  bsplc-h-taxnumber3 }</GSTIN>| &&
 |<Email_id>{  bsplc-hh-emailaddress }</Email_id>| &&
*  |<PAN>{  bsplc-h-BPPanReferenceNumber }</PAN>| &&
  |<PAN>{  kv_pan }</PAN>| &&
 |</SupplierDetails>| &&
 |</Subform3>| &&
 |<Tab1>| &&
 |<Table1>| &&
 |<Row1>| &&
 |<Table2>| &&
 |<Row1/>| &&
 |<Row2>| &&
 |<Table5>| &&
 |<Row1/>| &&
 |</Table5>| &&
 |</Row2>| &&
 |</Table2>| &&
 |<Table3>| &&
 |<Row1/>| &&
 |<Row2>| &&
 |<Table6>| &&
 |<Row1/>| &&
 |</Table6>| &&
 |</Row2>| &&
 |</Table3>| &&
 |<Table4>| &&
 |<Row1/>| &&
 |<Row2>| &&
 |<Table7>| &&
 |<Row1/>| &&
 |</Table7>| &&
 |</Row2>| &&
 |</Table4>| &&
 |</Row1>| &&
 |</Table1>|


      .




    DATA xsml TYPE string .

    DATA n TYPE string .
    DATA cgsdsgst TYPE p DECIMALS 2 .
    DATA igst TYPE p DECIMALS 2 .
    DATA tot TYPE p DECIMALS 2 .
    DATA totfinal TYPE p DECIMALS 2 .



    DATA cgstsgstamt TYPE p DECIMALS 2 .
    DATA igstamt TYPE p DECIMALS 2 .
    DATA taxamt TYPE p DECIMALS 2 .
    DATA rateamt TYPE p DECIMALS 2 .
    DATA uom TYPE string .
    DATA description TYPE string .









    DATA:rk_flag  TYPE  c LENGTH 1,
         rk_flag1 TYPE c LENGTH 1.
    CLEAR:rk_flag,rk_flag1.
    CONCATENATE docno year INTO DATA(awkey).
    SELECT SINGLE accountingdocument , originalreferencedocument , fiscalyear
    FROM i_journalentry WHERE originalreferencedocument = @awkey AND accountingdocumenttype = 'RK'
    INTO  @DATA(rk_item).
    IF sy-subrc = 0.
      rk_flag = 'X'.
*  rk_flag1 = 'X'.
    ENDIF.





    LOOP AT tab12 INTO DATA(wa) .

      """"code added by ss & rg on 22.01.2024
      IF debitcreditnote IS NOT INITIAL AND rk_flag IS NOT INITIAL.
        CONCATENATE docno year INTO awkey.
        SELECT SINGLE originalreferencedocument FROM i_journalentry WHERE originalreferencedocument = @awkey AND accountingdocumenttype = 'RK'
        INTO  @rk_item.
        IF sy-subrc = 0.
          rk_flag = 'X'.
          rk_flag1 = 'X'.
        ENDIF.
      ENDIF.
      """"""





      IF wa-b-taxcode = 'AA' .
        cgsdsgst = '2.5' .
      ELSEIF
      wa-b-taxcode = 'AB' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'AC' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'AD' .
        cgsdsgst = '14' .
      ELSEIF
      wa-b-taxcode = 'AE' .
        cgsdsgst = '2.5' .
      ELSEIF
      wa-b-taxcode = 'AF' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'AG' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'AH' .
        cgsdsgst = '14' .
      ELSEIF
      wa-b-taxcode = 'BA' .
        cgsdsgst = '2.5' .
      ELSEIF
      wa-b-taxcode = 'BB' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'BC' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'BD' .
        cgsdsgst = '14' .
      ELSEIF
      wa-b-taxcode = 'BE' .
        cgsdsgst = '2.5' .
      ELSEIF
      wa-b-taxcode = 'BF' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'BG' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'BH' .
        cgsdsgst = '14' .
      ELSEIF
      wa-b-taxcode = 'CA' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'CB' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'CC' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'CD' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'CE' .
        cgsdsgst = '2.5' .
      ELSEIF
      wa-b-taxcode = 'CF' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'CG' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'CH' .
        cgsdsgst = '14' .
      ELSEIF
      wa-b-taxcode = 'CI' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'CJ' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'CK' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'CL' .
        cgsdsgst = '0' .
      ELSEIF
      wa-b-taxcode = 'DA' .
        cgsdsgst = '2.5' .
      ELSEIF
      wa-b-taxcode = 'DB' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'DC' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'DD' .
        cgsdsgst = '14' .
      ELSEIF
      wa-b-taxcode = 'DE' .
        cgsdsgst = '2.5' .
      ELSEIF
      wa-b-taxcode = 'DF' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'DG' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'DF' .
        cgsdsgst = '6' .
      ELSEIF
      wa-b-taxcode = 'DG' .
        cgsdsgst = '9' .
      ELSEIF
      wa-b-taxcode = 'DH' .
        cgsdsgst = '14' .

      ENDIF.







      IF wa-b-taxcode = 'AI' .
        igst = '5' .
      ELSEIF
      wa-b-taxcode = 'AJ' .
        igst = '12' .
      ELSEIF
      wa-b-taxcode = 'AK' .
        igst = '18' .
      ELSEIF
      wa-b-taxcode = 'AL' .
        igst = '28' .
      ELSEIF
      wa-b-taxcode = 'BI' .
        igst = '5' .
      ELSEIF
      wa-b-taxcode = 'BJ' .
        igst = '12' .
      ELSEIF
      wa-b-taxcode = 'BK' .
        igst = '18' .
      ELSEIF
      wa-b-taxcode = 'BL' .
        igst = '28' .
      ELSEIF
      wa-b-taxcode = 'CI' .
        igst = '5' .
      ELSEIF
      wa-b-taxcode = 'CJ' .
        igst = '12' .
      ELSEIF
      wa-b-taxcode = 'CK' .
        igst = '18' .
      ELSEIF
      wa-b-taxcode = 'CL' .
        igst = '28' .
      ELSEIF
      wa-b-taxcode = 'DA' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'DB' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'DC' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'DD' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'DI' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'DJ' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'DK' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'DL' .
        igst = '0' .
      ELSEIF
      wa-b-taxcode = 'I1' .
        igst = '18' .
      ELSEIF
      wa-b-taxcode = 'I2' .
        igst = '18' .
      ELSEIF
      wa-b-taxcode = 'I3' .
        igst = '18' .
      ELSEIF
      wa-b-taxcode = 'I4' .
        igst = '18' .
      ENDIF.


      IF
      wa-b-purchaseorderquantityunit = 'ST' .
        uom = 'PC' .
      ELSEIF
      wa-b-purchaseorderquantityunit = 'ZNO' .
        uom = 'NOS' .
      ELSEIF
      wa-b-purchaseorderquantityunit = 'ZST' .
        uom = 'SET' .
      ELSE.
        uom = wa-b-purchaseorderquantityunit .
      ENDIF.


      rateamt = wa-b-supplierinvoiceitemamount / wa-b-quantityinpurchaseorderunit .
      taxamt =  wa-b-supplierinvoiceitemamount .



      IF debitcreditnote IS NOT INITIAL AND rk_flag IS NOT INITIAL.
        DATA:itm TYPE c LENGTH 4.
        CLEAR:itm.
        DATA(imt1) =  wa-b-supplierinvoiceitem.
        SHIFT imt1 LEFT DELETING LEADING '0'.
        itm = imt1.

        itm = |{ itm ALPHA = IN }|.

        SELECT SINGLE quantityindeliveryqtyunit , quantity , deliveryquantityunit
        FROM i_purchaseorderhistoryapi01  WHERE purchasinghistorydocument = @docno AND
        purchasinghistorydocumentyear = @year
        AND purchasinghistorydocumentitem = @itm
        INTO @DATA(wa_history).
        IF sy-subrc = 0.
          wa-b-quantityinpurchaseorderunit = wa_history-quantityindeliveryqtyunit  - wa_history-quantity .
          uom = wa_history-deliveryquantityunit.
          IF uom = 'ST'.
            uom = 'PC'.
          ENDIF.
          SELECT SINGLE amountintransactioncurrency , accountingdocument
          FROM i_operationalacctgdocitem WHERE accountingdocument = @rk_item-accountingdocument
          AND fiscalyear = @rk_item-fiscalyear AND transactiontypedetermination = 'RKA' INTO @DATA(rkamt).
          IF sy-subrc = 0.
            IF wa-b-quantityinpurchaseorderunit = 0.

              DATA(error_flag) = 'X'.
            ELSE.
              taxamt =  rkamt-amountintransactioncurrency * ( -1 ) .
              rateamt = taxamt / wa-b-quantityinpurchaseorderunit.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.




      IF error_flag NE 'X'.




        cgstsgstamt =  cgsdsgst / 100 * taxamt .
        igstamt =   igst / 100 * taxamt .
        totfinal = totfinal + taxamt + cgstsgstamt + cgstsgstamt + igstamt.
        tot =  taxamt + cgstsgstamt + cgstsgstamt + igstamt .



        DATA condtyp TYPE string.

        IF wa-e-conditiontype = ''.
          condtyp = 'WRX'.
        ELSEIF  wa-e-conditiontype = 'ZFRT' OR   wa-e-conditiontype = 'ZFRB'  OR  wa-e-conditiontype = 'ZTPF'.
          condtyp = 'FR1'.
        ELSEIF  wa-e-conditiontype = 'ZCDB' OR  wa-e-conditiontype = 'ZSWC'.
          condtyp = 'FR2'.
        ELSEIF     wa-e-conditiontype = 'ZPCK' OR wa-e-conditiontype = 'ZINC' OR wa-e-conditiontype = 'ZOTH'
          OR  wa-e-conditiontype = 'ZCFA'
          OR  wa-e-conditiontype = 'ZTPI'.
          condtyp = 'FR3' .
        ENDIF.



        n = n + 1 .

        IF wa-e-conditiontypename = '' .
          IF condtyp = 'WRX'.

            CONCATENATE docno year INTO DATA(ref).
            SELECT SINGLE originalreferencedocument , in_hsnorsaccode , fixedasset
            FROM i_operationalacctgdocitem  WHERE originalreferencedocument
            = @ref  AND purchasingdocument = @wa-b-purchaseorder AND
             purchasingdocumentitem = @wa-b-purchaseorderitem AND transactiontypedetermination = @condtyp
              INTO @DATA(docitm) .
            IF sy-subrc = 0.
              DATA(hsn)   = docitm-in_hsnorsaccode.
              CONCATENATE 'HSN/SAC Code: ' hsn INTO DATA(hsn1) SEPARATED BY ''.
              IF docitm-fixedasset IS NOT INITIAL.
                DATA(asset) = docitm-fixedasset.
                CONCATENATE 'Asset Code: ' hsn INTO DATA(asset1) SEPARATED BY ''.
              ENDIF.
            ENDIF.
            description = wa-d-purchaseorderitemtext .


*  DATA: original_string TYPE string.
*        DATA: words TYPE TABLE OF string.
*
*original_string = DESCRIPTION.
*
*SPLIT original_string AT ' ' INTO TABLE words.
*
*LOOP AT words INTO DATA(word).
**  WRITE word.  " This will output each word on a new line
*ENDLOOP.
*
*SPLIT original_string AT 'NBSP' INTO TABLE words.
*
*LOOP AT words INTO word.
**  WRITE word.  " This will output each word on a new line
*ENDLOOP.
*
**CALL FUNCTION  'SSM_REPLACE_SPACE_BY_NBSP'
** IMPORTING
**    VALUE(INPUT_STRING) LIKE SMEN_BUFF-TEXT
**  EXPORTING
**    VALUE(OUTPUT_STRING) LIKE SMEN_BUFF-TEXT.
*
*CALL METHOD cl_



            SHIFT wa-d-material LEFT DELETING LEADING '0'.
            IF docitm-fixedasset IS NOT INITIAL.
              CONCATENATE wa-d-material
              cl_abap_char_utilities=>newline
              wa-d-purchaseorderitemtext
              cl_abap_char_utilities=>newline
               hsn1
              cl_abap_char_utilities=>newline
               asset1
               INTO description.
            ELSE.
              description = wa-d-purchaseorderitemtext .

              SHIFT wa-d-material LEFT DELETING LEADING '0'.
              CONCATENATE wa-d-material
              cl_abap_char_utilities=>newline
              wa-d-purchaseorderitemtext
              cl_abap_char_utilities=>newline
               hsn1
               INTO description.
            ENDIF.
          ENDIF.


          IF  bsplc-f-purchaseordertype = 'ZSER' .
            CLEAR:description.
            CONCATENATE wa-d-purchaseorderitemtext
             cl_abap_char_utilities=>newline
              hsn1  INTO description.
          ENDIF.




        ELSEIF wa-e-conditiontypename NE '' .

          IF condtyp = 'FR1' OR condtyp = 'FR2' OR condtyp = 'FR3' .
            CONCATENATE docno year INTO ref.
            SELECT SINGLE originalreferencedocument , in_hsnorsaccode
            FROM i_operationalacctgdocitem  WHERE originalreferencedocument
            = @ref  AND purchasingdocument = @wa-b-purchaseorder AND
             purchasingdocumentitem = @wa-b-purchaseorderitem  AND transactiontypedetermination =
             @condtyp    INTO @docitm.
            IF sy-subrc = 0.
              hsn = docitm-in_hsnorsaccode.
              CONCATENATE 'HSN/SAC Code: ' hsn INTO hsn1 SEPARATED BY ''.
            ENDIF.
            description = wa-e-conditiontypename .
            CONCATENATE description
            cl_abap_char_utilities=>newline
             hsn1  INTO description.

            IF  bsplc-f-purchaseordertype = 'ZSER' .
              CLEAR:description.
              CONCATENATE wa-e-conditiontypename
               cl_abap_char_utilities=>newline
                hsn1  INTO description.
            ENDIF.




          ENDIF.
        ENDIF.











        CLEAR:hsn,docitm,condtyp.

        REPLACE ALL OCCURRENCES OF '<' IN description WITH 'LT'.
        REPLACE ALL OCCURRENCES OF '>' IN description WITH 'GT'.
        REPLACE ALL OCCURRENCES OF '”' IN description WITH ''.

        DATA(lv_xml2) =
|<Table8>| &&

     |<Row1>| &&
     |<Sno>{ n }</Sno>| &&
     |<Description>{ description }</Description>| &&
     |<Qty>{ wa-b-quantityinpurchaseorderunit }</Qty>| &&
     |<UOM>{ uom }</UOM>| &&
     |<Rate>{ rateamt }</Rate>| &&
     |<Taxable>{  taxamt  }</Taxable>| &&
     |<CGSTRAte>{ cgsdsgst }%</CGSTRAte>| &&
     |<CGSTamount>{ cgstsgstamt  }</CGSTamount>| &&
     |<SGSTRATE>{ cgsdsgst }%</SGSTRATE>| &&
     |<SGSTamount>{ cgstsgstamt }</SGSTamount>| &&
     |<IGSTRATE>{ igst }%</IGSTRATE>| &&
     |<IGSTamount>{ igstamt }</IGSTamount>| &&
     |<TOT>{ tot }</TOT>| &&
     |</Row1>| &&
          |</Table8>|

     .

        CONCATENATE xsml lv_xml2 INTO  xsml .

      ENDIF.

      CLEAR  : lv_xml2,wa,rateamt,taxamt,cgstsgstamt,igstamt,description,error_flag.
*         ,CGSDSGST,IGST.
*

    ENDLOOP.

*##########################################VV#######V##############VV############################LOOP"



    DATA roundoff TYPE string .
    IF
    bp-glaccount = '0045000890' .
      roundoff = bp-amountintransactioncurrency.
    ELSE .
      roundoff = '' .
    ENDIF.

    DATA cgtot TYPE string .
    DATA igtot TYPE string .
    DATA inctot TYPE string .

    cgtot = cgsdsgst / 100 * bsplc-a-unplanneddeliverycost .
    igtot = igst  / 100 * bsplc-a-unplanneddeliverycost .

    inctot = totfinal + cgtot + cgtot + igtot + bsplc-a-unplanneddeliverycost  .


    IF rk_flag1 = 'X' AND debitcreditnote = 'X'.
      bsplc-a-unplanneddeliverycost = 0.
      cgtot = 0.
      igtot = 0 .
      bp-accountingdocument = rk_item-accountingdocument.

      inctot = totfinal + cgtot + cgtot + igtot + bsplc-a-unplanneddeliverycost .

    ENDIF.

    DATA: lv_number  TYPE p DECIMALS 2,
          lv_number1 TYPE p DECIMALS 0. " Rounded to 0 decimals for a whole number

    lv_number = inctot.
    lv_number1 = round( val = lv_number dec = 0 ) .
    IF lv_number1 > lv_number.
      roundoff = lv_number1 - lv_number .
    ELSEIF lv_number1 < lv_number .
      roundoff = lv_number - lv_number1 .
    ENDIF.

    inctot = lv_number1 .







    DATA(lv_xml_middle) =
    |</Tab1>| &&
    |<Subform4>| &&
    |<Remark>{ bsplc-a-supplierpostinglineitemtext }</Remark>| &&
    |<AmountInWords>{ bsplc-a-documentcurrency }</AmountInWords>| &&
*     |<AmountInWords>{ tot }</AmountInWords>| &&  "SWETA"
    |<Subform5>| &&
    |<FrightCharges>{ bsplc-a-unplanneddeliverycost }</FrightCharges>| &&
    |<CGST>{ cgtot }</CGST>| &&
    |<SGST>{ cgtot }</SGST>| &&
    |<IGST>{ igtot }</IGST>| &&
    |<RoundingOff>{ roundoff }</RoundingOff>| &&
    |<InvoiceTotal>{ inctot }</InvoiceTotal>| &&
    |</Subform5>| &&
    |</Subform4>| &&


     |<Subform13>| &&
        |<VoucherNo>{ bp-accountingdocument }</VoucherNo>| &&
        |<VoucherDate>{ bsplc-a-postingdate+6(2) }/{ bsplc-a-postingdate+4(2) }/{ bsplc-a-postingdate+0(4) }</VoucherDate>| &&
     |</Subform13>| &&
     |<Subform14>| &&
     |<Table13>| &&
     |<HeaderRow/>| .

    CLEAR: roundoff.




    IF rk_flag1 NE 'X'.
      SELECT  d~amountintransactioncurrency ,
              d~debitcreditcode ,
              e~glaccountlongname,
              c~accountingdocument,
              d~accountingdocumentitemtype ,
              d~glaccount,
              d~accountingdocumentitem,
              d~costcenter,
              d~segment



               FROM  i_supplierinvoiceapi01 AS a
*                             left OUTER join I_SuplrInvcItemPurOrdRefAPI01 as b on ( b~SupplierInvoice = a~SupplierInvoice and b~FiscalYear = a~FiscalYear )
                        LEFT OUTER JOIN i_journalentry AS c ON ( c~originalreferencedocument = a~supplierinvoicewthnfiscalyear AND c~accountingdocumenttype = 'RE'  )
                        LEFT OUTER JOIN i_operationalacctgdocitem AS d ON ( d~accountingdocument = c~accountingdocument AND d~fiscalyear = c~fiscalyear   )
                        LEFT OUTER JOIN i_glaccounttext AS e ON ( e~glaccount = d~glaccount AND e~language = 'E' )

                        WHERE a~supplierinvoice = @docno AND a~fiscalyear = @year AND a~companycode = @comcode INTO TABLE @DATA(footer) .

    ELSEIF rk_flag1 = 'X'.

      SELECT  d~amountintransactioncurrency ,
                       d~debitcreditcode ,
                       e~glaccountlongname,
                       c~accountingdocument,
                       d~accountingdocumentitemtype ,
                       d~glaccount,
                       d~accountingdocumentitem,
                       d~costcenter,
                       d~segment



                        FROM  i_supplierinvoiceapi01 AS a
*                             left OUTER join I_SuplrInvcItemPurOrdRefAPI01 as b on ( b~SupplierInvoice = a~SupplierInvoice and b~FiscalYear = a~FiscalYear )
                                 LEFT OUTER JOIN i_journalentry AS c ON ( c~originalreferencedocument = a~supplierinvoicewthnfiscalyear AND c~accountingdocumenttype = 'RK'  )
                                 LEFT OUTER JOIN i_operationalacctgdocitem AS d ON ( d~accountingdocument = c~accountingdocument AND d~fiscalyear = c~fiscalyear   )
                                 LEFT OUTER JOIN i_glaccounttext AS e ON ( e~glaccount = d~glaccount AND e~language = 'E' )

                                 WHERE a~supplierinvoice = @docno AND a~fiscalyear = @year AND a~companycode = @comcode INTO TABLE @footer .



    ENDIF.
*DELETE ADJACENT DUPLICATES FROM footer COMPARING GLAccount .

    DATA xsmll TYPE string .
    DATA paisatot TYPE p DECIMALS 2 .
    DATA paisa1tot TYPE p DECIMALS 2 .
    DATA paisa1 TYPE p DECIMALS 2 .
    DATA paisa TYPE p DECIMALS 2 .

    SORT footer BY accountingdocumentitem .

    TYPES:BEGIN OF t_footer,
            sl                          TYPE string,
            glaccount                   TYPE c LENGTH 10,
            amountintransactioncurrency TYPE menge_d,
            debitcreditcode             TYPE c LENGTH 1,
            glaccountlongname           TYPE c LENGTH 40,
            accountingdocument          TYPE belnr_d,
            accountingdocumentitemtype  TYPE c LENGTH 1,
            accountingdocumentitem      TYPE n LENGTH 3,
            costcenter                  TYPE c LENGTH 10,
            segment                     TYPE c LENGTH 10,
          END OF t_footer.




    DATA:footern TYPE STANDARD TABLE OF  t_footer.
    DATA:footern1 TYPE STANDARD TABLE OF  t_footer.
    CLEAR footern1[].
    DATA(foot) = footer[].
    CLEAR:foot[].
    MOVE-CORRESPONDING footer TO footern.
    SORT footern BY glaccount ASCENDING.
    DATA amt TYPE p DECIMALS 2.


    LOOP AT footern INTO DATA(fs).
      CONCATENATE fs-glaccount fs-accountingdocumentitemtype INTO fs-sl.
      MODIFY footern FROM fs INDEX sy-tabix TRANSPORTING sl.
    ENDLOOP..




    LOOP AT footern INTO DATA(gs) WHERE accountingdocumentitemtype = 'T' OR accountingdocumentitemtype = 'W' .
      amt = amt + gs-amountintransactioncurrency.
      DATA(gs1) = gs.
      AT END OF sl.
        gs1-amountintransactioncurrency = amt.
        APPEND gs1 TO footern1.
        CLEAR:amt.
      ENDAT.
    ENDLOOP.
    MOVE-CORRESPONDING footern1 TO foot.
    DELETE footer[] WHERE accountingdocumentitemtype = 'T'.
    DELETE footer[] WHERE accountingdocumentitemtype = 'W'.
    APPEND LINES OF foot TO footer.



    SORT footer BY accountingdocumentitem.



    READ TABLE footer INTO DATA(chnge) INDEX 1 .

    IF chnge-accountingdocumentitemtype <> '' .

      LOOP AT footer INTO DATA(wa2) .
        SHIFT wa2-segment LEFT DELETING LEADING '0'.
        IF wa2-debitcreditcode = 'S' AND wa2-amountintransactioncurrency > 0.
          paisa = wa2-amountintransactioncurrency  .
        ELSEIF
        wa2-debitcreditcode = 'H' OR wa2-amountintransactioncurrency < 0.
          paisa1 = wa2-amountintransactioncurrency .
        ENDIF.
        paisatot   =  paisatot + paisa .
        paisa1tot = paisa1tot + paisa1 .


        IF wa2-costcenter IS NOT INITIAL.
*CONCATENATE '-' wa2-CostCenter INTO data(lv_cost) SEPARATED BY ' '.
          DATA(lv_cost) = |-| & | | & | { wa2-costcenter } | .
        ENDIF.
        IF wa2-segment IS NOT INITIAL.
*CONCATENATE '-'  wa2-Segment INTO data(lv_seg) SEPARATED BY ' '.
          DATA(lv_seg) = |-| & | | & | { wa2-segment } | .
        ENDIF.


* CONCATENATE WA2-GLAccountLongName lv_cost lv_seg  INTO data(lv_name)
* separated by ' '.

        DATA(lv_name) = |{ wa2-glaccountlongname }| & | | & |{ lv_cost }| & | | & |{ lv_seg  }| .
        wa2-glaccountlongname = lv_name.






        SHIFT wa2-glaccount LEFT DELETING LEADING '0'.

        DATA(lv_xmlnew) =

                 |<Row1>| &&
                 |<GLAccount>{ wa2-glaccount }</GLAccount>| &&
                 |<Particulars>{ wa2-glaccountlongname }</Particulars>| &&
                 |<debit>{  paisa }</debit>| &&
                 |<credit>{ paisa1 * -1 }</credit>| &&
                 |</Row1>| .





        CONCATENATE xsmll lv_xmlnew INTO  xsmll .
        CLEAR : lv_xmlnew,wa2,paisa1,paisa,lv_cost,lv_seg,lv_name .
*        ,PAISA1tot,PAISAtot.
      ENDLOOP.

    ELSE .




      LOOP AT footer INTO wa2 .

        SHIFT wa2-segment LEFT DELETING LEADING '0'.

* if Wa2-DebitCreditCode = 'S' AND Wa2-AmountInTransactionCurrency > 0.
        IF wa2-amountintransactioncurrency > 0.
          paisa = wa2-amountintransactioncurrency  .
        ELSEIF
* Wa2-DebitCreditCode = 'H' AND Wa2-AmountInTransactionCurrency < 0.
         wa2-amountintransactioncurrency < 0.
          paisa1 = wa2-amountintransactioncurrency .
        ENDIF.
        paisatot   =  paisatot + paisa .
        paisa1tot = paisa1tot + paisa1 .



        IF wa2-costcenter IS NOT INITIAL.
*CONCATENATE '-' wa2-CostCenter INTO data(lv_cost) SEPARATED BY ' '.
          lv_cost = |-| & | | & | { wa2-costcenter } | .
        ENDIF.
        IF wa2-segment IS NOT INITIAL.
*CONCATENATE '-'  wa2-Segment INTO data(lv_seg) SEPARATED BY ' '.
          lv_seg = |-| & | | & | { wa2-segment } | .
        ENDIF.


* CONCATENATE WA2-GLAccountLongName lv_cost lv_seg  INTO data(lv_name)
* separated by ' '.

        lv_name = |{ wa2-glaccountlongname }| & | |  & |{ lv_cost }| & | | & |{ lv_seg  }| .
        wa2-glaccountlongname = lv_name.






        wa2-glaccountlongname = lv_name.

        SHIFT wa2-glaccount LEFT DELETING LEADING '0'.


        lv_xmlnew =

                  |<Row1>| &&
                  |<GLAccount>{ wa2-glaccount }</GLAccount>| &&
                  |<Particulars>{ wa2-glaccountlongname }</Particulars>| &&
                  |<debit>{  paisa }</debit>| &&
                  |<credit>{ paisa1 * -1 }</credit>| &&
                  |</Row1>| .





        CONCATENATE xsmll lv_xmlnew INTO  xsmll .
        CLEAR : lv_xmlnew,wa2,paisa1,paisa,lv_cost,lv_seg,lv_name .
      ENDLOOP.
    ENDIF.


    IF paisatot = 0.
      paisatot   =   paisa1tot .

    ENDIF.

    IF paisa1tot = 0.

      paisa1tot   =   paisatot .

    ENDIF.

    """""""
    SELECT  SINGLE
    FROM  i_supplierinvoiceapi01  AS a
    LEFT OUTER JOIN  i_businessuserbasic  AS b  ON a~createdbyuser  = b~userid
    FIELDS
    b~personfullname
    WHERE a~supplierinvoice   = @docno
    INTO   @DATA(lt_pre).



    IF bsplc-f-purchaseordertype <> 'ZSUB' .

      DATA(lv_xml3) =

             |<FooterRow>| &&
             |<drbittot>{ paisatot }</drbittot>| &&
             |<credittot>{ paisa1tot * -1 }</credittot>| &&
             |<preparedby>{ lt_pre }</preparedby>| &&
             |</FooterRow>| &&
      |</Table13>| &&
      |</Subform14>| &&

      |</Page1>| &&
      |</form1>| .

      CONCATENATE lv_xml xsml lv_xml_middle xsmll lv_xml3 INTO DATA(lv_xml1) .
*//////////////////////////////////////////////////////////jobber invoice//////////////////////////////////
    ELSEIF bsplc-f-purchaseordertype = 'ZSUB' .

      lv_xml3 =

          |<FooterRow>| &&
          |<drbittot>{ paisatot }</drbittot>| &&
          |<credittot>{ paisa1tot * -1 }</credittot>| &&
          |</FooterRow>| &&
   |</Table13>| &&
   |</Subform14>| .

      CONCATENATE xsmll lv_xml3 INTO  xsmll .


      SELECT  * FROM  i_supplierinvoiceapi01 AS a

*                            left OUTER join I_PurchaseOrderItemAPI01 as D on ( D~PurchaseOrder = B~PurchaseOrder AND D~PurchaseOrderItem = B~PurchaseOrderItem )
*                                                                                AND b~SuplrInvcDeliveryCostCndnType = '' )
                                   LEFT OUTER JOIN i_suplrinvcitempurordrefapi01 AS b ON ( b~supplierinvoice = a~supplierinvoice AND b~fiscalyear = a~fiscalyear )
                                   LEFT OUTER JOIN i_purchaseorderhistoryapi01 AS e ON ( e~purchaseorder = b~purchaseorder AND e~purchaseorderitem = b~purchaseorderitem AND
                                                                                           e~purchasinghistorycategory = 'E' AND e~goodsmovementtype = '101' )
                                    LEFT OUTER JOIN i_product AS g ON  ( g~product = e~material )
                                     LEFT OUTER JOIN i_producttypetext AS h ON  ( h~producttype = g~producttype AND h~language = 'E' )

                                   WHERE a~supplierinvoice = @docno AND a~fiscalyear = @year AND a~companycode = @comcode  INTO TABLE @DATA(jobwork) .

      LOOP AT jobwork INTO DATA(wa3) .

        DATA(lv_xml4) =

        |<Subform15>| &&
               |<Table14>| &&
                  |<HeaderRow/>| &&
                  |<Row1>| &&
                     |<GRNCode>{ wa3-e-purchasinghistorydocument }/{ wa3-e-purchasinghistorydocumentyear }</GRNCode>| &&
                     |<ChallanNo>{ wa3-e-documentreferenceid }</ChallanNo>| &&
                     |<ChallanDate>{ wa3-e-documentdate+6(2) }/{ wa3-e-documentdate+4(2) }/{ wa3-e-documentdate+0(4) }</ChallanDate>| &&
                     |<LRNo></LRNo>| &&
                     |<LRDate>{ wa3-e-documentdate+6(2) }/{ wa3-e-documentdate+4(2) }/{ wa3-e-documentdate+0(4) }</LRDate>| &&
                     |<MaterialType>{ wa3-h-materialtypename }</MaterialType>| &&
                  |</Row1>| &&
               |</Table14>| &&
            |</Subform15>| .

        CONCATENATE xsmll lv_xml4 INTO  xsmll .
        CLEAR : lv_xml4 .
      ENDLOOP.



      DATA(lv_xml5) =

          |</Page1>| &&
          |</form1>| .


      CONCATENATE lv_xml xsml lv_xml_middle xsmll lv_xml5 INTO lv_xml1 .
    ENDIF.







    DATA template TYPE string .
    IF bsplc-f-purchaseordertype = 'ZSUB' .
      template = 'ZMM_PURCHASE_JOBBER_INC/ZMM_PURCHASE_JOBBER_INC' .
    ELSE .
      template =  'ZFI_PURCHASE_FIN/ZFI_PURCHASE_FIN' .
    ENDIF.

    REPLACE ALL OCCURRENCES OF '&' IN lv_xml1 WITH 'And'.
    REPLACE ALL OCCURRENCES OF '༯' IN lv_xml1 WITH '/'.
    REPLACE ALL OCCURRENCES OF '\u00A0' IN lv_xml1 WITH space.
    REPLACE ALL OCCURRENCES OF PCRE '[\x00-\x08\x0B\x0C\x0E-\x1F]' IN lv_xml1 WITH ''.
    REPLACE ALL OCCURRENCES OF PCRE '\xA0' IN lv_xml1 WITH ' '.

    CALL METHOD ycl_test_adobe1=>getpdf(
      EXPORTING
        xmldata  = lv_xml1
        template = template
      RECEIVING
        result   = result12 ).



  ENDMETHOD.
ENDCLASS.
