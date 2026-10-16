CLASS zcl_maintenance_order DEFINITION
   public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MAINTENANCE_ORDER IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

   DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'Optional' ).

    data(accountingdocument) = req[ 2 ]-value .
*    data(fiscalyear) = req[ 5 ]-value .
*    data(companycode) = req[ 7 ]-value .
*    data(radiobuttontext) = req[ 6 ]-value .


*    SELECT SINGLE AccountingDocumentType from I_OperationalAcctgDocItem where FiscalYear = @fiscalyear and CompanyCode = @companycode
*                                        and AccountingDocument = @accountingdocument
*                                        into @data(bankvoucher) .




* DATA(pdf2) = zpm_maintenance_order=>read_posts( accountingdocument = accountingdocument fiscalyear = fiscalyear  companycode = companycode radiobuttontext
* = radiobuttontext ) .

 DATA(pdf2) = zpm_maintenance_order=>read_posts( accountingdocument = accountingdocument  ) .


    response->set_text( pdf2  ).



  endmethod.
ENDCLASS.
