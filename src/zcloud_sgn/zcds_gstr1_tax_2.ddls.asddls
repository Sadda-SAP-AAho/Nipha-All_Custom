@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - GSTR1 Tax Data 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_gstr1_tax_2 as select from I_OperationalAcctgDocItem as a
left outer join I_Customer as b on a.Customer = b.Customer
left outer join I_RegionText as i on b.Country = i.Country and b.Region = i.Region and i.Language = 'E'
left outer join I_JournalEntry as f on a.CompanyCode = f.CompanyCode and a.AccountingDocument = f.AccountingDocument
 and a.FiscalYear = f.FiscalYear 
left outer join I_OperationalAcctgDocItem as e on a.AccountingDocument = e.AccountingDocument //CGST
 and a.CompanyCode = e.CompanyCode and a.FiscalYear = e.FiscalYear and e.AccountingDocumentItemType = 'T' 
 and e.FinancialAccountType = 'S' and e.TransactionTypeDetermination = 'JOC'
left outer join I_OperationalAcctgDocItem as c on e.AccountingDocument = c.AccountingDocument //SGST
 and e.CompanyCode = c.CompanyCode and e.FiscalYear = c.FiscalYear and e.TaxItemAcctgDocItemRef = c.TaxItemAcctgDocItemRef
 and ( c.TransactionTypeDetermination = 'JOS' or c.TransactionTypeDetermination = 'JOU' ) and c.AccountingDocumentItemType = 'T'
left outer join I_OperationalAcctgDocItem as h on a.AccountingDocument = h.AccountingDocument //IGST
 and a.CompanyCode = h.CompanyCode and a.FiscalYear = h.FiscalYear and h.AccountingDocumentItemType = 'T' 
 and h.FinancialAccountType = 'S' and h.TransactionTypeDetermination = 'JOI'
 ------------ added on 19-05-2024 vvk---------------------------
 /*left outer join I_OperationalAcctgDocItem as j on j.AccountingDocument = a.AccountingDocument //Non Taxable
 and j.CompanyCode = a.CompanyCode and j.FiscalYear = a.FiscalYear and j.AccountingDocumentItemType = 'R' 
 and j.FinancialAccountType = 'S'  and j.TransactionTypeDetermination = ' ' */
/* //ended------------ added on 19-05-2024---------------------------
//left outer join I_OperationalAcctgDocItem as j on a.AccountingDocument = j.AccountingDocument //TCS
// and a.CompanyCode = j.CompanyCode and a.FiscalYear = j.FiscalYear and j.AccountingDocumentItemType = 'T' 
// and j.FinancialAccountType = 'S' and j.TransactionTypeDetermination = 'JTC'*/
 {
 key a.AccountingDocument,
 key a.CompanyCode,
 key a.FiscalYear,
 key a.AccountingDocumentItem,
 a.FiscalPeriod,
 a.CompanyCodeCurrency,
 a.TransactionCurrency,
 a.BusinessPlace,
 a.CompanyCodeCurrencyDetnMethod,
 b.Customer,
 b.CustomerName,
 b.TaxNumber3,
 b.Region,
 i.RegionName,
 f.PostingDate,
 f.DocumentDate,
 f.OriginalReferenceDocument,
 f.DocumentReferenceID,
 f.AccountingDocumentType,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.AmountInTransactionCurrency,// added by vvk
// j.Plant as plant1, // added by vvk
 coalesce( e.TaxCode,h.TaxCode ) as TaxCode,
 coalesce( e.ChartOfAccounts,h.ChartOfAccounts ) as ChartOfAccounts,
 case when f.AccountingDocumentType = 'RV' or f.AccountingDocumentType = 'DR' // DR DG ADD BY VVK
 or f.AccountingDocumentType = 'DG'
 then cast(f.OriginalReferenceDocument as abap.char( 10 )) end as billingdoc,
 coalesce( e.Plant, h.Plant) as Plant, // old code 
 //a.Plant as plant,
 coalesce(a.IN_GSTPlaceOfSupply,coalesce( e.IN_GSTPlaceOfSupply,h.IN_GSTPlaceOfSupply )) as IN_GSTPlaceOfSupply,
 coalesce( e.TaxItemAcctgDocItemRef,h.TaxItemAcctgDocItemRef ) as TaxItemAcctgDocItemRef,
 coalesce( e.TransactionTypeDetermination, h.TransactionTypeDetermination ) as TransactionTypeDetermination,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(a.AmountInCompanyCodeCurrency) as BASE_AMT1,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce(e.TaxBaseAmountInCoCodeCrcy,h.TaxBaseAmountInCoCodeCrcy)) as BASE_AMT,// - OLD CODE
 //abs(coalesce(e.TaxBaseAmountInCoCodeCrcy,coalesce(h.TaxBaseAmountInCoCodeCrcy ,j.TaxBaseAmountInCoCodeCrcy))) as BASE_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(e.AmountInCompanyCodeCurrency) as CGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(c.AmountInCompanyCodeCurrency) as SGST_AMT,
 //abs(e.AmountInCompanyCodeCurrency) as SGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(h.AmountInCompanyCodeCurrency) as IGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce( (e.AmountInCompanyCodeCurrency * 2), h.AmountInCompanyCodeCurrency )) as TOT_TAX,
// @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
// abs(j.AmountInCompanyCodeCurrency) as TCS_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce( ((e.AmountInCompanyCodeCurrency * 2) + e.TaxBaseAmountInCoCodeCrcy), (h.AmountInCompanyCodeCurrency + h.TaxBaseAmountInCoCodeCrcy) )) as TOT_INVOICE 
 }
where a.FinancialAccountType = 'D'
