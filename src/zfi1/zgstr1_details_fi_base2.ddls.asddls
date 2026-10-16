@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 FI Details Base2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_FI_BASE2 as select from ZGSTR1_DETAILS_FI_BASE1 as a
{
    key a.AccountingDocument,
    key a.CompanyCode,
    key a.FiscalYear,
    key a.AccountingDocumentItem,
    a.AccountingDocumentType,
    a.FiscalPeriod,
    a.FinancialTransactionType,
    a.TransactionTypeDetermination,
    a.FinancialAccountType,
    a.TransactionCurrency,
    a.Customer,
    a.CUSTOMER_NAME,
    a.CUSTOMER_GSTIN,
    a.region_code,
    a.BusinessPlace,
    a.PostingDate,
    a.DocumentDate,
    a.TransactionCode,
    a.OriginalReferenceDocument,
    a.ReverseDocument,
    a.ReverseDocumentFiscalYear,
    a.IsReversal,
    a.IsReversed,
    a.AccountingDocCreatedByUser,
    a.CompanyCodeCurrency,
    a.DocumentReferenceID,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.base_amount,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.CGST_AMOUNT,
    a.cgst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.SGST_AMOUNT,
    a.sgst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.IGST_AMOUNT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.TCS_AMT,
    a.igst_rate,
    a.Billing_doc,
    a.UNIT_OF_ENTRY,
    a.GST_PARTNER,
    a.PLACE_OF_SUPPLY,
    a.UOM,
    a.ControllingArea,
    a.Segment,
    a.ProfitCenter,
    a.ITEM_TEXT,
    a.Material,
    a.ProductDescription,
    a.Plant,
    a.PlantName,
    a.cgst_item,
    a.igst_item,
    a.billing_unit,
    @Semantics.quantity.unitOfMeasure: 'billing_unit'
    a.billing_qty,
    a.shipping_bill_no,
    a.shipping_bill_dt,
    a.IGST_INF,
    a.GLAccountLongName,
    a.GLAccount,
    a.SegmentName,
    a.IN_GSTPlaceOfSupply,
    a.RegionName,
    a.hsn_sac_code,
    
    case when a.CUSTOMER_GSTIN != ' ' then cast('B2B' as abap.char( 15 )) 
  //case when a.CompanyCodeCurrency <> 'INR' 
   when ( a.TransactionCurrency != 'INR' and IGST_INF = 'NOTIGST' )
     then cast('EXP WITHOUT TAX' as abap.char( 15 ))
   when ( a.TransactionCurrency <> 'INR' and IGST_AMOUNT <> 0)
    then cast('EXP WITH TAX' as abap.char( 15 )) 
    else cast('B2C' as abap.char( 15 ))
   end as inv_type,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
   a.total_tax_value_cgst,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
   a.total_tax_value_isgt,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.total_tax_value_cgst <> 0 then
              a.total_tax_value_cgst
         when a.total_tax_value_isgt <> 0 then
              a.total_tax_value_isgt
         else
              a.base_amount
         end as total_tax_value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    case when a.IGST_AMOUNT is not initial then
          abs(get_numeric_value(a.IGST_AMOUNT))
     else
       abs(get_numeric_value(a.SGST_AMOUNT)) + abs(get_numeric_value(a.CGST_AMOUNT)) 
     end 
    as tot_taxable_value
              
          
/*    case when a.SGST_AMOUNT <> 0
    then
           a.base_amount + a.CGST_AMOUNT + a.SGST_AMOUNT
         when a.IGST_AMOUNT <> 0 then      
           a.base_amount + a.IGST_AMOUNT
         else
           a.base_amount        
     end as total_tax_value*/
//   (a.base_amount + a.CGST_AMOUNT + a.SGST_AMOUNT + a.IGST_AMOUNT) as total_tax_value,
//    @Semantics.amount.currencyCode: 'TransactionCurrency'
//   (a.base_amount + a.CGST_AMOUNT + a.SGST_AMOUNT + a.IGST_AMOUNT + a.TCS_AMT) as total_value_wth_tcs
   
}
where a.GLAccount <> '0016000330'
