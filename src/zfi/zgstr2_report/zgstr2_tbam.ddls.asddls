@AbapCatalog.sqlViewName: 'ZGSTR_TBMA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_TBAM'
define view ZGSTR2_TBAM as select from I_OperationalAcctgDocItem
{
AccountingDocument,
AccountingDocumentItem ,
FiscalYear,
CompanyCode,
TaxDeterminationDate,
TaxCode,
TaxItemGroup,
TaxItemAcctgDocItemRef,
//cast(sum(AmountInCompanyCodeCurrency) as  abap.dec( 16,3 ) ) as TAX_BASE_AMOUNT
AmountInCompanyCodeCurrency as TBA_M

    
}
where   AccountingDocumentItemType = 'M' 
  and ( TaxCode <> '' or TaxCode <> 'BA' or TaxCode <> 'BB' or TaxCode <> 'BC' or TaxCode <> 'BD' or TaxCode <> 'BI' or TaxCode <> 'BJ' or
        TaxCode <> 'BK' or TaxCode <> 'DA' or TaxCode <> 'DB'or TaxCode <> 'DC'or TaxCode <> 'DD'or TaxCode <> 'DI'or TaxCode <> 'DJ'or 
        TaxCode <> 'BL' or TaxCode <> 'DK'or TaxCode <> 'DL' or
        TaxCode <> 'F0' or TaxCode <> 'F1' or TaxCode <> 'F2' or TaxCode <> 'F3' or TaxCode <> 'F4' or TaxCode <> 'F5' 
       or TaxCode <> 'F6' or TaxCode <> 'F7' or TaxCode <> 'F8' or TaxCode <> 'G0' or TaxCode <> 'G1' or TaxCode <> 'G2' 
       or TaxCode <> 'G3' or TaxCode <> 'G4' or TaxCode <> 'G5' or TaxCode <> 'G6' or TaxCode <> 'G7' or TaxCode <> 'G8' 
       or TaxCode <> 'H1' or TaxCode <> 'H2' or TaxCode <> 'H3' or TaxCode <> 'H4' or TaxCode <> 'H5' or TaxCode <> 'H6'
       or TaxCode <> 'IS' or TaxCode <> 'J5' or TaxCode <> 'J6' or TaxCode <> 'JG' or TaxCode <> 'JH' or TaxCode <> 'JI' 
       or TaxCode <> 'JJ' or TaxCode <> 'JK' or TaxCode <> 'JL' or TaxCode <> 'JM' or TaxCode <> 'JN' or TaxCode <> 'JO' 
       or TaxCode <> 'JP' or TaxCode <> 'JQ' or TaxCode <> 'JR' or TaxCode <> 'JS' or TaxCode <> 'JT' or TaxCode <> 'K1' 
       or TaxCode <> 'K2' or TaxCode <> 'K3' or TaxCode <> 'K4' or TaxCode <> 'K9' or TaxCode <> 'L1' or TaxCode <> 'NT'  
       or TaxCode <> 'RN' or TaxCode <> 'RS' or TaxCode <> 'U1' or TaxCode <> 'U2' or TaxCode <> 'X1' )
  and ( TransactionTypeDetermination = 'WRX' or TransactionTypeDetermination = '' or TransactionTypeDetermination = 'BSX' )
  and TaxDeterminationDate is not initial 


  
