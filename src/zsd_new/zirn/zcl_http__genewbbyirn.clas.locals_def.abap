*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section


CONSTANTS: req_module TYPE string VALUE 'EWB-IRN-CREATE-URL',
           header_key TYPE string VALUE 'DRC-HEAD'.

TYPES: BEGIN OF ty_request,
         billingdocument TYPE zr_irn-billingdocument,
         companycode     TYPE zr_irn-companycode,
       END OF ty_request.


TYPES: BEGIN OF errordetails,
         error_code    TYPE string,
         error_message TYPE string,
         error_source  TYPE string,
       END OF errordetails.

TYPES: BEGIN OF ty_message,
         ewbno        TYPE string,
         ewbdt        TYPE string,
         ewbvalidtill TYPE string,
       END OF ty_message.

TYPES: BEGIN OF success,
         success TYPE string,
       END OF success.

TYPES: BEGIN OF gvtres1,
         govt_response TYPE success,
       END OF gvtres1.

TYPES: BEGIN OF errors,
         errordetails TYPE TABLE OF errordetails WITH EMPTY KEY,
       END OF errors.

TYPES: BEGIN OF gvtres2,
         govt_response TYPE errors,
       END OF gvtres2.

TYPES: BEGIN OF gvtres3,
         govt_response TYPE ty_message,
         errormessage  TYPE string,
         ewaybill      TYPE string,
       END OF gvtres3.

TYPES: BEGIN OF ty_expshipdtls,
         addr1 TYPE string,
         addr2 TYPE string,
         loc   TYPE string,
         pin   TYPE string,
         stcd  TYPE string,
       END OF ty_expshipdtls.

TYPES: BEGIN OF ty_dispdtls,
         nm    TYPE string,
         addr1 TYPE string,
         addr2 TYPE string,
         loc   TYPE string,
         pin   TYPE string,
         stcd  TYPE string,
       END OF ty_dispdtls.

TYPES: BEGIN OF ty_json_data,
         irn         TYPE string,
         distance    TYPE i,
         transmode   TYPE string,
         transid     TYPE string,
         transname   TYPE string,
         transdocdt  TYPE string,
         transdocno  TYPE string,
         vehno       TYPE string,
         vehtype     TYPE string,
         expshipdtls TYPE ty_expshipdtls,
         dispdtls    TYPE ty_dispdtls,
       END OF ty_json_data.


TYPES: BEGIN OF ty_ewb_payload,
         irn            TYPE string,
         transmode      TYPE string,
         transid        TYPE string,
         transname      TYPE string,
         distance       TYPE p LENGTH 10 DECIMALS 2,
         transdocno     TYPE string,
         transdocdt     TYPE string,
         vehno          TYPE string,
         vehtype        TYPE string,
         shipfrom_addr1 TYPE string,
         shipfrom_addr2 TYPE string,
         shipfrom_loc   TYPE string,
         shipfrom_pin   TYPE i,
         shipfrom_stcd  TYPE string,
         shipto_gstin   TYPE string,
         shipto_trdnm   TYPE string,
         shipto_addr1   TYPE string,
         shipto_addr2   TYPE string,
         shipto_loc     TYPE string,
         shipto_pin     TYPE i,
         shipto_stcd    TYPE string,
         gstin          TYPE string,
         cdkey          TYPE string,
         ewbusername    TYPE string,
         ewbpassword    TYPE string,
         efusername     TYPE string,
         efpassword     TYPE string,
       END OF ty_ewb_payload.
