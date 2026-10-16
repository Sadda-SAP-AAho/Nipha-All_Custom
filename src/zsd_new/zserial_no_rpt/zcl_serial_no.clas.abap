CLASS zcl_serial_no DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SERIAL_NO IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).

      DATA: lt_response    TYPE TABLE OF zce_serial_no_report,
            ls_response    LIKE LINE OF lt_response,
            lt_responseout LIKE lt_response,
            ls_responseout LIKE LINE OF lt_responseout.
      DATA: lv_lastserial TYPE string,
            lv_result     TYPE string,
            lv_len        TYPE i,
            lv_offset     TYPE i,
            lv_mfr_year   TYPE string.

      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).



      " Handle Search
      DATA(lv_search_string) = io_request->get_search_expression( ).
      DATA: lv_search_clause TYPE string.
      IF lv_search_string IS NOT INITIAL.
        " Create WHERE condition for search
        lv_search_clause = |AND ( UPPER( a~MaintenanceOrder ) LIKE UPPER( '%{ lv_search_string }%' ) |.
        lv_search_clause = |{ lv_search_clause } OR UPPER( b~OperationDescription ) LIKE UPPER( '%{ lv_search_string }%' ) )|.
      ENDIF.


      TRY.
          DATA(lt_clause) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
          CLEAR lx_no_range.
      ENDTRY.

      DATA(lt_parameter) = io_request->get_parameters( ).
      DATA(lt_fields)    = io_request->get_requested_elements( ).
      DATA(lt_sort)      = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
          CLEAR lx_no_sel_option.
      ENDTRY.

      LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
        IF ls_filter_cond-name = 'BILLINGDOCUMENT'.
          DATA(lt_billingdocument) = ls_filter_cond-range[].
        ELSEIF ls_filter_cond-name = 'SALES_ORG'.
          DATA(lt_salesorg) = ls_filter_cond-range[].
        ELSEIF ls_filter_cond-name = 'CUSTOMER_CODE'.
          DATA(lt_customercode) = ls_filter_cond-range[].
        ELSEIF ls_filter_cond-name = 'INVOICE_DATE'.
          DATA(lt_invoicedate) = ls_filter_cond-range[].
        ELSEIF ls_filter_cond-name = 'PLANT'.
          DATA(lt_plant) = ls_filter_cond-range[].
        ELSEIF ls_filter_cond-name = 'DISTRIBUTION_CHANNEL'.
          DATA(lt_distch) = ls_filter_cond-range[].
        ENDIF.
      ENDLOOP.


      SELECT FROM i_billingdocument AS a
      LEFT JOIN i_billingdocumentitem AS b ON b~billingdocument =  a~billingdocument
      LEFT JOIN i_customergrouptext AS c ON c~customergroup = a~customergroup AND c~language EQ 'E'
      LEFT JOIN i_billingdocumentpartner AS d ON d~billingdocument = a~billingdocument AND d~partnerfunction EQ 'AG'
      LEFT JOIN i_customer AS e ON e~customer = d~customer
      LEFT JOIN i_salesdocumentitem AS f ON f~salesdocument = b~salesdocument AND f~salesdocumentitem = b~salesdocumentitem
      LEFT JOIN i_productdescription AS g ON g~product = f~product AND g~language EQ 'E'
      LEFT JOIN i_billingdocumentitem AS h ON  h~billingdocument =  a~billingdocument AND  h~referencesddocumentcategory = 'J'
      LEFT JOIN i_serialnumberdeliverydocument  AS i  ON h~referencesddocument  = i~deliverydocument  AND h~referencesddocumentitem  = i~deliverydocumentitem
      LEFT JOIN i_serialnumbermaterialdoc_2  AS j ON   i~serialnumber  = j~serialnumber
      LEFT JOIN i_materialdocumentitemtp  AS k ON j~materialdocument  = k~materialdocument  AND j~materialdocumentitem  = k~materialdocumentitem
      LEFT JOIN  i_serialnumberdeliverydocument  AS l ON b~referencesddocument  = l~deliverydocument  AND b~referencesddocumentitem = l~deliverydocumentitem
      LEFT JOIN zmnufctresermm AS m ON l~serialnumber = m~serial_no
      LEFT JOIN zdbmanusrspp AS o ON l~serialnumber = o~serialno
      LEFT JOIN i_customer AS p ON p~customer = a~soldtoparty
      LEFT JOIN i_productgrouptext_2 AS q ON q~productgroup = b~productgroup AND q~language EQ 'E'
*      LEFT JOIN i_product AS r ON r~product  = b~product
*      LEFT JOIN zdt_modelname AS s ON s~code = r~yy1_modelname_prd AND s~language EQ 'E'
      FIELDS a~billingdocument , a~salesorganization , a~customergroup , a~creationdate , a~documentreferenceid ,
             a~division ,a~distributionchannel,
             b~plant, b~billingdocumentitem , b~productgroup ,
             c~customergroupname,
             d~customer,
             e~customername ,
             f~product ,
             g~productdescription,
             k~yy1_mfrserialno_mmi,
             l~serialnumber ,
             m~mfr_serialno,
             o~serialno AS pp_sernum ,  o~place , o~model , o~make , o~yers , o~machineno , o~state,
             p~region,
             q~productgroupname
*             s~description
      WHERE a~billingdocument IN @lt_billingdocument
      AND a~salesorganization IN @lt_salesorg
      AND d~customer IN @lt_customercode
      AND a~creationdate IN @lt_invoicedate
      AND b~plant IN @lt_plant
      AND a~distributionchannel IN @lt_distch
      INTO TABLE @DATA(it_data)
      PRIVILEGED ACCESS.

      SELECT FROM i_billingdocument AS a
      LEFT JOIN i_billingdocumentpartner AS b ON b~billingdocument = a~billingdocument AND b~partnerfunction EQ 'AG'
      LEFT JOIN i_customer AS c ON c~customer = b~customer
      LEFT JOIN i_address_2 AS d ON d~addressid = c~addressid
      LEFT JOIN i_regiontext AS e ON e~region = d~region AND e~language EQ 'E' AND e~country EQ 'IN'
      LEFT JOIN i_countrytext AS f ON f~country = d~country AND f~language EQ 'E'
      FIELDS a~billingdocument ,
             d~streetname , d~streetprefixname1 , d~streetprefixname2 , d~cityname , d~postalcode ,
             e~regionname ,
             f~countryname
      WHERE a~billingdocument IN @lt_billingdocument
      INTO TABLE @DATA(it_customer)
      PRIVILEGED ACCESS.

      SORT it_data BY billingdocument billingdocumentitem serialnumber   yy1_mfrserialno_mmi DESCENDING.
      DELETE ADJACENT DUPLICATES FROM it_data
      COMPARING billingdocument billingdocumentitem serialnumber .

      LOOP AT it_data INTO DATA(wa_data).

        IF wa_data-yers IS NOT INITIAL.
          lv_mfr_year = wa_data-yers.
        ELSE .
          lv_mfr_year = ''.
        ENDIF.
        ls_response-billingdocument = wa_data-billingdocument.
        ls_response-billingdocumentitem = wa_data-billingdocumentitem.
        ls_response-sales_org = wa_data-salesorganization.
        ls_response-customer_type = wa_data-customergroup.
        ls_response-customer_type_desc = wa_data-customergroupname.
        ls_response-customer_code = wa_data-customer.
        ls_response-customer_name = wa_data-customername.
        ls_response-invoice_date = wa_data-creationdate.
        ls_response-invoice_no = wa_data-documentreferenceid.
        ls_response-division = wa_data-division.
        ls_response-product_group = wa_data-productgroup.
        ls_response-product_code = wa_data-product.
        ls_response-product_name = wa_data-productdescription.
        ls_response-serial_no  = wa_data-serialnumber.
        ls_response-plant  = wa_data-plant.
        ls_response-distribution_channel  = wa_data-distributionchannel.
        ls_response-product_group_desc = wa_data-productgroupname.
*        ls_response-brand = wa_data-description.

        READ TABLE it_customer INTO DATA(wa_customer) WITH KEY billingdocument = wa_data-billingdocument.
        CONCATENATE wa_customer-streetname ',' wa_customer-streetprefixname1 ',' wa_customer-streetprefixname2 ','
                    wa_customer-cityname ',' wa_customer-regionname ',' wa_customer-postalcode '-' wa_customer-countryname
                    INTO ls_response-customer_address SEPARATED BY space .
        ls_response-customer_state = wa_customer-regionname.
        ls_response-customer_country = wa_customer-countryname.
        ls_response-customer_city = wa_customer-cityname.

        CLEAR: lv_lastserial, lv_len, lv_offset.

        IF wa_data-serialnumber IS NOT INITIAL.
          lv_len = strlen( wa_data-serialnumber ).

          IF lv_len > 5.
            lv_offset = lv_len - 5.
            lv_lastserial = wa_data-serialnumber+lv_offset(5).
          ELSE.
            lv_lastserial = wa_data-serialnumber+lv_offset.
          ENDIF.
        ENDIF.

        IF wa_data-yy1_mfrserialno_mmi IS NOT INITIAL.

          CONCATENATE wa_data-yy1_mfrserialno_mmi lv_lastserial
            INTO ls_response-mfg_serial_no.

        ELSEIF wa_data-pp_sernum IS NOT INITIAL.

          IF wa_data-region = 'UP'.
            CONCATENATE wa_data-place '/' wa_data-model '/' wa_data-make '/'
                        lv_mfr_year '/' wa_data-machineno '/' wa_data-state
              INTO ls_response-mfg_serial_no.
          ELSE.
            CONCATENATE wa_data-place '/' wa_data-model '/' wa_data-make '/'
                        lv_mfr_year '/' wa_data-machineno
              INTO ls_response-mfg_serial_no.
          ENDIF.

        ELSEIF wa_data-mfr_serialno IS NOT INITIAL.

          ls_response-mfg_serial_no = wa_data-mfr_serialno.

        ELSE.

          CLEAR ls_response-mfg_serial_no.

        ENDIF.


        APPEND ls_response TO lt_response.
        CLEAR: wa_data, wa_customer, ls_response .
      ENDLOOP.


      lv_max_rows = lv_skip + lv_top.
      IF lv_skip > 0.
        lv_skip = lv_skip + 1.
      ENDIF.

      CLEAR lt_responseout.
      LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<lfs_out_line_item>) FROM lv_skip TO lv_max_rows.
        ls_responseout = <lfs_out_line_item>.
        APPEND ls_responseout TO lt_responseout.
      ENDLOOP.

      io_response->set_total_number_of_records( lines( lt_response ) ).
      io_response->set_data( lt_responseout ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
