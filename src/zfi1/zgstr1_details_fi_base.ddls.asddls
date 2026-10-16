@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 FI Details Base'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_FI_BASE as select from I_OperationalAcctgDocItem as a
   left outer join I_OperationalAcctgDocItem as b on b.CompanyCode = a.CompanyCode 
   and b.AccountingDocument = a.AccountingDocument and b.FiscalYear = a.FiscalYear
   and b.TaxItemGroup = a.TaxItemGroup
//   and a.AmountInTransactionCurrency  = b.TaxBaseAmountInTransCrcy
  // and ( a.Material = b.Material or a.Material = '' )
   and b.TransactionTypeDetermination = 'JOC'
   and b.AccountingDocumentItemType = 'T'
   left outer join I_OperationalAcctgDocItem as C on C.CompanyCode = a.CompanyCode 
   and C.AccountingDocument = a.AccountingDocument and C.FiscalYear = a.FiscalYear
   and C.TaxItemGroup = a.TaxItemGroup
//   and a.AmountInTransactionCurrency  = C.TaxBaseAmountInTransCrcy
 //  and ( a.Material = C.Material or a.Material = '' )
   
   and C.TransactionTypeDetermination = 'JOS'
   and C.AccountingDocumentItemType = 'T'
   left outer join I_OperationalAcctgDocItem as D on D.CompanyCode = a.CompanyCode 
   and D.AccountingDocument = a.AccountingDocument and D.FiscalYear = a.FiscalYear
   and D.TaxItemGroup = a.TaxItemGroup
//   and a.AmountInTransactionCurrency  = D.TaxBaseAmountInTransCrcy
//   and ( a.Material = D.Material or a.Material = '' )
   
   and D.TransactionTypeDetermination = 'JOI'
   and D.AccountingDocumentItemType = 'T'
   left outer join I_OperationalAcctgDocItem as K on K.CompanyCode = a.CompanyCode 
   and K.AccountingDocument = a.AccountingDocument and K.FiscalYear = a.FiscalYear
   and K.TaxItemGroup = a.TaxItemGroup
//   and a.AmountInTransactionCurrency  = K.TaxBaseAmountInTransCrcy
//   and ( a.Material = K.Material or a.Material = '' )

   and K.TransactionTypeDetermination = 'JTC'
   and K.AccountingDocumentItemType = 'T'
   left outer join I_JournalEntry as e on e.AccountingDocument = a.AccountingDocument
   and e.CompanyCode = a.CompanyCode and e.FiscalYear = a.FiscalYear
   left outer join I_OperationalAcctgDocItem as f on f.CompanyCode = a.CompanyCode
   and f.AccountingDocument = a.AccountingDocument and f.FiscalYear = a.FiscalYear
   and f.FinancialAccountType = 'S' and 
   ( f.AccountingDocumentItemType = 'T' or f.AccountingDocumentItemType = ' ' )
   and f.TaxItemGroup = a.TaxItemGroup
   and ( f.TransactionTypeDetermination = 'JOC' or D.TransactionTypeDetermination = 'JOI' or 
   D.TransactionTypeDetermination = 'JOI' or D.TransactionTypeDetermination = ' ')
   left outer join I_OperationalAcctgDocItem as g on g.CompanyCode = a.CompanyCode and
   g.AccountingDocument = a.AccountingDocument and g.FiscalYear = a.FiscalYear
   and g.FinancialAccountType = 'D'
   left outer join I_Customer as h on h.Customer = g.Customer  
   left outer join I_Plant as i on i.Plant = a.Plant
   left outer join I_ProductDescription as j on j.Product = a.Product and j.Language = 'E'

   
   
   {
     key a.AccountingDocument,
     key a.CompanyCode,
     key a.FiscalYear,
     key a.AccountingDocumentItem,
 //   a.DocumentReferenceID,
         a.BillingDocument,
         a.AccountingDocumentType,
         a.FiscalPeriod,
//         a.PostingDate,
         a.FinancialTransactionType,
         a.TransactionTypeDetermination,
         a.FinancialAccountType,
         a.TransactionCurrency,
         a.CompanyCodeCurrency,
         g.Customer,
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
         b.TaxItemAcctgDocItemRef as cgst_item,
         
         D.TaxItemAcctgDocItemRef as igst_item,       
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         a.AmountInTransactionCurrency as base_amount,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         b.AmountInTransactionCurrency as CGST_AMOUNT,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         b.TaxBaseAmountInTransCrcy as CGST_BASE_AMT,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         C.AmountInTransactionCurrency as SGST_AMOUNT,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         C.TaxBaseAmountInTransCrcy  as SGST_BASE_AMT,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         D.AmountInTransactionCurrency as IGST_AMOUNT,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         D.TaxBaseAmountInTransCrcy  as IGST_BASE_AMT,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         K.AmountInTransactionCurrency as TCS_AMT,
         case when e.AccountingDocumentType = 'RV'
           then e.OriginalReferenceDocument 
           end as Billing_doc,
         f.GoodsMovementEntryUnit as UNIT_OF_ENTRY,
         g.IN_GSTPartner as GST_PARTNER,
         g.IN_GSTPlaceOfSupply as PLACE_OF_SUPPLY,
         f.BaseUnit as UOM,
//         l.BillingQuantityInBaseUnit,
//         @Semantics.quantity.unitOfMeasure: 'BillingQuantityInBaseUnit'
//         f.Quantity,
         f.ControllingArea,
         a.Segment,
         f.DocumentItemText as ITEM_TEXT,
         h.CustomerFullName,
         h.TaxNumber3,
         h.Region,
         h.Country as CUSTOMER_COUNTRY,
         a.Material,
         j.ProductDescription,
         a.Plant,
         i.PlantName,
         a.ProfitCenter,
         a.AccountingDocumentItemType,
         a.TaxItemGroup,
         a.GLAccount,
         a.ChartOfAccounts,
         coalesce( b.IN_GSTPlaceOfSupply,D.IN_GSTPlaceOfSupply ) as IN_GSTPlaceOfSupply
         

        
         
         
            
         
 

}
where (a.FinancialAccountType = 'S' and 
(a.AccountingDocumentItemType = ' ' or a.AccountingDocumentItemType = 'R' ) )

