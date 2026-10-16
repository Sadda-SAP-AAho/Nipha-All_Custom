@AbapCatalog.sqlViewName: 'ZTEST_CDS1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase REgister'
define view ZTEST_CDS as select distinct from ZPUR_REG_DOC as a
left outer join I_JournalEntry as b on ( b.CompanyCode = a.CompanyCode and b.AccountingDocument = a.AccountingDocument
                               and b.FiscalYear = a.FiscalYear )  
left outer join ZPUR_WIT_AMT as c on (c.CompanyCode = a.CompanyCode and c.AccountingDocument = a.AccountingDocument
                               and c.FiscalYear = a.FiscalYear  and c.AccountingDocumentItem = a.AccountingDocumentItem)   
left outer join ZPUR_WIT_AMT2 as d on (d.CompanyCode = a.CompanyCode and d.AccountingDocument = a.AccountingDocument
                               and d.FiscalYear = a.FiscalYear and d.AccountingDocumentItem = a.AccountingDocumentItem  )   
left outer join ZPUR_TEXT as e on ( e.CompanyCode = a.CompanyCode and e.AccountingDocument = a.AccountingDocument
                               and e.FiscalYear = a.FiscalYear )
left outer join ZPUR_SUPP as ee on ( ee.CompanyCode = ee.CompanyCode and ee.AccountingDocument = a.AccountingDocument
                               and ee.FiscalYear = a.FiscalYear)                               
left outer join ZSUPPLIER_DETAILS as f on f.Supplier = ee.Supplier  
left outer join ZPUR_REG_GL as g on ( g.CompanyCode = a.CompanyCode and g.AccountingDocument = a.AccountingDocument
                               and g.FiscalYear = a.FiscalYear and g.AccountingDocumentItem = a.AccountingDocumentItem)        
left outer join I_GLAccountTextRawData as h on (h.GLAccount = g.GLAccount and h.ChartOfAccounts = 'YCOA' and h.Language = 'E' )       
left outer join ZPUR_CDS1 as i on (i.CompanyCode = a.CompanyCode and i.AccountingDocument = a.AccountingDocument
                               and i.FiscalYear = a.FiscalYear )
left outer join ZPUR_CDS2 as j on (j.CompanyCode = a.CompanyCode and j.AccountingDocument = a.AccountingDocument
                               and j.FiscalYear = a.FiscalYear )    
left outer join ZPUR_Taxcode as k on ( k.CompanyCode = a.CompanyCode and k.AccountingDocument = a.AccountingDocument
                               and k.FiscalYear = a.FiscalYear and k.GLAccount = g.GLAccount ) 
left outer join I_TaxCodeText as l on l.TaxCode = a.TaxCode   
left outer join ZPUR_REG_INV_AMT as m on ( m.CompanyCode = a.CompanyCode and m.AccountingDocument = a.AccountingDocument
                               and m.FiscalYear = a.FiscalYear and m.AccountingDocumentItemType = ' ' and m.GLAccount = g.GLAccount)   
left outer join ZPUR_CGST as n on ( n.CompanyCode = a.CompanyCode and n.AccountingDocument = a.AccountingDocument
                               and n.FiscalYear = a.FiscalYear and n.TaxItemGroup = a.TaxItemGroup and n.TransactionTypeDetermination = 'JIC')   
left outer join ZPUR_SGST as o on ( o.CompanyCode = a.CompanyCode and o.AccountingDocument = a.AccountingDocument
                               and o.FiscalYear = a.FiscalYear and o.TaxItemGroup = a.TaxItemGroup and o.TransactionTypeDetermination = 'JIS')       
left outer join ZPUR_IGST as p on ( p.CompanyCode = a.CompanyCode and p.AccountingDocument = a.AccountingDocument
                               and p.FiscalYear = a.FiscalYear and p.TaxItemGroup = a.TaxItemGroup and p.AccountingDocumentItem = a.AccountingDocumentItem)  
left outer join ZPUR_RCM_CGST as q on ( q.CompanyCode = a.CompanyCode and q.AccountingDocument = a.AccountingDocument
                               and q.FiscalYear = a.FiscalYear and q.TaxItemGroup = a.TaxItemGroup)    
left outer join ZPUR_RCM_SGST as r on ( r.CompanyCode = a.CompanyCode and r.AccountingDocument = a.AccountingDocument
                               and r.FiscalYear = a.FiscalYear and r.TaxItemGroup = a.TaxItemGroup)   
left outer join ZPUR_RCM_IGST as s on ( s.CompanyCode = a.CompanyCode and s.AccountingDocument = a.AccountingDocument
                               and s.FiscalYear = a.FiscalYear and s.TaxItemGroup = a.TaxItemGroup)  
left outer join ZPUR_REG_NC_CGST_AMT as t on (t.CompanyCode = a.CompanyCode and t.AccountingDocument = a.AccountingDocument
                               and t.FiscalYear = a.FiscalYear )  
left outer join ZPUR_REG_NC_IGST_AMT as u on (u.CompanyCode = a.CompanyCode and u.AccountingDocument = a.AccountingDocument
                               and u.FiscalYear = a.FiscalYear )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
{
key a.FiscalYear,
key a.CompanyCode,
key a.AccountingDocument,
key a.AccountingDocumentItem,
key g.GLAccount,
b.DocumentReferenceID,
a.BusinessPlace,
a.TaxSection,
c.AmountInCompanyCodeCurrency as wit_base_amount,
//d.WithholdingTaxAmount,
d.AmountInTransactionCurrency as withholding_tax_amt,
d.WithholdingTaxCode,
a.DocumentDate,
a.PostingDate,
a.AccountingDocumentType,
e.DocumentItemText,
ee.Supplier,
f.SupplierFullName,
a.IN_GSTPlaceOfSupply,
f.TaxNumber3,
f.BusinessPartnerPanNumber,
f.SupplierAccountGroup,
h.GLAccountName,   
i.ProfitCenter,
i.CostCenter,
j.Segment,
k.TaxCode,
l.TaxCodeName,
////m.AmountInCompanyCodeCurrency,
case when k.TaxCode = 'DA' or k.TaxCode = 'DB'
 or k.TaxCode = 'DC' or g.TaxCode = 'DD' or k.TaxCode = 'DI' or k.TaxCode = 'DJ' or k.TaxCode = 'DK' or k.TaxCode = 'DL' then m.OriglTaxBaseAmountInCoCodeCrcy
 when k.TaxCode = 'BA' or k.TaxCode = 'BB' or k.TaxCode = 'BC' or k.TaxCode = 'BD' or k.TaxCode = 'BI' or k.TaxCode = 'BJ'
 or k.TaxCode = 'BK' or k.TaxCode = 'BL' then m.OriglTaxBaseAmountInCoCodeCrcy else m.AmountInCompanyCodeCurrency end as basic_inv_amt,
n.AmountInTransactionCurrency as cgst_amt,
o.AmountInTransactionCurrency as sgst_amt,
p.AmountInTransactionCurrency as igst_amt,
q.AmountInTransactionCurrency as cgst_rcm_amt,
r.AmountInTransactionCurrency as sgst_rcm_amt,
s.AmountInTransactionCurrency as igst_rcm_amt,
cast(cast(t.NonDcblTaxAbsltAmtInCoCodeCrcy as abap.decfloat16) / cast(2 as abap.decfloat16)  as abap.decfloat16 ) as no_credit_cgst_amt,
cast(cast(t.NonDcblTaxAbsltAmtInCoCodeCrcy as abap.decfloat16) / cast(2 as abap.decfloat16)  as abap.decfloat16 ) as no_credit_sgst_amt,
cast(cast(u.NonDcblTaxAbsltAmtInCoCodeCrcy as abap.decfloat16) / cast(2 as abap.decfloat16)  as abap.decfloat16 ) as no_credit_igst_amt,
( cast( case when q.AmountInTransactionCurrency is not null then q.AmountInTransactionCurrency  else 0 end as abap.dec( 16, 3 ) ) ) + 
( cast( case when r.AmountInTransactionCurrency is not null then r.AmountInTransactionCurrency  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when s.AmountInTransactionCurrency is not null then s.AmountInTransactionCurrency  else 0 end as abap.dec( 16, 3 ) ) ) as total_rcm_payable

}

