@AbapCatalog.sqlViewName: 'ZGSTR2TBA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_TBA'
define view ZGSTR2_TBA 
as select from I_OperationalAcctgDocItem as A 
left outer join ZGSTR2_TBAM as B on ( B.AccountingDocument = A.AccountingDocument and B.TaxItemAcctgDocItemRef = A.TaxItemAcctgDocItemRef and
                                      B.FiscalYear = A.FiscalYear and B.CompanyCode = A.CompanyCode )
left outer join ZGSTR2_TBAS as C on ( C.AccountingDocument = A.AccountingDocument and C.TaxItemAcctgDocItemRef = A.TaxItemAcctgDocItemRef and
                                      C.FiscalYear = A.FiscalYear and C.CompanyCode = A.CompanyCode )    
left outer join ZGSTR2_TBAP as D on ( D.AccountingDocument = A.AccountingDocument and D.TaxItemAcctgDocItemRef = A.TaxItemAcctgDocItemRef and
                                      D.FiscalYear = A.FiscalYear and D.CompanyCode = A.CompanyCode )                                                                        
{
A.AccountingDocument,
A.AccountingDocumentItem ,
A.FiscalYear,
A.CompanyCode,
A.TaxDeterminationDate,
A.TaxCode,
A.TaxItemGroup,
A.TaxItemAcctgDocItemRef,
//cast(sum(AmountInCompanyCodeCurrency) as  abap.dec( 16,3 ) ) as TAX_BASE_AMOUNT
A.AmountInCompanyCodeCurrency as TAX_BAS_AMOUNT,
B.TBA_M,
C.TBA_S,
D.TBA_P,

case when ( A.TransactionTypeDetermination = 'ANL'  ) then 
A.AmountInCompanyCodeCurrency else 
 
 ( cast( case when A.AmountInCompanyCodeCurrency is not null then A.AmountInCompanyCodeCurrency  else 0 end as abap.dec( 23, 2 ) ) ) +
   ( cast( case when B.TBA_M is not null then B.TBA_M else 0 end as abap.dec( 23, 2 ) ) ) +
//   ( cast( case when C.TBA_S is not null then C.TBA_S else 0 end as abap.dec( 16, 3 ) ) ) +
   ( cast( case when D.TBA_P is not null then D.TBA_P else 0 end as abap.dec( 23, 2 ) ) ) end  as TAX_BASE_AMOUNT
   
    
}
where ( A.AccountingDocumentItemType = 'W' or A.AccountingDocumentItemType = '' or A.AccountingDocumentItemType = 'F' or 
        A.AccountingDocumentItemType = 'S' or A.AccountingDocumentItemType = 'G' )
  and ( A.TaxCode <> 'BA' or A.TaxCode <> 'BB' or A.TaxCode <> 'BC' or A.TaxCode <> 'BD' or A.TaxCode <> 'BI' or A.TaxCode <> 'BJ' or
        A.TaxCode <> 'BK' or A.TaxCode <> 'DA' or A.TaxCode <> 'DB'or A.TaxCode <> 'DC'or A.TaxCode <> 'DD'or A.TaxCode <> 'DI'or A.TaxCode <> 'DJ'or 
        A.TaxCode <> 'BL' or A.TaxCode <> 'DK'or A.TaxCode <> 'DL' or
        A.TaxCode <> 'F0' or A.TaxCode <> 'F1' or A.TaxCode <> 'F2' or A.TaxCode <> 'F3' or A.TaxCode <> 'F4' or A.TaxCode <> 'F5' 
       or A.TaxCode <> 'F6' or A.TaxCode <> 'F7' or A.TaxCode <> 'F8' or A.TaxCode <> 'G0' or A.TaxCode <> 'G1' or A.TaxCode <> 'G2' 
       or A.TaxCode <> 'G3' or A.TaxCode <> 'G4' or A.TaxCode <> 'G5' or A.TaxCode <> 'G6' or A.TaxCode <> 'G7' or A.TaxCode <> 'G8' 
       or A.TaxCode <> 'H1' or A.TaxCode <> 'H2' or A.TaxCode <> 'H3' or A.TaxCode <> 'H4' or A.TaxCode <> 'H5' or A.TaxCode <> 'H6'
       or A.TaxCode <> 'IS' or A.TaxCode <> 'J5' or A.TaxCode <> 'J6' or A.TaxCode <> 'JG' or A.TaxCode <> 'JH' or A.TaxCode <> 'JI' 
       or A.TaxCode <> 'JJ' or A.TaxCode <> 'JK' or A.TaxCode <> 'JL' or A.TaxCode <> 'JM' or A.TaxCode <> 'JN' or A.TaxCode <> 'JO' 
       or A.TaxCode <> 'JP' or A.TaxCode <> 'JQ' or A.TaxCode <> 'JR' or A.TaxCode <> 'JS' or A.TaxCode <> 'JT' or A.TaxCode <> 'K1' 
       or A.TaxCode <> 'K2' or A.TaxCode <> 'K3' or A.TaxCode <> 'K4' or A.TaxCode <> 'K9' or A.TaxCode <> 'L1' or A.TaxCode <> 'NT'  
       or A.TaxCode <> 'RN' or A.TaxCode <> 'RS' or A.TaxCode <> 'U1' or A.TaxCode <> 'U2' or A.TaxCode <> 'X1'  )
  and ( A.TransactionTypeDetermination = 'WRX' or A.TransactionTypeDetermination = '' or A.TransactionTypeDetermination = 'BSX' or
        A.TransactionTypeDetermination = 'FR1' or A.TransactionTypeDetermination = 'ANL' or A.TransactionTypeDetermination = 'FR2' or 
        A.TransactionTypeDetermination = 'KBS' )
  and A.TaxDeterminationDate is not initial and A.TaxItemAcctgDocItemRef <> '000000'

