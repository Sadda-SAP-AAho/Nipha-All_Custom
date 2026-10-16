@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Details Base 4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_BASE4 as select from ZGSTR1_DETAILS_BASE3
{
    key CompanyCode,
    key AccountingDocument,
    key FiscalYear,
    key AccountingDocumentItem,
    AccountingDocumentType,
    GLAccountLongName,
    CUSTOMER_GSTIN,
    CUSTOMER_NAME,
    region_code,
    customer,
    OriginalReferenceDocument,
    DocumentDate,
    DocumentReferenceID,
    PostingDate,
    BillingDocument,
    inv_type,
    Plant,
    plantname,
    Segment,
    SegmentName,
    IN_GSTPlaceOfSupply,
    shipping_bill_dt,
    shipping_bill_no,
    TransactionCurrency,
    billing_unit,
    GLAccount,
    CompanyCodeCurrency,
    @Semantics.quantity.unitOfMeasure: 'billing_unit'
    billing_qty,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    base_amount,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    base_amount2,
    cgst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    CGST_AMOUNT,
    sgst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    SGST_AMOUNT,
    igst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    IGST_AMOUNT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when TransactionCurrency <> 'INR' then
     ( cast(total_tax_value  as abap.dec( 15, 2 )) * cast(AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(total_tax_value as abap.dec( 15, 2 ))
       end as total_tax_value,
//    total_tax_value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when TransactionCurrency <> 'INR' then
     ( cast(TCS_AMT  as abap.dec( 15, 2 )) * cast(AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(TCS_AMT as abap.dec( 15, 2 ))
       end as TCS_AMT,
//    TCS_AMT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
//    total_value_with_tcs,
    case when TransactionCurrency <> 'INR' then
      ( cast(total_value_with_tcs  as abap.dec( 15, 2 )) * cast(AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(total_value_with_tcs as abap.dec( 15, 2 ))
       end as total_value_with_tcs,
    
    RegionName,
    PLACE_OF_SUPPLY,
    BillingDocumentDate,
    Material,
    ProductDescription,
    hsn_sac_code,
    FiscalPeriod,
    BusinessPlace,
    UOM1,
    BillingDocumentType,
    AccountingExchangeRate, 
    (coalesce(abs(get_numeric_value(CGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(SGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(IGST_AMOUNT )),0)) + 
    (coalesce(abs(get_numeric_value(base_amount)),0)) as base_with_gst ,
    (coalesce(abs(get_numeric_value(CGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(SGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(IGST_AMOUNT )),0)) as tot_gst  
    
}
