CLASS zcl_withholding_desc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  interfaces if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_WITHHOLDING_DESC IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.
DATA: lt_withhold TYPE TABLE OF zwithholdtaxdesc .
      lt_withhold = value #(  (
                          client  = SY-mandt
                           tax_code = 'AB'
                           tax_type = 'A0'
                           type_desc  = 'INV_194 : TDS : PAY DIVIDEND - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'AB'
                           tax_type = 'A1'
                           type_desc  = 'INV_194 : TDS : PAY DIVIDEND - 20%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'AC'
                           tax_type = 'A1'
                           type_desc  = 'INV_194A : TDS : OTH THN INT SEC - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'AC'
                           tax_type = 'A2'
                           type_desc  = 'INV_194A : TDS : OTH THN INT SEC - 20%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'C0'
                           tax_type = 'C0'
                           type_desc  = 'INV_194C : TDS : PAY CONTRCTOR - 1%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'C0'
                           tax_type = 'C1'
                           type_desc  = 'INV_194C : TDS : PAY CONTRCTOR - 2%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'C0'
                           tax_type = 'IE'
                           type_desc  = 'INV_194C : TDS : PAY CONTRCTOR - 5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'D0'
                           tax_type = 'D0'
                           type_desc  = 'INV_194D : TDS : INSURNCE COMM - 3.75%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'D0'
                           tax_type = 'II'
                           type_desc  = 'INV_194D : TDS : INSURNCE COMM - 5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'D0'
                           tax_type = 'D1'
                           type_desc  = 'INV_194D : TDS : INSURNCE COMM - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = '1H'
                           tax_type = '1H'
                           type_desc  = 'INV_194H : TDS : COMM & BROKER - 3.75%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = '1H'
                           tax_type = 'IM'
                           type_desc  = 'INV_194H : TDS : COMM & BROKER - 7.5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'I0'
                           tax_type = 'I0'
                           type_desc  = 'INV_194I : TDS : RENT BUILD/PM - 2.0%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'I0'
                           tax_type = 'I2'
                           type_desc  = 'INV_194I : TDS : RENT BUILD/PM - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'I0'
                           tax_type = 'IO'
                           type_desc  = 'INV_194I : TDS : RENT BUILD/PM - 5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'I0'
                           tax_type = 'IP'
                           type_desc  = 'INV_194I : TDS : RENT BUILD/PM - 20%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J0'
                           tax_type = 'J0'
                           type_desc  = 'INV_194J : TDS : PROF FEES - 1.5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J0'
                           tax_type = 'J1'
                           type_desc  = 'INV_194J : TDS : PROF FEES - 2%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J0'
                           tax_type = 'J2'
                           type_desc  = 'INV_194J : TDS : PROF FEES - 5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J0'
                           tax_type = 'J3'
                           type_desc  = 'INV_194J : TDS : PROF FEES - 7.5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J0'
                           tax_type = 'J4'
                           type_desc  = 'INV_194J : TDS : PROF FEES - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J0'
                           tax_type = 'J5'
                           type_desc  = 'INV_194J : TDS : PROF FEES - 20%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'K3'
                           tax_type = 'K3'
                           type_desc  = 'INV_194K : TDS : INCOME FRM MF - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = '4Q'
                           tax_type = '4Q'
                           type_desc  = 'INV_194Q : TDS : PUR OF GOODS - 0.10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = '4Q'
                           tax_type = 'Q4'
                           type_desc  = 'INV_194Q : TDS : PUR OF GOODS - 5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'M0'
                           tax_type = 'M0'
                           type_desc  = 'INV_195 : TDS : PAY NON RESIDNT - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'M0'
                           tax_type = 'M1'
                           type_desc  = 'INV_195 : TDS : PAY NON RESIDNT - 20%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'I1'
                           tax_type = 'I1'
                           type_desc  = 'INV_19IA : TDS : IMMVBL PROPERTY - 1%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'I1'
                           tax_type = 'I2'
                           type_desc  = 'INV_19IA : TDS : IMMVBL PROPERTY - 20%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'L0'
                           tax_type = 'L0'
                           type_desc  = 'INV_194IA : TDS : INT INC BUS TR - 5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'L0'
                           tax_type = 'L1'
                           type_desc  = 'INV_194IA : TDS : INT INC BUS TR - 20%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'L1'
                           tax_type = 'L1'
                           type_desc  = 'INV_194LD : TDS : INT INC BOND - 5%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = '4H'
                           tax_type = '4H'
                           type_desc  =  'INV_206C : TCS - 0.10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = '4H'
                           tax_type = 'H4'
                           type_desc  = 'INV_206C : TCS - 1%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'H1'
                           tax_type = 'H1'
                           type_desc  = 'INV_194BP : TDS : WIN FRM LOTERRY - 30%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J3'
                           tax_type = 'J3'
                           type_desc  = 'INV_194RP : TDS : BENEFT OR PERQST - 10%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'J7'
                           tax_type = 'J7'
                           type_desc  = 'INV_194SP : TDS : VIRTUAL ASSET - 1%'
                           )
                           (
                           client  = SY-mandt
                           tax_code = 'G0'
                           tax_type = 'G0'
                           type_desc  = 'INV_194G : TDS : COM SALE LOTTRY - 5%'
                           )
                          ).

    delete from zwithholdtaxdesc.
    INSERT zwithholdtaxdesc FROM TABLE @lt_withhold.


 ENDMETHOD.
ENDCLASS.
