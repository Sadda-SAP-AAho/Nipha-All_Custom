CLASS zcl_brs DEFINITION
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
                 VALUE(bankid)      TYPE string
*                  VALUE(from_postingdate)   TYPE string
*                  VALUE(to_postingdate)      TYPE string
                  VALUE(houseid)         TYPE string
                  VALUE(STATEMENT_DT) TYPE STRING


        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .


  PROTECTED SECTION.
  PRIVATE SECTION.
   CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://devtenant-ux00yyve.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
 CONSTANTS  lc_template_name TYPE string VALUE 'ZBRS_ZBRS/ZBRS_ZBRS'.

ENDCLASS.



CLASS ZCL_BRS IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.
    TRY.
    ENDTRY.
  ENDMETHOD.


  METHOD read_posts .

    TYPES:BEGIN OF TY_CLEAR,
              COMPANYCODE TYPE CHAR4,
              ACCOUNTINGDOCUMENT TYPE CHAR4,
              FISCALYEAR TYPE CHAR4,
              DOCUMENTDATE TYPE CHAR10,
              CUSTOMERNAME TYPE CHAR40,
              ASSIGNMENTREFERENCE TYPE CHAR16,
              DT_TO_PRESENT TYPE STRING,
              AMOUNT TYPE P LENGTH 16 DECIMALS 2,
          END OF TY_CLEAR.

    DATA : IT_CLEAR TYPE STANDARD TABLE OF TY_CLEAR,
           IT_CLEAR1 TYPE STANDARD TABLE OF TY_CLEAR,
           IT_CLEAR11 TYPE STANDARD TABLE OF TY_CLEAR,
           WA_CLEAR TYPE TY_CLEAR,
           WA_CLEAR1 TYPE TY_CLEAR,
           WA_CLEAR11 TYPE TY_CLEAR.
data : lv_xml type string ,
       lv_vs2 type string ,
       lv_vs3 type string ,
       lv_vs4 type string,
       lv_vs5 type string,
       STATEMENT_DT1 TYPE CHAR10,
       TOT_AMT1 TYPE P LENGTH 16 DECIMALS 2,
       TOT_AMT2 TYPE P LENGTH 16 DECIMALS 2,
       TOT_AMT22 TYPE P LENGTH 16 DECIMALS 2,
       TOT_AMT3 TYPE P LENGTH 16 DECIMALS 3,
       TOT_AMT33 TYPE P LENGTH 16 DECIMALS 3,
       TOT_AMT4 TYPE P LENGTH 16 DECIMALS 3,
       TOT_AMT5 TYPE P LENGTH 16 DECIMALS 3,
       TOT_AMT55 TYPE P LENGTH 16 DECIMALS 3,
       TOT_AMT6 TYPE P LENGTH 16 DECIMALS 3,
       TOT_AMT66 TYPE P LENGTH 16 DECIMALS 3,
       BANKADDRESS TYPE CHAR200.

*       STATEMENT_DT1 = |{ STATEMENT_DT+6(4) }| && |{ STATEMENT_DT+3(2) }| && |{ STATEMENT_DT(2) }|.
*       STATEMENT_DT+6(4) STATEMENT_DT+3(2) STATEMENT_DT(2)

     CONCATENATE STATEMENT_DT+6(4) STATEMENT_DT+3(2) STATEMENT_DT(2) INTO STATEMENT_DT1.

*data:statement_dt type sy-datum value '20240804'.
*data(statement_dt1) = statement_dt.

************************data form table ********************

  select houseid,bankid,gl1,gl2,gl3 from zbrs_tab1 where
         houseid = @houseid and bankid = @bankid
         into @data(brs_tab) UP TO 1 ROWS.
         ENDSELECT.
*-------------------------BANK BALANCE ---------------------

      select COMPANYCODE,ACCOUNTINGDOCUMENT,FISCALYEAR,
           GLACCOUNT,AMOUNTINTRANSACTIONCURRENCY
         fROM I_OPERATIONALACCTGDOCITEM
            where GLACCOUNT EQ @brs_tab-gl1
            AND POSTINGDATE LE @STATEMENT_DT1
            INTO TABLE @DATA(LT_BANK).
   SORT LT_BANK BY COMPANYCODE ACCOUNTINGDOCUMENT FISCALYEAR.  " ADDED ON 20.08.2024
   DELETE ADJACENT DUPLICATES FROM LT_BANK COMPARING ALL FIELDS . " ADDED ON 20.08.2024
            IF LT_BANK IS NOT INITIAL.
              LOOP AT LT_BANK INTO DATA(LS_BANK).
                TOT_AMT4 = TOT_AMT4 + LS_BANK-AMOUNTINTRANSACTIONCURRENCY.
              ENDLOOP.

            ENDIF.
************************Not clear Data incoming********************

  SELECT A~COMPANYCODE,A~ACCOUNTINGDOCUMENT,A~FISCALYEAR,
         A~CLEARINGDATE,A~DOCUMENTDATE,A~GLACCOUNT,
         D~SUPPLIER,D~CUSTOMER,A~OFFSETTINGACCOUNT,
         A~AMOUNTINTRANSACTIONCURRENCY,B~CUSTOMERNAME,C~SupplierNAME,
         e~DOCUMENTREFERENCEID,A~POSTINGDATE
         FROM I_OPERATIONALACCTGDOCITEM AS A
         left outer join I_OPERATIONALACCTGDOCITEM as d on
         d~AccountingDocument = a~AccountingDocument and d~CompanyCode = a~CompanyCode
         and d~FiscalYear = a~FiscalYear and d~FinancialAccountType IN ( 'K' , 'D' )
         LEFT OUTER JOIN I_CUSTOMER AS B ON B~Customer = D~Customer
         LEFT OUTER JOIN I_Supplier AS C ON C~Supplier = D~Supplier
         LEFT OUTER JOIN I_JOURNALENTRY AS E ON e~CompanyCode = a~CompanyCode and
         e~AccountingDocument = a~AccountingDocument and e~FiscalYear = a~FiscalYear

         WHERE A~GLAccount = @brs_tab-gl2
           AND A~PostingDate LE @STATEMENT_DT1 and
          ( A~ClearingDaTE GT @STATEMENT_DT1 OR A~ClearingDate = '00000000' )
*         A~PostingDate LE @STATEMENT_DT1 and A~ClearingDate = '00000000'
*           AND A~ClearingDate = '00000000' ( A~ClearingDaTE LE @STATEMENT_DT1 OR A~ClearingDate = '00000000'
*            AND A~PostingDate LE @STATEMENT_DT1
           INTO TABLE @DATA(lt_clear).

IF LT_CLEAR IS NOT INITIAL.
   LOOP AT LT_CLEAR INTO DATA(LS_CLEAR).
        WA_CLEAR-COMPANYCODE        = LS_CLEAR-CompanyCode.
        WA_CLEAR-accountingdocument = LS_CLEAR-AccountingDocument.
        WA_CLEAR-fiscalyear         = LS_CLEAR-FiscalYear.
        WA_CLEAR-documentdate       = LS_CLEAR-DocumentDate.
        IF LS_CLEAR-CustomerName IS NOT INITIAL.
          WA_CLEAR-customername     = LS_CLEAR-CustomerName.
        ELSE.
          WA_CLEAR-customername     = LS_CLEAR-SupplierName.
        ENDIF.
        WA_CLEAR-assignmentreference = LS_CLEAR-DOCUMENTREFERENCEID .
        WA_CLEAR-amount = LS_CLEAR-AmountInTransactionCurrency.
        APPEND WA_CLEAR TO IT_CLEAR.
        TOT_AMT1 = TOT_AMT1 + WA_CLEAR-AMOUNT.
        CLEAR WA_CLEAR.
   ENDLOOP.
ENDIF.
   SORT IT_CLEAR BY documentdate ASCENDING.  "added on 17-08-2024
   delete ADJACENT DUPLICATES FROM it_clear COMPARING ALL FIELDS. "added on 17-08-2024

************************ Clear Data1 outgoing*****************************

 SELECT A~COMPANYCODE,A~ACCOUNTINGDOCUMENT,A~FISCALYEAR,
         A~CLEARINGDATE,A~DOCUMENTDATE,A~GLACCOUNT,
         D~SUPPLIER,D~CUSTOMER,A~OFFSETTINGACCOUNT,
         A~AMOUNTINTRANSACTIONCURRENCY,B~CUSTOMERNAME,C~SupplierNAME,
         e~DOCUMENTREFERENCEID
         FROM I_OPERATIONALACCTGDOCITEM AS A
         left outer join I_OPERATIONALACCTGDOCITEM as d on
         d~AccountingDocument = a~AccountingDocument and d~CompanyCode = a~CompanyCode
         and d~FiscalYear = a~FiscalYear and d~FinancialAccountType IN ( 'K' , 'D' )
         LEFT OUTER JOIN I_CUSTOMER AS B ON B~Customer = D~Customer
         LEFT OUTER JOIN I_Supplier AS C ON C~Supplier = D~Supplier
         LEFT OUTER JOIN I_JOURNALENTRY AS E ON e~CompanyCode = a~CompanyCode and
         e~AccountingDocument = a~AccountingDocument and e~FiscalYear = a~FiscalYear
         WHERE A~GLAccount = @brs_tab-gl3
            AND A~PostingDate LE @STATEMENT_DT1 and
          ( A~ClearingDaTE GT @STATEMENT_DT1 OR A~ClearingDate = '00000000' )
*           AND ( A~ClearingDate LE @STATEMENT_DT1 OR A~ClearingDate = '00000000' )
           INTO TABLE @DATA(lt_clear11).
           CLEAR : WA_CLEAR,TOT_AMT3.
IF LT_CLEAR11 IS NOT INITIAL.

    sort LT_CLEAR11 BY COMPANYCODE ACCOUNTINGDOCUMENT FISCALYEAR.  " ADDED ON 20.08.2024
    DELETE ADJACENT DUPLICATES FROM LT_CLEAR11 COMPARING ALL FIELDS. " ADDED ON 20.08.2024

    LOOP AT LT_CLEAR11 INTO DATA(LS_CLEAR11).
        WA_CLEAR11-COMPANYCODE        = LS_CLEAR11-CompanyCode.
        WA_CLEAR11-accountingdocument = LS_CLEAR11-AccountingDocument.
        WA_CLEAR11-fiscalyear         = LS_CLEAR11-FiscalYear.
        WA_CLEAR11-documentdate       = LS_CLEAR11-DocumentDate.
        IF LS_CLEAR11-CustomerName IS NOT INITIAL.
          WA_CLEAR11-customername     = LS_CLEAR11-CustomerName.
        ELSE.
          WA_CLEAR11-customername     = LS_CLEAR11-SupplierName.
        ENDIF.
        WA_CLEAR11-assignmentreference = LS_CLEAR11-DOCUMENTREFERENCEID.
        WA_CLEAR11-amount = LS_CLEAR11-AmountInTransactionCurrency.
        APPEND WA_CLEAR11 TO IT_CLEAR11.
        TOT_AMT3 = TOT_AMT3 + LS_CLEAR11-AmountInTransactionCurrency.
        CLEAR WA_CLEAR11.
   ENDLOOP.

ENDIF.

  CLEAR : TOT_AMT22,WA_CLEAR.
  LOOP AT IT_CLEAR INTO WA_CLEAR.
      TOT_AMT22 = TOT_AMT22 + WA_CLEAR-AMOUNT.

  ENDLOOP.




*BREAKCB9980000010.

* select * from YY1_0CC4087B0F9D  where BUSINESSPLACE = '1000' into table @data(it_gl).

DATA(LV_TAB1) =
  |<form1>| &&
   |<Head>| &&
      |<headerdata>| &&
         |<logo/>| .
               IF TOT_AMT4 GE 0 .
                    TOT_AMT55 = TOT_AMT4 + TOT_AMT3.
              ELSE.
                    TOT_AMT55 = TOT_AMT4 - TOT_AMT3.
              ENDIF.
               IF TOT_AMT55 GE 0 .
                    TOT_AMT66 = TOT_AMT55 + TOT_AMT22.
              ELSE.
                    TOT_AMT66 = TOT_AMT55 - TOT_AMT22.
              ENDIF.
*DATA(LV_TAB10) = |<amount11>{ TOT_AMT66 }</amount11>| .

*-------------------HEADER DETAILS-----------------------------

SELECT A~BANKINTERNALID,A~HOUSEBANKCHARGEACCOUNT,B~BANKNAME,B~STREETNAME,
       B~CITYNAME
       FROM I_HOUSEBANK AS A LEFT OUTER JOIN
            I_BANK_2 AS B ON B~BANKINTERNALID EQ A~BANKINTERNALID
        WHERE HOUSEBANK EQ @houseid
        INTO @DATA(LS_BANK11).
       ENDSELECT.

 CONCATENATE LS_BANK11-StreetName LS_BANK11-CityName INTO BANKADDRESS SEPARATED BY ','.

*-------------------HEADER DETAILS-----------------------------
DATA(LV_TAB10) = |<Com_details>| &&
            |<Address>{ BANKADDRESS }</Address>| &&
            |<BANK_NAME>{ LS_BANK11-BankName }</BANK_NAME>| &&
            |<STAT_DATE>Bank Statement As On - { STATEMENT_DT }</STAT_DATE>| &&
            |<account_no>Account Number - { LS_BANK11-HouseBankChargeAccount }</account_no>| &&
            |<IFSC>IFSC Code - { LS_BANK11-BankInternalID }</IFSC>| &&
            |<amount11>{ TOT_AMT66 }</amount11>| &&
         |</Com_details>| &&


      |</headerdata>| &&
   |</Head>| &&
      |<item>| &&
      |<Table1>| &&
         |<HeaderRow/>| &&
          |<Row1>| &&
            |<Date>20040606T101010</Date>| &&
            |<Chq_no>Si manu vacuas</Chq_no>| &&
            |<DESCRIPTION>Apros tres et quidem</DESCRIPTION>| &&
            |<DTTO>Mirum est</DTTO>| &&
            |<AMOUNT>{ TOT_AMT6 }</AMOUNT>| &&
         |</Row1>|.
IF IT_CLEAR IS NOT INITIAL.
*   SORT IT_CLEAR BY documentdate ASCENDING.  "added on 17-08-2024
*   delete ADJACENT DUPLICATES FROM it_clear COMPARING ALL FIELDS. "added on 17-08-2024
  LOOP AT IT_CLEAR INTO WA_CLEAR.
    DATA(LV_TAB2) =
          |<Row1>| &&
            |<Date>{ WA_CLEAR-documentdate }</Date> | &&
            |<Chq_no>{ WA_CLEAR-assignmentreference }</Chq_no> | &&
            |<DESCRIPTION>{ WA_CLEAR-customername }</DESCRIPTION>| &&
            |<DTTO>{ WA_CLEAR-dt_to_present }</DTTO>| &&
            |<AMOUNT>{ WA_CLEAR-amount }</AMOUNT>| &&
         |</Row1>|.

         CONCATENATE lv_vs2 LV_TAB2 into lv_vs2 .
         CLEAR : LV_TAB2.

   ENDLOOP.

  CLEAR : TOT_AMT2,WA_CLEAR.
  LOOP AT IT_CLEAR INTO WA_CLEAR.
      TOT_AMT2 = TOT_AMT2 + WA_CLEAR-AMOUNT.

  ENDLOOP.
 ENDIF.
  DATA(LV_TAB3) =
           |<Row1>| &&
            |<Date></Date>| &&
            |<Chq_no></Chq_no>| &&
            |<DESCRIPTION>TOTAL CHEQUE ISSUED :-</DESCRIPTION>| &&
            |<DTTO></DTTO>| &&
            |<AMOUNT>{ TOT_AMT2 }</AMOUNT>| &&
         |</Row1>| &&
        |</Table1>| &&
      |</item>| .
*            |<TOTAL1>TOTAL</TOTAL1>| &&
*            |<AMT1>{ TOT_AMT2 }</AMT1>| &&
*         |</Row1>|.


************************ Clear Data outgoing*****************************

 SELECT A~COMPANYCODE,A~ACCOUNTINGDOCUMENT,A~FISCALYEAR,
         A~CLEARINGDATE,A~DOCUMENTDATE,A~GLACCOUNT,
         D~SUPPLIER,D~CUSTOMER,A~OFFSETTINGACCOUNT,
         A~AMOUNTINTRANSACTIONCURRENCY,B~CUSTOMERNAME,C~SupplierNAME,
         e~DOCUMENTREFERENCEID
         FROM I_OPERATIONALACCTGDOCITEM AS A
         left outer join I_OPERATIONALACCTGDOCITEM as d on
         d~AccountingDocument = a~AccountingDocument and d~CompanyCode = a~CompanyCode
         and d~FiscalYear = a~FiscalYear and d~FinancialAccountType IN ( 'K' , 'D' )
         LEFT OUTER JOIN I_CUSTOMER AS B ON B~Customer = D~Customer
         LEFT OUTER JOIN I_Supplier AS C ON C~Supplier = D~Supplier
         LEFT OUTER JOIN I_JOURNALENTRY AS E ON e~CompanyCode = a~CompanyCode and
         e~AccountingDocument = a~AccountingDocument and e~FiscalYear = a~FiscalYear
         WHERE A~GLAccount = @brs_tab-gl3
           AND A~PostingDate LE @STATEMENT_DT1 and
          ( A~ClearingDaTE GT @STATEMENT_DT1 OR A~ClearingDate = '00000000' )
           INTO TABLE @DATA(lt_clear1).
           CLEAR : WA_CLEAR,TOT_AMT3.
IF LT_CLEAR1 IS NOT INITIAL.
    LOOP AT LT_CLEAR1 INTO DATA(LS_CLEAR1).
        WA_CLEAR1-COMPANYCODE        = LS_CLEAR1-CompanyCode.
        WA_CLEAR1-accountingdocument = LS_CLEAR1-AccountingDocument.
        WA_CLEAR1-fiscalyear         = LS_CLEAR1-FiscalYear.
        WA_CLEAR1-documentdate       = LS_CLEAR1-DocumentDate.
        IF LS_CLEAR1-CustomerName IS NOT INITIAL.
          WA_CLEAR1-customername     = LS_CLEAR1-CustomerName.
        ELSE.
          WA_CLEAR1-customername     = LS_CLEAR1-SupplierName.
        ENDIF.
        WA_CLEAR1-assignmentreference = LS_CLEAR1-DOCUMENTREFERENCEID.
        WA_CLEAR1-amount = LS_CLEAR1-AmountInTransactionCurrency.
        APPEND WA_CLEAR1 TO IT_CLEAR1.
        TOT_AMT3 = TOT_AMT3 + LS_CLEAR1-AmountInTransactionCurrency.
        CLEAR WA_CLEAR1.
   ENDLOOP.

ENDIF.
*APPEND  LINES OF IT_CLEAR1[] TO IT_CLEAR[].

  DATA(LV_TAB4) =

    |<item1>| &&
      |<Table1>| &&
*         |<Row1>| &&
*            |<BAL_AS_PER_BOOK></BAL_AS_PER_BOOK>| &&
*         |</Row1>| &&
         |<Row1>| &&
            |<CHEQUE></CHEQUE>| &&
         |</Row1>|.
IF IT_CLEAR1 IS NOT INITIAL.
   SORT IT_CLEAR1 BY documentdate ASCENDING.  "added on 17-08-2024
   delete ADJACENT DUPLICATES FROM it_clear1 COMPARING ALL FIELDS.
   loop at  IT_CLEAR1 into wa_clear1.
 DATA(LV_TAB5) =
          |<Row1>| &&
            |<DATE1>{ WA_CLEAR1-documentdate }</DATE1>| &&
            |<Chq_no>{ WA_CLEAR1-assignmentreference }</Chq_no>| &&
            |<desc>{ WA_CLEAR1-customername }</desc>| &&
            |<date></date>| &&
            |<amt1>{ WA_CLEAR1-amount }</amt1>| &&
         |</Row1>|.
         CONCATENATE lv_vs4 LV_TAB5 into lv_vs4 .
         CLEAR LV_TAB5.
    endloop.
 ENDIF.
DATA(LV_TAB6) =
         |<Row1>| &&
            |<DATE1></DATE1>| &&
            |<Chq_no></Chq_no>| &&
            |<desc>TOTAL CHEQUE DEPOSITED :-</desc>| &&
            |<date></date>| &&
            |<amt1>{ TOT_AMT3 }</amt1>| &&
         |</Row1>|.


              IF TOT_AMT4 GE 0 .
                    TOT_AMT5 = TOT_AMT4 + TOT_AMT3.
              ELSE.
                    TOT_AMT5 = TOT_AMT4 - TOT_AMT3.
              ENDIF.
               IF TOT_AMT5 GE 0 .
                    TOT_AMT6 = TOT_AMT5 + TOT_AMT2.
              ELSE.
                    TOT_AMT6 = TOT_AMT5 - TOT_AMT2.
              ENDIF.


DATA(LV_TAB7) = |<Row1>| &&
            |<DATE1></DATE1>| &&
            |<Chq_no></Chq_no>| &&
            |<desc>BALANCE AS PER OUR BOOKS</desc>| &&
            |<date></date>| &&
            |<amt1>{ TOT_AMT6 }</amt1>| &&
         |</Row1>|.

DATA(LV_TAB8) = |<FooterData>| &&
            |<Bal_as_per_bank>{ TOT_AMT4 }</Bal_as_per_bank>| &&
         |</FooterData>|.

DATA(LV_TAB9) =
   |</Table1>| &&
   |</item1>| &&
|</form1>|
 .

CONCATENATE LV_TAB1 LV_TAB10 lv_vs2 LV_TAB3 LV_TAB4 lv_vs4 LV_TAB6 LV_TAB7 LV_TAB8 LV_TAB9 into lv_xml .

*
*data:prdoc TYPE char10.
*
*  SELECT SINGLE * FROM I_PURCHASEREQUISITIONAPI01 WHERE PurchaseR equisition = @prdoc INTO @DATA(IT) .
*
*  SELECT SINGLE * FROM I_PurchaseRequisitionItemAPI01 WHERE PurchaseRequisition = @prdoc INTO @DATA(IT2) .
*
*  SELECT SINGLE * FROM I_PlantStdVH WHERE Plant = @it2-Plant INTO @DATA(plant) .
*
*  if
*  it2-plant = '1001' .
*  DATA(bp) = '1000'.
*  ELSEIF
*  it2-plant = '2001' .
*  bp = '2000' .
*  ELSEIF
*  it2-plant = '3001' .
*  bp = '3000' .
*  ELSEIF
*  it2-plant = '3002' .
*  bp = '3000' .
*  ELSEIF
*  it2-plant = '3003' .
*  bp = '3000' .
*  ELSEIF
*  it2-plant = '3004' .
*  bp = '3000' .
*  ELSEIF
*  it2-plant = '3005' .
*  bp = '3000' .
*  ELSEIF
*  it2-plant = '4001' .
*  bp = '4000' .
*  ELSEIF
*  it2-plant = '5001' .
*  bp = '5000' .
*  ELSEIF
*  it2-plant = '6001' .
*  bp = '6000' .
*  ENDIF.
*
*  SELECT SINGLE * FROM I_KR_BusinessPlace WHERE Branch = @bp INTO @DATA(bplace) .
*
*
*
*
*
*
*   IF IT2-Plant = '6001' .
*   DATA(GST) = '06AAACN9099H1Z2 ' .
*   ELSE .
*   GST = '19AAACN9099H1ZV' .
*   ENDIF.
*   data lv_xml type string .
*      DATA(lv_vs1) =
*     |<form1>| &&
*   |<Subform1>| &&
*      |<add1></add1>| &&
*      |<PlantHead>NIPHA EXPORTS PRIVATE LIMITED</PlantHead>| &&
*      |<add2>Registered Address:- 48, Ganga jamuna, 28/1 Shakespeare Sarani, Kolkata 700 017, West Bengal, India</add2>| &&
*      |<Subform7>| &&
*         |<CINNo>U51909WB1973PTC028897</CINNo>| &&
*         |<GSTIN>{ GST }</GSTIN>| &&
*         |<PAN>AAACN9099H</PAN>| &&
*      |</Subform7>| &&
*   |</Subform1>| &&
*   |<Subform8>| &&
*      |<venadd1>{ prdoc }</venadd1>| &&
*      |<venadd2>{ it2-PurReqCreationDate+6(2)  }/{ it2-PurReqCreationDate+4(2) }/{ it2-PurReqCreationDate+0(4) }</venadd2>| &&
*      |<venadd3>{ it2-RequisitionerName }</venadd3>| &&
*      |<venadd4></venadd4>| &&
*      |<venadd5></venadd5>| &&
*      |<venadd6></venadd6>| &&
*      |<billadd1>{ bplace-AddressName }</billadd1>| &&
*      |<billadd2>{ bplace-HouseNumber }{ bplace-StreetName }</billadd2>| &&
*      |<billadd3>{ bplace-CityName }{ bplace-PostalCode }</billadd3>| &&
*      |<billadd4>{ bplace-ResponsiblePersonEmailAddress }{ bplace-PhoneNumber }</billadd4>| &&
*      |<billadd5></billadd5>| &&
*      |<billadd6></billadd6>| &&
*   |</Subform8>| &&
*   |<Subform9>| &&
*      |<Table1>| &&
*         |<HeaderRow/>| .
*
*   data lv_vs2 type string .
*   data sno type string .
*      data TEXTDES type string .
*
*
*     SELECT * FROM I_PurchaseRequisitionItemAPI01 WHERE PurchaseRequisition = @prdoc INTO TABLE @DATA(IT_tab) .
*
*
*
*LOOP AT IT_tab INTO DATA(wa_tab) .
*sno = 1 + sno .
*
*if wa_tab-BaseUnit = 'ST' .
*DATA(PC) = 'PC' .
*ELSE .
*PC = wa_tab-BaseUnit .
*ENDIF .
*
*SELECT SINGLE * FROM I_ProductGroupText_2 WHERE ProductGroup = @wa_tab-MaterialGroup AND Language = 'E' INTO @DATA(TEXT) .
*DATA(var1) =   |{  wa_tab-Material ALPHA = OUT }| .
*   REPLACE ALL OCCURRENCES OF '”' IN wa_tab-PurchaseRequisitionItemText WITH '"' .
*   REPLACE ALL OCCURRENCES OF REGEX '&#160' IN wa_tab-PurchaseRequisitionItemText WITH ''.
**   REPLACE ALL OCCURRENCES OF CL_ABAP_CHAR_UTILITIES=>newline in
**   wa_tab-PurchaseRequisitionItemText WITH ''.
*
*    CONDENSE wa_tab-PurchaseRequisitionItemText  .
**SHIFT wa_tab-PurchaseRequisitionItemText LEFT DELETING LEADING space .
*
*
*
*
*
*         DATA(lv_vs_tab) =
*         |<Row1>| &&
*            |<sno>{ sno }</sno>| &&
*            |<itemcode>{ var1 }</itemcode>| &&
*            |<itemdes>{ wa_tab-PurchaseRequisitionItemText }</itemdes>| &&
*            |<unit>{ PC }</unit>| &&
*            |<quantity>{ wa_tab-RequestedQuantity }</quantity>| &&
*            |<rate>{  wa_tab-DeliveryDate+6(2) }/{  wa_tab-DeliveryDate+4(2) }/{  wa_tab-DeliveryDate+0(4) }</rate>| &&
**            |<total>{ TEXT-ProductGroupText }</total>| &&
*         |</Row1>| .
*
*         CONCATENATE lv_vs2 lv_vs_tab into lv_vs2 .
*         clear : lv_vs_tab .
*
*         ENDLOOP.
*
*
*        DATA(lv_vs3) =
*        |<FooterRow/>| &&
*      |</Table1>| &&
*   |</Subform9>| &&
*   |<Subform10>| &&
*      |<preparedby></preparedby>| &&
*   |</Subform10>| &&
*|</form1>| .
*
*CONCATENATE lv_vs1 lv_vs2 lv_vs3 into lv_xml .

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
