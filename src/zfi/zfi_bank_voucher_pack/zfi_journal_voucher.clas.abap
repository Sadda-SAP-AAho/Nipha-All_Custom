CLASS zfi_journal_voucher DEFINITION
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
 CONSTANTS  lc_template_name TYPE string VALUE 'ZFI_JOURNAL_VOUCHER/ZFI_JOURNAL_VOUCHER'.

ENDCLASS.



CLASS ZFI_JOURNAL_VOUCHER IMPLEMENTATION.


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
                 left OUTER JOIN I_SegmentText as d on ( d~Segment = A~Segment  AND d~Language = 'E' )
                 left OUTER JOIN I_CostCenterText as e on ( e~CostCenter = a~CostCenter and e~Language = 'E' )
                 left OUTER JOIN I_ProfitCenterText as f on ( f~ProfitCenter = a~ProfitCenter and e~Language = 'E' )

                   WHERE
                   A~Ledger = '0L' and A~CompanyCode = @companycode and
                    a~AccountingDocument = @accountingdocument
*                 and A~PostingDate GE @date2 and A~PostingDate LE @date3
                  and A~GLAccount <> '0090000010' AND
                  a~FiscalYear = @fiscalyear INTO TABLE @DATA(TAB) .




 READ TABLE tab INTO DATA(READ) INDEX 1 .

  SELECT SINGLE * FROM I_KR_BusinessPlace as a
                  inner JOIN I_OperationalAcctgDocItem as b on ( a~Branch = b~BusinessPlace )

  WHERE b~AccountingDocument = @accountingdocument AND B~FiscalYear = @fiscalyear AND B~CompanyCode = @companycode
  INTO @DATA(HEADDET) .

   SELECT SINGLE * FROM i_journalentry where CompanyCode = @companycode and
      AccountingDocument = @accountingdocument and FiscalYear = @fiscalyear into @data(refno) .

  SELECT SINGLE * FROM i_CUSTOMER  as a
*  LEFT OUTER JOIN I_BusinessPartnerBank as b ON ( b~BusinessPartner = a~Customer )
  LEFT OUTER JOIN ZCUSTOMER_DETAILS as c ON ( c~Customer = a~Customer )
*  WHERE a~Customer = @customer
   INTO @DATA(Cust).


  data Register3 TYPE STRING.
   Register3 = 'Factory Address : Serampore Unit (Rolling Div), Nh2, Delhi Road, Dakshin Rajyadharpur, West Bengal, India'.

   DATA DOCTYPE TYPE STRING .
*   IF headdet-B-AccountingDocumentType = 'AA' .
*    DOCTYPE = 'Asset Posting' .
*    ELSEIF
*    headdet-B-AccountingDocumentType = 'AB' .
*    DOCTYPE = 'Journal Entry' .
*    ELSEIF

IF headdet-B-AccountingDocumentType = 'AA' .


    DOCTYPE = 'Asset Posting' .


    ELSEIF



headdet-B-AccountingDocumentType = 'AB' .


    DOCTYPE ='Journal Entry' .


    ELSEIF



headdet-B-AccountingDocumentType = ' AD' .


    DOCTYPE = 'Accruals/Deferrals'.


    ELSEIF


headdet-B-AccountingDocumentType = ' AF' .


    DOCTYPE = 'Depreciation Pstngs' .


    ELSEIF


headdet-B-AccountingDocumentType = ' AN' .


  DOCTYPE = ' Net Asset Posting'.


  ELSEIF


headdet-B-AccountingDocumentType =  'AP' .
DOCTYPE = ' Periodic asset post'.


  ELSEIF

headdet-B-AccountingDocumentType = 'AR' .

DOCTYPE = ' Asset Reorg Posting'.


  ELSEIF

headdet-B-AccountingDocumentType = 'CC' .

DOCTYPE = ' Sec. Cost CrossComp' .


  ELSEIF

headdet-B-AccountingDocumentType = 'CL' .

DOCTYPE = ' CL/OP FY Postings'.


  ELSEIF

headdet-B-AccountingDocumentType = 'CO' .

DOCTYPE = ' Secondary Cost'.


  ELSEIF

headdet-B-AccountingDocumentType = 'DA' .

DOCTYPE = ' Customer document'.


  ELSEIF

headdet-B-AccountingDocumentType = 'DG' .

DOCTYPE = ' Customer credit memo'.


  ELSEIF

headdet-B-AccountingDocumentType = 'DR' .

DOCTYPE = ' Customer invoice'.


  ELSEIF


headdet-B-AccountingDocumentType = 'DV' .

DOCTYPE = ' Customer interests'.


  ELSEIF


headdet-B-AccountingDocumentType = 'DZ' .

DOCTYPE = ' Customer Payment'.


  ELSEIF


headdet-B-AccountingDocumentType = 'ER'.

DOCTYPE = ' Manual ExpenseTravel'.


  ELSEIF


headdet-B-AccountingDocumentType = 'EU' .

DOCTYPE = ' Euro Rounding Diff.'.


  ELSEIF


headdet-B-AccountingDocumentType = 'EX' .

DOCTYPE = ' External Number'.


  ELSEIF


headdet-B-AccountingDocumentType = 'JD' .

DOCTYPE = ' IN: PDC'.


  ELSEIF


headdet-B-AccountingDocumentType = 'JS' .

DOCTYPE = ' IN: ISD Invoice'.


  ELSEIF


headdet-B-AccountingDocumentType = 'JV' .

DOCTYPE = ' IN: Journal Voucher'.


  ELSEIF


headdet-B-AccountingDocumentType = 'KA' .

DOCTYPE = ' Vendor Document'.


  ELSEIF


headdet-B-AccountingDocumentType = 'KG' .

DOCTYPE = ' Vendor Credit Memo'.


  ELSEIF


headdet-B-AccountingDocumentType = 'KN' .

DOCTYPE = ' Net vendors'.


  ELSEIF
headdet-B-AccountingDocumentType = 'KP' .

DOCTYPE = ' Account maintenance'.


  ELSEIF


headdet-B-AccountingDocumentType = 'KR' .

DOCTYPE = ' Vendor Invoice'.


  ELSEIF


headdet-B-AccountingDocumentType = 'KZ' .

DOCTYPE = ' Vendor payment'.


  ELSEIF


headdet-B-AccountingDocumentType = 'ML' .

DOCTYPE = ' ML Settlement'.


  ELSEIF


headdet-B-AccountingDocumentType = 'PR' .

DOCTYPE = ' Price Change'.


  ELSEIF


headdet-B-AccountingDocumentType = 'RA' .

DOCTYPE = ' Sub.Cred.Memo Stlmt'.


  ELSEIF


headdet-B-AccountingDocumentType = 'RE' .

DOCTYPE = ' Invoice - Gross'.


  ELSEIF


headdet-B-AccountingDocumentType = 'RK' .

DOCTYPE = ' Invoice Reduction'.


  ELSEIF


headdet-B-AccountingDocumentType = 'RN' .

DOCTYPE = ' Invoice - Net'.


  ELSEIF
headdet-B-AccountingDocumentType = 'RP' .

DOCTYPE = ' Spl Inv Price Change'.


  ELSEIF


headdet-B-AccountingDocumentType = 'RR' .

DOCTYPE = ' Rev Rec Document'.


  ELSEIF


headdet-B-AccountingDocumentType = 'RT' .

DOCTYPE = ' Retentions'.


  ELSEIF


headdet-B-AccountingDocumentType = 'RV' .

DOCTYPE = ' Billing doc.transfer'.


  ELSEIF


headdet-B-AccountingDocumentType = 'SA' .

DOCTYPE = ' G/L Account Document'.


  ELSEIF


headdet-B-AccountingDocumentType = 'SB' .

DOCTYPE = ' G/L Account Posting'.


  ELSEIF


headdet-B-AccountingDocumentType = 'SC' .

DOCTYPE = ' Transfer P&L to B/S'.


  ELSEIF


headdet-B-AccountingDocumentType = 'SD' .

DOCTYPE = ' MENA Cust Debit Memo'.


  ELSEIF


headdet-B-AccountingDocumentType = 'SE' .

DOCTYPE = ' Inventory Postings'.


  ELSEIF
headdet-B-AccountingDocumentType = 'SJ' .

DOCTYPE = ' Cash Journal Doc'.


  ELSEIF


headdet-B-AccountingDocumentType = 'SK' .

DOCTYPE = ' Cash Document'.


  ELSEIF


headdet-B-AccountingDocumentType = 'SU' .

DOCTYPE = ' Intercomp./Clearing'.


  ELSEIF


headdet-B-AccountingDocumentType = 'UE' .

DOCTYPE = ' Data Transfer'.


  ELSEIF


headdet-B-AccountingDocumentType = 'WA' .

DOCTYPE = ' Goods Issue'.


  ELSEIF


headdet-B-AccountingDocumentType = 'WE' .

DOCTYPE = ' Goods Receipt'.


  ELSEIF


headdet-B-AccountingDocumentType = 'WI' .

DOCTYPE = ' Inventory Document'.


  ELSEIF


headdet-B-AccountingDocumentType = 'WL' .

DOCTYPE = ' Goods Issue/Delivery'.


  ELSEIF


headdet-B-AccountingDocumentType = 'WN' .

DOCTYPE = ' Net Goods Receipt'.


  ELSEIF

headdet-B-AccountingDocumentType = 'Y1' .

DOCTYPE = ' Invoice - Gross'.


  ELSEIF


headdet-B-AccountingDocumentType = 'ZP' .

DOCTYPE = ' Payment Posting'.


  ELSEIF


headdet-B-AccountingDocumentType = 'ZR' .

DOCTYPE = ' Bank reconciliation'.


  ELSEIF


headdet-B-AccountingDocumentType = 'ZS' .

DOCTYPE = ' Payment by Check'.


  ELSEIF


headdet-B-AccountingDocumentType = 'ZV' .

DOCTYPE = ' Payment Clearing'.


  ELSEIF


headdet-B-AccountingDocumentType = 'ZZ' .

DOCTYPE = ' Billing doc.transfer'.


  ENDIF.

   SELECT SINGLE AssignmentReference FROM I_OperationalAcctgDocItem WHERE FiscalYear = @fiscalyear and CompanyCode = @companycode
                                        and AccountingDocument = @accountingdocument
                                       AND FinancialAccountType = 'S'

                                         into @data(AssignmentReference) .



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
       |<ReferanceDate>{ read-A-DocumentDate+6(2) }/{ read-A-DocumentDate+4(2) }/{ read-A-DocumentDate+0(4) }</ReferanceDate>| &&
       |<AssignmentNo>{ AssignmentReference }</AssignmentNo>| &&

      |<partyadd1>{ CUST-A-TaxNumber3 }</partyadd1>| &&
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
   |<Subform13>| &&
   |<Documenttype>{ DOCTYPE }</Documenttype>| &&
   |</Subform13>| .





   data xsml TYPE string .
   data amtwords TYPE string .
   data paisatot type string .
   data debitTot type p DECIMALS 2.
   data creditTot type  p DECIMALS 2.
   clear:debittot,credittot.



SORT tab BY A-AccountingDocumentItem  ASCENDING.
LOOP at tab INTO DATA(wa) .

if
 Wa-A-AmountInCompanyCodeCurrency > 0.
 DATA(PAISA) = Wa-A-AmountInCompanyCodeCurrency  .
 ELSEIF

  Wa-A-AmountInCompanyCodeCurrency < 0.
 DATA(PAISA1) = Wa-A-AmountInCompanyCodeCurrency .

 ENDIF.
* paisatot = paisa .

 paisatot = paisatot + paisa .

* if PAISA <> '0' .
 amtwords = paisatot .
* ELSE .
* amtwords = paisa1 * -1 .
* ENDIF.



 if
 wa-a-Customer <> '' .
 DATA(Party) = wa-a-Customer  .
 ELSEIF

 Party =  wa-a-Supplier  .

 ENDIF.

 SELECT SINGLE CustomerName FROM i_CUSTOMER WHERE Customer = @wa-a-Customer INTO @data(CustomerName) .
 SELECT SINGLE SupplierName FROM I_Supplier WHERE Supplier = @wa-a-Supplier INTO @data(SupplierName) .

* data check type string.
* if wa-a-GLAccount ge 0025500009 and  wa-a-GLAccount le 0025500012 .
* check = 'PUT YOUR DESCRIPTION  ' .
* ELSEIF
* wa-a-GLAccount ge 0045000269 and  wa-a-GLAccount le 0045000272.
* CHECK = 'RAM RAM' .
* ENDIF.

     debitTot = debitTot + paisa.
     creditTot = creditTot + paisa1.


if paisa1 ne 0.
wa-a-CostCenter = wa-a-ProfitCenter.
select SINGLE * from I_ProfitCenterText  WHERE ProfitCenter = @wa-a-ProfitCenter AND Language = 'E' into @data(itxt).
if sy-subrc = 0.
wa-e-CostCenterName = itxt-ProfitCenterName.
endif.
endif.



     DATA(lv_xml2) =
         |<LopTab>| &&
         |<Row1>| &&
         |<glcode>{ wa-a-GLAccount }</glcode>| &&
         |<gldesc>{ wa-c-GLAccountLongName }</gldesc>| &&
         |<partycode>{ wa-a-Customer }{ wa-a-Supplier }</partycode>| &&
         |<partyname>{ CustomerName }{ SupplierName }</partyname>| &&
         |<debitcredit>{ wa-d-SegmentName }  { wa-a-CostCenter } { wa-e-CostCenterName }</debitcredit>| &&
         |<amtloccurry>{ PAISA }</amtloccurry>| &&
         |<smtindoccurry>{ PAISA1 }</smtindoccurry>| &&

         |</Row1>| &&
         |</LopTab>|.

 CONCATENATE xsml lv_xml2 INTO  xsml .
  clear : PAISA ,PAISA1 ,CustomerName,SupplierName.
  ENDLOOP.


"
*     I_User                       as _User on  $projection.AccountingDocCreatedByUser = _User.UserID


*association[0..1] to I_AccountingDocument as ACCOUNTHDR on ACCOUNTHDR.CompanyCode = GSTR1ITEM.CompanyCode
*and ACCOUNTHDR.FiscalYear = GSTR1ITEM.FiscalYear
*and ACCOUNTHDR.AccountingDocument = GSTR1ITEM.AccountingDocument
*I_User                       as _User                       on  $projection.AccountingDocCreatedByUser = _User.UserID
*

select single * from I_JournalEntry WHERE FiscalYear = @fiscalyear and CompanyCode = @companycode  and
AccountingDocument = @accountingdocument
into @data(VV1) .
*if sy-subrc = 0.
data(CODE) = VV1-AccountingDocCreatedByUser.
select single  PersonFullName from I_BusinessUserBasic WHERE UserID = @code into @data(SIGN).




    DATA(lv_xml3) =
       |<Subform3>| &&
       |<narration>{ wa-a-DocumentItemText }</narration>| &&
       |<AMT>{ amtwords }</AMT>| &&

       |<TT>Total</TT>| &&
      |<DebitTot>{ debitTot }</DebitTot>| &&
      |<CreditTot>{ credittot }</CreditTot>| &&




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
