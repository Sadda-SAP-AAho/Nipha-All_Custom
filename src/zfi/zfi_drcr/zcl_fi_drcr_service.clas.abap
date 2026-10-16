CLASS zcl_fi_drcr_service DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FI_DRCR_SERVICE IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.


    DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).





    DATA(comcode) = VALUE #( req[ name = 'comcode' ]-value OPTIONAL ) .
    DATA(docnum) = VALUE #( req[ name = 'docnum' ]-value OPTIONAL ) .
    DATA(year) = VALUE #( req[ name = 'year' ]-value OPTIONAL ) .
    DATA(plant) = VALUE #( req[ name = 'plant' ]-value OPTIONAL ) .
    DATA(checkboxvalue) = VALUE #( req[ name = 'checkboxvalue' ]-value OPTIONAL ) .
    DATA(debitcreditnote) =   req[ 8 ]-value. .
    DATA(creditmemo) = req[ 9 ]-value. .

    DATA : docnum1 TYPE c LENGTH 10,
           year1   TYPE c LENGTH 4.
    docnum1 = docnum.
    year1 = year.





*SELECT SINGLE AccountingDocumentType FROM I_SupplierInvoiceAPI01  WITH PRIVILEGED ACCESS WHERE SupplierInvoice = @docnum and FiscalYear = @year INTO @DATA(MIRODOC)  .
    SELECT SINGLE accountingdocumenttype FROM i_supplierinvoiceapi01  WHERE supplierinvoice = @docnum1 AND fiscalyear = @year1 INTO @DATA(mirodoc)  .
    SELECT SINGLE accountingdocumenttype FROM i_operationalacctgdocitem  WITH PRIVILEGED ACCESS WHERE accountingdocument = @docnum AND fiscalyear = @year INTO @DATA(oper)  .

*SELECT SINGLE AccountingDocumentType FROM I_JournalEntry " WITH PRIVILEGED ACCESS
* WHERE AccountingDocument = @docnum1 and FiscalYear = @year1 INTO @DATA(OPER)  . " Added by Rehan on 01/08/2025


    IF mirodoc = 'RE' ."

      DATA(pdf2) = zclfi_pur_doc=>read_posts( comcode = comcode date = ' '
      docno = docnum plant = plant year = year checkboxvalue = checkboxvalue debitcreditnote = debitcreditnote creditmemo = creditmemo ) .
    ELSEIF oper = 'KR' OR oper = 'KG' AND creditmemo IS INITIAL .
      pdf2 = z_crdr_note_fi=>read_posts( comcode = comcode date = ' '
      docno = docnum plant = plant year = year checkboxvalue = checkboxvalue debitcreditnote = debitcreditnote creditmemo = creditmemo ) .
    ELSEIF oper = 'KR' AND creditmemo IS NOT INITIAL .
      pdf2 = zservice_crdr_note=>read_posts( comcode = comcode date = ' '
      docno = docnum plant = plant year = year checkboxvalue = checkboxvalue debitcreditnote = debitcreditnote creditmemo = creditmemo ) .

    ENDIF.

    response->set_text( pdf2 ).

  ENDMETHOD.
ENDCLASS.
