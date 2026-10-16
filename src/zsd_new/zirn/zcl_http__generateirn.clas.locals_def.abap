*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CONSTANTS: req_module TYPE string VALUE 'IRN-CREATE-URL',
           header_key TYPE string VALUE 'DRC-HEAD'.

TYPES: BEGIN OF ty_request,
         billingdocument TYPE zr_irn-billingdocument,
         companycode     TYPE zr_irn-companycode,
       END OF ty_request.


TYPES: BEGIN OF mainres,
         alert          TYPE string,
         date           TYPE string,
         docno          TYPE string,
         irn            TYPE string,
         ackdate         TYPE string,
         ackno           TYPE string,
         signedinvoice   TYPE string,
         signedqrcode    TYPE string,
         irnstatus        TYPE string,
         errormessage       TYPE string,
         errorcode          TYPE string,
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


TYPES: BEGIN OF govt_res,
         success       TYPE string,
         ackno         TYPE string,
         ackdt         TYPE string,
         irn           TYPE string,
         signedinvoice TYPE string,
         signedqrcode  TYPE string,
         status        TYPE string,
       END OF govt_res.

TYPES: BEGIN OF govt_res3,
         govt_response TYPE  govt_res,
       END OF govt_res3.


TYPES: BEGIN OF ty_transaction_details,
         supply_type     TYPE string,
         ecommerce_gstin TYPE string,
         reg_rev         TYPE string,
         tax_sch         TYPE string,
         igstonintra     TYPE string,
       END OF ty_transaction_details.

TYPES: BEGIN OF ty_document_details,
         document_type   TYPE string,
         document_number TYPE string,
         document_date   TYPE string,
       END OF ty_document_details.

TYPES: BEGIN OF ty_seller_details,
         gstin      TYPE string,
         legal_name TYPE string,
         trade_name TYPE string,
         address1   TYPE string,
         address2   TYPE string,
         location   TYPE string,
         pincode    TYPE string,
         state_code TYPE string,
         state      TYPE string,
       END OF ty_seller_details.


TYPES: BEGIN OF ty_buyer_details,
         gstin           TYPE string,
         legal_name      TYPE string,
         trade_name      TYPE string,
         address1        TYPE string,
         address2        TYPE string,
         location        TYPE string,
         pincode         TYPE string,
         place_of_supply TYPE string,
         state_code      TYPE string,
         state           TYPE string,
       END OF ty_buyer_details.


TYPES:BEGIN OF ty_dispatch_details,
        name       TYPE string,
        address1   TYPE string,
        address2   TYPE string,
        location   TYPE string,
        pincode    TYPE string,
        state_code TYPE string,
        state      TYPE string,
      END OF ty_dispatch_details.


TYPES: BEGIN OF ty_ship_details,
         gstin      TYPE string,
         legal_name TYPE string,
         trade_name TYPE string,
         address1   TYPE string,
         address2   TYPE string,
         location   TYPE string,
         pincode    TYPE string,
         state_code TYPE string,
         state      TYPE string,
       END OF ty_ship_details.

TYPES: BEGIN OF ty_export_details,
         foreign_currency TYPE string,
         port_code        TYPE string,
         country_code     TYPE string,
         refund_claim     TYPE string,
       END OF ty_export_details.


TYPES: BEGIN OF ty_ewaybill_details,
         transporter_id              TYPE string,
         transporter_name            TYPE string,
         transportation_mode         TYPE string,
         transportation_distance     TYPE int4,
         transporter_document_number TYPE string,
         transporter_document_date   TYPE string,
         vehicle_number              TYPE string,
         vehicle_type                TYPE string,
       END OF ty_ewaybill_details.


TYPES: BEGIN OF ty_value_details,
         total_assessable_value      TYPE p LENGTH 13 DECIMALS 2,
         total_cgst_value            TYPE p LENGTH 13 DECIMALS 2,
         total_sgst_value            TYPE p LENGTH 13 DECIMALS 2,
         total_igst_value            TYPE p LENGTH 13 DECIMALS 2,
         total_cess_value            TYPE p LENGTH 13 DECIMALS 2,
         total_cess_value_of_state   TYPE p LENGTH 13 DECIMALS 2,
         total_discount              TYPE p LENGTH 13 DECIMALS 2,
         total_other_charge          TYPE p LENGTH 13 DECIMALS 2,
         total_invoice_value         TYPE p LENGTH 13 DECIMALS 2,
         round_off_amount            TYPE p LENGTH 13 DECIMALS 2,
         tot_inv_val_additional_curr TYPE p LENGTH 13 DECIMALS 2,
       END OF ty_value_details.


TYPES: BEGIN OF ty_item_list,
         item_serial_number         TYPE string,
         product_description        TYPE string,
         is_service                 TYPE string,
         hsn_code                   TYPE string,
         bar_code                   TYPE string,
         quantity                   TYPE p LENGTH 13 DECIMALS 2,
         unit                       TYPE string,
         unit_price                 TYPE p LENGTH 13 DECIMALS 2,
         total_amount               TYPE p LENGTH 13 DECIMALS 2,
         pre_tax_value              TYPE p LENGTH 13 DECIMALS 2,
         discount                   TYPE p LENGTH 13 DECIMALS 2,
         other_charge               TYPE p LENGTH 13 DECIMALS 2,
         assessable_value           TYPE p LENGTH 13 DECIMALS 2,
         gst_rate                   TYPE p LENGTH 13 DECIMALS 2,
         igst_amount                TYPE p LENGTH 13 DECIMALS 2,
         cgst_amount                TYPE p LENGTH 13 DECIMALS 2,
         sgst_amount                TYPE p LENGTH 13 DECIMALS 2,
         cess_rate                  TYPE p LENGTH 13 DECIMALS 2,
         cess_amount                TYPE p LENGTH 13 DECIMALS 2,
         cess_nonadvol_amount       TYPE p LENGTH 13 DECIMALS 2,
         state_cess_rate            TYPE p LENGTH 13 DECIMALS 2,
         state_cess_amount          TYPE p LENGTH 13 DECIMALS 2,
         state_cess_nonadvol_amount TYPE p LENGTH 13 DECIMALS 2,
         total_item_value           TYPE p LENGTH 13 DECIMALS 2,
       END OF ty_item_list.

TYPES ty_item_list_table TYPE TABLE OF ty_item_list WITH EMPTY KEY.

TYPES: BEGIN OF ty_transaction,
         version             TYPE string,
         transaction_details TYPE ty_transaction_details,
         document_details    TYPE ty_document_details,
         seller_details      TYPE ty_seller_details,
         buyer_details       TYPE ty_buyer_details,
         dispatch_details    TYPE ty_dispatch_details,
         ship_details        TYPE ty_ship_details,
         export_details      TYPE ty_export_details,
         ewaybill_details    TYPE ty_ewaybill_details,
         value_details       TYPE ty_value_details,
         item_list           TYPE ty_item_list_table,
       END OF ty_transaction.

TYPES: BEGIN OF ty_body,
         transaction TYPE  ty_transaction,
       END OF ty_body.







TYPES: BEGIN OF ty_tran_details,
         suptyp      TYPE string,
         regrev      TYPE string,
         ecmgstin    TYPE string,
         igstonintra TYPE string,
       END OF ty_tran_details.


TYPES: BEGIN OF ty_doc_details,
         typ TYPE string,
         no  TYPE string,
         dt  TYPE string,
       END OF ty_doc_details.


TYPES: BEGIN OF ty_seller_details_new,
         gstin TYPE string,
         lglnm TYPE string,
         trdnm TYPE string,
         addr1 TYPE string,
         addr2 TYPE string,
         loc   TYPE string,
         pin   TYPE string,
         stcd  TYPE string,
         ph    TYPE string,
         em    TYPE string,
       END OF ty_seller_details_new.

TYPES: BEGIN OF ty_buyer_details_new,
         gstin TYPE string,
         lglnm TYPE string,
         trdnm TYPE string,
         pos   TYPE string,
         addr1 TYPE string,
         addr2 TYPE string,
         loc   TYPE string,
         pin   TYPE string,
         stcd  TYPE string,
         ph    TYPE string,
         em    TYPE string,
       END OF ty_buyer_details_new.

TYPES: BEGIN OF ty_disp_details,
         nm    TYPE string,
         addr1 TYPE string,
         addr2 TYPE string,
         loc   TYPE string,
         pin   TYPE string,
         stcd  TYPE string,
       END OF ty_disp_details.


TYPES: BEGIN OF ty_ship_details_new,
         gstin TYPE string,
         lglnm TYPE string,
         trdnm TYPE string,
         addr1 TYPE string,
         addr2 TYPE string,
         loc   TYPE string,
         pin   TYPE string,
         stcd  TYPE string,
       END OF ty_ship_details_new.

TYPES: BEGIN OF ty_batch_details,
         nm    TYPE string,
         expdt TYPE string,
         wrdt  TYPE string,
       END OF ty_batch_details.


TYPES: BEGIN OF ty_attribute_details,
         nm  TYPE string,
         val TYPE string,
       END OF ty_attribute_details.

TYPES ty_attribute_details_tab TYPE STANDARD TABLE OF ty_attribute_details WITH EMPTY KEY.

TYPES: BEGIN OF ty_item_list_new,
         slno                TYPE string,
         prddesc             TYPE string,
         isservc             TYPE string,
         hsncd               TYPE string,
         barcde              TYPE string,
         qty                 TYPE p LENGTH 13 DECIMALS 2,
         freeqty             TYPE p LENGTH 13 DECIMALS 2,
         unit                TYPE string,
         unitprice           TYPE p LENGTH 13 DECIMALS 2,
         totamt              TYPE p LENGTH 13 DECIMALS 2,
         discount            TYPE p LENGTH 13 DECIMALS 2,
         pretaxval           TYPE p LENGTH 13 DECIMALS 2,
         assamt              TYPE p LENGTH 13 DECIMALS 2,
         gstrt               TYPE p LENGTH 13 DECIMALS 2,
         igstamt             TYPE p LENGTH 13 DECIMALS 2,
         cgstamt             TYPE p LENGTH 13 DECIMALS 2,
         sgstamt             TYPE p LENGTH 13 DECIMALS 2,
         cesrt               TYPE p LENGTH 13 DECIMALS 2,
         cesamt              TYPE p LENGTH 13 DECIMALS 2,
         cesnonadlvlamt      TYPE p LENGTH 13 DECIMALS 2,
         statecesrt          TYPE p LENGTH 13 DECIMALS 2,
         statecesamt         TYPE p LENGTH 13 DECIMALS 2,
         statecesnonadlvlamt TYPE p LENGTH 13 DECIMALS 2,
         othchrg             TYPE p LENGTH 13 DECIMALS 2,
         totitemval          TYPE p LENGTH 13 DECIMALS 2,
         ordlineref          TYPE string,
         orgcntry            TYPE string,
         prdslno             TYPE string,
         bchdtls             TYPE c LENGTH 4,
         attribdtls          TYPE c LENGTH 4,
       END OF ty_item_list_new.

TYPES ty_item_list_new_tab TYPE STANDARD TABLE OF ty_item_list_new WITH EMPTY KEY.

TYPES: BEGIN OF ty_val_details_new,
         assval      TYPE p LENGTH 13 DECIMALS 2,
         cgstval     TYPE p LENGTH 13 DECIMALS 2,
         sgstval     TYPE p LENGTH 13 DECIMALS 2,
         igstval     TYPE p LENGTH 13 DECIMALS 2,
         cesval      TYPE p LENGTH 13 DECIMALS 2,
         stcesval    TYPE p LENGTH 13 DECIMALS 2,
         discount    TYPE p LENGTH 13 DECIMALS 2,
         othchrg     TYPE p LENGTH 13 DECIMALS 2,
         rndoffamt   TYPE p LENGTH 13 DECIMALS 2,
         totinvval   TYPE p LENGTH 13 DECIMALS 2,
         totinvvalfc TYPE p LENGTH 13 DECIMALS 2,
       END OF ty_val_details_new.

TYPES: BEGIN OF ty_pay_details,
         nm       TYPE string,
         accdet   TYPE string,
         mode     TYPE string,
         fininsbr TYPE string,
         payterm  TYPE string,
         payinstr TYPE string,
         crtrn    TYPE string,
         dirdr    TYPE string,
         crday    TYPE i,
         paidamt  TYPE p LENGTH 13 DECIMALS 2,
         paymtdue TYPE p LENGTH 13 DECIMALS 2,
       END OF ty_pay_details.

TYPES: BEGIN OF ty_doc_period,
         invstdt  TYPE string,
         invenddt TYPE string,
       END OF ty_doc_period.

TYPES: BEGIN OF ty_prec_doc,
         invno    TYPE string,
         invdt    TYPE string,
         othrefno TYPE string,
       END OF ty_prec_doc.

TYPES ty_prec_doc_tab TYPE STANDARD TABLE OF ty_prec_doc WITH EMPTY KEY.

TYPES: BEGIN OF ty_contract_details,
         recadvrefr TYPE string,
         recadvdt   TYPE string,
         tendrefr   TYPE string,
         contrrefr  TYPE string,
         extrefr    TYPE string,
         projrefr   TYPE string,
         porefr     TYPE string,
         porefdt    TYPE string,
       END OF ty_contract_details.

TYPES ty_contract_tab TYPE STANDARD TABLE OF ty_contract_details WITH EMPTY KEY.

TYPES: BEGIN OF ty_ref_details,
         invrm       TYPE string,
         docperddtls TYPE ty_doc_period,
         precdocdtls TYPE ty_prec_doc_tab,
         contrdtls   TYPE ty_contract_tab,
       END OF ty_ref_details.

TYPES: BEGIN OF ty_addl_doc,
         url  TYPE string,
         docs TYPE string,
         info TYPE string,
       END OF ty_addl_doc.

TYPES ty_addl_doc_tab TYPE STANDARD TABLE OF ty_addl_doc WITH EMPTY KEY.

TYPES: BEGIN OF ty_exp_details_new,
         shipbno TYPE string,
         shipbdt TYPE string,
         port    TYPE string,
         refclm  TYPE string,
         forcur  TYPE string,
         cntcode TYPE string,
         expduty TYPE string,
       END OF ty_exp_details_new.

TYPES: BEGIN OF ty_ewaybill_details_new,
         transid    TYPE string,
         transname  TYPE string,
         distance   TYPE i,
         transdocno TYPE string,
         transdocdt TYPE string,
         vehno      TYPE string,
         vehtype    TYPE string,
         transmode  TYPE string,
       END OF ty_ewaybill_details_new.

TYPES: BEGIN OF ty_einv_request,
         cdkey            TYPE string,
         einvusername     TYPE string,
         einvpassword     TYPE string,
         efusername       TYPE string,
         efpassword       TYPE string,
         gstin            TYPE string,
         getqrimg         TYPE string,
         getsignedinvoice TYPE string,
         trandtls         TYPE ty_tran_details,
         docdtls          TYPE ty_doc_details,
         sellerdtls       TYPE ty_seller_details_new,
         buyerdtls        TYPE ty_buyer_details_new,
         dispdtls         TYPE ty_disp_details,
         shipdtls         TYPE ty_ship_details_new,
         itemlist         TYPE ty_item_list_new_tab,
         valdtls          TYPE ty_val_details_new,
         paydtls          TYPE c LENGTH 4,
         refdtls          TYPE c LENGTH 4,
         addldocdtls      TYPE c LENGTH 4,
         expdtls          TYPE ty_exp_details_new,
         ewbdtls          TYPE c LENGTH 4,
       END OF ty_einv_request.
