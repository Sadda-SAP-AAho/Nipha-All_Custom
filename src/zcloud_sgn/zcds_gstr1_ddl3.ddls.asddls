@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR 1 DDL3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_GSTR1_DDL3 as select from ZCDS_GSTR1_DDL4
{
    key AccountingDocument,
    key CompanyCode,
    key FiscalYear,
    key TaxItemAcctgDocItemRef,
    TaxNumber3,
    Customer,
    CustomerName,
    Region,
    OriginalReferenceDocument,
    PostingDate,
    DocumentReferenceID,
    DocumentDate,
    case when TaxNumber3 != ' ' then cast('B2B' as abap.char( 15 )) 
  //case when a.CompanyCodeCurrency <> 'INR' 
   when ( TransactionCurrency != 'INR' and IGST_INF = 'NOTIGST' )
     then cast('EXP WITHOUT TAX' as abap.char( 15 ))
   when ( TransactionCurrency <> 'INR' and IGST_AMT <> 0)
    then cast('EXP WITH TAX' as abap.char( 15 )) 
    else cast('B2C' as abap.char( 15 ))
   end as inv_type,
   
    //inv_type,
    CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when ( AccountingDocumentType = 'DG' 
    or  BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' or 
    ( AccountingDocumentType = 'RV' and CompanyCodeCurrencyDetnMethod = 'E' )
     or  ( AccountingDocumentType = 'DR' and AmountInTransactionCurrency < 0 )
     )
      then BASE_AMT * -1
         else
         BASE_AMT
         end as BASE_AMT,
    cgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when ( AccountingDocumentType = 'DG' 
    or  BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' or 
    ( AccountingDocumentType = 'RV' and CompanyCodeCurrencyDetnMethod = 'E' )
  or   ( AccountingDocumentType = 'DR' and AmountInTransactionCurrency < 0 ) 
    )
    then CGST_AMT * -1
    else
        CGST_AMT
    end as CGST_AMT,
    sgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when ( AccountingDocumentType = 'DG' 
    or  BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' or 
    ( AccountingDocumentType = 'RV' and CompanyCodeCurrencyDetnMethod = 'E' ) 
   or( AccountingDocumentType = 'DR' and AmountInTransactionCurrency < 0 ) 
    )
    then SGST_AMT * -1
    else
    SGST_AMT
    end as SGST_AMT,
    igst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when ( AccountingDocumentType = 'DG' 
    or  BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' or 
    ( AccountingDocumentType = 'RV' and CompanyCodeCurrencyDetnMethod = 'E' )
    or( AccountingDocumentType = 'DR' and AmountInTransactionCurrency < 0 )
     )
    then IGST_AMT * -1
    else
    IGST_AMT
    end as IGST_AMT,
    ChartOfAccounts,
    Plant,
    GLAccount,
    Segment,
    IN_GSTPlaceOfSupply,
    YY1_ShippingbillNo_BDH,
    YY1_shippingbillDate_BDH,
    BillingDocumentType,
    YY1_SalesType_BDH,
    SalesOrganization,
    TransactionCurrency,
    AccountingDocumentType,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when ( AccountingDocumentType = 'DG' 
    or  BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' or 
    ( AccountingDocumentType = 'RV' and CompanyCodeCurrencyDetnMethod = 'E' )
    or( AccountingDocumentType = 'DR' and AmountInTransactionCurrency < 0 )
     )
    then TOT_TAX * -1
    else
    TOT_TAX
    end as TOT_TAX,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when ( AccountingDocumentType = 'DG' 
    or  BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' or 
    ( AccountingDocumentType = 'RV' and CompanyCodeCurrencyDetnMethod = 'E' )
    or( AccountingDocumentType = 'DR' and AmountInTransactionCurrency < 0 )
     )
    then TCS_AMT * -1
    else
    TCS_AMT
    end as TCS_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when ( AccountingDocumentType = 'DG' 
    or  BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' or 
    ( AccountingDocumentType = 'RV' and CompanyCodeCurrencyDetnMethod = 'E' )
    or( AccountingDocumentType = 'DR' and AmountInTransactionCurrency < 0 )
     )
    then tot_invoice * -1
    else
    tot_invoice
    end as tot_invoice,
    BillingQuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    BillingQuantity,
    region_code,
    RegionName,
    TaxCode,
    plofsuppl_name,
    seg
}
 where seg = 'ALLSHOW'
/*where ( ( Segment = '0000001000' or Segment = '0000001010' or
          Segment = '0000002000' or Segment = '0000003000' or
          Segment = '0000004000') and ( TaxNumber3 <> '19AAACN9099H1ZV' ))*/
