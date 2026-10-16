@AbapCatalog.sqlViewName: 'ZGSTR2_BEF_FIN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_BEFORE_FINAL'
define view ZGSTR2_BEFORE_FINAL 
as select from I_OperationalAcctgDocItem as A 
left outer join I_JournalEntry as B on ( B.AccountingDocument = A.AccountingDocument and B.FiscalYear = A.FiscalYear and B.CompanyCode = A.CompanyCode )
left outer join ZGSTR2_CDS1 as C on ( C.AccountingDocument = A.AccountingDocument and C.TaxItemGroup = A.TaxItemGroup and C.CompanyCode  = A.CompanyCode and 
                                      C.FiscalYear = A.FiscalYear )
left outer join I_KR_BusinessPlace as D on ( D.Branch = C.BusinessPlace  )
left outer join I_ProfitCenterText as E on ( E.ProfitCenter = C.ProfitCenter and E.Language = 'E' )
left outer join I_SegmentText      as F on ( F.Segment = C.Segment and F.Language = 'E' )
left outer join ZMMR01_SUPPLIER as G on ( G.AccountingDocument = A.AccountingDocument and G.FiscalYear = A.FiscalYear  )
left outer join I_ProductDescription as H on ( H.Product = C.Material )
left outer join I_TaxCodeText        as I on ( I.TaxCode = A.TaxCode and I.Language = 'E' )
left outer join ZGSTR2_TBA as J on ( J.AccountingDocument = A.AccountingDocument and J.AccountingDocumentItem = A.AccountingDocumentItem and J.TaxItemAcctgDocItemRef = A.TaxItemAcctgDocItemRef and
                                     J.CompanyCode = A.CompanyCode and J.FiscalYear = A.FiscalYear )
left outer join ZGSTR2_NOCR_TBA  as JJ on ( JJ.AccountingDocument = A.AccountingDocument and JJ.AccountingDocumentItem = A.AccountingDocumentItem and JJ.TaxItemAcctgDocItemRef = A.TaxItemAcctgDocItemRef  )
left outer join ZGSTR2_RCMTBA    as JJJ on ( JJJ.AccountingDocument = A.AccountingDocument and JJJ.AccountingDocumentItem = A.AccountingDocumentItem and JJJ.TaxItemAcctgDocItemRef = A.TaxItemAcctgDocItemRef )
left outer join ZGSTR2_NOCRTBAREIGCSG as JJJJ on ( JJJJ.AccountingDocument = A.AccountingDocument and JJJJ.AccountingDocumentItem = A.TaxItemGroup and 
                                                   JJJJ.CompanyCode = A.CompanyCode and JJJJ.FiscalYear = A.FiscalYear )
left outer join ZGSTR2_NOCRTBAREIGCSG as JG on ( JG.AccountingDocument = A.AccountingDocument and JG.AccountingDocumentItem = A.AccountingDocumentItem and 
                                                 JG.CompanyCode = A.CompanyCode and JG.FiscalYear = A.FiscalYear )

left outer join ZGSTR2_JIC as K on     ( K.AccountingDocument = A.AccountingDocument and K.FiscalYear = A.FiscalYear and 
                                         K.CompanyCode = A.CompanyCode and K.TaxItemGroup = A.TaxItemGroup  )
left outer join ZGSTR2_JII as L on     ( L.AccountingDocument = A.AccountingDocument and L.FiscalYear = A.FiscalYear and 
                                         L.CompanyCode = A.CompanyCode and L.TaxItemGroup = A.TaxItemGroup  )
left outer join ZGSTR2_PAYCGST as M on ( M.AccountingDocument = A.AccountingDocument and M.FiscalYear = A.FiscalYear and 
                                         M.CompanyCode = A.CompanyCode and M.TaxItemGroup = A.TaxItemGroup )
left outer join ZGSTR2_PAYIGST as N on ( N.AccountingDocument = A.AccountingDocument and N.FiscalYear = A.FiscalYear and 
                                         N.CompanyCode = A.CompanyCode and N.TaxItemGroup = A.TaxItemGroup )
left outer join ZGSTR2_CR_CGST as O on ( O.AccountingDocument = A.AccountingDocument and O.FiscalYear = A.FiscalYear and 
                                         O.CompanyCode = A.CompanyCode and O.TaxItemGroup = A.TaxItemGroup )
left outer join ZGSTR2_NOCR_CSGST as OO on ( OO.AccountingDocument = A.AccountingDocument and OO.FiscalYear = A.FiscalYear and 
                                             OO.CompanyCode = A.CompanyCode and OO.TaxItem = A.AccountingDocumentItem  ) 
left outer join ZGSTR2_NOCR_IGST as PP on ( PP.AccountingDocument = A.AccountingDocument and PP.FiscalYear = A.FiscalYear and 
                                            PP.CompanyCode = A.CompanyCode and PP.TaxItem = A.TaxItemGroup )                                                                                 
left outer join ZGSTR2_CR_IGST as P on ( P.AccountingDocument = A.AccountingDocument and P.FiscalYear = A.FiscalYear and 
                                         P.CompanyCode = A.CompanyCode and P.TaxItemGroup = A.TaxItemGroup )     
left outer join ZGSTR2_JIM as U on     ( U.AccountingDocument = A.AccountingDocument and U.FiscalYear = A.FiscalYear and 
                                         U.CompanyCode = A.CompanyCode and U.TaxItemGroup = A.TaxItemGroup  )                                                                                                              
                                                                                                                                                    
left outer join ZGSTR2_GLFINAL2 as Q on ( Q.AccountingDocument = A.AccountingDocument and Q.AccountingDocumentItem = A.AccountingDocumentItem 
                                           and Q.CompanyCode = A.CompanyCode and Q.FiscalYear = A.FiscalYear ) // added by Pintu on 20.11.25

left outer join I_GLAccountTextRawData as R on ( R.GLAccount = Q.GLACCOUNTS and R.Language = 'E' )     
left outer join I_KR_BusinessPlace as S on ( S.Branch = A.BusinessPlace )       
left outer join I_Plant as T on ( T.Plant = A.Plant )   
                          
{
key A.CompanyCode,
key A.FiscalYear,
key A.AccountingDocument,
A.AccountingDocumentItem,
A.AccountingDocumentType,
A.FiscalPeriod,
A.PostingDate,
A.DocumentDate,
A.TaxCode,
A.TaxItemGroup,
A.BaseUnit,
A.FunctionalCurrency,
A.TransactionTypeDetermination,
B.AccountingDocumentCreationDate,
B.DocumentReferenceID,
C.BusinessPlace,
C.ProfitCenter,
C.Segment,
C.Material,
C.Quantity,
C.IN_HSNOrSACCode,
C.GoodsMovementEntryUnit,
D.BusinessPlaceName,
E.ProfitCenterName,
F.SegmentName,
G.Supplier,
G.SupplierName,
G.TaxNumber3 as GSTIN,
G.Region,
G.RegionName,
G.IN_GSTPlaceOfSupply,
H.ProductDescription,
I.TaxCodeName,
J.TAX_BASE_AMOUNT,
JJ.AMLOUNT_NOCR_TBA ,
JG.AMT_NOCRTBA_RECSG,
JJJJ.AMLOUNT_NOCRRE_TBAIG,
JJJJ.AMLOUNT_NOCRRE_TBA,
JJJ.AMLOUNT_RCM_TBA,
K.AMOUNT_JIC,
K.AMOUNT_JIC as AMOUNT_JIS,
L.AMOUNT_JII,
//L.AMOUNT_JII as AMOUNT_JIM, 
U.AMOUNT_JIM,
M.AMOUNT_PAYCGST,
M.AMOUNT_PAYCGST as AMOUNT_PAYSGST,
N.AMOUNT_PAYIGST,
O.TWO,
O.AMOUNT_CR_CGST,
O.AMOUNT_CR_CGST as AMOUNT_CR_SGST,
OO.AMOUNT_CRRE_CGST,
OO.AMOUNT_CRRE_CGST as AMOUNT_CRRE_SGST,
P.AMOUNT_CR_IGST as AMOUNT_CROT_IGST ,
PP.AMOUNT_CRRE_IGST,
Q.GLACCOUNTS,
R.GLAccountLongName,
S.TaxNumber1 as BUSINESS_PLACE_GSTIN,
A.OriginalReferenceDocument, 
A.Plant,
T.PlantName as PLANTNAME,
'' as TCS_AMOUNT,


case when A.AccountingDocumentType <> 'RE' and O.AMOUNT_CR_CGST is not null then
//O.AMOUNT_CR_CGST / O.TWO else 0 end as AMT_CR_CGST,
cast( O.AMOUNT_CR_CGST / O.TWO as abap.dec( 23,2 ) ) else 0 end as AMT_CR_CGST,

case when JG.AMT_NOCRTBA_RECSG <> 0 then
JG.AMT_NOCRTBA_RECSG  else JJJJ.AMLOUNT_NOCRRE_TBAIG end as AMT_NOCRRE_TBACSI,


case when A.AccountingDocumentType = 'RE' then 
PP.AMOUNT_CRRE_IGST  else  P.AMOUNT_CR_IGST end as AMOUNT_CR_IGST,


( cast( case when M.AMOUNT_PAYCGST is not null then M.AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 3 ) ) ) + 
( cast( case when M.AMOUNT_PAYCGST is not null then M.AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 3 ) ) ) +
( cast( case when N.AMOUNT_PAYIGST is not null then N.AMOUNT_PAYIGST  else 0 end as abap.dec( 23, 3 ) ) ) as TOTAL_RCM_PAYABLE,




( cast( case when K.AMOUNT_JIC is not null then K.AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when K.AMOUNT_JIC is not null then K.AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when L.AMOUNT_JII is not null then L.AMOUNT_JII  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when O.AMOUNT_CR_CGST is not null then O.AMOUNT_CR_CGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when O.AMOUNT_CR_CGST is not null then O.AMOUNT_CR_CGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when P.AMOUNT_CR_IGST is not null then P.AMOUNT_CR_IGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when M.AMOUNT_PAYCGST is not null then M.AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when M.AMOUNT_PAYCGST is not null then M.AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when N.AMOUNT_PAYIGST is not null then N.AMOUNT_PAYIGST  else 0 end as abap.dec( 23, 2 ) ) ) as TOTAL_TAX_VALUE,

( cast( case when J.TAX_BASE_AMOUNT is not null then J.TAX_BASE_AMOUNT  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when JJ.AMLOUNT_NOCR_TBA is not null then JJ.AMLOUNT_NOCR_TBA  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when K.AMOUNT_JIC is not null then K.AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when K.AMOUNT_JIC is not null then K.AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when L.AMOUNT_JII is not null then L.AMOUNT_JII  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when O.AMOUNT_CR_CGST is not null then O.AMOUNT_CR_CGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when O.AMOUNT_CR_CGST is not null then O.AMOUNT_CR_CGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when P.AMOUNT_CR_IGST is not null then P.AMOUNT_CR_IGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when M.AMOUNT_PAYCGST is not null then M.AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when M.AMOUNT_PAYCGST is not null then M.AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when N.AMOUNT_PAYIGST is not null then N.AMOUNT_PAYIGST  else 0 end as abap.dec( 23, 2 ) ) ) as TOTAL_INVOICE_AMOUNT,
B.AccountingDocCreatedByUser



}
where ( A.AccountingDocumentType = 'RE' or A.AccountingDocumentType = 'KR' or A.AccountingDocumentType = 'KG' or A.AccountingDocumentType = 'SA' )
    and ( A.AccountingDocumentItemType = 'W' or A.AccountingDocumentItemType = '' or A.AccountingDocumentItemType = 'F' or 
          A.AccountingDocumentItemType = 'S' or A.AccountingDocumentItemType = 'G'  )
    and ( A.FinancialAccountType = 'S' or A.FinancialAccountType = 'A' )
    and   A.TaxDeterminationDate is not initial and A.TaxItemAcctgDocItemRef <> '000000'
    and ( A.TransactionTypeDetermination = 'WRX' or A.TransactionTypeDetermination = '' or A.TransactionTypeDetermination = 'BSX' or
          A.TransactionTypeDetermination = 'FR1' or A.TransactionTypeDetermination = 'ANL' or A.TransactionTypeDetermination = 'FR2' or
          A.TransactionTypeDetermination = 'KBS' )    
    and A.TaxCode <> 'F0' and A.TaxCode <> 'F1' and A.TaxCode <> 'F2' and A.TaxCode <> 'F3' and A.TaxCode <> 'F4' and A.TaxCode <> 'F5' 
    and A.TaxCode <> 'F6' and A.TaxCode <> 'F7' and A.TaxCode <> 'F8' and A.TaxCode <> 'G0' and A.TaxCode <> 'G1' and A.TaxCode <> 'G2' 
    and A.TaxCode <> 'G3' and A.TaxCode <> 'G4' and A.TaxCode <> 'G5' and A.TaxCode <> 'G6' and A.TaxCode <> 'G7' and A.TaxCode <> 'G8' 
    and A.TaxCode <> 'H1' and A.TaxCode <> 'H2' and A.TaxCode <> 'H3' and A.TaxCode <> 'H4' and A.TaxCode <> 'H5' and A.TaxCode <> 'H6'
    and A.TaxCode <> 'IS' and A.TaxCode <> 'J5' and A.TaxCode <> 'J6' and A.TaxCode <> 'JG' and A.TaxCode <> 'JH' and A.TaxCode <> 'JI' 
    and A.TaxCode <> 'JJ' and A.TaxCode <> 'JK' and A.TaxCode <> 'JL' and A.TaxCode <> 'JM' and A.TaxCode <> 'JN' and A.TaxCode <> 'JO' 
    and A.TaxCode <> 'JP' and A.TaxCode <> 'JQ' and A.TaxCode <> 'JR' and A.TaxCode <> 'JS' and A.TaxCode <> 'JT' and A.TaxCode <> 'K1' 
    and A.TaxCode <> 'K2' and A.TaxCode <> 'K3' and A.TaxCode <> 'K4' and A.TaxCode <> 'K9' and A.TaxCode <> 'L1' and A.TaxCode <> 'NT'  
    and A.TaxCode <> 'RN' and A.TaxCode <> 'RS' and A.TaxCode <> 'U1' and A.TaxCode <> 'U2' and A.TaxCode <> 'X1' 

