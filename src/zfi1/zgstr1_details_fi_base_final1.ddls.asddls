@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Details Final base  1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_FI_BASE_final1 as select from ZGSTR1_DETAILS_FI_BASE_final
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
    Customer,
    OriginalReferenceDocument,
    DocumentDate,
    DocumentReferenceID,
    PostingDate,
    FiscalPeriod,
    inv_type,
    Plant,
    PlantName,
    Material,
    ProductDescription,
    hsn_sac_code,
    BusinessPlace,
    Segment,
    SegmentName,
    IN_GSTPlaceOfSupply,
    shipping_bill_no,
    shipping_bill_dt,
    TransactionCurrency,
    billing_unit,
    GLAccount,
    CompanyCodeCurrency,
    BillingDocument,
    BillingDocumentDate,
    @Semantics.quantity.unitOfMeasure: 'billing_unit'
    billing_qty,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    base_amount,
    cgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    CGST_AMOUNT,
    sgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    SGST_AMOUNT,
    igst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    IGST_AMOUNT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    total_tax_value,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    TCS_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    total_value_with_tcs,
    RegionName,
    PLACE_OF_SUPPLY,
    UOM1,
    case when (CUSTOMER_GSTIN = '19AAACN9099H1ZV') and (Segment = '0000001000' or Segment = '0000002000'
    or Segment = '0000003000' or Segment = '0000004000' or Segment = '0000005000') then
    cast('STO' as abap.char( 6 ))
    else
    cast('NOTSTO' as abap.char( 4 ))
   end as STO,
     base_with_gst,
     tot_gst,
    case when TCS_AMT <> 0
    then 
        cast(base_with_gst  as abap.dec( 15, 2 )) + cast(TCS_AMT as abap.dec( 15, 2 ))
    else
        cast(base_with_gst  as abap.dec( 15, 2 ))
    end as total_value_with_tcs1 
     
    
       
    
      
      
}
