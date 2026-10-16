CONSTANTS: req_module TYPE string VALUE 'CANCEL-EWB-URL',
           header_key TYPE string VALUE 'DRC-HEAD'.

TYPES: BEGIN OF ty_request,
         billingdocument TYPE zr_irn-billingdocument,
         companycode     TYPE zr_irn-companycode,
       END OF ty_request.


TYPES: BEGIN OF ty_item_list,
         ewbno         TYPE string,
         cancelrsncode TYPE string,
         cancelrmrk    TYPE string,
       END OF ty_item_list.


TYPES: BEGIN OF errordetails,
         error_code    TYPE string,
         error_message TYPE string,
         error_source  TYPE string,
       END OF errordetails.

TYPES: BEGIN OF govt_res1,
         errordetails TYPE  errordetails,
       END OF govt_res1.

TYPES: BEGIN OF mainres,
         alert          TYPE string,
         date           TYPE string,
         docno          TYPE string,
         ewbdetails     TYPE string,
         ewaybill       TYPE string,
         errorcode      TYPE string,
         errormessage   TYPE string,
         gstin          TYPE string,
         issuccess      TYPE string,
         old_ewaybill   TYPE string,
         supplierstate  TYPE string,
         validupto      TYPE string,
         vehicleno      TYPE string,
       END OF mainres.

TYPES: BEGIN OF ty_push_data,
         gstin            TYPE string,
         ewbnumber        TYPE int8,
         cancelreasoncode TYPE string,
         cancelremark     TYPE string,
         ewbusername      TYPE string,
         ewbpassword      TYPE string,
       END OF ty_push_data.
