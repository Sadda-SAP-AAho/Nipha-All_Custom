CLASS zcl_sales_reg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .

    INTERFACES if_oo_adt_classrun .
    METHODS runjob.
*      IMPORTING paraminvoiceno TYPE c .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALES_REG IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'S_ID'    kind = if_apj_dt_exec_object=>select_option datatype = 'C' length = 10 param_text = 'My ID'                                      changeable_ind = abap_true )
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 80 param_text = 'My Description'   lowercase_ind = abap_true changeable_ind = abap_true )
      ( selname = 'P_COUNT' kind = if_apj_dt_exec_object=>parameter     datatype = 'I' length = 10 param_text = 'My Count'                                   changeable_ind = abap_true )
      ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length =  1 param_text = 'My Simulate Only' checkbox_ind = abap_true  changeable_ind = abap_true )
      """cancel sales invoice
     " ( selname  = 'P_CAN' kind  = if_apj_dt_exec_object=>parameter  datatype  = 'C' length  = 1  param_text = 'Include Cancelled  Invoice' checkbox_ind  = abap_true changeable_ind = abap_true )
    ).

    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'S_ID'    kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'EQ' low = '4711' )
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'My Default Description' )
      ( selname = 'P_COUNT' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = '200' )
      ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
      " ( selname = 'P_CAN' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_false )
    ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    TYPES ty_id TYPE c LENGTH 10.

    DATA s_id    TYPE RANGE OF ty_id.
    DATA p_descr TYPE c LENGTH 80.
    DATA p_count TYPE i.
    DATA p_simul TYPE abap_boolean.
    DATA p_can TYPE abap_boolean.

    DATA: jobname   TYPE cl_apj_rt_api=>ty_jobname.
    DATA: jobcount  TYPE cl_apj_rt_api=>ty_jobcount.
    DATA: catalog   TYPE cl_apj_rt_api=>ty_catalog_name.
    DATA: template  TYPE cl_apj_rt_api=>ty_template_name.


    DATA maxbillingdate TYPE d.
    DATA deletestring TYPE c LENGTH 4.
    DATA: lv_tstamp TYPE timestamp, lv_date TYPE d, lv_time TYPE t, lv_dst TYPE abap_bool.


    GET TIME STAMP FIELD lv_tstamp.
    CONVERT TIME STAMP lv_tstamp TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time DAYLIGHT SAVING TIME lv_dst.

    deletestring = |{ lv_date+6(2) }| && |{ lv_time+0(2) }|.


    SELECT FROM zsales_reg_tb
      FIELDS MAX( invoicedate )
      WHERE invoiceno IS NOT INITIAL
      INTO @maxbillingdate .
    IF maxbillingdate IS INITIAL.
      maxbillingdate = 20010101.
    ELSE.
      maxbillingdate = maxbillingdate - 30.
    ENDIF.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    " Getting the actual parameter values
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_ID'.
          APPEND VALUE #( sign   = ls_parameter-sign
                          option = ls_parameter-option
                          low    = ls_parameter-low
                          high   = ls_parameter-high ) TO s_id.
        WHEN 'P_DESCR'.
          p_descr = ls_parameter-low.
        WHEN 'P_COUNT'.
          p_count = ls_parameter-low.
        WHEN 'P_SIMUL'.
          p_simul = ls_parameter-low.
*        WHEN 'P_CAN'.
*          p_can  = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    IF deletestring = p_descr+7(4).
      DELETE FROM zsales_reg_tb WHERE billingdocument IS NOT INITIAL.
*      DELETE FROM zbillinglines WHERE invoice IS NOT INITIAL.
      COMMIT WORK.
    ENDIF.

    TRY.
*      read own runtime info catalog
        cl_apj_rt_api=>get_job_runtime_info(
                         IMPORTING
                           ev_jobname        = jobname
                           ev_jobcount       = jobcount
                           ev_catalog_name   = catalog
                           ev_template_name  = template ).

      CATCH cx_apj_rt.
        CLEAR jobcount.
    ENDTRY.
    runjob( ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
*    DELETE FROM zsales_reg_tb.
    runjob( ).
  ENDMETHOD.


  METHOD runjob.


    TYPES ty_id TYPE c LENGTH 10.

    DATA s_id    TYPE RANGE OF ty_id.
    DATA p_descr TYPE c LENGTH 80.
    DATA p_count TYPE i.
    DATA p_simul TYPE abap_boolean.
    DATA p_can TYPE abap_boolean.

    DATA: jobname   TYPE cl_apj_rt_api=>ty_jobname.
    DATA: jobcount  TYPE cl_apj_rt_api=>ty_jobcount.
    DATA: catalog   TYPE cl_apj_rt_api=>ty_catalog_name.
    DATA: template  TYPE cl_apj_rt_api=>ty_template_name.

*    DATA: lt_billinglines     TYPE TABLE OF zbillinglines,
*          wa_billinglines     TYPE zbillinglines,
*          lt_billingprocessed TYPE STANDARD TABLE OF zbillingproc,
*          wa_billingprocessed TYPE zbillingproc.
*    DATA: lt_cancelled TYPE TABLE OF zbillinglines.
*    DATA: wa_cancelled TYPE zbillinglines.

    DATA maxbillingdate TYPE d.
    DATA deletestring TYPE c LENGTH 4.
    DATA: lv_tstamp TYPE timestamp, lv_date TYPE d, lv_time TYPE t, lv_dst TYPE abap_bool.


    GET TIME STAMP FIELD lv_tstamp.
    CONVERT TIME STAMP lv_tstamp TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time DAYLIGHT SAVING TIME lv_dst.

    deletestring = |{ lv_date+6(2) }| && |{ lv_time+0(2) }|.


    DATA: amountsign TYPE int2.
    DATA: localinvoiceno TYPE n LENGTH 10.
    DATA: lt_response TYPE TABLE OF zsales_reg_tb,
          ls_response TYPE zsales_reg_tb.

    DATA: lv_condition_zmrp TYPE p DECIMALS 3.
    DATA: lv_condition_zbpo TYPE p DECIMALS 3.

    SELECT FROM zsales_reg_tb
      FIELDS MAX( invoicedate )
      WHERE invoiceno IS NOT INITIAL
      INTO @maxbillingdate .
    IF maxbillingdate IS INITIAL.
      maxbillingdate = 20010101.
    ELSE.
      maxbillingdate = maxbillingdate - 30.
    ENDIF.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    IF deletestring = p_descr+7(4).
      DELETE FROM zsales_reg_tb WHERE billingdocument IS NOT INITIAL.
      COMMIT WORK.
    ENDIF.

    TRY.
*      read own runtime info catalog
        cl_apj_rt_api=>get_job_runtime_info(
                         IMPORTING
                           ev_jobname        = jobname
                           ev_jobcount       = jobcount
                           ev_catalog_name   = catalog
                           ev_template_name  = template ).

      CATCH cx_apj_rt.
        CLEAR jobcount.
    ENDTRY.


*    localinvoiceno = paraminvoiceno.

    IF maxbillingdate IS INITIAL.
      DELETE FROM zsales_reg_tb WHERE billingdocument IS NOT INITIAL.
      COMMIT WORK.
    ENDIF.

    SELECT FROM i_billingdocument AS a
        LEFT JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
        LEFT JOIN i_billingdocumentpartner AS bdp ON bdp~billingdocument = a~billingdocument AND bdp~partnerfunction = 'RE'
       " LEFT JOIN i_billingdocumentpartner AS bdp1 ON bdp1~billingdocument  = a~billingdocument  AND bdp1~partnerfunction  = 'AG'
        LEFT JOIN i_businesspartner AS bp1 ON bp1~businesspartner = bdp~customer
        LEFT JOIN i_businesspartner AS bp ON bp~businesspartner = a~soldtoparty
        LEFT JOIN i_customer AS cu1 ON cu1~customer = bdp~customer
        LEFT JOIN i_customer AS cu ON cu~customer = a~soldtoparty
       " LEFT JOIN i_customer AS  cu2 ON   cu2~customer =  bdp1~customer
       " LEFT JOIN i_address_2 AS ad1 ON cu2~addressid  = ad1~addressid

        LEFT JOIN i_address_2 AS ad ON ad~addressid = cu~addressid
      "  LEFT JOIN i_regiontext  AS rt ON ad1~country  = rt~country AND   ad1~region  = rt~region  AND rt~language  = 'E'
        LEFT JOIN i_productplantbasic AS ppb ON b~product = ppb~product AND ppb~plant = b~plant
        LEFT JOIN i_product AS p ON b~product = p~product
        LEFT JOIN i_deliverydocument AS dd ON b~referencesddocument = dd~deliverydocument
        LEFT JOIN i_plant AS j ON j~plant = b~plant
        LEFT JOIN i_productgrouptext_2 AS z ON z~productgroup = b~productgroup AND z~language = 'E'
        LEFT JOIN i_unitofmeasure AS um ON um~unitofmeasure = b~billingquantityunit
      "  LEFT JOIN i_accountingdocumentjournal AS acc ON acc~accountingdocument = a~accountingdocument AND acc~fiscalyear  = a~fiscalyear  AND acc~ledger = '0L' AND acc~glaccounttype = 'P'
        LEFT JOIN i_salesorder  AS  so  ON so~salesorder =  b~salesdocument
    FIELDS a~billingdocument, a~billingdocumenttype, a~billingdocumentdate, a~documentreferenceid, a~accountingdocument, a~purchaseorderbycustomer,
           a~salesorganization, a~distributionchannel, a~division, a~incotermsclassification, a~incotermslocation1, a~cancelledbillingdocument,
           a~assignmentreference, a~customerpaymentterms, a~soldtoparty, a~payerparty, a~createdbyuser, a~billingdocumentiscancelled,  a~fiscalyear , a~companycode,  a~accountingexchangerate ,
       ""    a~FiscalYear, a~CompanyCode,a~YY1_Remarks_bd_BDH,
           b~billingdocumentitem, b~salesgroup, b~salesoffice, b~product, b~billingdocumentitemtext, b~productgroup, b~billingquantityinbaseunit,
           b~billingquantity, b~billingquantityunit, b~itemgrossweight, b~itemnetweight, b~itemweightunit, b~netamount, b~taxamount, b~transactioncurrency,
           b~referencesddocument, b~plant AS bill_doc_plant, b~referencesddocumentitem,
           bdp~customer, bdp~partnerfunction, bdp~billingdocument AS billdoc_bdp,
           bp~businesspartnername, bp1~businesspartnername AS businesspartnername2,
           cu~taxnumber3, cu~addressid, cu1~addressid AS addressid1, cu1~taxnumber3 AS taxnumber31,
           ppb~consumptiontaxctrlcode,ppb~product AS plantproduct, ppb~plant, ppb~profitcenter,
           p~producttype,
           p~division  AS product_division,
           dd~deliverydate, dd~actualgoodsmovementdate, dd~shiptoparty, dd~shippingpoint, j~plantname, z~productgroupname ,
           um~unitofmeasure_e,

*           acc~glaccount,
*           acc~glaccountname,
           so~customerpurchaseorderdate
          " ad1~streetname   , ad1~streetprefixname1 , ad1~streetprefixname2 , ad1~cityname, ad1~region , ad1~postalcode, ad1~country,
          " rt~regionname

            WHERE a~billingdocumentdate >= @maxbillingdate
             AND  NOT EXISTS (
             SELECT billingdocument FROM zsales_reg_tb
             WHERE a~billingdocument = zsales_reg_tb~billingdocument )
*               AND
*                 a~CompanyCode = zsales_reg_tb~companycode AND
*                 a~FiscalYear = zsales_reg_tb~ )
        INTO TABLE @DATA(it_header)
        PRIVILEGED ACCESS.

    DELETE it_header WHERE referencesddocumentitem CP '90*' AND billingdocumenttype = 'F8'.

    SELECT DISTINCT a~billingdocument, b~referencesddocument, b~referencesddocumentitem, b~billingdocumentitem, a~billingdocumenttype
    FROM i_billingdocument AS a
    LEFT JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
    WHERE b~salesdocumentitemcategory NE 'CB99'
    INTO TABLE @DATA(it_billingheader)
    PRIVILEGED ACCESS.

    DELETE it_billingheader WHERE referencesddocumentitem CP '90*' AND billingdocumenttype = 'F8'.

    ""

    IF it_header IS NOT INITIAL.
********************************************************************************************************************


      """""
*select from  i_billingdocument AS a
*   LEFT JOIN i_billingdocumentitem AS b ON a~billingdocument = b~billingdocument
*left outer join I_BILLINGDOCUMENTPARTNER  as c on b~BillingDocument  = c~BillingDocument  and c~PartnerFunction  = 'AG'
*fieldS
*a~BillingDocument
*where a~BillingDocument  =
*INTO TABLE @DATA(LT_ADDRESS)
*PRIVILEGED ACCESS.

      """"""GL ACCOUNT NAME AND GL ACCOUNT
      SELECT FROM i_accountingdocumentjournal AS acc

      INNER JOIN @it_header  AS a  ON acc~accountingdocument = a~accountingdocument
       AND acc~fiscalyear  = a~fiscalyear AND acc~companycode  = a~companycode
       FIELDS
       a~accountingdocument,
       a~fiscalyear,
       a~companycode,
         acc~glaccount,
                 acc~glaccountname
                 WHERE acc~ledger = '0L'
                         AND acc~glaccounttype = 'P'
                         INTO TABLE @DATA(it_accounting)
                         PRIVILEGED ACCESS.

      " 1. For BillingDocumentType
      SELECT FROM i_billingdocumenttypetext AS t
             INNER JOIN @it_header AS h ON t~billingdocumenttype = h~billingdocumenttype
          FIELDS t~billingdocumenttypename, t~billingdocumenttype
          WHERE t~language EQ 'E'
          INTO TABLE @DATA(it_billtext)
          PRIVILEGED ACCESS.

      " 2. For SalesOrganization
      SELECT FROM i_salesorganizationtext AS t
             INNER JOIN @it_header AS h ON t~salesorganization = h~salesorganization
          FIELDS t~salesorganizationname, t~salesorganization
          WHERE t~language EQ 'E'
          INTO TABLE @DATA(it_salestext)
          PRIVILEGED ACCESS.

      " 3. For DistributionChannel
      SELECT FROM i_distributionchanneltext AS t
             INNER JOIN @it_header AS h ON t~distributionchannel = h~distributionchannel
          FIELDS t~distributionchannel, t~distributionchannelname
          WHERE t~language  = 'E'
          INTO TABLE @DATA(it_distributiontext)
          PRIVILEGED ACCESS.

      " 4. For Division
      SELECT FROM i_divisiontext AS t
      INNER JOIN @it_header AS h ON t~division = h~product_division
      FIELDS t~division, t~divisionname
      WHERE t~language = 'E'
      INTO TABLE @DATA(it_divisiontext) PRIVILEGED ACCESS.

      " 5. For SalesOffice
      SELECT FROM i_salesofficetext AS a FIELDS a~salesofficename, a~salesoffice
      WHERE a~language = 'E' INTO TABLE @DATA(it_salesofctext) PRIVILEGED ACCESS.

      " 6. For SalesGroup
      SELECT FROM i_salesgrouptext AS a FIELDS a~salesgroup, a~salesgroupname
      WHERE a~language = 'E' INTO TABLE @DATA(it_salesgrptext) PRIVILEGED ACCESS.

      " 7. For Ship-to Customer Name
      SELECT FROM i_businesspartner AS bp
      INNER JOIN @it_header AS h ON bp~businesspartner = h~shiptoparty
      FIELDS bp~businesspartner, bp~businesspartnerfullname
      INTO TABLE @DATA(ship_to_cust_name) PRIVILEGED ACCESS.


      " 8. For Ship-to Party Address
      TYPES: BEGIN OF ty_shiptoparty,
               customer TYPE kunnr,
             END OF ty_shiptoparty.
      DATA: lt_shiptoparty TYPE TABLE OF ty_shiptoparty.

      lt_shiptoparty = VALUE #( FOR h IN it_header
                                 ( customer = h-shiptoparty ) ).
      SORT lt_shiptoparty BY customer.
      DELETE ADJACENT DUPLICATES FROM lt_shiptoparty COMPARING customer.

      IF lt_shiptoparty IS NOT INITIAL.
        SELECT cust~customer,
               cust~country,
               addrs~addressid,
               addrs~housenumber,
               addrs~streetname,
               addrs~streetprefixname1,
               addrs~streetprefixname2,
               addrs~streetsuffixname1,
               addrs~streetsuffixname2,
               cust~cityname,
               addrs~postalcode,
               rt~regionname,
               ct~countryname
          FROM i_customer AS cust
          LEFT JOIN i_address_2  AS addrs ON cust~addressid  = addrs~addressid
                                         AND addrs~correspondencelanguage = 'E'
          LEFT JOIN i_regiontext AS rt    ON addrs~region   = rt~region
                                         AND addrs~country  = rt~country
                                         AND rt~language    = 'E'
          LEFT JOIN i_countrytext AS ct   ON addrs~country  = ct~country
          FOR ALL ENTRIES IN @lt_shiptoparty
          WHERE cust~customer = @lt_shiptoparty-customer
          INTO TABLE @DATA(ship_to_prty_addrs)
          PRIVILEGED ACCESS.
      ENDIF.

*      SELECT FROM i_customer AS cust
*             INNER JOIN @it_header AS h ON cust~customer = h~shiptoparty
*             LEFT JOIN i_address_2 AS addrs ON cust~addressid = addrs~addressid
*             LEFT JOIN i_regiontext AS rt ON addrs~region = rt~region " AND rt~country = 'IN'
*             LEFT JOIN i_countrytext AS ct ON addrs~country = ct~country
*          FIELDS cust~customer, cust~country , addrs~addressid, addrs~housenumber, addrs~streetname,
*                 addrs~streetprefixname1, addrs~streetprefixname2,
*                 addrs~streetsuffixname1, addrs~streetsuffixname2, cust~cityname ,
*                 addrs~postalcode, rt~regionname, ct~countryname
*             WHERE addrs~correspondencelanguage = 'E' AND rt~language = 'E'  "AND rt~country = 'IN'
*          INTO TABLE @DATA(ship_to_prty_addrs)
*          PRIVILEGED ACCESS.

      " 9. For Standard Cost
      SELECT FROM i_billingdocumentitemprcgelmnt AS cond
             INNER JOIN @it_header AS h ON cond~billingdocument = h~billingdocument
             AND cond~billingdocumentitem = h~billingdocumentitem
          FIELDS cond~conditionratevalue, cond~billingdocument,
                 cond~billingdocumentitem, cond~pricingprocedurestep,
                 cond~pricingprocedurecounter
          WHERE cond~conditiontype = 'ZCIP'
          INTO TABLE @DATA(stnd_cost_unit)
          PRIVILEGED ACCESS.

      " 10. For Material Type Description
      SELECT FROM i_producttypetext AS t
             INNER JOIN @it_header AS h ON t~producttype = h~producttype
          FIELDS t~producttype, t~materialtypename
          WHERE t~language EQ 'E'
          INTO TABLE @DATA(mat_type_desc)
          PRIVILEGED ACCESS.

      " 11. For Delivery Document
      SELECT FROM i_deliverydocument AS d
             INNER JOIN @it_header AS h ON d~deliverydocument = h~referencesddocument
          FIELDS d~deliverydocument, d~deliverydate,
                 d~actualgoodsmovementdate, d~shiptoparty, d~billoflading
          INTO TABLE @DATA(ship_to_cust)
          PRIVILEGED ACCESS.


      " 12. For Pricing Conditions
      SELECT FROM i_billingdocumentitemprcgelmnt AS cond
             INNER JOIN @it_header AS h ON cond~billingdocument = h~billingdocument
             AND cond~billingdocumentitem = h~billingdocumentitem
          FIELDS cond~billingdocument, cond~billingdocumentitem,
                 cond~conditiontype, cond~conditionamount,
                 cond~conditionratevalue, cond~transactioncurrency
          WHERE cond~conditiontype IN ('ZPR0', 'D100', 'ZHF1', 'ZHP1', 'ZHI1',
                                     'ZBK1', 'ZCA1', 'JOCG', 'JOSG', 'JOIG', 'ZOIG' ,
                                     'JOUG', 'JTC2', 'ZRAB', 'ZIF1', 'ZDIF', 'ZMRP', 'ZBP0','ZPR1' , 'ZPEX' , 'ZDIS')
          INTO TABLE @DATA(it_price)
          PRIVILEGED ACCESS.




      SELECT DISTINCT
         cu~addressid
  FROM i_billingdocument AS a
  INNER JOIN @it_header AS h
          ON a~billingdocument = h~billingdocument
  LEFT JOIN i_billingdocumentpartner AS bdp
          ON bdp~billingdocument = a~billingdocument
         AND bdp~partnerfunction = 'RE'
  LEFT JOIN i_customer AS cu
          ON cu~customer = bdp~customer
  WHERE cu~addressid IS NOT INITIAL
  INTO TABLE @DATA(it_address_new)
  PRIVILEGED ACCESS.

      "customer state code
      SELECT DISTINCT
          cu~addressid
   FROM i_billingdocument AS a
   INNER JOIN @it_header AS h
           ON a~billingdocument = h~billingdocument
   LEFT JOIN i_billingdocumentpartner AS bdp
           ON bdp~billingdocument = a~billingdocument
          AND bdp~partnerfunction = 'AG'
   LEFT JOIN i_customer AS cu
           ON cu~customer = bdp~customer
   WHERE cu~addressid IS NOT INITIAL
   INTO TABLE @DATA(it_customer_state)
   PRIVILEGED ACCESS.

      SELECT FROM i_address_2 AS addr
        LEFT JOIN i_regiontext  AS rt ON addr~region  = rt~region
      "  LEFT JOIN i_countrytext AS ct ON addr~country = ct~country
        FIELDS addr~addressid,

               addr~streetname,
               addr~streetprefixname1,
               addr~streetprefixname2,

               addr~cityname,
               addr~country,
               addr~postalcode,
               rt~region,
               rt~regionname
             "  ct~countryname
        FOR ALL ENTRIES IN @it_customer_state
        WHERE addr~addressid = @it_customer_state-addressid
          AND addr~correspondencelanguage = 'E'
          AND rt~language = 'E'
          "AND rt~country = 'IN'
        INTO TABLE @DATA(it_customer_address_details)
        PRIVILEGED ACCESS.



      " For SOLD TO ADDRESS

      SELECT FROM i_address_2 AS addr
        LEFT JOIN i_regiontext  AS rt ON addr~region  = rt~region
        LEFT JOIN i_countrytext AS ct ON addr~country = ct~country
        FIELDS addr~addressid,
               addr~housenumber,
               addr~streetname,
               addr~streetprefixname1,
               addr~streetprefixname2,
               addr~streetsuffixname1,
               addr~streetsuffixname2,
               addr~cityname,
               addr~country,
               addr~postalcode,
               rt~region,
               rt~regionname,
               ct~countryname
        FOR ALL ENTRIES IN @it_address_new
        WHERE addr~addressid = @it_address_new-addressid
          AND addr~correspondencelanguage = 'E'
          AND rt~language = 'E'
          AND rt~country = 'IN'
        INTO TABLE @DATA(it_sold_address_details)
        PRIVILEGED ACCESS.


      " BILL TO ADDRESS
      SELECT FROM i_address_2 AS addr
         INNER JOIN @it_address_new AS h ON addr~addressid = h~addressid
         LEFT JOIN i_regiontext AS rt ON addr~region = rt~region
         LEFT JOIN i_countrytext AS ct ON addr~country = ct~country
      FIELDS addr~addressid,
             addr~housenumber,
             addr~streetname,
             addr~streetprefixname1,
             addr~streetprefixname2,
             addr~streetsuffixname1,
             addr~streetsuffixname2,
             addr~cityname,
             addr~country,
             addr~postalcode,
             rt~region,
             rt~regionname,
             ct~countryname
      WHERE addr~correspondencelanguage = 'E' AND rt~language = 'E' AND rt~country = 'IN'
      INTO TABLE @DATA(it_bill_address_details)
      PRIVILEGED ACCESS.


      SELECT DISTINCT h~shiptoparty
      FROM @it_header AS h
      INTO TABLE @DATA(lt_customer).


      SELECT FROM i_customer AS cust
      INNER JOIN @lt_customer AS h ON cust~customer = h~shiptoparty
      LEFT JOIN i_address_2 AS addrs ON cust~addressid = addrs~addressid
      LEFT JOIN i_regiontext AS rt ON addrs~region = rt~region
      LEFT JOIN i_countrytext AS ct ON addrs~country = ct~country
      FIELDS cust~customer, cust~country , addrs~addressid, addrs~housenumber, addrs~streetname,
          addrs~streetprefixname1, addrs~streetprefixname2,
          addrs~streetsuffixname1, addrs~streetsuffixname2, addrs~cityname,
          addrs~postalcode, rt~regionname, ct~countryname
      WHERE addrs~correspondencelanguage = 'E' AND rt~language = 'E'  AND rt~country = 'IN'
   INTO TABLE @DATA(bill_to_party_country)
   PRIVILEGED ACCESS.

      IF it_sold_address_details IS INITIAL.
        SELECT FROM i_address_2 AS addr
          INNER JOIN @it_address_new AS h ON addr~addressid = h~addressid
          LEFT JOIN i_regiontext AS rt ON addr~region = rt~region
          LEFT JOIN i_countrytext AS ct ON addr~country = ct~country
          FIELDS addr~addressid,
               addr~housenumber,
               addr~streetname,
               addr~streetprefixname1,
               addr~streetprefixname2,
               addr~streetsuffixname1,
               addr~streetsuffixname2,
               addr~cityname,
               addr~country,
               addr~postalcode,
               rt~region,
               rt~regionname,
               ct~countryname
          WHERE addr~correspondencelanguage = 'E' AND rt~language = 'E' AND rt~country = 'IN'
          INTO TABLE @it_sold_address_details
          PRIVILEGED ACCESS.
      ENDIF.

      " Split the results if you need separate tables
      DATA(it_sold_address) = it_sold_address_details.
      DATA(it_bill_address) = it_bill_address_details.


      " For Delivery Item details
      SELECT FROM i_deliverydocumentitem AS ddi
         INNER JOIN @it_billingheader AS h ON ddi~deliverydocument = h~referencesddocument
         LEFT JOIN i_purchaseorderchangedocument AS pocd ON ddi~referencesddocument = pocd~purchaseorder
         LEFT JOIN i_plant AS pl ON ddi~plant = pl~plant
         LEFT JOIN i_storagelocation AS sl ON ddi~storagelocation = sl~storagelocation AND ddi~plant = sl~plant
         LEFT JOIN i_salesorder AS so ON ddi~referencesddocument = so~salesorder
         LEFT JOIN i_salesdocument AS sd ON ddi~referencesddocument = sd~salesdocument
         LEFT JOIN i_salesorderpartner AS sopap ON ddi~referencesddocument = sopap~salesorder
                                            AND sopap~partnerfunction = 'AP'
         LEFT JOIN i_salesorderpartner AS sopze ON ddi~referencesddocument = sopze~salesorder
                                            AND sopze~partnerfunction = 'ZE'
         LEFT JOIN i_salesorderpartner AS sopes ON ddi~referencesddocument = sopes~salesorder
                                            AND sopes~partnerfunction = 'ES'
         LEFT JOIN i_customer AS custze ON sopze~customer = custze~customer
         LEFT JOIN i_salescontract AS sc ON sd~referencesddocument = sc~salescontract
         LEFT JOIN i_unitofmeasure AS um ON um~unitofmeasure = ddi~deliveryquantityunit
      FIELDS ddi~deliverydocument,
             ddi~deliverydocumentitem,
             ddi~referencesddocument,
             pocd~creationdate,
             ddi~plant,
             ddi~issuingorreceivingplant,
             ddi~storagelocation,
             sl~storagelocationname,
             ddi~actualdeliveryquantity,
             ddi~deliveryquantityunit,
             ddi~batch,
             ddi~itemgrossweight,
             ddi~itemnetweight,
             ddi~itemweightunit,
             pl~plantname,
             pl~businessplace,
             so~salesorderdate,
             so~salesordertype,
             so~purchaseorderbycustomer,
             so~customerpurchaseorderdate,
             so~customergroup,
             so~salesorder,
             so~referencesddocument AS refersddoc_so,
             so~salesoffice,
             so~salesgroup,
             sopap~contactperson AS contactpersoncode,
             sopap~fullname AS contactpersonname,
             sopes~supplier AS brokercode,
             sopes~fullname AS brokername,
             sopze~customer AS salesemployeecode,
             custze~customername AS salesemployeename,
             sc~salescontractdate,
             sc~salescontractvaliditystartdate,
             sc~salescontractvalidityenddate,
             sc~salescontracttype,
             sc~salescontract,
             sd~sddocumentreason,
             sd~salesdistrict,
             sd~salesdocumenttype,
             um~unitofmeasure_e
      WHERE ddi~material <> '' AND ddi~actualdeliveryquantity <> 0
      INTO TABLE @DATA(dlvry_item)
      PRIVILEGED ACCESS.


      " FOR SALES DISTRICT
      SELECT FROM i_salesdistricttext AS a
          INNER JOIN @dlvry_item AS b ON a~salesdistrict = b~salesdistrict
              FIELDS a~salesdistrictname, a~salesdistrict
                  INTO TABLE @DATA(sales_dist) PRIVILEGED ACCESS.

      " For Order Type Text
      SELECT FROM i_salesdocumenttypetext AS t
             INNER JOIN @dlvry_item AS d ON t~salesdocumenttype = d~salesordertype
          FIELDS t~salesdocumenttype,
                 t~salesdocumenttypename
          WHERE t~language EQ 'E'
          INTO TABLE @DATA(order_type_text)
          PRIVILEGED ACCESS.

      " For Document Reason Text
      SELECT FROM i_sddocumentreasontext AS t
             INNER JOIN @dlvry_item AS d ON t~sddocumentreason = d~sddocumentreason
          FIELDS t~sddocumentreason,
                 t~sddocumentreasontext
          WHERE t~language EQ 'E'
          INTO TABLE @DATA(ord_reason_desc)
          PRIVILEGED ACCESS.

      " Payment Terms Description
      SELECT FROM i_paymenttermstext AS a
              INNER JOIN @it_header AS hdr ON a~paymentterms = hdr~customerpaymentterms
             FIELDS a~paymenttermsdescription, a~paymentterms
             WHERE a~language  = 'E'
              INTO TABLE @DATA(payt_desc) PRIVILEGED ACCESS.

      SELECT FROM zdt_salestm AS a
      INNER JOIN @it_header AS hdr ON a~customerid = hdr~soldtoparty
      FIELDS a~customerid ,  a~field , a~degination , a~rm , a~zm ,a~sales_head
      INTO TABLE @DATA(it_salesteam) PRIVILEGED ACCESS.

      " GATE ENTRY
*      SELECT FROM zgateentrylines AS a
*              INNER JOIN @it_header AS hdr ON a~documentno = hdr~ReferenceSDDocument
*              LEFT JOIN zgateentryheader AS ge ON ge~gateentryno = a~gateentryno
*           FIELDS ge~gateentryno, ge~vehrepdate, ge~vehreptime, ge~gateindate, ge~gateintime, ge~lrno, ge~lrdate, ge~grosswt, ge~tarewt, ge~netwt,
*                  ge~gateoutdate, ge~gateouttime,
*                  a~documentno
*               INTO TABLE @DATA(gate_entry).


    ENDIF.
    DATA: lv_refsddoc TYPE vgbel.

********************************************************** LOOP's
    DATA: lv_last_invoice TYPE vbeln.
    DATA: lv_invoice_amt TYPE p LENGTH 15 DECIMALS 2.
    LOOP AT it_header INTO DATA(wa).

      lv_refsddoc = wa-referencesddocument.
      SHIFT lv_refsddoc LEFT DELETING LEADING '0'.

      SELECT SINGLE FROM zgateentryheader AS ge
      LEFT JOIN zgateentrylines AS a ON ge~gateentryno = a~gateentryno
      FIELDS ge~gateentryno, ge~vehrepdate, ge~vehreptime, ge~gateindate, ge~gateintime, ge~lrno, ge~lrdate, ge~grosswt, ge~tarewt, ge~netwt,
                    ge~gateoutdate, ge~gateouttime,
                    a~documentno
                    WHERE a~documentno = @lv_refsddoc
                    INTO @DATA(gate_entry).
      SELECT SINGLE FROM zgatepassheader  AS gp
      LEFT JOIN zgatepasslineitm  AS gi  ON gp~gate_pass  = gi~gate_pass
      FIELDS gi~document_no, gp~out_date , gp~out_time , gp~gate_pass
      WHERE gi~document_no  = @wa-referencesddocument
      INTO @DATA(gate_out).

      IF wa-billingdocumenttype = 'F2' OR wa-billingdocumenttype = 'JSTO' OR wa-billingdocumenttype = 'L2'
                                       OR wa-billingdocumenttype = 'S2' OR wa-billingdocumenttype = 'F8'.
        amountsign = 1.
      ELSE.
        amountsign = -1.
      ENDIF.


      READ TABLE it_billtext INTO DATA(wa_billtext) WITH KEY billingdocumenttype = wa-billingdocumenttype.
*      ls_response-InvoiceDocumentTypeDes = wa_billtext-BillingDocumentTypeName.
      IF sy-subrc = 0.
        ls_response-invoicedocumenttypedes = wa_billtext-billingdocumenttypename.
      ENDIF.

      READ TABLE it_salestext INTO DATA(wa_salestext) WITH KEY salesorganization = wa-salesorganization.
      ls_response-salesorganizationname = wa_salestext-salesorganizationname.

      READ TABLE it_distributiontext INTO DATA(wa_distributiontext) WITH KEY distributionchannel = wa-distributionchannel.
      ls_response-distributionchannelname = wa_distributiontext-distributionchannelname.

      READ TABLE it_divisiontext INTO DATA(wa_divisiontext) WITH KEY division = wa-product_division.
      ls_response-salesdivisionname = wa_divisiontext-divisionname.

      READ TABLE it_sold_address INTO DATA(wa_sold_address) WITH KEY addressid = wa-addressid.
      DATA : sold_to_address TYPE string.
      CONCATENATE wa_sold_address-housenumber wa_sold_address-streetname wa_sold_address-streetprefixname1 wa_sold_address-streetprefixname2
                  wa_sold_address-streetsuffixname1 wa_sold_address-streetsuffixname2 wa_sold_address-cityname
                      INTO sold_to_address.
      ls_response-soldtopartyaddress = sold_to_address.
      ls_response-soldtopartycity  = wa_sold_address-cityname.
      ls_response-soldtopartystate = wa_sold_address-regionname.
      ls_response-soldtopartypincode = wa_sold_address-postalcode.
      ls_response-soldtocustomercode = wa-soldtoparty .
      ls_response-soldtocustomername = wa-businesspartnername.
      ls_response-soldtocustomergstinno = wa-taxnumber3.

      READ TABLE it_bill_address INTO DATA(wa_bill_address) WITH KEY addressid = wa-addressid1.
      DATA: bill_to_address TYPE string.
      CONCATENATE wa_bill_address-housenumber wa_bill_address-streetname wa_bill_address-streetprefixname1
               wa_bill_address-streetprefixname2 wa_bill_address-streetsuffixname1
               wa_bill_address-streetsuffixname2 wa_bill_address-cityname
               INTO bill_to_address.
      ls_response-billtopartyaddress = bill_to_address.
      ls_response-billtopartystate = wa_bill_address-regionname.
      ls_response-billtopartycity = wa_bill_address-cityname.
      ls_response-billtopartypincode = wa_bill_address-postalcode.
*      ls_response-BillToPartyCode = wa-PayerParty.
      ls_response-billtopartycode = wa-customer.
      ls_response-billtopartyname = wa-businesspartnername2.
      """"""""""""""
      READ TABLE it_customer_address_details INTO DATA(wa_customer_address) WITH KEY addressid = wa-addressid.
      DATA : customer_address_details TYPE string.
      CONCATENATE  wa_customer_address-streetname wa_customer_address-streetprefixname1 wa_sold_address-streetprefixname2
                  wa_customer_address-cityname   wa_customer_address-postalcode   wa_customer_address-regionname
                      INTO customer_address_details.
      ls_response-customer_state_code  = customer_address_details.
      """""""""""""""""""""
      READ TABLE bill_to_party_country INTO DATA(wa_bill_to_party_country) WITH KEY addressid = wa-addressid1.
      ls_response-billtopartycountry = wa_bill_to_party_country-country.

      READ TABLE stnd_cost_unit INTO DATA(wa_stnd_cost_unit) WITH KEY billingdocument = wa-billingdocument billingdocumentitem = wa-billingdocumentitem.
      ls_response-standardcostperunit = wa_stnd_cost_unit-conditionratevalue.

      READ TABLE ship_to_cust INTO DATA(wa_ship_to_cust) WITH KEY deliverydocument = wa-referencesddocument.
      ls_response-deliveryorderdate = wa_ship_to_cust-deliverydate.
      ls_response-actualgidate = wa_ship_to_cust-actualgoodsmovementdate.
      ls_response-shiptocustomercode = wa_ship_to_cust-shiptoparty.
      " ls_response-billoflading = wa_ship_to_cust-billoflading.
      """"""changes
      READ TABLE dlvry_item INTO DATA(wa_dlvry_item)
       WITH KEY deliverydocument = wa-referencesddocument
       deliverydocumentitem  = wa-referencesddocumentitem.
      ls_response-ponumber = wa_dlvry_item-referencesddocument.
      ls_response-podate = wa_dlvry_item-creationdate.

      IF ls_response-dispatchingplant IS INITIAL.
        SELECT SINGLE FROM i_salesdocumentitem AS a
        FIELDS a~plant
        WHERE a~salesdocument = @wa-referencesddocument AND a~salesdocumentitem = @wa-referencesddocumentitem
        INTO @DATA(wa_dispplant).
        ls_response-dispatchingplant = wa_dispplant.
      ENDIF.

      ls_response-dispatchingplant = wa-bill_doc_plant.
      ls_response-dispatchingplantname = wa-plantname.
*      ls_response-ReceivingPlant = wa_dlvry_item-IssuingOrReceivingPlant.
      ls_response-storagelocation = wa_dlvry_item-storagelocation.
      ls_response-storagelocationdescription = wa_dlvry_item-storagelocationname.
      ls_response-deliveryquantity = wa_dlvry_item-actualdeliveryquantity.
      ls_response-uomdeliveryqty = wa_dlvry_item-unitofmeasure_e.
      ls_response-batch  = wa_dlvry_item-batch.
      ls_response-dlvrygrossweightwithpackaging  = wa_dlvry_item-itemgrossweight.
      ls_response-deliverynetoilweight = wa_dlvry_item-itemnetweight.
      ls_response-deliveryweightuom = wa_dlvry_item-itemweightunit.
      ls_response-salesorderno = wa_dlvry_item-referencesddocument.
      ls_response-salesorderdate = wa_dlvry_item-salesorderdate.
      ""    ls_response-yy1_remarks_bd_bdh = wa-YY1_Remarks_bd_BDH.


      "=== Add logic sales order type ===
      SELECT SINGLE
      FROM i_billingdocumentitem AS a
      LEFT JOIN i_deliverydocumentitem AS b ON a~referencesddocument = b~deliverydocument AND a~referencesddocumentitem = b~deliverydocumentitem
      LEFT JOIN i_salesdocumentitem AS c ON b~referencesddocument = c~salesdocument  AND b~referencesddocumentitem = c~salesdocumentitem
      FIELDS
      c~salesdocumenttype
      WHERE a~billingdocument = @wa-billingdocument AND a~billingdocumentitem = @wa-billingdocumentitem
      INTO @DATA(lv_sel_otype) PRIVILEGED ACCESS.
      ls_response-salesorder_type =  lv_sel_otype. "wa_dlvry_item-SalesDocumentType.   "  wa_dlvry_item-SalesOrderType.

      " If SalesOrderType is INITIAL, fetch from BillingDocumentItem
      IF ls_response-salesorder_type IS INITIAL.
        SELECT SINGLE
          FROM i_billingdocumentitem AS a
          LEFT JOIN i_salesdocumentitem AS b ON a~referencesddocument = b~salesdocument AND a~referencesddocumentitem = b~salesdocumentitem
          FIELDS
          b~salesdocumenttype
          WHERE a~billingdocument = @wa-billingdocument AND a~billingdocumentitem = @wa-billingdocumentitem
          INTO @ls_response-salesorder_type.
      ENDIF.

      IF ls_response-salesorder_type = 'TA'.
        ls_response-salesorder_type = 'OR'.
      ENDIF.

*      IF ls_response-SalesOrder_Type IS INITIAL.
*        SELECT SINGLE SalesDocumentType
*          FROM I_SalesDocument
*          WHERE SalesDocument = @wa-ReferenceSDDocument
*          INTO @ls_response-SalesOrder_Type.
*      ENDIF.
      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      ls_response-customerpono = wa_dlvry_item-purchaseorderbycustomer.
      ls_response-customerpodate = wa_dlvry_item-customerpurchaseorderdate.
      ls_response-contactpersoncode  = wa_dlvry_item-contactpersoncode.
      ls_response-contactpersonname  = wa_dlvry_item-contactpersonname.
      ls_response-salesemployeecode = wa_dlvry_item-salesemployeecode.
      ls_response-salesemployeename = wa_dlvry_item-salesemployeename.
      ls_response-brokercode = wa_dlvry_item-brokercode.
      ls_response-brokername = wa_dlvry_item-brokername.
      ls_response-orderreason  = wa_dlvry_item-sddocumentreason.
      ls_response-customergroup  = wa_dlvry_item-customergroup.
      ls_response-salescontractno  = wa_dlvry_item-refersddoc_so.
      ls_response-salescontractdate  = wa_dlvry_item-salescontractdate.
      ls_response-salescontractvalidfromdate  = wa_dlvry_item-salescontractvaliditystartdate.
      ls_response-salescontractvalidtodate  = wa_dlvry_item-salescontractvalidityenddate.
      ls_response-salescontract_type  = wa_dlvry_item-salescontracttype.

      READ TABLE order_type_text INTO DATA(wa_order_type_text) WITH KEY salesdocumenttype = wa_dlvry_item-salesordertype.
      ls_response-salesordertypedesc =  wa_order_type_text-salesdocumenttypename.

      "=== Add Sales order tyep desc ===
*      SELECT SINGLE
*      FROM i_billingdocumentitem AS a
*      LEFT JOIN i_deliverydocumentitem AS b ON a~referencesddocument = b~deliverydocument AND a~referencesddocumentitem = b~deliverydocumentitem
*      LEFT JOIN i_salesdocumentitem AS c ON b~referencesddocument = c~salesdocument AND b~referencesddocumentitem = c~salesdocumentitem
*      LEFT JOIN i_ordertypetext AS d ON c~salesdocumenttype = d~ordertype
*      FIELDS
*      d~ordertypename
*      WHERE a~billingdocument = @wa-billingdocument AND a~billingdocumentitem = @wa-billingdocumentitem
*      INTO @DATA(lv_sel_otype_desc) PRIVILEGED ACCESS.
*      ls_response-salesordertypedesc = lv_sel_otype_desc.

*      IF ls_response-salesordertypedesc IS INITIAL.
*        SELECT SINGLE
*        FROM i_billingdocumentitem AS a
*        LEFT JOIN i_salesdocumentitem AS b ON a~referencesddocument = b~salesdocument AND a~referencesddocumentitem = b~salesdocumentitem
*        LEFT JOIN i_ordertypetext AS c ON b~salesdocumenttype = c~ordertype
*
*        FIELDS
*        c~ordertypename
*        WHERE a~billingdocument = @wa-billingdocument AND a~billingdocumentitem = @wa-billingdocumentitem
*        INTO @ls_response-salesordertypedesc.
*
*      ENDIF.

      "=== end ===

      READ TABLE ord_reason_desc INTO DATA(wa_ord_reason_desc) WITH KEY sddocumentreason = wa_dlvry_item-sddocumentreason.
      ls_response-orderreasondescription  = wa_ord_reason_desc-sddocumentreasontext.

      READ TABLE ship_to_cust_name INTO DATA(wa_ship_to_cust_name) WITH KEY businesspartner = wa-shiptoparty.
      ls_response-shiptocustomername = wa_ship_to_cust_name-businesspartnerfullname.

      READ TABLE ship_to_prty_addrs INTO DATA(wa_ship_to_prty_addrs) WITH KEY customer = wa-shiptoparty.
      DATA : ship_to_part_address TYPE string.
      CONCATENATE wa_ship_to_prty_addrs-housenumber wa_ship_to_prty_addrs-streetname wa_ship_to_prty_addrs-streetprefixname1
                  wa_ship_to_prty_addrs-streetprefixname2 wa_ship_to_prty_addrs-streetsuffixname1 wa_ship_to_prty_addrs-streetsuffixname2
                  INTO ship_to_part_address.
      ls_response-shiptopartyaddress = ship_to_part_address.
      ls_response-shiptopartycity = wa_ship_to_prty_addrs-cityname.
      ls_response-shiptopartystate = wa_ship_to_prty_addrs-regionname.
      ls_response-shiptopartycountry = wa_ship_to_prty_addrs-country.
      ls_response-soldtopartycountry = wa_ship_to_prty_addrs-country.
      ls_response-shiptopartypincode = wa_ship_to_prty_addrs-postalcode.

      READ TABLE mat_type_desc INTO DATA(wa_mat_type_desc) WITH KEY producttype = wa-producttype.
      ls_response-materialtypedescription = wa_mat_type_desc-materialtypename.


*      READ TABLE gate_entry INTO DATA(wa_gate_entry) WITH KEY documentno = wa-ReferenceSDDocument.
      ls_response-tokennumber = gate_entry-gateentryno.
      ls_response-tokendatetime = |{ gate_entry-gateindate DATE = ISO } { gate_entry-gateintime TIME = ISO }|.
      ls_response-gateentrynumber = gate_entry-gateentryno.
      ls_response-gateentrydatetime = |{ gate_entry-gateindate DATE = ISO } { gate_entry-gateintime TIME = ISO }|.
      ls_response-lrno = gate_entry-lrno.
      ls_response-lrdate = gate_entry-lrdate.
      ls_response-weighbridgegrossweight = gate_entry-grosswt.
      ls_response-weighbridgetareweight = gate_entry-tarewt.
      ls_response-weighbridgenetweight = gate_entry-netwt.
      "  ls_response-gateentrynumber = gate_entry-gateentryno.
      IF ls_response-gateoutnumber IS INITIAL.
        ls_response-gateoutnumber = gate_out-gate_pass.
      ENDIF.

      " ls_response-gateentrydatetime = |{ gate_entry-gateoutdate DATE = ISO } { gate_entry-gateouttime TIME = ISO }|.
      IF ls_response-gateoutdatetime  IS INITIAL.
        ls_response-gateoutdatetime = |{ gate_out-out_date DATE = ISO } { gate_out-out_time TIME = ISO }|.
      ENDIF.

      READ TABLE sales_dist INTO DATA(wa_sales_dist) WITH KEY salesdistrict = wa_dlvry_item-salesdistrict.
      ls_response-salesdistrict = wa_sales_dist-salesdistrictname.

      READ TABLE payt_desc INTO DATA(wa_payt_desc) WITH KEY paymentterms = wa-customerpaymentterms.
      ls_response-description = wa_payt_desc-paymenttermsdescription.

      READ TABLE it_salesteam INTO DATA(wa_salesteam) WITH KEY customerid = wa-soldtoparty.
      ls_response-field = wa_salesteam-field.
      ls_response-desgination = wa_salesteam-degination.
      ls_response-rm = wa_salesteam-rm.
      ls_response-zm = wa_salesteam-zm.
      ls_response-sales_head = wa_salesteam-sales_head.

      """""""""gl account
      READ TABLE  it_accounting   INTO DATA(wa_accounting)   WITH KEY  accountingdocument  = wa-accountingdocument
                                                                        companycode   = wa-companycode
                                                                        fiscalyear  = wa-fiscalyear .
      ls_response-glaccount  = wa_accounting-glaccount.
      ls_response-glaccountname  = wa_accounting-glaccountname.

***********************************************************  SALES GROUP & ORDER
      SELECT SINGLE FROM i_billingdocument AS a
      LEFT JOIN i_billingdocumentitem  AS b ON a~billingdocument = b~billingdocument
      LEFT JOIN i_deliverydocumentitem  AS c ON b~referencesddocument = c~deliverydocument AND b~referencesddocumentitem = c~deliverydocumentitem
      LEFT JOIN i_salesorderitem       AS d ON c~referencesddocument = d~salesorder AND c~referencesddocumentitem = d~salesorderitem
      LEFT JOIN i_salescontract        AS e ON d~referencesddocument = e~salescontract
      FIELDS e~salesoffice, e~salesgroup
         WHERE a~billingdocument = @wa-billingdocument
         INTO @DATA(sales_data).

      IF sales_data IS NOT INITIAL.
        ls_response-salesoffice = sales_data-salesoffice.
        ls_response-salesgroup = sales_data-salesgroup.
      ELSE.
        ls_response-salesoffice = wa_dlvry_item-salesoffice.      " wa-SalesOffice.
        ls_response-salesgroup = wa_dlvry_item-salesgroup.       " wa-SalesGroup.
      ENDIF.

      READ TABLE it_salesofctext INTO DATA(wa_salesofctext) WITH KEY salesoffice = ls_response-salesoffice.
      IF wa_salesofctext IS NOT INITIAL.
        ls_response-salesofficename = wa_salesofctext-salesofficename.
      ENDIF.

      READ TABLE it_salesgrptext INTO DATA(wa_salesgrptext) WITH KEY salesgroup = ls_response-salesgroup.
      IF wa_salesgrptext IS NOT INITIAL.
        ls_response-salesgroupname = wa_salesgrptext-salesgroupname.
      ENDIF.

      ls_response-salesinvoiceqtyuom = wa-unitofmeasure_e.
      ls_response-invoiceno = wa-billingdocument.
      ls_response-itemno = wa-billingdocumentitem.
      ls_response-invoicetype = wa-billingdocumenttype.
      ls_response-invoicedate = wa-billingdocumentdate.
      ls_response-referenceinvoiceno = wa-documentreferenceid.
      ls_response-refinvoicedate = wa-billingdocumentdate.
      ls_response-accountingdocno = wa-accountingdocument.
      IF ls_response-customerpono IS INITIAL.
        ls_response-customerpono = wa-purchaseorderbycustomer.
      ENDIF.
      IF ls_response-customerpodate  IS INITIAL.
        ls_response-customerpodate  = wa-customerpurchaseorderdate.
      ENDIF.
      ls_response-salesorganization = wa-salesorganization.
      ls_response-distributionchannel = wa-distributionchannel.
      ls_response-salesdivision = wa-product_division.
      ls_response-paymenttermcode = wa-customerpaymentterms.
      ls_response-againstinvoicedate = wa-billingdocumentdate.
      ls_response-created_by = wa-createdbyuser.
      ls_response-itemcode = wa-product.
      SHIFT ls_response-itemcode LEFT DELETING LEADING '0'.
      ls_response-itemdescription = wa-billingdocumentitemtext.
      ls_response-materialgroupcode = wa-productgroup.
      ls_response-hsncode = wa-consumptiontaxctrlcode.
      ls_response-materialtypecode = wa-producttype.
      ls_response-salesinvoicequantity = wa-billingquantity.
      ls_response-salesinvoicegrossweight = wa-itemgrossweight.
      ls_response-salesinvoicenetweight = wa-itemnetweight.
      ls_response-salesinvoiceweightuom = wa-itemweightunit.
      ls_response-salesinvoicetaxableamount = wa-netamount.
      ls_response-taxamount = wa-taxamount.
      ls_response-documentcurrency = wa-transactioncurrency.
      ls_response-incoterms = wa-incotermsclassification.
      ls_response-incotermslocation = wa-incotermslocation1.

      ls_response-cancellationindicator = wa-billingdocumentiscancelled.
      ls_response-exchange_rate  = wa-accountingexchangerate.

      IF ls_response-cancellationindicator EQ 'X'.
        SELECT SINGLE FROM i_billingdocument AS a
        FIELDS a~billingdocument
        WHERE a~cancelledbillingdocument = @ls_response-invoiceno
        INTO @ls_response-cancellationinvoicenumber.
      ELSE.
        ls_response-cancellationinvoicenumber = ''.
      ENDIF.

      ls_response-outbounddeliverynumber = wa-referencesddocument.
      ls_response-deliveryorderdate = wa-deliverydate.
      ls_response-actualgidate = wa-actualgoodsmovementdate.
      ls_response-shiptocustomercode = wa-shiptoparty.
      ls_response-shippingpoint = wa-shippingpoint.
      ls_response-againstinvoicenumber = wa-assignmentreference.
      ls_response-profit_center  = wa-profitcenter.


      SELECT SINGLE FROM ztable_plant AS a
      FIELDS a~plant_code , a~businessplace
      WHERE a~plant_code = @wa-bill_doc_plant
      INTO @DATA(wa_businessplace).

      ls_response-businessplace = wa_businessplace-businessplace.

      ls_response-matgroupcodedescription = wa-productgroupname.
      ls_response-billtopartygstin = wa-taxnumber31.

      LOOP AT it_price INTO DATA(wa_condition) WHERE billingdocument = wa-billingdocument
                                                      AND billingdocumentitem = wa-billingdocumentitem.
        CASE wa_condition-conditiontype.
          WHEN 'ZPR0'.
            ls_response-salesinvoiceunitprice = wa_condition-conditionratevalue.


          WHEN 'ZPR1'.
            ls_response-salesinvoiceunitprice = wa_condition-conditionratevalue.

          WHEN 'ZPEX'.
            ls_response-salesinvoiceunitprice = wa_condition-conditionratevalue.


*          WHEN 'D100' OR 'ZRAB'.
*            ls_response-freegoodsdiscount = wa_condition-conditionamount.

          WHEN 'ZMRP' .
            lv_condition_zmrp = wa_condition-conditionamount.

          WHEN 'ZBP0' .
            lv_condition_zbpo = wa_condition-conditionamount.

          WHEN 'ZHF1' OR 'ZIF1'.
            ls_response-freightamount = wa_condition-conditionamount.

          WHEN 'ZHP1'.
            ls_response-packingamount = wa_condition-conditionamount.

          WHEN 'ZHI1'.
            ls_response-insuranceamount = wa_condition-conditionamount.

          WHEN 'ZDIS'.
            ls_response-discountpercent = wa_condition-conditionratevalue.
            ls_response-discountamount = wa_condition-conditionamount.

*          WHEN 'ZBK1'.
*            ls_response-brokeramount = wa_condition-conditionamount.

          WHEN 'ZCA1'.
            ls_response-commissionagentamount = wa_condition-conditionamount.

          WHEN 'JOCG'.
            ls_response-cgstamount = wa_condition-conditionamount.
            ls_response-cgstpercentage = wa_condition-conditionratevalue.

          WHEN 'JOSG'.
            ls_response-sgstamount = wa_condition-conditionamount.
            ls_response-sgstpercentage = wa_condition-conditionratevalue.

          WHEN 'JOIG'.
            ls_response-igstamount = wa_condition-conditionamount.
            ls_response-igstpercentage = wa_condition-conditionratevalue.

          WHEN 'ZOIG'.
            ls_response-zoigamount = wa_condition-conditionamount.
            ls_response-zoigpercentage = wa_condition-conditionratevalue.

          WHEN 'JOUG'.
            ls_response-ugstamount = wa_condition-conditionamount.
            ls_response-ugstpercentage = wa_condition-conditionratevalue.

          WHEN 'JTC2'.
            ls_response-tcsamount = wa_condition-conditionamount.
            ls_response-tcspercentage = wa_condition-conditionratevalue.
          WHEN 'ZDIF'.
            ls_response-roundoff = wa_condition-conditionamount.
        ENDCASE.
      ENDLOOP.

      ls_response-invoiceamount = wa-netamount + ls_response-taxamount.   " + ls_response-RoundOff .
      "  lv_invoice_amt  = wa-netamount + ls_response-taxamount.
************************************************************************* HIDDEN FIELDS ...
      ls_response-pricingprocedurestep = wa_stnd_cost_unit-pricingprocedurestep.
      ls_response-pricingprocedurecounter = wa_stnd_cost_unit-pricingprocedurecounter.
      ls_response-plant = wa-plant.
      ls_response-product = wa-plantproduct.
      ls_response-salesorder = wa_dlvry_item-salesorder.
      IF wa_dlvry_item-salesordertype = 'TA'.
        ls_response-salesordertype = 'OR'.
      ELSE.
        ls_response-salesordertype = wa_dlvry_item-salesordertype.
      ENDIF.
      ls_response-salescontract = wa_dlvry_item-salescontract.
      ls_response-salescontracttype = wa_dlvry_item-salescontracttype.
      ls_response-billingdocument = wa-billdoc_bdp.
      ls_response-customer = wa_ship_to_prty_addrs-customer.


******************************************* Negative Fields
      "  ls_response-freegoodsdiscount = amountsign * ls_response-freegoodsdiscount.
      ls_response-freightamount = amountsign * ls_response-freightamount.
      ls_response-packingamount = amountsign * ls_response-packingamount.
      ls_response-insuranceamount = amountsign * ls_response-insuranceamount .
      "  ls_response-brokeramount = amountsign * ls_response-brokeramount.
      ls_response-commissionagentamount = amountsign * ls_response-commissionagentamount.
      ls_response-cgstamount = amountsign * ls_response-cgstamount.
      ls_response-sgstamount = amountsign * ls_response-sgstamount.
      ls_response-igstamount = amountsign * ls_response-igstamount.
      ls_response-ugstamount = amountsign * ls_response-ugstamount.
      ls_response-tcsamount = amountsign * ls_response-tcsamount.
      ls_response-roundoff = amountsign * ls_response-roundoff.
      ls_response-salesinvoicetaxableamount = amountsign * ls_response-salesinvoicetaxableamount.
      ls_response-taxamount = amountsign * ls_response-taxamount.
      ls_response-salesinvoicegrossweight = amountsign * ls_response-salesinvoicegrossweight.
      ls_response-salesinvoicenetweight = amountsign * ls_response-salesinvoicenetweight.
      ls_response-salesinvoicequantity = amountsign * ls_response-salesinvoicequantity.
      ls_response-invoiceamount = amountsign * ls_response-invoiceamount.
      lv_invoice_amt  = amountsign * ls_response-invoiceamount.
*      IF lv_last_invoice = wa-billingdocument.
*
*        CLEAR ls_response-invoiceamount.
*        CLEAR ls_response-gross_bill_num.
*
*      ELSE.
*
*        ls_response-invoiceamount = lv_invoice_amt.
*        ls_response-gross_bill_num = lv_invoice_amt.
*
*        lv_last_invoice = wa-billingdocument.
*
*      ENDIF.
      ls_response-deliverynetoilweight = amountsign * ls_response-deliverynetoilweight.
      ls_response-dlvrygrossweightwithpackaging = amountsign * ls_response-dlvrygrossweightwithpackaging.
      ls_response-weighbridgegrossweight = amountsign * ls_response-weighbridgegrossweight.
      ls_response-weighbridgetareweight = amountsign * ls_response-weighbridgetareweight.
      ls_response-weighbridgenetweight = amountsign * ls_response-weighbridgenetweight.
      ls_response-deliveryquantity = amountsign * ls_response-deliveryquantity.
      ls_response-gross_bill_num  =   ls_response-invoiceamount .
      ls_response-invoice_value_forex = ls_response-invoiceamount.
      ls_response-invoice_value_inr   = ls_response-invoiceamount * wa-accountingexchangerate.
      ls_response-gross_value_forex = ls_response-gross_bill_num.
      ls_response-gross_value_inr   = ls_response-gross_bill_num * wa-accountingexchangerate.


******************************************** CONDITION
      IF wa-billingdocumenttype = 'JSTO' OR wa-billingdocumenttype = 'F8'.
        ls_response-cgstamount = 0.
        ls_response-cgstpercentage = 0.
        ls_response-sgstamount = 0.
        ls_response-sgstpercentage = 0.
      ENDIF.

      APPEND ls_response TO lt_response.
      MODIFY zsales_reg_tb FROM @ls_response.
      CLEAR ls_response.
      CLEAR: wa_billtext, wa_salestext, wa_distributiontext, wa_divisiontext, wa_salesgrptext, wa_salesofctext,
          wa_sold_address, wa_bill_address, wa_stnd_cost_unit, wa_ship_to_cust, wa_dlvry_item, wa_ord_reason_desc, wa_order_type_text,
          wa_ship_to_cust_name, wa_ship_to_prty_addrs, wa_mat_type_desc, sales_data  , wa_bill_to_party_country.

    ENDLOOP.
    CLEAR: lt_response.



************************************************** IRN & E-WAY BILL **************************************

    DATA: lt_irn TYPE TABLE OF ztable_irn,
          ls_irn TYPE ztable_irn.

    DATA: lt_sales TYPE TABLE OF zsales_reg_tb,
          ls_sales TYPE zsales_reg_tb.

    SELECT  FROM zsales_reg_tb
    FIELDS invoiceno , itemno , ewaybillnumber ,irnacknumber , ewaybilldatetime , transportername ,
           modeoftransport , vehiclenumber , transportercode
    WHERE ewaybillnumber IS INITIAL
    OR irnacknumber IS INITIAL
    AND invoicedate >= @maxbillingdate
    INTO CORRESPONDING FIELDS OF TABLE @lt_sales
    PRIVILEGED ACCESS.

    SELECT FROM ztable_irn AS irn
    INNER JOIN @lt_sales AS s ON irn~billingdocument = s~invoiceno
    FIELDS irn~billingdocument , irn~ewaybillno , irn~ackno , irn~ewaydate , irn~transportername ,
           irn~transportmode , irn~vehiclenum , irn~transportergstin
    INTO CORRESPONDING FIELDS OF TABLE @lt_irn
    PRIVILEGED ACCESS.

    LOOP AT lt_sales INTO ls_sales.
      READ TABLE lt_irn INTO ls_irn WITH KEY billingdocument = ls_sales-invoiceno.
      IF sy-subrc = 0.

        UPDATE zsales_reg_tb
        SET ewaybillnumber = @ls_irn-ewaybillno,
        irnacknumber = @ls_irn-ackno,
        ewaybilldatetime = @ls_irn-ewaydate,
        transportername = @ls_irn-transportername,
        modeoftransport = @ls_irn-transportmode,
        vehiclenumber = @ls_irn-vehiclenum,
        transportercode = @ls_irn-transportergstin
        WHERE invoiceno = @ls_sales-invoiceno.
      ENDIF.

    ENDLOOP.
    COMMIT WORK.

*********************************update cancelled invoice*************************************

    SELECT FROM i_billingdocument AS a
    FIELDS a~billingdocument , a~cancelledbillingdocument
    WHERE a~cancelledbillingdocument IS NOT INITIAL
    AND a~billingdocumentdate >= @maxbillingdate
    INTO TABLE @DATA(lt_cancelbill)
    PRIVILEGED ACCESS.

    SELECT FROM zsales_reg_tb AS a
    INNER JOIN @lt_cancelbill AS b ON a~invoiceno = b~cancelledbillingdocument
    FIELDS a~invoiceno , a~cancellationinvoicenumber , a~cancellationindicator
    WHERE  a~invoicedate >= @maxbillingdate
    AND a~cancellationinvoicenumber IS INITIAL
    INTO TABLE @DATA(lt_cancel)
    PRIVILEGED ACCESS.

    LOOP AT lt_cancel ASSIGNING FIELD-SYMBOL(<ls_cancel>).
      READ TABLE lt_cancelbill ASSIGNING FIELD-SYMBOL(<ls_cancelbill>) WITH KEY cancelledbillingdocument = <ls_cancel>-invoiceno.
      IF sy-subrc = 0.
        UPDATE zsales_reg_tb
          SET cancellationinvoicenumber = @<ls_cancelbill>-billingdocument,
          cancellationindicator = 'X'
        WHERE invoiceno = @<ls_cancel>-invoiceno.
      ENDIF.
      CLEAR : <ls_cancelbill> , <ls_cancel>.
    ENDLOOP.

    COMMIT WORK.

******************************* NEGATIVE VALUE FOR CANCELLED INVOICE*****************************


    DATA: lt_canceldata TYPE TABLE OF zsales_reg_tb,
          ls_canceldata TYPE zsales_reg_tb.

    SELECT *
    FROM zsales_reg_tb AS a
    WHERE a~cancellationindicator = 'X'
      AND a~cancellationinvoicenumber IS NOT INITIAL
      AND a~salesinvoicequantity >= 0
      AND a~invoicedate >= @maxbillingdate
    INTO TABLE @lt_canceldata
    PRIVILEGED ACCESS.


    DATA : lv_negative TYPE int2.
    lv_negative = -1.


    LOOP AT lt_canceldata INTO ls_canceldata.

      ls_canceldata-salesinvoicequantity           = lv_negative * ls_canceldata-salesinvoicequantity.
      ls_canceldata-salesinvoicegrossweight        = lv_negative * ls_canceldata-salesinvoicegrossweight.
      ls_canceldata-salesinvoicenetweight          = lv_negative * ls_canceldata-salesinvoicenetweight.
      ls_canceldata-salesinvoiceunitprice          = lv_negative * ls_canceldata-salesinvoiceunitprice.
      ls_canceldata-salesinvoicetaxableamount      = lv_negative * ls_canceldata-salesinvoicetaxableamount.
      ls_canceldata-freightamount                  = lv_negative * ls_canceldata-freightamount.
      ls_canceldata-packingamount                  = lv_negative * ls_canceldata-packingamount.
      ls_canceldata-insuranceamount                = lv_negative * ls_canceldata-insuranceamount.
      ls_canceldata-commissionagentamount          = lv_negative * ls_canceldata-commissionagentamount.
      ls_canceldata-cgstpercentage                 = lv_negative * ls_canceldata-cgstpercentage.
      ls_canceldata-cgstamount                     = lv_negative * ls_canceldata-cgstamount.
      ls_canceldata-sgstpercentage                 = lv_negative * ls_canceldata-sgstpercentage.
      ls_canceldata-sgstamount                     = lv_negative * ls_canceldata-sgstamount.
      ls_canceldata-igstpercentage                 = lv_negative * ls_canceldata-igstpercentage.
      ls_canceldata-igstamount                     = lv_negative * ls_canceldata-igstamount.
      ls_canceldata-zoigpercentage                 = lv_negative * ls_canceldata-zoigpercentage.
      ls_canceldata-zoigamount                     = lv_negative * ls_canceldata-zoigamount.
      ls_canceldata-tcspercentage                  = lv_negative * ls_canceldata-tcspercentage.
      ls_canceldata-tcsamount                      = lv_negative * ls_canceldata-tcsamount.
      ls_canceldata-discountpercent                = lv_negative * ls_canceldata-discountpercent.
      ls_canceldata-discountamount                 =  lv_negative * ls_canceldata-discountamount.
      ls_canceldata-taxamount                      = lv_negative * ls_canceldata-taxamount.
      ls_canceldata-roundoff                       = lv_negative * ls_canceldata-roundoff.
      ls_canceldata-invoiceamount                  = lv_negative * ls_canceldata-invoiceamount.
      ls_canceldata-gross_bill_num                 = lv_negative * ls_canceldata-gross_bill_num.
      ls_canceldata-invoice_value_forex    = lv_negative * ls_canceldata-invoice_value_forex.
      ls_canceldata-invoice_value_inr      = lv_negative * ls_canceldata-invoice_value_inr.
      ls_canceldata-gross_value_forex   = lv_negative * ls_canceldata-gross_value_forex.
      ls_canceldata-gross_value_inr    = lv_negative * ls_canceldata-gross_value_inr.

      ls_canceldata-deliveryquantity               = lv_negative * ls_canceldata-deliveryquantity.
      ls_canceldata-dlvrygrossweightwithpackaging  = lv_negative * ls_canceldata-dlvrygrossweightwithpackaging.
      ls_canceldata-weighbridgegrossweight         = lv_negative * ls_canceldata-weighbridgegrossweight.
      ls_canceldata-weighbridgetareweight          = lv_negative * ls_canceldata-weighbridgetareweight.
      ls_canceldata-weighbridgenetweight           = lv_negative * ls_canceldata-weighbridgenetweight.

      UPDATE zsales_reg_tb
        SET salesinvoicequantity           = @ls_canceldata-salesinvoicequantity,
            salesinvoicegrossweight        = @ls_canceldata-salesinvoicegrossweight,
            salesinvoicenetweight          = @ls_canceldata-salesinvoicenetweight,
            salesinvoiceunitprice          = @ls_canceldata-salesinvoiceunitprice,
            salesinvoicetaxableamount      = @ls_canceldata-salesinvoicetaxableamount,
            freightamount                  = @ls_canceldata-freightamount,
            packingamount                  = @ls_canceldata-packingamount,
            insuranceamount                = @ls_canceldata-insuranceamount,
            commissionagentamount          = @ls_canceldata-commissionagentamount,
            cgstpercentage                 = @ls_canceldata-cgstpercentage,
            cgstamount                     = @ls_canceldata-cgstamount,
            sgstpercentage                 = @ls_canceldata-sgstpercentage,
            sgstamount                     = @ls_canceldata-sgstamount,
            igstpercentage                 = @ls_canceldata-igstpercentage,
            igstamount                     = @ls_canceldata-igstamount,
            zoigpercentage                 = @ls_canceldata-zoigpercentage,
            zoigamount                     = @ls_canceldata-zoigamount,
            tcspercentage                  = @ls_canceldata-tcspercentage,
            tcsamount                      = @ls_canceldata-tcsamount,
            discountpercent                = @ls_canceldata-discountpercent,
            discountamount                 = @ls_canceldata-discountamount,
            taxamount                      = @ls_canceldata-taxamount,
            roundoff                       = @ls_canceldata-roundoff,
            invoiceamount                  = @ls_canceldata-invoiceamount,
            gross_bill_num                 = @ls_canceldata-gross_bill_num,
            invoice_value_forex  = @ls_canceldata-invoice_value_forex,
            invoice_value_inr  = @ls_canceldata-invoice_value_inr,
            gross_value_forex  = @ls_canceldata-gross_value_forex,
            gross_value_inr  = @ls_canceldata-gross_value_inr,
            deliveryquantity               = @ls_canceldata-deliveryquantity,
            dlvrygrossweightwithpackaging  = @ls_canceldata-dlvrygrossweightwithpackaging,
            weighbridgegrossweight         = @ls_canceldata-weighbridgegrossweight,
            weighbridgetareweight          = @ls_canceldata-weighbridgetareweight,
            weighbridgenetweight           = @ls_canceldata-weighbridgenetweight

        WHERE invoiceno = @ls_canceldata-invoiceno.

    ENDLOOP.

    COMMIT WORK.

  ENDMETHOD.
ENDCLASS.
