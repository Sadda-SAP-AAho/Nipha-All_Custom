CLASS zservice_crdr_note DEFINITION

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
    CONSTANTS  lc_template_name TYPE string VALUE 'ZFI_SERVICE_CRDR/ZFI_SERVICE_CRDR'.


ENDCLASS.



CLASS ZSERVICE_CRDR_NOTE IMPLEMENTATION.


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
        out->write( 'Error: An exception occurred in read_posts.' ).
        out->write( lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_posts.
    DATA lc_template_name1 TYPE string .



    SELECT  * FROM  i_operationalacctgdocitem AS a
*                    commtented by ss         left OUTER join zsd_journal_entry as c on ( c~OriginalReferenceDocument = A~OriginalReferenceDocument AND C~AccountingDocumentType = 'KR' AND C~FiscalYear = A~FiscalYear )
            LEFT OUTER JOIN zsd_journal_entry AS c ON ( c~originalreferencedocument = a~accountingdocument AND c~accountingdocumenttype = 'KR' AND c~fiscalyear = a~fiscalyear )

           LEFT OUTER JOIN i_plant AS e ON ( e~plant = a~plant  )
           LEFT OUTER JOIN i_businesspartner AS g ON ( g~businesspartner = a~supplier  )
           LEFT OUTER JOIN i_supplier AS h ON ( h~supplier = g~businesspartner  )
           LEFT OUTER JOIN i_regiontext AS i ON ( i~region = h~region AND i~language = 'E'   )
           WHERE a~accountingdocument = @docno AND a~fiscalyear = @year AND a~companycode = @comcode  INTO TABLE @DATA(tab1) .


    SELECT  SINGLE * FROM  i_operationalacctgdocitem AS a
                             LEFT OUTER JOIN i_journalentry AS c ON ( c~originalreferencedocument = a~originalreferencedocument AND c~accountingdocumenttype = 'KR' AND c~fiscalyear = a~fiscalyear )
                             LEFT OUTER JOIN i_purchaseorderapi01 AS d ON ( d~purchaseorder = a~purchasingdocument )
                             WHERE a~accountingdocument = @docno AND a~fiscalyear = @year AND a~companycode = @comcode  INTO  @DATA(referance) .


    """"""""""""""""""""""""""""""""""""""""""""""""""""Plant Wise Address, GST & PAN"""""""""""""""""""""""""""""""""""
    DATA(gst1)  = '23AAPCS1247M1Z1'.
    DATA(pan1)  = 'AAPCS1247M'.
    DATA(register1) = 'NIPHA EXPORTS PRIVATE LIMITED'.
    DATA(register2) = 'Registered Address : Nipha Exports Private Limited, 48, Ganga Jamuna, 28/1, Shakespeare Sarani, West Bengal' .
    DATA(register3) = 'Factory Address : ' .
*Serampore Unit (Rolling Div), Nh2, Delhi Road, Dakshin Rajyadharpur, West Bengal, India'.
    DATA(cin1) = 'U01403MP2010PTC024723'.


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    READ TABLE tab1 INTO DATA(bsplc) INDEX 1 .
    SELECT SINGLE phonenumber , responsiblepersonemailaddress , postalcode , cityname , streetname ,
                  housenumber , vatregistration , taxnumber1 , businesstype
    FROM i_kr_businessplace WHERE  branch = @bsplc-a-businessplace INTO @DATA(headdet) .

    DATA purchaseinvoice TYPE string .

    IF
     creditmemo IS NOT INITIAL .
      purchaseinvoice  =  'Service Credit Note' .
    ENDIF.


    DATA(po_no) = bsplc-a-purchasingdocument .
    DATA(po_dt) = bsplc-a-documentdate.
    CONCATENATE   po_dt+6(2) po_dt+4(2) po_dt+0(4) INTO po_dt SEPARATED BY '/'.

    """code added by ss on 25.12.2023
    SELECT SINGLE accountingdocumenttype , supplier
    FROM i_operationalacctgdocitem WHERE accountingdocument = @docno AND
    supplier NE '' AND fiscalyear = @year AND companycode = @comcode INTO @DATA(supp).
    IF sy-subrc = 0.
      DATA(vendor) = supp-supplier.
      IF supp-accountingdocumenttype = 'KR'.
        po_no = ''.
        po_dt = ''.
        DATA(kr) = 'X'.
      ENDIF.
    ENDIF.
    IF vendor IS NOT INITIAL.
      SELECT SINGLE supplier  FROM i_supplier WHERE supplier = @vendor INTO @DATA(supplier).
*  select SINGLE * from I_BusinessPartAddress_2 WHERE BusinessPartner = @vendor INTO @data(lv_email).
      IF sy-subrc = 0.

        SELECT * FROM i_businesspartner AS g
                                   LEFT OUTER JOIN i_supplier AS h ON ( h~supplier = g~businesspartner  )
                                   LEFT OUTER JOIN i_regiontext AS i ON ( i~region = h~region AND i~language = 'E'   )
                                   WHERE h~supplier = @vendor  INTO TABLE @DATA(supp_dtl).
      ENDIF.
    ENDIF.

    """ss add on 26.03.2024
*  if po_no is INITIAL.
*  PURCHASEINVOICE  =  'Service Invoice' .
*  endif.


    """


    READ TABLE supp_dtl INTO DATA(sup_dtl) INDEX 1.

    DATA panno TYPE string .
    panno = sup_dtl-h-taxnumber3+3(10) .


    IF panno IS INITIAL.
      panno = bsplc-h-businesspartnerpannumber.
    ENDIF.


    DATA(lv_xml) =
     |<form1>| &&
 |<Page1>| &&
 |<Subform1>| &&
 |<PlantHead>{ register1 }</PlantHead>| &&
 |<add1>{ register2 }</add1>| &&
 |<add2>{ bsplc-e-plantname } ,{ headdet-housenumber  }{ headdet-streetname },{ headdet-cityname }, { headdet-postalcode },{ headdet-responsiblepersonemailaddress },{ headdet-phonenumber }</add2>| &&
 |<Subform7>| &&
 |<CINNo>{ headdet-businesstype }</CINNo>| &&
 |<GSTIN>{ headdet-taxnumber1 }</GSTIN>| &&
 |<PAN>{ headdet-vatregistration }</PAN>| &&
 |</Subform7>| &&
 |</Subform1>| &&
 |<Subform2>| &&
|<DOCUMENT>{ purchaseinvoice }</DOCUMENT>| &&
|</Subform2>| &&
 |<Subform3>| &&
 |<CreditDetails>| &&
 |<DOCUMENT>Invoice</DOCUMENT>| &&
 |<DOCUMENT>Invoice</DOCUMENT>| &&
 |<DebitNoteNo>{ bsplc-a-accountingdocument }</DebitNoteNo>| &&
 |<DebitNoteNoHIDE></DebitNoteNoHIDE>| &&
 |<DebitNoteDateHIDDEN></DebitNoteDateHIDDEN>| &&
 |<DocumentNo>Invoice</DocumentNo>| &&
 |<ReferenceNo.>{ referance-c-documentreferenceid }</ReferenceNo.>| &&
 |<Referencedate>{ bsplc-a-documentdate+6(2) }/{ bsplc-a-documentdate+4(2) }/{ bsplc-a-documentdate+0(4) }</Referencedate>| &&
*  |<Referencedate>{ supdet-a-DocumentDate+6(2) }/{ supdet-a-DocumentDate+4(2) }/{ supdet-a-DocumentDate+0(4) }</Referencedate>| &&
 |<PurchaseNo>{ po_no }</PurchaseNo>| &&
 |<PurchaseDate>{ po_dt }</PurchaseDate>| &&
 |<CURRENCY>{ bsplc-a-companycodecurrency }</CURRENCY>| &&
*  |<plant_no></plant_no>| &&
 |<PREPAREBYY></PREPAREBYY>| &&
 |<DOCUMENT>Invoice</DOCUMENT>| &&
 |<DebitNoteDate>{ bsplc-a-postingdate+6(2) }/{ bsplc-a-postingdate+4(2) }/{ bsplc-a-postingdate+0(4) }</DebitNoteDate>| &&
 |</CreditDetails>| &&
 |<SupplierDetails>| &&
 |<DetailsofSupplier>Supplier Detail</DetailsofSupplier>| &&
*  |<Name>  { bsplc-g-BusinessPartnerName }</Name>| &&
  |<Name>  { sup_dtl-g-businesspartnername }</Name>| &&
 |<Address>{ sup_dtl-h-streetname } </Address>| &&
*  |<City>{  bsplc-h-BPAddrCityName }</City>| &&
|<City>{ sup_dtl-h-bpaddrcityname }</City>| &&
 |<PinCode>{  sup_dtl-h-postalcode }</PinCode>| &&
 |<State>{  sup_dtl-i-regionname }</State>| &&
 |<Phone>{  sup_dtl-h-phonenumber1 }</Phone>| &&
 |<GSTIN>{  sup_dtl-h-taxnumber3 }</GSTIN>| &&
 |<PANNO>{  panno }</PANNO>| &&
*  |<Email_id>{  lv_email-EmailAddress }</Email_id>| &&
 |<PAN>{  sup_dtl-h-bppanreferencenumber }</PAN>| &&
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

*
* SELECT   * from  I_OperationalAcctgDocItem as a
* where a~AccountingDocument = @docno and a~FiscalYear = @year AND A~CompanyCode = @comcode AND
** and AccountingDocumentItemType = 'T' AND
* ( A~TransactionTypeDetermination = 'JIC' OR A~TransactionTypeDetermination = 'JCN' OR A~TransactionTypeDetermination = 'JRC'  or
*  A~TransactionTypeDetermination = 'JIS' OR A~TransactionTypeDetermination = 'JSN' OR A~TransactionTypeDetermination = 'JRS'   or
*  A~TransactionTypeDetermination = 'JII' OR A~TransactionTypeDetermination = 'JIN' OR A~TransactionTypeDetermination = 'JRI'  or
*  A~TransactionTypeDetermination = '')
*  into table @DATA(tabl2) .


*   SELECT   * from  I_OperationalAcctgDocItem as a
* where a~AccountingDocument = @docno and a~FiscalYear = @year AND A~CompanyCode = @comcode
* And TaxItemGroup ne '000'
* and AccountingDocumentItemType = 'T' AND
* ( A~TransactionTypeDetermination = 'JIC' OR A~TransactionTypeDetermination = 'JCN' OR A~TransactionTypeDetermination = 'JRC'  or
*  A~TransactionTypeDetermination = 'JIS' OR A~TransactionTypeDetermination = 'JSN' OR A~TransactionTypeDetermination = 'JRS'   or
*  A~TransactionTypeDetermination = 'JII' OR A~TransactionTypeDetermination = 'JIN' OR A~TransactionTypeDetermination = 'JRI'  or
*  A~TransactionTypeDetermination = '')
*  into table @DATA(tabl2) .


    IF kr = 'X'.
      SELECT accountingdocument , accountingdocumentitem , fiscalyear , companycode , taxitemgroup , taxcode ,
             taxitemacctgdocitemref , amountintransactioncurrency , documentitemtext , transactiontypedetermination
      FROM  i_operationalacctgdocitem AS a
      WHERE a~accountingdocument = @docno AND a~fiscalyear = @year AND a~companycode = @comcode
      AND financialaccounttype IN ('S','A') AND debitcreditcode = 'S' AND
      a~transactiontypedetermination = ''
      INTO TABLE @DATA(tabl2) .

      SELECT  accountingdocument , accountingdocumentitemtype , fiscalyear , companycode , taxitemgroup , taxcode ,
              taxitemacctgdocitemref , amountintransactioncurrency , documentitemtext , transactiontypedetermination
     FROM  i_operationalacctgdocitem AS a
     WHERE a~accountingdocument = @docno AND a~fiscalyear = @year AND a~companycode = @comcode
     AND financialaccounttype IN ('S','A') AND
* DEBITCREDITCODE = 'H' AND
     a~accountingdocumentitemtype = 'T'
     INTO TABLE @DATA(tabll2) .



    ENDIF.






*sort tabl2 by TaxBaseAmountInTransCrcy.
*delete ADJACENT DUPLICATES FROM tabl2  COMPARING TaxBaseAmountInTransCrcy .
*sort tabl2 by AccountingDocumentItem ASCENDING.



    DATA:invoicetotal TYPE p DECIMALS 2.
    DATA:inv_tot_rcm TYPE p DECIMALS 2.
    SORT  tabl2 BY accountingdocumentitem ASCENDING.
    DATA:lv_lines TYPE i.
    lv_lines = lines( tabl2 ).
    LOOP AT tabl2 INTO DATA(wa) .



*      SELECT  SINGLE * FROM  i_operationalacctgdocitem AS a
*        WHERE  a~financialaccounttype = 'S' AND  a~debitcreditcode = 'S' AND a~accountingdocumentitemtype = ' ' AND
*        a~accountingdocument = @docno AND a~fiscalyear = @year AND a~companycode = @comcode
*         AND glaccount NOT IN ( '0016005010','0016005020' ) AND transactiontypedetermination = '' AND taxitemgroup =
*         @wa-taxitemgroup
*         AND documentitemtext NE ''  INTO  @DATA(dc) .

*      SELECT  SINGLE * FROM  i_operationalacctgdocitem AS a
*      WHERE  ( a~financialaccounttype = 'S' OR a~financialaccounttype = 'A') AND  a~debitcreditcode = 'S'
*      AND a~accountingdocumentitemtype = ' ' AND ( a~taxcode = 'AA' OR  a~taxcode = 'AB' OR a~taxcode = 'AC' OR a~taxcode = 'AD'
*      OR a~taxcode = 'AI' OR a~taxcode = 'AJ' OR a~taxcode = 'AK' OR a~taxcode = 'AL' ) AND
*      a~accountingdocument = @docno AND a~accountingdocumentitem = @wa-accountingdocumentitem AND a~fiscalyear = @year AND a~companycode = @comcode  INTO  @DATA(dc1) .



      n = n + 1 .
*  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


      SELECT  SINGLE a~amountintransactioncurrency FROM  i_operationalacctgdocitem AS a
      WHERE ( a~transactiontypedetermination = 'JIC' OR a~transactiontypedetermination = 'JCN' OR a~transactiontypedetermination = 'JRC' )
      AND a~accountingdocumentitemtype = 'T' AND
      a~accountingdocument = @docno AND a~fiscalyear = @year AND a~companycode = @comcode  INTO  @DATA(cgst) .


*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      DATA:cgstt     TYPE p DECIMALS 2,
           sgstt     TYPE p DECIMALS 2,
           igstt     TYPE p DECIMALS 2,
           cgstt_amt TYPE p DECIMALS 2,
           sgstt_amt TYPE p DECIMALS 2,
           igstt_amt TYPE p DECIMALS 2.


      IF wa-taxcode = 'AA' OR wa-taxcode = 'BA' OR wa-taxcode = 'CA' OR wa-taxcode = 'DA'.
        cgstt = '2.5' .
      ELSEIF wa-taxcode = 'AB' OR wa-taxcode = 'BB'  OR wa-taxcode = 'CB' OR wa-taxcode = 'DB'.
        cgstt = 6.
      ELSEIF wa-taxcode = 'AC'  OR wa-taxcode = 'BC' OR wa-taxcode = 'CC' OR wa-taxcode = 'DC'.
        cgstt = 9.
      ELSEIF wa-taxcode = 'AD'  OR wa-taxcode = 'BD' OR wa-taxcode = 'CD' OR wa-taxcode = 'DD'.
        cgstt = 14.
      ELSEIF wa-taxcode = 'AI' OR wa-taxcode = 'BI' OR wa-taxcode = 'CI' OR wa-taxcode = 'DI'.
        igstt = 5.
      ELSEIF wa-taxcode = 'AJ'  OR wa-taxcode = 'BJ' OR wa-taxcode = 'CJ' OR wa-taxcode = 'DJ'.
        igstt = 12.
      ELSEIF wa-taxcode = 'AK' OR wa-taxcode = 'BK' OR wa-taxcode = 'CK' OR wa-taxcode = 'DK'.
        igstt = 18.
      ELSEIF wa-taxcode = 'AL' OR wa-taxcode = 'BL' OR wa-taxcode = 'CL' OR wa-taxcode = 'DL'.
        igstt = 28.
      ENDIF.

      IF cgstt IS NOT INITIAL.
        lv_lines = lv_lines + wa-accountingdocumentitem.
        DATA var1 TYPE c LENGTH 3.
        var1 = lv_lines.
        var1 =   |{ |{ var1 ALPHA = OUT }| ALPHA = IN }| .

*READ TABLE TABLL2 INTO DATA(GSTAMT) WITH KEY TaxCode = wa-TaxCode AccountingDocumentItem = var1 .
        READ TABLE tabll2 INTO DATA(gstamt) WITH KEY taxcode = wa-taxcode accountingdocumentitemtype = 'T' .

        IF sy-subrc = 0.
          cgstt_amt = gstamt-amountintransactioncurrency.
          sgstt_amt = gstamt-amountintransactioncurrency.
*igstt_amt = gstamt-AmountInTransactionCurrency.
          DATA:tot TYPE p DECIMALS 2.
          tot  = cgstt_amt + sgstt_amt + wa-amountintransactioncurrency.
        ENDIF.
      ELSEIF igstt IS NOT INITIAL.
        IF sy-subrc = 0.
*cgstt_amt = gstamt-AmountInTransactionCurrency.
*sgstt_amt = gstamt-AmountInTransactionCurrency.
          igstt_amt = gstamt-amountintransactioncurrency.
          tot =  igstt_amt + wa-amountintransactioncurrency.
        ENDIF.
      ENDIF.

      IF cgstt_amt IS INITIAL AND sgstt_amt IS INITIAL .
        tot = wa-amountintransactioncurrency.
      ENDIF.

      """"tax ammount
*cgstt_amt = ( wa-AmountInTransactionCurrency * cgstt ) / 100 .
*sgstt_amt = ( wa-AmountInTransactionCurrency * cgstt ) / 100 .
*igstt_amt = ( wa-AmountInTransactionCurrency * igstt ) / 100 .



      """""



      invoicetotal = invoicetotal + tot.

      SELECT  SINGLE amountintransactioncurrency,transactiontypedetermination
      FROM  i_operationalacctgdocitem WHERE accountingdocumentitemtype = 'T' AND fiscalyear = @year
      AND companycode = @comcode AND accountingdocument = @docno AND taxitemacctgdocitemref = @wa-taxitemacctgdocitemref INTO @DATA(gsttab) .



      DATA cgstamnttab TYPE P LENGTH 8 DECIMALS 2.
      DATA igstamnttab TYPE P LENGTH 8 DECIMALS 2 .
      IF
      gsttab-transactiontypedetermination = 'JIC' OR gsttab-transactiontypedetermination = 'JRC'  OR gsttab-transactiontypedetermination = 'JCN' .
        cgstamnttab = gsttab-amountintransactioncurrency .
      ELSEIF
*GSTTAB-TransactionTypeDetermination = 'JIS' OR GSTTAB-TransactionTypeDetermination = 'JRS'  OR GSTTAB-TransactionTypeDetermination = 'JSN' .
*SGSTAMNTTAB = GSTTAB-AmountInTransactionCurrency .
*Elseif
      gsttab-transactiontypedetermination = 'JII' OR gsttab-transactiontypedetermination = 'JRI'  OR gsttab-transactiontypedetermination = 'JIN' .
        igstamnttab = gsttab-amountintransactioncurrency .
      ENDIF .


      DATA finaltotal TYPE P LENGTH 10 DECIMALS 2.
      finaltotal = wa-amountintransactioncurrency + cgstamnttab + cgstamnttab + igstamnttab .

      IF wa-transactiontypedetermination = 'JRC' OR wa-transactiontypedetermination = 'JRS' OR wa-transactiontypedetermination = 'JRI' .
        DATA(tottaxvalue) = wa-amountintransactioncurrency .
      ELSE.
        tottaxvalue = tottaxvalue + finaltotal .

      ENDIF.


      """logic added by ss on 07.04.2024
*      SELECT SINGLE * FROM i_operationalacctgdocitem  WHERE companycode = @wa-companycode AND
*      accountingdocument = @wa-accountingdocument  AND fiscalyear = @wa-fiscalyear AND  transactiontypedetermination IN
*      ('JRC','JRS','JRI') INTO @DATA(wa_rcm).
      IF sy-subrc = 0.
        finaltotal = wa-amountintransactioncurrency.
        inv_tot_rcm = inv_tot_rcm + finaltotal .
        tottaxvalue = inv_tot_rcm .

      ENDIF.

      """"








      DATA(lv_xml2) =
|<Table8>| &&

   |<Row1>| &&
   |<Sno>{ n }</Sno>| &&
*       |<Description>{ DC-DocumentItemText }</Description>| &&
    |<Description>{ wa-documentitemtext }</Description>| &&
   |<Qty></Qty>| &&
   |<UOM></UOM>| &&
   |<Rate></Rate>| &&
   |<Taxable>{ wa-amountintransactioncurrency }</Taxable>| &&
   |<CGSTRAte>{ cgstt }%</CGSTRAte>| &&
   |<CGSTamount>{ cgstamnttab }</CGSTamount>| && "cgstt_amt
   |<SGSTRATE>{ cgstt }%</SGSTRATE>| &&
   |<SGSTamount>{ cgstamnttab }</SGSTamount>| && "{ sgstt_amt }
   |<IGSTRATE>{ igstt }%</IGSTRATE>| &&
   |<IGSTamount>{ igstamnttab }</IGSTamount>| &&  "{ igstt_amt }
   |<TOT>{ finaltotal }</TOT>| && "tot
   |</Row1>| &&
        |</Table8>|

   .

      CONCATENATE xsml lv_xml2 INTO  xsml .

      CLEAR  : lv_xml2,cgstt,igstt,gsttab,igstamnttab,cgstamnttab.


    ENDLOOP.

*##########################################VV#######V##############VV############################LOOP"





    DATA(lv_xml_middle) =
    |</Tab1>| &&
    |<Subform4>| &&
    |<Remark>{ bsplc-a-documentitemtext }</Remark>| &&
    |<AmountInWords></AmountInWords>| &&
    |<Subform5>| &&
    |<FrightCharges>0</FrightCharges>| &&
    |<CGST></CGST>| &&
    |<SGST></SGST>| &&
    |<IGST></IGST>| &&
    |<RoundingOff></RoundingOff>| &&
    |<InvoiceTotal>{ tottaxvalue }</InvoiceTotal>| &&
    |</Subform5>| &&
    |</Subform4>| &&


     |<Subform13>| &&
        |<VoucherNo>{ bsplc-a-accountingdocument }</VoucherNo>| &&
        |<VoucherDate>{ bsplc-a-postingdate+6(2) }/{ bsplc-a-postingdate+4(2) }/{ bsplc-a-postingdate+0(4) }</VoucherDate>| &&
     |</Subform13>| &&
     |<Subform14>| &&
     |<Table13>| &&
     |<HeaderRow/>|
      .


    SELECT  a~amountincompanycodecurrency ,
            a~debitcreditcode ,
            e~glaccountlongname,
            a~accountingdocument,
            a~accountingdocumentitemtype ,
            a~glaccount


             FROM  i_operationalacctgdocitem AS a
**                             left OUTER join I_SuplrInvcItemPurOrdRefAPI01 as b on ( b~SupplierInvoice = a~SupplierInvoice and b~FiscalYear = a~FiscalYear )
*                             LEFT OUTER join I_JournalEntry as c on ( c~OriginalReferenceDocument = A~SupplierInvoiceWthnFiscalYear AND c~AccountingDocumentType = 'RE'  )
*                             LEFT OUTER join I_OperationalAcctgDocItem as d on ( d~AccountingDocument = c~AccountingDocument and d~FiscalYear = c~FiscalYear   )
                      LEFT OUTER JOIN i_glaccounttext AS e ON ( e~glaccount = a~glaccount AND e~language = 'E' )

                      WHERE a~accountingdocument = @docno AND a~fiscalyear = @year AND a~companycode = @comcode INTO TABLE @DATA(footer) .
*DELETE ADJACENT DUPLICATES FROM footer COMPARING GLAccount .

    DATA xsmll TYPE string .
    DATA paisatot TYPE p DECIMALS 2 .
    DATA paisa1tot TYPE p DECIMALS 2 .
    DATA paisa1 TYPE p DECIMALS 2 .
    DATA paisa TYPE p DECIMALS 2 .

    READ TABLE footer INTO DATA(chnge) INDEX 1 .

    IF chnge-accountingdocumentitemtype <> '' .

      LOOP AT footer INTO DATA(wa2) .

        IF wa2-debitcreditcode = 'S' AND wa2-amountincompanycodecurrency > 0.
          paisa = wa2-amountincompanycodecurrency  .
        ELSEIF
        wa2-debitcreditcode = 'H' OR wa2-amountincompanycodecurrency < 0.
          paisa1 = wa2-amountincompanycodecurrency .
        ENDIF.
        paisatot   =  paisatot + paisa .
        paisa1tot = paisa1tot + paisa1 .









        DATA(lv_xmlnew) =

                 |<Row1>| &&
                 |<Particulars>{ wa2-glaccountlongname }</Particulars>| &&
                 |<debit>{  paisa }</debit>| &&
                 |<credit>{ paisa1 * -1 }</credit>| &&
                 |</Row1>| .





        CONCATENATE xsmll lv_xmlnew INTO  xsmll .
        CLEAR : lv_xmlnew,wa2,paisa1,paisa .
*        ,PAISA1tot,PAISAtot.
      ENDLOOP.

    ELSE .

      LOOP AT footer INTO wa2 .

        IF wa2-debitcreditcode = 'S' AND wa2-amountincompanycodecurrency > 0.
          paisa = wa2-amountincompanycodecurrency  .
        ELSEIF
        wa2-debitcreditcode = 'H' OR wa2-amountincompanycodecurrency < 0.
          paisa1 = wa2-amountincompanycodecurrency .
        ENDIF.
        paisatot   =  paisatot + paisa .
        paisa1tot = paisa1tot + paisa1 .









        lv_xmlnew =

                  |<Row1>| &&
                  |<Particulars>{ wa2-glaccountlongname }</Particulars>| &&
                  |<debit>{  paisa }</debit>| &&
                  |<credit>{ paisa1 * -1 }</credit>| &&
                  |</Row1>| .





        CONCATENATE xsmll lv_xmlnew INTO  xsmll .
        CLEAR : lv_xmlnew,wa2,paisa1,paisa .
*        ,PAISA1tot,PAISAtot.
      ENDLOOP.
    ENDIF.


    IF paisatot = 0.
      paisatot   =   paisa1tot .

    ENDIF.

    IF paisa1tot = 0.

      paisa1tot   =   paisatot .

    ENDIF.

    DATA(lv_xml3) =

           |<FooterRow>| &&
           |<drbittot>{ paisatot }</drbittot>| &&
           |<credittot>{ paisa1tot * -1 }</credittot>| &&
           |</FooterRow>| &&
    |</Table13>| &&
    |</Subform14>| &&
    |</Page1>| &&
    |</form1>| .


* lv_xmlnew1
    CONCATENATE lv_xml xsml lv_xml_middle xsmll lv_xml3 INTO DATA(lv_xml1) .
    DATA template TYPE string .
    template =  'ZFI_SERVICE_CRDR/ZFI_SERVICE_CRDR'.

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
