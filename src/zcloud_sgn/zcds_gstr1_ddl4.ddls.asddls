@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR 1 DDL4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_GSTR1_DDL4 as select from zcds_gstr1_ddl2
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

    CompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    AmountInTransactionCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    BASE_AMT1,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    BASE_AMT,
    cgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    CGST_AMT,
    sgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    SGST_AMT,
    igst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    IGST_AMT,
    case when IGST_AMT > 0 then 
    cast('YESIGST' as abap.char( 7 ))
    else
    cast('NOTIGST' as abap.char( 7 ))
    end as IGST_INF,
    ChartOfAccounts,
    Plant,
    GLAccount,
    Segment,
    IN_GSTPlaceOfSupply,
    YY1_ShippingbillNo_BDH,
    YY1_shippingbillDate_BDH,
    BillingDocumentType,
    CompanyCodeCurrencyDetnMethod,
    YY1_SalesType_BDH,
    SalesOrganization,
    TransactionCurrency,
    AccountingDocumentType,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    TOT_TAX,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    TCS_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    //(coalesce(abs(get_numeric_value(tot_invoice)),0) + get_numeric_value(BASE_AMT1))
    (coalesce(abs(get_numeric_value(tot_invoice)), get_numeric_value(BASE_AMT1)))
    as tot_invoice,
//    coalesce((abs(get_numeric_value(tot_invoice))), BASE_AMT1 ) as tot_invoice,
    
    BillingQuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    BillingQuantity,
    region_code,
    RegionName,
    TaxCode,
    plofsuppl_name,
    case when (Segment <> '0000006000' and TaxNumber3 = '19AAACN9099H1ZV') then
    cast('NOTSHOW' as abap.char( 7 ))
    else 
    cast('ALLSHOW' as abap.char( 7 )) 
    end as seg
}
