class ZCL_FI_ACCOUNTSTATEMENT_SER definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FI_ACCOUNTSTATEMENT_SER IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

 DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).


DATA profitcenter TYPE C LENGTH 10 .

    DATA(accounttype) = VALUE #( req[ name = 'accounttype' ]-value OPTIONAL ) .
    DATA(lastdate) = VALUE #( req[ name = 'lastdate' ]-value OPTIONAL ) .
    DATA(currentdate) = VALUE #( req[ name = 'currentdate' ]-value OPTIONAL ) .
    DATA(correspondence) = VALUE #( req[ name = 'correspondence' ]-value OPTIONAL ) .
    DATA(companycode) = VALUE #( req[ name = 'companycode' ]-value OPTIONAL ) .
    DATA(customer) = VALUE #( req[ name = 'customer' ]-value OPTIONAL ) .
    DATA(profitcenter1) = VALUE #( req[ name = 'profitcenter' ]-value OPTIONAL ) .
    DATA(confirmletterbox) = VALUE #( req[ name = 'confirmletterbox' ]-value OPTIONAL ) .
    DATA(segment) = VALUE #( req[ name = 'segment' ]-value OPTIONAL ) .
*     DATA(year) = VALUE #( req[ name = 'year' ]-value OPTIONAL ) .



    profitcenter = |{ profitcenter1 ALPHA = IN }| .



  DATA ALPHA TYPE CHAR10 .
  ALPHA = |{ customer ALPHA = IN }| .
  customer = alpha .

    SELECT SINGLE D~AccountingDocumentType FROM  I_GLAccountLineItem  AS A
     LEFT OUTER JOIN I_JournalEntry AS B ON ( B~AccountingDocument = A~AccountingDocument )
     LEFT OUTER JOIN I_OperationalAcctgDocItem AS D ON ( D~AccountingDocument = A~AccountingDocument  )


    WHERE
      A~Supplier = @customer
      AND A~Ledger = '0L'
      AND
      A~CompanyCode = @companycode

     INTO @DATA(IT) .

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


 IF  AccountType = 'K' .   """""SUPPLIER""""""""""""""""""""""""""""""""""""""""""
*   IF
*   IT = 'KZ' .
    DATA(pdf2) = zfi_accountstatement=>read_posts( companycode = companyCode
    correspondence = correspondence
    accounttype = accounttype customer = customer lastdate = lastdate currentdate  = currentdate
    profitcenter = profitcenter confirmletterbox = confirmletterbox segment = segment
*    year = year
     ) .

*    ELSEIF
*    IT = 'KR' OR IT = 'KG' OR IT = 'RE' OR IT = 'RK' .
*
*
*    pdf2 = zfi_accountstatement_vendor2=>read_posts( companycode = companyCode  correspondence = correspondence
*    accounttype = accounttype customer = customer lastdate = lastdate currentdate  = currentdate
*    profitcenter = profitcenter confirmletterbox = confirmletterbox segment = segment ) .
*
*    ENDIF.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 ELSEIF AccountType = 'D' . """"""CUSTOMER"""""""""""""""""""""""""""""""""""""""

*   IF
*   IT = 'DZ' .
   pdf2 = ycl_account_statement_customer=>read_posts( companycode = companyCode  correspondence = correspondence
    accounttype = accounttype customer = customer lastdate = lastdate currentdate  = currentdate
    profitcenter = profitcenter   confirmletterbox = confirmletterbox segment = segment     ) .
*
*   ELSEIF
*    IT = 'DR' OR IT = 'DG' OR IT = 'RV' .
*
*    pdf2 = ycl_account_statement_custmr2=>read_posts( companycode = companyCode  correspondence = correspondence
*    accounttype = accounttype customer = customer lastdate = lastdate currentdate  = currentdate
*    profitcenter = profitcenter   confirmletterbox = confirmletterbox segment = segment  ) .
*   ENDIF.

 ENDIF.
    response->set_text( pdf2  ).

  ENDMETHOD.
ENDCLASS.
