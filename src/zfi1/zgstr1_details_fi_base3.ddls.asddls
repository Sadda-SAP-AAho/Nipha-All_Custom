@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 FI Details Base3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_FI_BASE3 as select from ZGSTR1_DETAILS_FI_BASE2 as A
{
    key A.AccountingDocument,
    key A.CompanyCode,
    key A.FiscalYear,
    key A.AccountingDocumentItem,
    A.AccountingDocumentType,
    A.GLAccountLongName,
    A.CUSTOMER_GSTIN,
    A.CUSTOMER_NAME,
    A.Customer,
    A.region_code,
    A.OriginalReferenceDocument,
    A.DocumentDate,
    A.DocumentDate as BillingDocumentDate,
    A.DocumentReferenceID,
    A.PostingDate,
    A.FiscalPeriod,
    A.inv_type,
    A.Plant,
    A.PlantName,
    A.Segment,
    A.SegmentName,
    A.IN_GSTPlaceOfSupply,
    A.shipping_bill_no,
    A.shipping_bill_dt,
    A.TransactionCurrency,
    A.billing_unit,
    A.GLAccount,
    A.Material,
    A.ProductDescription,
    A.hsn_sac_code,
    A.Billing_doc as BillingDocument,
    A.CompanyCodeCurrency,
    @Semantics.quantity.unitOfMeasure: 'billing_unit'
    A.billing_qty,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.base_amount,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.base_amount as base_amount1,
    A.cgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.CGST_AMOUNT,
    A.sgst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.SGST_AMOUNT,
    A.igst_rate,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.IGST_AMOUNT,
//    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   @Semantics.amount.currencyCode: 'TransactionCurrency'
    cast(tot_taxable_value as abap.curr(15,2)) as total_tax_value,   
//    A.total_tax_value,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.TCS_AMT,
   // A.total_value_with_tcs,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when A.TCS_AMT <> 0
    then A.total_tax_value + A.TCS_AMT
    else
         A.total_tax_value
    end as total_value_with_tcs,
    A.RegionName,
    A.PLACE_OF_SUPPLY,
    A.BusinessPlace,
    '  ' as UOM1
}
where ( A.AccountingDocumentType = 'DR' or A.AccountingDocumentType = 'DG' or A.AccountingDocumentType = 'SA' )
