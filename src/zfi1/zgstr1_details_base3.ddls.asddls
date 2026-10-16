@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Details Base 3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_BASE3 as select from ZGSTR1_DETAILS_BASE2
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
    cast(tot_taxable_value as abap.curr(15,2)) as total_tax_value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    TCS_AMT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when (BillingDocumentType = 'S1' or BillingDocumentType = 'CBRE' or BillingDocumentType = 'G2' )
    then
        cast(total_value_with_tcs as abap.curr(15,2)) * -1
    else
        cast(total_value_with_tcs as abap.curr(15,2)) 
        
    end as total_value_with_tcs ,
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
    AccountingExchangeRate
    
}
