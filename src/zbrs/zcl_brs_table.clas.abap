CLASS zcl_brs_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  interfaces if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BRS_TABLE IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.
DATA: lt_BRS_TAB1 TYPE TABLE OF ZBRS_TAB1.

          lt_BRS_TAB1 = value #(  (
                          client  = SY-mandt
                          houseid = 'PN403'
                          bankid  = 'PN403'
                          gl1     = '0015751120'
                          gl2     = '0015751122'
                          gl3     = '0015751121'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PN179'
                          bankid  = 'PN179'
                          gl1     = '0015751150'
                          gl2     = '0015751152'
                          gl3     = '0015751151'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PN267'
                          bankid  = 'PN267'
                          gl1     = '0015751160'
                          gl2     = '0015751162'
                          gl3     = '0015751161'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PN067'
                          bankid  = 'PN067'
                          gl1     = '0015751170'
                          gl2     = '0015751172'
                          gl3     = '0015751171'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PN487'
                          bankid  = 'PN487'
                          gl1     = '0015751180'
                          gl2     = '0015751182'
                          gl3     = '0015751181'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PN342'
                          bankid  = 'PN342'
                          gl1     = '0015751190'
                          gl2     = '0015751192'
                          gl3     = '0015751191'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PN560'
                          bankid  = 'PN560'
                          gl1     = '0015752110'
                          gl2     = '0015752112'
                          gl3     = '0015752111'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PB167'
                          bankid  = 'PB167'
                          gl1     = '0015751220'
                          gl2     = '0015751222'
                          gl3     = '0015751221'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PN042'
                          bankid  = 'PN042'
                          gl1     = '0015752190'
                          gl2     = '0015752192'
                          gl3     = '0015752191'
                           )
                           (
                          client  = SY-mandt
                          houseid = 'PB179'
                          bankid  = 'PB179'
                          gl1     = '0015751150'
                          gl2     = '0015751152'
                          gl3     = '0015751151'
                           )
                            ).
    delete from ZBRS_TAB1.

    INSERT ZBRS_TAB1 FROM TABLE @lt_BRS_TAB1.



 ENDMETHOD.
ENDCLASS.
