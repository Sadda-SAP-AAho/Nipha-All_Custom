*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS xml_class DEFINITION CREATE PRIVATE.


  PUBLIC SECTION.

    CLASS-METHODS xml_function
      IMPORTING
                request       TYPE REF TO if_web_http_request
                response      TYPE REF TO if_web_http_response
      RETURNING VALUE(result) TYPE string.


ENDCLASS.

CLASS xml_class IMPLEMENTATION.

  METHOD xml_function.
    DATA lv_slipdata TYPE ty_request .

    xco_cp_json=>data->from_string( request->get_text(  ) )->write_to( REF  #( lv_slipdata ) ) .
    SELECT SINGLE FROM ztable_plant AS a
    FIELDS a~company_name,
           a~plant_name1,
           a~address1,
           a~pin,
           a~country,
           a~state_code1,
           a~district
    WHERE a~plant_code = @lv_slipdata-plant
    INTO @DATA(companydetail) PRIVILEGED ACCESS .


    DATA secondAdd TYPE string.

    CONCATENATE companydetail-district ', ' companydetail-state_code1 ', ' companydetail-country ', ' companydetail-pin  INTO secondadd .


    SELECT FROM ZC_GateEntryHeader AS a
    INNER JOIN ZC_GateEntryLines AS b ON b~GateEntryNo = a~GateEntryNo
    FIELDS
    a~GateEntryNo,
    a~Plant,
    a~GateInDate,
    a~GateInTime,
    a~GateOutDate,
    a~GateOutTime,
    a~VehicleNo,
    a~TareWt,
    a~GrossWt,
    a~NetWt,
    a~InvoicePartyName,
    b~ProductCode
    WHERE a~GateEntryNo = @lv_slipdata-gateentryno AND a~EntryDate = @lv_slipdata-entrydate
    INTO @DATA(content) .
    ENDSELECT.


    DATA lv_xml TYPE string.


    lv_xml = |<XML>| &&
             |<ADDRESS>| &&
             |<COMPNAME>{ companydetail-company_name }</COMPNAME>| &&
             |<COMPADD>{ companydetail-address1 }</COMPADD>| &&
             |<COMPADD2>{ secondadd }</COMPADD2>| &&
             |</ADDRESS>| &&
             |<SECONDLINE>| &&
             |<RSTNO>{ content-GateEntryNo }</RSTNO>| &&
             |<MATERIAL>{ content-ProductCode }</MATERIAL>| &&
             |<ADD1>{ 'ADD' }</ADD1>| &&
             |<VEHICLE>{ content-VehicleNo }</VEHICLE>| &&
             |<PARTYNAME>{ content-InvoicePartyName }</PARTYNAME>| &&
             |<SOURCE>{ 'SOURCE' }</SOURCE>| &&
             |</SECONDLINE>| &&
             |<THIRDLINE>| &&
             |<GROSS>{ content-GrossWt }</GROSS>| &&
             |<TARE>{ content-TareWt }</TARE>| &&
             |<NET>{ content-NetWt }</NET>| &&
             |<DATEIN>{ content-GateInDate }</DATEIN>| &&
             |<TIMEIN>{ content-GateInTime }</TIMEIN>| &&
             |<DATEOUT>{ content-GateOutDate }</DATEOUT>| &&
             |<TIMEOUT>{ content-GateOutTime }</TIMEOUT>| &&
             |<OPNAME>{ 'OPERATION' }</OPNAME>| &&
             |</THIRDLINE>| &&
             |</XML>| .

    response->set_text( lv_xml ).
  ENDMETHOD.
ENDCLASS.
