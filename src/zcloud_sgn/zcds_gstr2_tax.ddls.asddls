@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - Tax Data For GSTR1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_gstr2_tax as select from I_OperationalAcctgDocItem as a
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
 {
 a.AccountingDocument,
 a.CompanyCode,
 a.FiscalYear,
 a.AccountingDocumentItem,
 a.FiscalPeriod,
 a.CompanyCodeCurrency,
 a.BusinessPlace,
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
 coalesce( e.TaxItemAcctgDocItemRef,h.TaxItemAcctgDocItemRef ) as TaxItemAcctgDocItemRef,
 coalesce( e.TransactionTypeDetermination, h.TransactionTypeDetermination ) as TransactionTypeDetermination,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce(e.TaxBaseAmountInCoCodeCrcy,h.TaxBaseAmountInCoCodeCrcy)) as BASE_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(e.AmountInCompanyCodeCurrency) as CGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(c.AmountInCompanyCodeCurrency) as SGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(h.AmountInCompanyCodeCurrency) as IGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce( (e.AmountInCompanyCodeCurrency * 2), h.AmountInCompanyCodeCurrency )) as TOT_TAX,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce( ((e.AmountInCompanyCodeCurrency * 2) + e.TaxBaseAmountInCoCodeCrcy), (h.AmountInCompanyCodeCurrency + h.TaxBaseAmountInCoCodeCrcy) )) as TOT_INVOICE 
 }
where a.FinancialAccountType = 'D' 

