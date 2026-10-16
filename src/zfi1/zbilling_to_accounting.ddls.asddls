@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing to account details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBILLING_TO_ACCOUNTING as select from 
   I_JournalEntry as e
   left outer join I_OperationalAcctgDocItem as a on e.AccountingDocument = a.AccountingDocument
   and e.CompanyCode = a.CompanyCode and e.FiscalYear = a.FiscalYear 
   {
     key e.AccountingDocument,
     key e.CompanyCode,
     key e.FiscalYear,
        // a.AccountingDocumentItem,
 //   a.DocumentReferenceID,
         a.BillingDocument,
         a.AccountingDocumentType,
         a.FiscalPeriod,
//         a.PostingDate,
         a.FinancialTransactionType,
         a.TransactionTypeDetermination,
         a.FinancialAccountType,
         a.TransactionCurrency,
         a.Customer,
         a.BusinessPlace,
         e.PostingDate,
         e.DocumentDate,
         e.TransactionCode,
         e.OriginalReferenceDocument,
         e.ReverseDocument,
         e.ReverseDocumentFiscalYear,
         e.IsReversal,
         e.IsReversed,
         e.AccountingDocCreatedByUser,
         e.DocumentReferenceID,
         a.CompanyCodeCurrency      

            
         
 

}
where a.FinancialAccountType = 'D' and a.AccountingDocumentType = 'RV'
