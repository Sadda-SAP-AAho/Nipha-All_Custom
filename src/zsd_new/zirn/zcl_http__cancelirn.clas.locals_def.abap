*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CONSTANTS: req_module TYPE string VALUE 'CANCEL-IRN-URL',
           header_key TYPE string VALUE 'DRC-HEAD'.

TYPES: BEGIN OF ty_request,
         billingdocument TYPE zr_irn-billingdocument,
         companycode     TYPE zr_irn-companycode,
       END OF ty_request.


TYPES: BEGIN OF mainres,
         deleted         TYPE string,
         document_status TYPE string,
         irn             TYPE string,
         errormessage    TYPE string,
       END OF mainres.

TYPES: BEGIN OF errordetails,
         error_code    TYPE string,
         error_message TYPE string,
         error_source  TYPE string,
       END OF errordetails.

TYPES: BEGIN OF govt_res1,
         success      TYPE string,
         errordetails TYPE TABLE OF errordetails WITH EMPTY KEY,
       END OF govt_res1.

TYPES: BEGIN OF govt_res2,
         govt_response TYPE  govt_res1,
       END OF govt_res2.


TYPES: BEGIN OF ty_item_list,
         irn    TYPE string,
         cnlrsn TYPE string,
         cnlrem TYPE string,
       END OF ty_item_list.



TYPES: BEGIN OF ty_data,
         irn          TYPE string,
         gstin        TYPE string,
         cnlrsn       TYPE string,
         cnlrem       TYPE string,
         cdkey        TYPE string,
         efusername   TYPE string,
         efpassword   TYPE string,
         einvusername TYPE string,
         einvpassword TYPE string,
       END OF ty_data.

TYPES: tt_data TYPE STANDARD TABLE OF ty_data WITH EMPTY KEY.


TYPES: BEGIN OF ty_push_data_list,
         data TYPE tt_data,
       END OF ty_push_data_list.
