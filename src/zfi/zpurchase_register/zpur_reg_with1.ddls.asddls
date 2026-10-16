@AbapCatalog.sqlViewName: 'ZPUR_REG_WITH1_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Reg. Withhoding data'
//@Metadata.ignorePropagatedAnnotations: true
define view ZPUR_REG_WITH1 as select from ZPURCHASE_REGISTER as a
{
    key a.CompanyCode,
    key a.AccountingDocument,
    key a.FiscalYear,
        a.wit_base_amount,
        a.withholding_tax_amt,
        a.WithholdingTaxCode,
        min(a.AccountingDocumentItem ) as AccountingDocumentItem 
//    cast(a.wit_base_amount as abap.dec( 23, 2 )) as w_base_amount ,
    
//    
//    cast(a.wit_base_amount as abap.dec( 15, 2 )) as ,
//    cast(a.withholding_tax_amt as abap.dec( 23, 2 )) as w_tax_amt,
    
}
group by a.CompanyCode,
         a.AccountingDocument,
         a.FiscalYear ,      
         a.wit_base_amount,
         a.withholding_tax_amt,
         a.WithholdingTaxCode
