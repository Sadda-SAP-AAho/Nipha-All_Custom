*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

TYPES: BEGIN OF ty_request,
         billingdocument TYPE ztable_irn-billingdocument,
         companycode     TYPE ztable_irn-companycode,
       END OF ty_request.


TYPES : BEGIN OF ty_irnprint ,
          irn          TYPE string,
          gstin        TYPE string,
          cdkey        TYPE string,
          einvusername TYPE string,
          einvpassword TYPE string,
          efusername   TYPE string,
          efpassword   TYPE string,
        END OF ty_irnprint.

TYPES : BEGIN OF ty_resprint ,
          file TYPE string,
          ErrorMessage TYPE string,
        END OF ty_resprint.
