CLASS ycl_account_statement_customer DEFINITION
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
        IMPORTING VALUE(companycode)      TYPE string
                  VALUE(correspondence)   TYPE string
                  VALUE(accounttype)      TYPE string
                  VALUE(customer)         TYPE string
                  VALUE(lastdate)         TYPE string
                  VALUE(currentdate)      TYPE string
                  VALUE(profitcenter)     TYPE CHAR10
                  VALUE(confirmletterbox) TYPE string
                  VALUE(segment)          TYPE string




        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .
  PROTECTED SECTION.
  PRIVATE SECTION.
CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://devtenant-ux00yyve.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
 CONSTANTS  lc_template_name TYPE string VALUE 'ACCOUNTSTATEMENT_NEW1/ACCOUNTSTATEMENT_NEW1'.
ENDCLASS.



CLASS YCL_ACCOUNT_STATEMENT_CUSTOMER IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.
    TRY.
    ENDTRY.
  ENDMETHOD.


  METHOD read_posts .

    DATA xsml TYPE string.
    DATA date2 TYPE string.
    DATA gv1 TYPE string .
    DATA gv2 TYPE string .
    DATA gv3 TYPE string .

    gv3 = currentdate+6(4)  .
    gv2 = currentdate+3(2)  .
    gv1 = currentdate+0(2)  .

*    CONCATENATE gv3 gv1 gv2    INTO date2.
    CONCATENATE gv3 gv2 gv1    INTO date2.

    DATA date3 TYPE string.
    DATA gv4 TYPE string .
    DATA gv5 TYPE string .
    DATA gv6 TYPE string .

    gv6 = lastdate+6(4)  .
    gv5 = lastdate+3(2)  .
    gv4 = lastdate+0(2)  .

*    CONCATENATE gv6 gv4 gv5   INTO date3.
  CONCATENATE gv6 gv5 gv4   INTO date3.

     DATA VAR TYPE STRING .
       VAR   = |{ customer ALPHA = IN }|.
    customer = VAR.


DATA ALPHA TYPE CHAR10 .
  ALPHA = |{ customer ALPHA = IN }| .
  customer = alpha .

DATA var1 TYPE zchar10.
    var1 = segment.
    var1 =   |{ |{ var1 ALPHA = OUT }| ALPHA = IN }| .
    segment = var1.


*VIREN
if profitcenter = ''  AND segment = ''.

    SELECT  * FROM  I_GLAccountLineItem  AS A
     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear  )
     LEFT OUTER JOIN I_OperationalAcctgDocItem AS D ON ( D~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear )

     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
    WHERE
      A~CUSTOMER = @customer
      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
      AND A~Ledger = '0L'
*      AND a~FiscalYear = @year
      AND
      A~CompanyCode = @companycode
      AND ( ( (     a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( a~FinancialAccountType = 'D' ) )
*            OR ( ( D~AccountingDocumentType = 'KZ' ) AND D~FinancialAccountType = 'S' ) )
      AND  d~AccountingDocumentItemType <> 'T' )
     INTO TABLE  @DATA(IT) .

   """SS
*     SELECT  * FROM  I_OperationalAcctgDocItem  AS A
*     LEFT outer join I_GLAccountLineItem as d on (  d~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear )
*     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear  )
*     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
*    WHERE
*      A~CUSTOMER = @customer
*      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
*
*
**      AND A~Ledger = '0L'
**      AND a~FiscalYear = @year
*      AND
*      A~CompanyCode = @companycode
*      AND ( ( (   A~AccountingDocumentType = 'AB' OR A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG'
*      OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK' OR A~AccountingDocumentType = 'KZ'
*      OR A~AccountingDocumentType = 'UE')
*            AND ( A~FinancialAccountType = 'K' ) )
*
**            OR ( ( D~AccountingDocumentType = 'KZ' ) AND D~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T' )
*     INTO TABLE  @DATA(IT) .

     """SS

      ELSEIF   profitcenter <> '' AND segment  <> '' .

      SELECT  * FROM  I_GLAccountLineItem  AS A
     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear )
     LEFT OUTER JOIN I_OperationalAcctgDocItem AS D ON ( D~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear  )

     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
    WHERE
      A~CUSTOMER = @customer
      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
      AND A~Ledger = '0L'
*      AND a~FiscalYear = @year
      AND
      A~CompanyCode = @companycode
      and a~ProfitCenter = @profitcenter  AND A~Segment = @segment
             AND ( ( (  a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( a~FinancialAccountType = 'D' ) )
      AND  D~AccountingDocumentItemType <> 'T' )
     INTO TABLE @IT .

*     SELECT  * FROM  I_OperationalAcctgDocItem  AS A
*     LEFT outer join I_GLAccountLineItem as d on (  d~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear )
*     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear  )
*     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
*    WHERE
*      A~CUSTOMER = @customer
*      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
*
**      AND A~Ledger = '0L'
**      AND a~FiscalYear = @year
*      AND d~ProfitCenter = @profitcenter
*      and d~Segment = @segment
*      and
*      A~CompanyCode = @companycode
*      AND ( ( (   A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'AB'
*       OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK' OR A~AccountingDocumentType = 'KZ' OR A~AccountingDocumentType = 'UE')
*            AND ( A~FinancialAccountType = 'K' ) )
*
**            OR ( ( D~AccountingDocumentType = 'KZ' ) AND D~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T' )
*     INTO TABLE  @IT .


       ELSEIF   profitcenter = '' AND segment  <> '' .

     SELECT  * FROM  I_GLAccountLineItem  AS A
     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear )
     LEFT OUTER JOIN I_OperationalAcctgDocItem AS D ON ( D~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear )

     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
    WHERE
      A~CUSTOMER = @customer
      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
      AND A~Ledger = '0L'
*      AND a~FiscalYear = @year
      AND
      A~CompanyCode = @companycode
      AND A~Segment = @segment
              AND ( ( (   a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( a~FinancialAccountType = 'D' ) )

*            OR ( ( D~AccountingDocumentType = 'KZ' ) AND D~FinancialAccountType = 'S' ) )
      AND  D~AccountingDocumentItemType <> 'T' )
     INTO TABLE @IT .
*          SELECT  * FROM  I_OperationalAcctgDocItem  AS A
*     LEFT outer join I_GLAccountLineItem as d on (  d~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear )
*     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear  )
*     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
*    WHERE
*      A~CUSTOMER = @customer
*      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
*
**      AND A~Ledger = '0L'
**      AND A~FiscalYear = @year
*      AND D~Segment = @segment
*      and
*      A~CompanyCode = @companycode
*      AND ( ( (   A~AccountingDocumentType = 'AB' OR A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'RE'
*      OR A~AccountingDocumentType = 'RK' OR A~AccountingDocumentType = 'KZ' OR A~AccountingDocumentType = 'UE')
*            AND ( A~FinancialAccountType = 'K' ) )
*
**            OR ( ( D~AccountingDocumentType = 'KZ' ) AND D~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T' )
*     INTO TABLE  @IT .





      ELSEIF   profitcenter <> ''  AND segment = '' .

     SELECT  * FROM  I_GLAccountLineItem  AS A
     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear )
     LEFT OUTER JOIN I_OperationalAcctgDocItem AS D ON ( D~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear  )

     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
    WHERE
      A~CUSTOMER = @customer
      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
      AND A~Ledger = '0L'
*      AND a~FiscalYear = @year
      AND
      A~CompanyCode = @companycode
      and a~ProfitCenter = @profitcenter
            AND ( ( (    a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( a~FinancialAccountType = 'D' ) )
      AND  D~AccountingDocumentItemType <> 'T' )
     INTO TABLE @IT .

*   SELECT  * FROM  I_OperationalAcctgDocItem  AS A
*     LEFT outer join I_GLAccountLineItem as d on (  d~AccountingDocument = A~AccountingDocument and d~FiscalYear = a~FiscalYear )
*     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument and b~FiscalYear = a~FiscalYear  )
*     LEFT OUTER JOIN I_GLAccountText AS C ON ( C~GLAccount = A~GLAccount AND C~ChartOfAccounts = 'YCOA' AND C~Language = 'E'  )
*    WHERE
*      A~CUSTOMER = @customer
*      and A~PostingDate >= @date3 AND A~PostingDate <= @date2
*
**      AND A~Ledger = '0L'
**      AND a~FiscalYear = @year
*      AND D~ProfitCenter = @profitcenter
*      and
*      A~CompanyCode = @companycode
*      AND ( ( (   A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'AB'
*      OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK' OR A~AccountingDocumentType = 'KZ' OR A~AccountingDocumentType = 'UE')
*            AND ( A~FinancialAccountType = 'K' ) )
*
**            OR ( ( D~AccountingDocumentType = 'KZ' ) AND D~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T' )
*     INTO TABLE  @IT .



     ENDIF.

sort it BY a-AccountingDocument ASCENDING  .
*DELETE ADJACENT DUPLICATES FROM it COMPARING a-AccountingDocument .
DELETE it WHERE A-FinancialAccountType <> 'D'.
DELETE ADJACENT DUPLICATES FROM it COMPARING a-AccountingDocument  A-FiscalYear .
sort it BY a-DocumentDate  ASCENDING.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""OPENING BALANCE"""""""""""""""""""""""""""""""""""""""""""""""""""""""

*SELECT A~AMOUNTINCOMPANYCODECURRENCY
*       FROM   I_GLAccountLineItem as a
*
*
*        WHERE a~CUSTOMER = @customer AND
*        a~CompanyCode = @companycode
*        AND A~Ledger = '0L'
*        AND A~PostingDate LE @date3 INTO TABLE @DATA(OPENING).
*  IF date3 >= '20240401' AND year ='2024'.
*     data(yr) = '2023'.
*     else.
*     yr = year.
*     endif.


  IF Profitcenter = '' AND segment = '' .

*     IF date3 >= '20240401' AND year ='2024'.
*     data(yr) = '2023'.
*     else.
*     yr = year.
*     endif.

*    SELECT SUM( A~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_GLAccountLineItem as a
*
*
*        WHERE a~CUSTOMER = @customer AND
*        a~CompanyCode = @companycode
*        AND A~Ledger = '0L'
*        AND A~PostingDate < @date3
*        and a~FiscalYear = @yr
*         AND (  (   A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK'
*         OR A~AccountingDocumentType = 'KZ' )
*            AND ( A~FinancialAccountType = 'K' ) )
**             OR A~FinancialAccountType = 'S' )  )
*
**            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
**      AND  A~AccountingDocumentItemType <> 'T'
*        AND A~ItemIsSplit = 'X'
*        INTO @DATA(OPENING).

           SELECT SUM( A~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_OperationalAcctgDocItem as a
        FROM   I_GLAccountLineItem as a
        WHERE a~CUSTOMER = @customer AND
        a~CompanyCode = @companycode
        AND A~Ledger = '0L'
        AND A~PostingDate < @date3
*        and a~FiscalYear = @yr
         AND (  (    a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( A~FinancialAccountType = 'D' ) )
*             OR A~FinancialAccountType = 'S' )  )

*            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T'
*        AND A~ItemIsSplit = 'X'
        INTO @DATA(OPENING).




 ELSEIF  Profitcenter <> '' AND segment = ''.
* SELECT SUM( a~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_GLAccountLineItem as a
*
*
*        WHERE a~CUSTOMER = @customer AND
*        a~CompanyCode = @companycode
*        AND a~PostingDate < @date3
*        AND A~ProfitCenter = @profitcenter
*                and a~FiscalYear = @yr
*
*        AND A~Ledger = '0L'
*         AND ( ( (   A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK' )
*            AND ( A~FinancialAccountType = 'K' ) )
*
*            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
**      AND  A~AccountingDocumentItemType <> 'T'
*        INTO @OPENING.

        SELECT SUM( a~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_OperationalAcctgDocItem as a
       from  I_GLAccountLineItem as a
*        on (  b~AccountingDocument = a~AccountingDocument and b~FiscalYear = a~FiscalYear  )
        WHERE a~CUSTOMER = @customer AND
        a~CompanyCode = @companycode
        AND A~Ledger = '0L'
        AND A~PostingDate < @date3
*        and a~FiscalYear = @yr
        and a~ProfitCenter = @profitcenter

      AND (  (    a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( A~FinancialAccountType = 'D' ) )
*             OR A~FinancialAccountType = 'S' )  )

*            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T'
*        AND A~ItemIsSplit = 'X'
        INTO @OPENING.

*            SELECT *
**       FROM   I_OperationalAcctgDocItem as a
*       from  I_GLAccountLineItem as a
**        on (  b~AccountingDocument = a~AccountingDocument and b~FiscalYear = a~FiscalYear  )
*        WHERE a~CUSTOMER = @customer AND
*        a~CompanyCode = @companycode
*        AND A~Ledger = '0L'
*        AND A~PostingDate < @date3
**        and a~FiscalYear = @yr
*        and a~ProfitCenter = @profitcenter
*
*         AND (  (   A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK'
*         OR A~AccountingDocumentType = 'KZ' OR A~AccountingDocumentType = 'UE' )
*            AND ( A~FinancialAccountType = 'K' ) )
**             OR A~FinancialAccountType = 'S' )  )
*
**            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
**      AND  A~AccountingDocumentItemType <> 'T'
**        AND A~ItemIsSplit = 'X'
*        INTO  TABLE @DATA(YOPENING).

*        DATA:V_OPEN_TOT TYPE P DECIMALS 2.
*        LOOP AT yopening INTO DATA(OP).
*        v_open_tot = v_open_tot + OP-AmountInTransactionCurrency.
*
*        ENDLOOP.





  ELSEIF  Profitcenter = '' AND segment <> ''.
* SELECT SUM( a~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_GLAccountLineItem as a
*
*
*        WHERE a~CUSTOMER = @customer AND
*        a~CompanyCode = @companycode
*        AND a~PostingDate < @date3
*                and a~FiscalYear = @yr
*
*        AND A~Segment = @segment
*        AND A~Ledger = '0L'
*         AND ( ( (   A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK' )
*            AND ( A~FinancialAccountType = 'K' ) )
*
*            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
**      AND  A~AccountingDocumentItemType <> 'T'
*        INTO @OPENING.

       SELECT SUM( a~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_OperationalAcctgDocItem as a
       from  I_GLAccountLineItem as a
*        on (  b~AccountingDocument = a~AccountingDocument and b~FiscalYear = a~FiscalYear  )
        WHERE a~CUSTOMER = @customer AND
        a~CompanyCode = @companycode
        AND A~Ledger = '0L'
        AND A~PostingDate < @date3
*        and a~FiscalYear = @yr
        and a~Segment = @segment

      AND (  (    a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( A~FinancialAccountType = 'D' ) )
*             OR A~FinancialAccountType = 'S' )  )

*            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T'
*        AND A~ItemIsSplit = 'X'
        INTO @OPENING.

  ELSEIF  Profitcenter <> '' AND segment <> ''.
* SELECT SUM( a~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_GLAccountLineItem as a
*
*
*        WHERE a~CUSTOMER = @customer AND
*        a~CompanyCode = @companycode
*        AND a~PostingDate < @date3
*        AND A~Segment = @segment
*        AND A~ProfitCenter = @profitcenter
*                and a~FiscalYear = @yr
*
*        AND A~Ledger = '0L'
*         AND ( ( (   A~AccountingDocumentType = 'KR' OR A~AccountingDocumentType = 'KG' OR A~AccountingDocumentType = 'RE' OR A~AccountingDocumentType = 'RK' )
*            AND ( A~FinancialAccountType = 'K' ) )
*
*            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
**      AND  A~AccountingDocumentItemType <> 'T'
*        INTO @OPENING.

          SELECT SUM( A~AMOUNTINCOMPANYCODECURRENCY )
*       FROM   I_OperationalAcctgDocItem as a
*          left outer join  I_GLAccountLineItem as b on (  b~AccountingDocument = a~AccountingDocument and b~FiscalYear = a~FiscalYear  )
          from  I_GLAccountLineItem as a
        WHERE a~CUSTOMER = @customer AND
        a~CompanyCode = @companycode
        AND a~Ledger = '0L'
        AND A~PostingDate < @date3
*        and a~FiscalYear = @yr
        and a~ProfitCenter = @profitcenter
         and a~Segment = @segment

       AND (  (    a~AccountingDocumentType = 'RV' OR a~AccountingDocumentType = 'DR' OR a~AccountingDocumentType = 'DG' OR a~AccountingDocumentType = 'UE' OR a~AccountingDocumentType = 'DZ')
            AND ( A~FinancialAccountType = 'D' ) )
*             OR A~FinancialAccountType = 'S' )  )

*            OR ( ( A~AccountingDocumentType = 'KZ' ) AND A~FinancialAccountType = 'S' ) )
*      AND  A~AccountingDocumentItemType <> 'T'
*        AND A~ItemIsSplit = 'X'
        INTO @OPENING.




 ENDIF.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""CLOSING BALANCE""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  IF Profitcenter = '' AND segment = '' .
    SELECT SUM( A~AMOUNTINCOMPANYCODECURRENCY )
       FROM   I_GLAccountLineItem as a


        WHERE a~CUSTOMER = @customer AND
        a~CompanyCode = @companycode
        AND A~Ledger = '0L'
*                and a~FiscalYear = @year

        AND A~PostingDate LE @date2
        INTO @DATA(CLOSING_BAL).

ELSEIF  Profitcenter <> '' AND segment = ''.
  SELECT SUM( A~AMOUNTINCOMPANYCODECURRENCY )
       FROM I_GLAccountLineItem as a

       WHERE
        A~CUSTOMER = @customer AND
        A~CompanyCode = @companycode
        AND A~PostingDate LE @date2
        AND A~ProfitCenter = @profitcenter
*                and a~FiscalYear = @year

        AND A~Ledger = '0L'
        INTO @CLOSING_BAL.

  ELSEIF  Profitcenter = '' AND segment <> ''.
  SELECT SUM( A~AMOUNTINCOMPANYCODECURRENCY )
       FROM I_GLAccountLineItem as a

       WHERE
        A~CUSTOMER = @customer AND
        A~CompanyCode = @companycode
        AND A~PostingDate LE @date2
        AND A~Segment = @segment
        AND A~Ledger = '0L'
*                and a~FiscalYear = @year

        INTO @CLOSING_BAL.

   ELSEIF  Profitcenter <> '' AND segment <> ''.
  SELECT SUM( A~AMOUNTINCOMPANYCODECURRENCY )
       FROM I_GLAccountLineItem as a

       WHERE
        A~CUSTOMER = @customer AND
        A~CompanyCode = @companycode
        AND A~PostingDate LE @date2
        AND A~ProfitCenter = @profitcenter
        AND A~Segment   = @segment
*                and a~FiscalYear = @year

        AND A~Ledger = '0L'
        INTO @CLOSING_BAL.

ENDIF.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 SELECT SINGLE * FROM i_CUSTOMER as a
   left outer  join ZCUSTOMER_DETAILS as b on ( b~CUSTOMER = a~CUSTOMER  )
*    left outer  join  I_Bank_2 as f on ( f~BankInternalID = b~Bank  )
    WHERE a~CUSTOMER = @customer  INTO @DATA(CUSTOMER1).


* SELECT SINGLE * FROM ZCUSTOMER_DETAILS where CUSTOMER = @customer  into @DATA(email).
""""""""""""""""""""""""""""""""""""""""""""""" Address"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

   READ TABLE IT INTO DATA(bsplc) INDEX 1 .
*  SELECT SINGLE * FROM I_KR_BusinessPlace WHERE  Branch = @bsplc-D-BusinessPlace INTO @DATA(HEADDET) .
  SELECT SINGLE * FROM I_KR_BusinessPlace WHERE  Branch = @bsplc-d-BusinessPlace INTO @DATA(HEADDET) .


   data Register3 TYPE STRING.
   Register3 = 'Factory Address : Serampore Unit (Rolling Div), Nh2, Delhi Road, Dakshin Rajyadharpur, West Bengal, India'.



   if profitcenter <> '' .
   SELECT SINGLE ProfitCenterLongName from I_ProfitCenterText WHERE  ProfitCenter = @ProfitCenter  AND Language = 'E' AND ControllingArea = 'A000' INTO @DATA(PROFITCENTERNAME) .
   ENDIF.
   if segment <> '' .
   SELECT SINGLE SegmentName from I_SegmentText WHERE  Segment = @Segment  AND Language = 'E'  INTO @DATA(SEGMENTNAME) .
   ENDIF.


*OPENING = v_open_tot.


 DATA(lv_xml) =

   |<form1>| &&
   |<plantname>{ headdet-CompanyName }</plantname>| &&
   |<address1>{ Register3 }</address1>| &&
   |<address2>{  headdet-HouseNumber  }{ headdet-StreetName },{ headdet-CityName }-{ headdet-PostalCode }</address2>| &&
   |<emailphone>{ headdet-ResponsiblePersonEmailAddress },{ headdet-PhoneNumber }</emailphone>| &&
   |<address3>ACCOUNT STATEMENT</address3>| &&
   |<CINNO>{ headdet-BusinessType }</CINNO>| &&
   |<GSTIN>{ headdet-TaxNumber1 }</GSTIN>| &&
   |<PAN>{ headdet-VATRegistration }</PAN>| &&
     |<LeftSide>| &&
      |<partyno>{ CUSTOMER1-A-CUSTOMERFullName }</partyno>| &&
      |<partyno2>{ CUSTOMER1-B-StreetPrefixName1 }</partyno2>| &&
      |<partyno3>{ CUSTOMER1-B-StreetPrefixName2 }</partyno3>| &&
      |<partyadd>{ CUSTOMER1-A-CityName }-{ CUSTOMER1-A-PostalCode }</partyadd>| &&
      |<partyadd1>{ CUSTOMER1-A-TaxNumber3 }</partyadd1>| &&
      |<PHNNO>{ CUSTOMER1-B-TelephoneNumber1 }</PHNNO>| &&
      |<EMAIL>{  CUSTOMER1-B-EmailAddress }</EMAIL>| &&
    |<Subform7/>| &&
   |</LeftSide>| &&
   |<RightSide>| &&
      |<date></date>| &&
      |<openingbl>{ OPENING }</openingbl>| &&
      |<TransporterName></TransporterName>| &&
       |<FromDate>{ lastdate+0(3) }{ Lastdate+3(3) }{ Lastdate+6(4) }</FromDate>| &&
      |<ToDate>{ currentdate+0(3) }{ currentdate+3(3) }{ currentdate+6(4) }</ToDate>| &&
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
      |<profitcenter>{ PROFITCENTERNAME }</profitcenter>| &&
      |<Segment>{ SEGMENTNAME }</Segment>| &&
      |</BankDetail>| &&
   |<chk_mark>{ confirmletterbox }</chk_mark>| .


    DATA sum TYPE i_operationalacctgdocitem-AmountInCompanyCodeCurrency .
    DATA sum1 TYPE i_operationalacctgdocitem-AmountInCompanyCodeCurrency .
    DATA sum2 TYPE i_operationalacctgdocitem-AmountInCompanyCodeCurrency .
    DATA DebitAmt TYPE i_operationalacctgdocitem-AmountInCompanyCodeCurrency .
    DATA CreditAmt TYPE i_operationalacctgdocitem-AmountInCompanyCodeCurrency .




*LOOP AT IT INTO DATA(DLT) .
*IF DLT-d-FinancialAccountType = 'K' .
*DELETE IT WHERE D-AccountingDocumentType = 'DZ'  .
*ELSEIF
*DLT-d-FinancialAccountType = 'S' .
*DELETE IT WHERE  D-AccountingDocumentType = 'KR' AND D-AccountingDocumentType = 'KG' AND D-AccountingDocumentType = 'RE'
*                  AND D-AccountingDocumentType = 'RK'  .
* ENDIF.
*ENDLOOP.



    data BLNC TYPE string .
    data particular TYPE string .
"sort it by d~ACCOUNTINGDOCUMENT ASCENDING.
sort it BY a-postingdate  ASCENDING.


 LOOP AT it INTO DATA(WA) WHERE A-financialaccounttype = 'D'.

*
SELECT SINGLE * FROM I_OperationalAcctgDocItem WHERE CompanyCode = @WA-A-CompanyCode AND AccountingDocument = @WA-A-AccountingDocument
 AND FiscalYear = @WA-A-FiscalYear AND FinancialAccountType = 'S' INTO @DATA(PC1).
 IF SY-SUBRC = 0.
 Wa-A-AmountInCompanyCodeCurrency = PC1-AmountInTransactionCurrency.
 ENDIF.

 if  WA-A-AccountingDocumentType = 'RV' or  WA-A-AccountingDocumentType = 'DR' OR  WA-A-AccountingDocumentType = 'DG' OR  WA-A-AccountingDocumentType = 'UE' OR WA-a-AccountingDocumentType = 'DZ' .

* SELECT SINGLE * FROM I_OperationalAcctgDocItem WHERE CompanyCode = @WA-A-CompanyCode AND AccountingDocument = @WA-A-AccountingDocument
* AND FiscalYear = @WA-A-FiscalYear AND FinancialAccountType = 'K' INTO @PC1.

if profitcenter ne '' AND segment = ''.
SELECT SUM( AmountInTransactionCurrency ) FROM I_GLAccountLineItem WHERE Ledger ='0L' AND CompanyCode = @WA-A-CompanyCode AND AccountingDocument = @WA-A-AccountingDocument
 AND FiscalYear = @WA-A-FiscalYear AND PostingDate = @wa-a-PostingDate AND  AccountingDocumentType = @wa-a-AccountingDocumentType and CUSTOMER = @wa-a-CUSTOMER  and  FinancialAccountType = 'D' and ProfitCenter = @profitcenter
 INTO @data(ic).
IF SY-SUBRC = 0.
Wa-A-AmountInCompanyCodeCurrency = ic.
 ENDIF.
 ENDIF.
 if segment ne '' AND profitcenter = ''.
SELECT SUM( AmountInTransactionCurrency ) FROM I_GLAccountLineItem WHERE Ledger ='0L' AND CompanyCode = @WA-A-CompanyCode AND AccountingDocument = @WA-A-AccountingDocument
 AND FiscalYear = @WA-A-FiscalYear AND PostingDate = @wa-a-PostingDate AND  AccountingDocumentType = @wa-a-AccountingDocumentType and CUSTOMER = @wa-a-CUSTOMER  and  FinancialAccountType = 'D' and Segment = @segment
 INTO @ic.
IF SY-SUBRC = 0.
Wa-A-AmountInCompanyCodeCurrency = ic.
 ENDIF.
 ENDIF.
 if segment = '' AND profitcenter = '' .
SELECT SUM( AmountInTransactionCurrency ) FROM I_GLAccountLineItem WHERE Ledger ='0L' AND CompanyCode = @WA-A-CompanyCode AND AccountingDocument = @WA-A-AccountingDocument
 AND FiscalYear = @WA-A-FiscalYear AND PostingDate = @wa-a-PostingDate AND  AccountingDocumentType = @wa-a-AccountingDocumentType and CUSTOMER = @wa-a-CUSTOMER  and  FinancialAccountType = 'D'
 INTO @ic.
IF SY-SUBRC = 0.
Wa-A-AmountInCompanyCodeCurrency = ic.
 ENDIF.
 ENDIF.
 if segment NE '' AND profitcenter NE '' .
SELECT SUM( AmountInTransactionCurrency ) FROM I_GLAccountLineItem WHERE Ledger ='0L' AND CompanyCode = @WA-A-CompanyCode AND AccountingDocument = @WA-A-AccountingDocument
 AND FiscalYear = @WA-A-FiscalYear AND PostingDate = @wa-a-PostingDate AND  AccountingDocumentType = @wa-a-AccountingDocumentType and CUSTOMER = @wa-a-CUSTOMER  and  FinancialAccountType = 'D' AND Segment = @segment
 AND ProfitCenter = @profitcenter  INTO @ic.
IF SY-SUBRC = 0.
Wa-A-AmountInCompanyCodeCurrency = ic.
 ENDIF.
 ENDIF.
 ENDIF.
 clear:ic.


 if
  Wa-A-AmountInCompanyCodeCurrency < 0 .
 DATA(PAISA1) = Wa-A-AmountInCompanyCodeCurrency .
 ELSE .
* Wa-d-AmountInCompanyCodeCurrency > 0 .
 DATA(PAISA) = Wa-A-AmountInCompanyCodeCurrency  .
 ENDIF.






    sum   =  sum + PAISA + PAISA1 .
    sum1  = sum + opening.
    IF PAISA < 0 .
    DebitAmt  =  PAISA * -1  .
    ELSE .
    DebitAmt = PAISA .
    ENDIF.



     IF sum1 < 0 .
    sum2  =  sum1 * -1 .
    ELSE.
    sum2  = sum1 .
    ENDIF.

    IF PAISA1 < 0 .
    CreditAmt  =  PAISA1 * -1  .
    ELSE.
    CreditAmt   =  PAISA1  .
    ENDIF.

if
     WA-A-AccountingDocumentType = 'RV'   .

     SELECT SINGLE * FROM I_OperationalAcctgDocItem as a
          LEFT OUTER JOIN I_GLAccountText AS b ON ( b~GLAccount = a~GLAccount AND b~ChartOfAccounts = 'YCOA' AND b~Language = 'E'  )
     WHERE AccountingDocument = @wa-A-AccountingDocument AND CompanyCode = @wa-A-CompanyCode
*     a~FiscalYear = @year
*     AND A~AccountingDocumentItemType = 'M'
    AND ( A~FinancialAccountType = 'S' AND  A~AccountingDocumentItemType = 'R') AND ( a~GLAccount <> '0045000550' or a~GLAccount <> '0045000890'
    or a~GLAccount NOT BETWEEN '0015500010' AND '0155000070' )
      INTO @DATA(DICRIPTION) .

    ELSEif
     WA-A-AccountingDocumentType = 'DR'   OR WA-A-AccountingDocumentType = 'DG' OR WA-A-AccountingDocumentType = 'UE' OR WA-a-AccountingDocumentType = 'DZ'.

     SELECT SINGLE * FROM I_OperationalAcctgDocItem as a
          LEFT OUTER JOIN I_GLAccountText AS b ON ( b~GLAccount = a~GLAccount AND b~ChartOfAccounts = 'YCOA' AND b~Language = 'E'  )
     WHERE AccountingDocument = @wa-A-AccountingDocument AND CompanyCode = @wa-A-CompanyCode
*     a~FiscalYear = @year
*     AND A~AccountingDocumentItemType = 'M'
    AND ( A~FinancialAccountType = 'S' ) AND ( a~GLAccount <> '0045000550' or a~GLAccount <> '0045000890'
    or a~GLAccount NOT BETWEEN '0015500010' AND '0155000070' )
      INTO @DICRIPTION .
      ELSE .
      SELECT SINGLE * FROM I_OperationalAcctgDocItem as a
          LEFT OUTER JOIN I_GLAccountText AS b ON ( b~GLAccount = a~GLAccount AND b~ChartOfAccounts = 'YCOA' AND b~Language = 'E'  )
     WHERE AccountingDocument = @wa-A-AccountingDocument AND CompanyCode = @wa-A-CompanyCode
*     a~FiscalYear = @year
     AND A~AccountingDocumentItemType = 'R' AND ( a~GLAccount <> '0045000550' or a~GLAccount <> '0045000890'
    or a~GLAccount NOT BETWEEN '0015500010' AND '0155000070' )
           INTO @DICRIPTION .
           ENDIF .



*    if
*     WA-A-AccountingDocumentType = 'KZ' OR WA-A-AccountingDocumentType = 'KR'  OR WA-A-AccountingDocumentType = 'KG' .
*    particular = WA-c-GLAccountName .
*    ELSE .
*    particular = DICRIPTION-b-GLAccountName .
*    ENDIF.

   BLNC = BLNC + opening + DebitAmt - CreditAmt .



   """logic for TDS """"16.01.2024
   data:tds_amt TYPE p DECIMALS 2.
   clear:tds_amt.
   select SINGLE * from I_OperationalAcctgDocItem  WHERE AccountingDocument = @wa-b-AccountingDocument
   AND CompanyCode = @wa-b-CompanyCode AND FiscalYear = @wa-b-FiscalYear AND TransactionTypeDetermination
   = 'WIT' INTO @data(i_doc).
   if sy-subrc = 0.
   tds_amt = i_doc-AmountInTransactionCurrency.
   endif.


   """""

   select single * from I_OperationalAcctgDocItem WHERE CompanyCode = @companycode AND
   AccountingDocument = @wa-a-AccountingDocument  AND
*   fiscalyear = @year AND
    CUSTOMER = @wa-a-CUSTOMER
    and DocumentItemText  <> ''
   INTO @data(txt).

   CONCATENATE WA-C-GLAccountLongName txt-DocumentItemText INTO data(part_txt) SEPARATED BY '-'.






     DATA(lv_xml2) =
         |<LopTab>| &&
         |<Row1>| &&
         |<docno>{ WA-B-DocumentReferenceID }</docno>| &&
         |<docdate>{ WA-A-DocumentDate }</docdate>| &&
*         |<particulars>{ DICRIPTION-b-GLAccountLongName }</particulars>| &&
         |<particulars>{ part_txt }</particulars>| &&
*         |<doctype>{ WA-A-AccountingDocumentType }</doctype>| &&
         |<doctype>{ tds_amt }</doctype>| &&
         |<Tdsamt>{ WA-A-AccountingDocument }</Tdsamt>| &&
         |<debitamt>{ DebitAmt }</debitamt>| &&
         |<creditamt>{ CreditAmt }</creditamt>| &&

*         |<Balance>{ SUM2 }</Balance>| &&
         |<Balance>{ BLNC }</Balance>| &&
         |</Row1>| &&
         |</LopTab>|.

 CONCATENATE xsml lv_xml2 INTO  xsml .
  clear : PAISA,PAISA1,sum2,DebitAmt,CreditAmt,WA,particular,opening,part_txt,txt.


 ENDLOOP.




    DATA(lv_xml3) =
       |<Subform3>| &&
       |<Table3>| &&
          |<Row1>| &&
            |<closingbl>{ BLNC }</closingbl>| &&
         |</Row1>| &&
      |</Table3>| &&
      |</Subform3>| &&
      |<Subform2>| &&
      |<SIGN></SIGN>| &&
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
