*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
TYPES: BEGIN OF ty_request,
         billingdocument TYPE zr_irn-billingdocument,
         companycode     TYPE zr_irn-companycode,
         print       TYPE string,
       END OF ty_request.
