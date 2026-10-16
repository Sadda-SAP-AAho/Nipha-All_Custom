class ZCL_FI_BANK_JOURNAL definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FI_BANK_JOURNAL IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

   DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

    data(accountingdocument) = req[ 2 ]-value .
*    data(from_postingdate) = req[ 3 ]-value ...
*    data(to_postingdate) = req[ 4 ]-value .
    data(fiscalyear) = req[ 5 ]-value .
    data(companycode) = req[ 7 ]-value .
    data(radiobuttontext) = req[ 6 ]-value .

    SELECT SINGLE AccountingDocumentType from I_OperationalAcctgDocItem where FiscalYear = @fiscalyear and CompanyCode = @companycode
                                        and AccountingDocument = @accountingdocument
                                        into @data(bankvoucher) .



IF radiobuttontext = 'Journal Voucher' .
 DATA(pdf2) = zfi_journal_voucher=>read_posts( accountingdocument = accountingdocument fiscalyear = fiscalyear companycode = companycode radiobuttontext = radiobuttontext ) .

ELSEIF
 radiobuttontext = 'Payment Voucher' and bankvoucher = 'KZ' .
  pdf2 = zfi_bank_voucher_class=>read_posts( accountingdocument = accountingdocument fiscalyear = fiscalyear companycode = companycode radiobuttontext = radiobuttontext ) .

 ELSEIF
 radiobuttontext =  'Receipt Voucher' .
   pdf2 = zfi_reciept_voucher=>read_posts( accountingdocument = accountingdocument fiscalyear = fiscalyear companycode = companycode radiobuttontext = radiobuttontext ) .

  ELSEIF
 radiobuttontext =  'Cash Voucher' .
   pdf2 = zfi_cash_voucher_class=>read_posts( accountingdocument = accountingdocument fiscalyear = fiscalyear companycode = companycode radiobuttontext = radiobuttontext ) .

 ENDIF .
    response->set_text( pdf2  ).



  endmethod.
ENDCLASS.
