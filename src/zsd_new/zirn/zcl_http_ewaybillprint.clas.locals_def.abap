*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
TYPES: BEGIN OF ty_request,
         billingdocument TYPE ztable_irn-billingdocument,
         companycode     TYPE ztable_irn-companycode,
       END OF ty_request.


TYPES: BEGIN OF ty_ewb_request,


         gstin       TYPE string,
         ewbusername TYPE string,
         ewbpassword TYPE string,
         efusername  TYPE string,
         efpassword  TYPE string,
         cdkey       TYPE string,
         ewbno       TYPE string,
         year        TYPE string,
         month       TYPE string,
       END OF ty_ewb_request.


"SPLIT
TYPES: BEGIN OF ty_wrapper,
         efusername TYPE string,
         efpassword TYPE string,
         cdkey      TYPE string,
       END OF ty_wrapper.
