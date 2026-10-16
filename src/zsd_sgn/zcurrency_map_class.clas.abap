CLASS zcurrency_map_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCURRENCY_MAP_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: itab TYPE TABLE OF zcurrency_map,
         wa type zcurrency_map.

"   fill internal travel table (itab)
*    itab = VALUE #(
*      ( currency_id  = 'INR' country = 'INDIA'

*data(lv_description) = ' New Punjab National Bank,Large Corporate Branch, Kolkata-700016 , India.SWIFT CODE: PUNBINBBCPS Wire Transfer Instructions: Pay to Standard Chartered Bank, NY(SWIFT: SCBLUS33) For credit' &&
*' to A/c No. 3582-0808785-001UID-033086 of Punjab National Bank,Treasury Mumbai ,India For Further Credit to A/C No. 2186002800000067 of Nipha Exports (P) Ltd. with Punjab National Bank,Large Corporate Branch, United Tower, 2nd Floor, 11 Hemanta Basu Sa
"rani, Kolkata -700001, India' .

 wa-client = sy-mandt.
 wa-currency_id = 'INR'.
 wa-country = 'INDIA'.
 wa-description = 'New Punjab National Bank,Large Corporate Branch, Kolkata-700016 , India.SWIFT CODE: PUNBINBBCPS Wire Transfer Instructions: Pay to Standard Chartered Bank, NY(SWIFT: SCBLUS33) For credit to A/c No. 3582-0808785-001UID-033086 of Pu' &&
'njab National Bank , Treasury Mumbai ,India For Further Credit to A/C No. 2186002800000067 of Nipha Exports (P) Ltd. with Punjab National Bank,Large Corporate Branch, United Tower, 2nd Floor, 11 Hemanta Basu Sarani, Kolkata -700001, India'  .
APPEND wa to itab.


*   delete existing entries in the database table
    DELETE FROM zcurrency_map.

*   insert the new table entries
    INSERT zcurrency_map FROM TABLE @itab.

*   output the result as a console message
    out->write( |{ sy-dbcnt } Currency Data inserted successfully!| ).




  ENDMETHOD.
ENDCLASS.
