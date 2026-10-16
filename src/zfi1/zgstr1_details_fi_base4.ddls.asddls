@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 FI Details Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_FI_BASE4 as select from ZGSTR1_DETAILS_FI_BASE3
{
    key AccountingDocument,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocumentItem,
    AccountingDocumentType,
    GLAccountLongName,
    CUSTOMER_GSTIN,
    CUSTOMER_NAME,
    Customer,
    region_code,
    OriginalReferenceDocument,
    DocumentDate,
    BillingDocumentDate,
    DocumentReferenceID,
    PostingDate,
    FiscalPeriod,
    inv_type,
    Plant,
    PlantName,
    Segment,
    SegmentName,
    IN_GSTPlaceOfSupply,
    shipping_bill_no,
    shipping_bill_dt,
    TransactionCurrency,
    billing_unit,
    GLAccount,
    Material,
    ProductDescription,
    hsn_sac_code,
    BillingDocument,
    CompanyCodeCurrency,
    @Semantics.quantity.unitOfMeasure: 'billing_unit'
    case when AccountingDocumentType = 'DG' then
    billing_qty *-1
    else
     billing_qty
    end as  billing_qty,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//    base_amount,
    cast(base_amount as abap.dec( 15, 2 )) as base_amount,
    cgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    CGST_AMOUNT,
    sgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    SGST_AMOUNT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    igst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    IGST_AMOUNT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when AccountingDocumentType = 'DG' then
    total_tax_value * -1
    else
    total_tax_value
    end as total_tax_value,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when AccountingDocumentType = 'DG' then
    TCS_AMT * -1
    else
    TCS_AMT
    end as TCS_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when AccountingDocumentType = 'DG' then
    total_value_with_tcs * -1
    else
    total_value_with_tcs end as total_value_with_tcs,
    RegionName,
    PLACE_OF_SUPPLY,
    BusinessPlace,
    UOM1,
    (coalesce(abs(get_numeric_value(CGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(SGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(IGST_AMOUNT )),0)) + 
    (coalesce(abs(get_numeric_value(base_amount)),0)) as base_with_gst ,
    (coalesce(abs(get_numeric_value(CGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(SGST_AMOUNT )),0)) +
    (coalesce(abs(get_numeric_value(IGST_AMOUNT )),0)) as tot_gst,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    base_amount1
}
