CLASS zfi_reciept_voucher DEFINITION
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
        IMPORTING
                 VALUE(accountingdocument)      TYPE string
*                  VALUE(from_postingdate)   TYPE string
*                  VALUE(to_postingdate)      TYPE string
                  VALUE(fiscalyear)         TYPE string
                  VALUE(companycode)         TYPE string
                  VALUE(radiobuttontext)         TYPE string


        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .


  PROTECTED SECTION.
  PRIVATE SECTION.
  CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://devtenant-ux00yyve.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
 CONSTANTS  lc_template_name TYPE string VALUE 'ZFI_RECIEPTVOUCHER/ZFI_RECIEPTVOUCHER'.

ENDCLASS.



CLASS ZFI_RECIEPT_VOUCHER IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.
    TRY.
    ENDTRY.
  ENDMETHOD.


  METHOD read_posts .
*
*    DATA gv1 TYPE string .
*    DATA gv2 TYPE string .
*    DATA gv3 TYPE string .
*    DATA date2 TYPE string .
*
*    gv3 = from_postingdate+6(4)  .
*    gv2 = from_postingdate+3(2)  .
*    gv1 = from_postingdate+0(2)  .
*
*    CONCATENATE gv3 gv1 gv2     INTO date2.
*
*    DATA date3 TYPE string.
*    DATA gv4 TYPE string .
*    DATA gv5 TYPE string .
*    DATA gv6 TYPE string .
*
*    gv6 = to_postingdate+6(4)  .
*    gv5 = to_postingdate+3(2)  .
*    gv4 = to_postingdate+0(2)  .
*
*    CONCATENATE gv6 gv4 gv5    INTO date3.

   DATA var1 TYPE zchar10.
    var1 = accountingdocument.
    var1 =   |{ |{ var1 ALPHA = OUT }| ALPHA = IN }| .
    accountingdocument = var1.


  SELECT  * FROM I_GLAccountLineItem AS A
*                 inner JOIN I_GLAccountLineItem as b on ( b~AccountingDocument = a~AccountingDocument
*                                            and b~FiscalYear = a~FiscalYear and b~CompanyCode = a~CompanyCode )
                 LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E' )
*                 left OUTER JOIN I_SegmentText as d on ( d~Segment = A~Segment  AND d~Language = 'E' )
                   WHERE
                   A~Ledger = '0L' and A~CompanyCode = @companycode and
                    a~AccountingDocument = @accountingdocument
*                 and A~PostingDate GE @date2 and A~PostingDate LE @date3
                  and
                  a~FiscalYear = @fiscalyear INTO TABLE @DATA(TAB) .


   SELECT SINGLE * from I_OperationalAcctgDocItem where FiscalYear = @fiscalyear and CompanyCode = @companycode
                                        and AccountingDocument = @accountingdocument
                                        into @data(bankvoucher) .




 READ TABLE tab INTO DATA(READ) INDEX 1 .

  SELECT SINGLE * FROM I_KR_BusinessPlace as a
                  inner JOIN I_OperationalAcctgDocItem as b on ( a~Branch = b~BusinessPlace )

  WHERE b~AccountingDocument = @accountingdocument
  INTO @DATA(HEADDET) .

   SELECT SINGLE * FROM i_journalentry where CompanyCode = @companycode and
      AccountingDocument = @accountingdocument and FiscalYear = @fiscalyear into @data(refno) .

  SELECT SINGLE * FROM I_OperationalAcctgDocItem  as a
  LEFT OUTER JOIN zcustomer_details as c ON ( c~Customer = a~Customer )
  WHERE A~FiscalYear = @fiscalyear and A~CompanyCode = @companycode
                     and A~AccountingDocument = @accountingdocument
*                     AND A~AccountingDocumentType = 'DZ'
*                     AND A~ClearingAccountingDocument <> ''
                     AND A~FinancialAccountType = 'D'
   INTO @DATA(Cust).



  SELECT SINGLE B~SegmentName ,
                 C~ProfitCenterName from I_GLAccountLineItem AS A
              LEFT OUTER JOIN  I_SegmentText AS B ON ( B~Segment = A~Segment  AND B~Language = 'E' )
              LEFT OUTER JOIN  I_ProfitCenterText AS C ON ( C~ProfitCenter = A~ProfitCenter  AND C~Language = 'E' )
                           where FiscalYear = @fiscalyear and CompanyCode = @companycode
                                        and AccountingDocument = @accountingdocument
                                        into @data(SEGPRO) .


  SELECT SINGLE * from I_OperationalAcctgDocItem AS A
*  LEFT OUTER JOIN i_supplier AS B ON  ( B~Supplier = A~Supplier )
  left outer  join ZSUPPLIER_DETAILS as C on ( C~Supplier = A~Supplier  )
  where FiscalYear = @fiscalyear and CompanyCode = @companycode
                                        and AccountingDocument = @accountingdocument
                                  AND A~ClearingAccountingDocument <> ''
                                        into @data(supplier) .

          SELECT SINGLE AssignmentReference FROM I_OperationalAcctgDocItem WHERE FiscalYear = @fiscalyear and CompanyCode = @companycode
                                        and AccountingDocument = @accountingdocument
                                        AND AccountingDocumentType = 'DZ' AND FinancialAccountType = 'S'

                                         into @data(AssignmentReference) .



  data Register3 TYPE STRING.
   Register3 = 'Factory Address : Serampore Unit (Rolling Div), Nh2, Delhi Road, Dakshin Rajyadharpur, West Bengal, India'.



DATA(lv_xml) =

   |<form1>| &&
   |<plantname>{ headdet-a-CompanyName }</plantname>| &&
   |<address1>{ Register3 }</address1>| &&
   |<address2>{  headdet-a-HouseNumber  }{ headdet-a-StreetName },{ headdet-a-CityName }-{ headdet-a-PostalCode }</address2>| &&
   |<emailphone>{ headdet-a-ResponsiblePersonEmailAddress },{ headdet-a-PhoneNumber }</emailphone>| &&
   |<address3>{ radiobuttontext }</address3>| &&
   |<CINNO>{ headdet-a-BusinessType }</CINNO>| &&
   |<GSTIN>{ headdet-a-TaxNumber1 }</GSTIN>| &&
   |<PAN>{ headdet-a-VATRegistration }</PAN>| &&
     |<LeftSide>| &&
*      |<partyno>{ CUST-A-CustomerName }</partyno>| &&
*      |<partyno2>{ CUST-C-StreetPrefixName1 }</partyno2>| &&
*      |<partyno3>{ CUST-C-StreetPrefixName2 }</partyno3>| &&
*      |<partyadd>{ CUST-A-CityName }-{ CUST-A-PostalCode }</partyadd>| &&
       |<JournalVoucherNo>{ accountingdocument }</JournalVoucherNo>| &&
       |<JournalVoucherDate>{ read-A-PostingDate+6(2) }/{ read-A-PostingDate+4(2) }/{ read-A-PostingDate+0(4) }</JournalVoucherDate>| &&
       |<ReferanceNo>{ refno-DocumentReferenceID }</ReferanceNo>| &&
       |<AssignmentNo>{ AssignmentReference }</AssignmentNo>| &&
       |<SEGMENT>{ segpro-SegmentName }</SEGMENT>| &&
       |<PROFITCENTER>{ segpro-ProfitCenterName }</PROFITCENTER>| &&
      |<partyadd1>{ CUST-C-TaxNumber3 }</partyadd1>| &&
      |<PHNNO>{ CUST-C-TelephoneNumber1 }</PHNNO>| &&
      |<EMAIL>{  CUST-C-EmailAddress }</EMAIL>| &&
    |<Subform7/>| &&
   |</LeftSide>| &&
   |<RightSide>| &&
      |<date></date>| &&
      |<openingbl></openingbl>| &&
      |<TransporterName></TransporterName>| &&
      |<FromDate></FromDate>| &&
      |<ToDate></ToDate>| &&
      |<Page>| &&
         |<HaderData>| &&
            |<RightSide>| &&
               |<StationNo></StationNo>| &&
            |</RightSide>| &&
         |</HaderData>| &&
      |</Page>| &&
      |</RightSide>| &&
      |<BankDetail>| &&
*      |<BankName>{ CUST-B-BankName }</BankName>| &&
*      |<AccountNo>{  CUST-B-BankAccount }</AccountNo>| &&
*      |<IFSC>{ CUST-B-SWIFTCode }</IFSC>| &&
      |<profitcenter></profitcenter>| &&
      |<Segment></Segment>| &&
      |</BankDetail>| &&
   |<chk_mark></chk_mark>| &&
    |<LeftSide1>| &&
      |<partycode>{ Cust-c-Customer }</partycode>| &&
      |<partyname>{ Cust-c-CustomerName }</partyname>| &&
      |<gstnn>{ Cust-c-TaxNumber3 }</gstnn>| &&
      |<addresss>{ Cust-C-StreetPrefixName1 }-{ Cust-C-StreetPrefixName2 }-{ Cust-C-CityName }-{ Cust-C-PostalCode }</addresss>| &&
      |<partyadd1></partyadd1>| &&
      |<PHNNO></PHNNO>| &&
      |<EMAIL></EMAIL>| &&
      |<Subform7/>| &&
   |</LeftSide1>|

    .




   data xsml TYPE string .
   data amtwords TYPE string .
   data amtwords2 TYPE string .
   data paisatot TYPE string .


   SELECT  B~AmountInCompanyCodeCurrency ,
           B~AmountInTransactionCurrency,
                B~DocumentItemText ,
                B~AccountingDocument,
                B~DocumentDate,
                B~Segment,
                B~ClearingAccountingDocument ,
                A~GLAccountLongName
                FROM I_OperationalAcctgDocItem AS B
                   LEFT OUTER JOIN I_GLAccountText AS A ON ( A~GLAccount = B~GLAccount AND A~Language = 'E' )

                              where B~FiscalYear = @fiscalyear and B~CompanyCode = @companycode
                                        and B~AccountingDocument = @accountingdocument

AND B~AccountingDocumentType = 'DZ' AND B~FinancialAccountType = 'S'


                                        into TABLE @data(TABL) .
 DATA WA2AMT2 TYPE STRING .
 DATA WA2AMT2code TYPE STRING .
 DATA NARRATION TYPE STRING .


LOOP at tabL INTO DATA(wa) .


If narration is INITIAL.
NARRATION = wa-DocumentItemText .
endif.


  IF
WA-AmountInTransactionCurrency < 0 .
WA2AMT2code = WA-AmountInTransactionCurrency * -1 .
ELSEIF
WA-AmountInTransactionCurrency > 0 .
WA2AMT2code = WA-AmountInTransactionCurrency .
ENDIF.

IF
WA-AmountInCompanyCodeCurrency < 0 .
WA2AMT2 = WA-AmountInCompanyCodeCurrency * -1 .
ELSEIF
WA-AmountInCompanyCodeCurrency > 0 .
WA2AMT2 = WA-AmountInCompanyCodeCurrency .
ENDIF.

 amtwords = amtwords + WA-AmountInTransactionCurrency .
 amtwords2 = amtwords2 + WA-AmountInCompanyCodeCurrency .

if wa-Segment is NOT INITIAL.
shift wa-Segment left DELETING LEADING '0'.
 CONCATENATE wa-GLAccountLongName '-' wa-Segment INTO data(gl1).
 else.
 gl1 = wa-GLAccountLongName.
endif.


     DATA(lv_xml2) =
         |<LopTab>| &&
         |<Row1>| &&
         |<InvoiceDate>{ wa-DocumentDate+6(2) }/{ wa-DocumentDate+4(2) }/{ wa-DocumentDate+0(4) }</InvoiceDate>| &&
         |<glcode>{ refno-DocumentReferenceID }</glcode>| &&


         |<gldesc>{ gl1 }</gldesc>| &&

         |<smtindoccurry>{ WA2AMT2code }</smtindoccurry>| &&
         |<smtindoccurry22>{ WA2AMT2 }</smtindoccurry22>| &&

         |</Row1>| &&
         |</LopTab>|.

 CONCATENATE xsml lv_xml2 INTO  xsml .
 clear : WA2AMT2 ,wa  ,refno,WA2AMT2code .
  ENDLOOP.

*  ...////////////////////////////////

      SELECT    B~AmountInCompanyCodeCurrency ,
                B~AmountInTransactionCurrency ,
                B~DocumentItemText,
                B~DocumentDate ,
                A~DocumentReferenceID ,
                B~AccountingDocument as ACT_NO ,
                B~ClearingAccountingDocument ,
                B~Segment ,
                AA~ClearingAccountingDocument as aa_clr,
                AA~Segment as sg
                FROM I_OperationalAcctgDocItem AS AA
                LEFT OUTER JOIN  I_OperationalAcctgDocItem AS B ON ( B~ClearingAccountingDocument = AA~ClearingAccountingDocument
                                                                      AND B~ClearingAccountingDocument <> '' )
                LEFT OUTER JOIN I_JournalEntry AS A ON ( A~AccountingDocument = B~AccountingDocument AND A~FiscalYear = B~FiscalYear
                                                         AND A~CompanyCode = B~CompanyCode )

                              where B~FiscalYear = @fiscalyear and B~CompanyCode = @companycode
                                        and AA~AccountingDocument = @accountingdocument

*                                  AND ( B~AccountingDocumentType = 'KR' OR B~AccountingDocumentType = 'RE'
*                                       OR B~AccountingDocumentType = 'KA' OR B~AccountingDocumentType = 'KG' )
                                        AND B~FinancialAccountType = 'D'
                                        AND ( B~AccountingDocumentType = 'DR' OR B~AccountingDocumentType = 'DG'  OR B~AccountingDocumentType = 'RV' )

                                        into TABLE @data(TABL2) .


    DATA WA2AMT TYPE STRING .
    DATA WA2AMT22 TYPE STRING .
    DATA billamttot TYPE STRING .
    DATA billamttot22 TYPE STRING .

    sort tabl2 by act_no ASCENDING.
    DELETE ADJACENT DUPLICATES FROM tabl2 COMPARING act_no.

  LOOP at tabL2 INTO DATA(wa2) .

IF
WA2-AmountInTransactionCurrency < 0 .
WA2AMT22 = WA2-AmountInTransactionCurrency * -1 .
ELSEIF
WA2-AmountInTransactionCurrency > 0 .
WA2AMT22 = WA2-AmountInTransactionCurrency .
ENDIF.

 IF
WA2-AmountInCompanyCodeCurrency < 0 .
WA2AMT = WA2-AmountInCompanyCodeCurrency * -1 .
ELSEIF
WA2-AmountInCompanyCodeCurrency > 0 .
WA2AMT = WA2-AmountInCompanyCodeCurrency .
ENDIF.



billamttot = billamttot + WA2-AmountInCompanyCodeCurrency .
billamttot22 = billamttot22 + WA2-AmountInTransactionCurrency .



select SINGLE Segment from I_OperationalAcctgDocItem  WHERE AccountingDocument = @wa2-act_no
AND FINANCIALACCOUNTTYPE = 'S' AND  Segment ne ' ' into @data(wa_seg).
if sy-subrc = 0.
shift wa_seg left DELETING LEADING '0'.
 CONCATENATE wa2-DocumentItemText '-' wa_seg INTO data(gl2).
 else.
 gl2 = wa2-DocumentItemText.
ENDIF.


  DATA(lv_xml4) =

         |<LopTab2>| &&
         |<Row1>| &&
         |<InvoiceDate2>{ wa2-DocumentDate+6(2) }/{ wa2-DocumentDate+4(2) }/{ wa2-DocumentDate+0(4) }</InvoiceDate2>| &&
         |<glcode2>{ WA2-DocumentReferenceID }</glcode2>| &&



        |<gldesc2>{ gl2 }</gldesc2>| &&

         |<amtloccurry2>{ WA2AMT22 }</amtloccurry2>| &&
         |<amtloccurry21>{ WA2AMT }</amtloccurry21>| &&

         |</Row1>| &&
         |</LopTab2>|.



 CONCATENATE xsml lv_xml4 INTO  xsml .
   clear : WA2AMT , WA2 ,WA2AMT22,WA2AMT .

 ENDLOOP.



DATA AMWRDS TYPE STRING .
DATA AMWRDS2 TYPE STRING .

DATA BILLTOTMINUS TYPE STRING .
DATA BILLTOTMINUS22 TYPE STRING .


IF
amtwords < 0 .
AMWRDS = amtwords * -1 .
ELSEIF
amtwords > 0 .
AMWRDS = amtwords .
ENDIF.

IF
amtwords2 < 0 .
AMWRDS2 = amtwords2 * -1 .
ELSEIF
amtwords2 > 0 .
AMWRDS2 = amtwords2 .
ENDIF.

IF
billamttot < 0 .
BILLTOTMINUS = billamttot * -1 .
ELSEIF
billamttot > 0 .
BILLTOTMINUS = billamttot .
ENDIF.

IF
billamttot22 < 0 .
BILLTOTMINUS22 = billamttot22 * -1 .
ELSEIF
billamttot22 > 0 .
BILLTOTMINUS22 = billamttot22 .
ENDIF.



select single * from I_JournalEntry WHERE FiscalYear = @fiscalyear and CompanyCode = @companycode  and
AccountingDocument = @accountingdocument
into @data(VV1) .
*if sy-subrc = 0.
data(code) = VV1-AccountingDocCreatedByUser.
select single  PersonFullName from I_BusinessUserBasic WHERE UserID = @code into @data(SIGN).



    DATA(lv_xml3) =
         |<LopTot22>| &&
      |<Row1>| &&
         |<amtloccurrytot>{ BILLTOTMINUS22 }</amtloccurrytot>| &&
         |<amtloccurrytot1>{ BILLTOTMINUS }</amtloccurrytot1>| &&
         |<smtindoccurrytot>{ AMWRDS }</smtindoccurrytot>| &&
         |<smtindoccurrytot2222>{ AMWRDS2 }</smtindoccurrytot2222>| &&
        |</Row1>| &&
         |</LopTot22>| &&
       |<Subform3>| &&
       |<narration>{ narration }</narration>| &&
       |<AMT>{ AMWRDS }</AMT>| &&

      |</Subform3>| &&
      |<Subform2>| &&
      |<SIGN>{ SIGN }</SIGN>| &&
      |<preparedby></preparedby>| &&
      |</Subform2>| &&
      |</form1>| .

    CONCATENATE lv_xml xsml lv_xml3 INTO lv_xml .


   DATA(url) = |{ lv2_url }|.
    DATA(client) = create_client( url ).
    DATA(req) = client->get_http_request(  ).

   req->set_authorization_basic( i_username = 'sb-b68f47a1-4d84-4660-ae27-4b0389a8cd50!b260781|ads-xsappname!b102452'
     i_password = 'e4b90d62-af57-42ea-bd2b-b2c26db47cde$jdawARRtqDdYn-Q-bpnMFxqrM9oIp_YuD6d5C9c7C8I=')  .
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
