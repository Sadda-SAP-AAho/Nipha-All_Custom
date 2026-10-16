@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 FI Details Base2 final SD Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_BASE2 as select from ZGSTR1_DETAILS_BASE1 as A
  left outer join I_SegmentText as b on b.Segment = A.Segment and b.Language = 'E'
{
    key A.CompanyCode,
    key A.AccountingDocument,
    key A.FiscalYear,
    key A.BillingDocumentItem1 as AccountingDocumentItem,//A.AccountingDocumentItem,
    A.AccountingDocumentType,
    cast('' as abap.char( 30 )) as GLAccountLongName,
    A.sold_to_gstin as CUSTOMER_GSTIN,
    A.sold_to_name1 as CUSTOMER_NAME,
    A.sold_to_region as region_code,
    A.sold_to_customer as customer,
    A.OriginalReferenceDocument,
    A.DocumentDate,
    A.DocumentReferenceID,
    A.PostingDate,
    A.BillingDocument,
    case when A.sold_to_gstin != ' ' then cast('B2B' as abap.char( 15 )) 
  //case when a.CompanyCodeCurrency <> 'INR' 
    when ( A.TransactionCurrency != 'INR' and A.IGST_INF = 'NOTIGST' )
       then cast('EXP WITHOUT TAX' as abap.char( 15 ))
    when ( A.TransactionCurrency <> 'INR' and A.IGST <> 0)
       then cast('EXP WITH TAX' as abap.char( 15 )) 
       else cast('B2C' as abap.char( 15 ))
     end as inv_type,
//    cast('YYYYYYYYYYYYYYY' as abap.char( 15 )) as inv_type,
    A.Plant,
    A.plant_name as plantname,
    A.Segment,
    b.SegmentName,
    A.sold_to_region_name as IN_GSTPlaceOfSupply,
    A.YY1_shippingbillDate_BDH as shipping_bill_dt,
    A.YY1_ShippingbillNo_BDH as shipping_bill_no,
    A.TransactionCurrency,
    A.BaseUnit as billing_unit,
    cast('         ' as abap.char( 10 )) as GLAccount,
    A.CompanyCodeCurrency,
    @Semantics.quantity.unitOfMeasure: 'billing_unit'
    case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' )
    then
        A.inv_qty * -1
     else
        A.inv_qty 
     end
        as billing_qty,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' )
    then
       cast(A.base_amount1 as abap.curr( 15, 2 )) * -1 
     else
        cast(A.base_amount1 as abap.curr( 15, 2 ))
     end as base_amount,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.base_amount2,
//    A.Taxable_value as base_amount,
    A.CGST_RATE as cgst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
     case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' )
    then
    cast(A.CGST1 as abap.curr( 15, 2 )) * -1
    else  
    cast(A.CGST1 as abap.curr( 15, 2 )) 
    end as CGST_AMOUNT,
//    A.CGST as CGST_AMOUNT,
    A.SGST_RATE as sgst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' )
    then
    cast(A.SGST1 as abap.curr( 15, 2 )) * -1
    else   
    cast(A.SGST1 as abap.curr( 15, 2 )) 
    end as SGST_AMOUNT,
//    A.SGST as SGST_AMOUNT,
    A.IGST_RATE as igst_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' )
    then
    cast(A.IGST1 as abap.curr( 15, 2 )) * -1 
    else
    cast(A.IGST1 as abap.curr( 15, 2 ))
    end
    as IGST_AMOUNT,
//    A.IGST as IGST_AMOUNT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
     case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' )
    then   
    cast(A.TOTALTAXVALUE as abap.curr( 15, 2 )) * -1
    else
    cast(A.TOTALTAXVALUE as abap.curr( 15, 2 ))
    end as total_tax_value,
//    A.TOTALTAXVALUE as total_tax_value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' )
    then
    cast(A.TCS1 as abap.curr( 15, 2 )) * -1
    else
    cast(A.TCS1 as abap.curr( 15, 2 )) 
    end as TCS_AMT,
//    A.TCS as TCS_AMT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when  A.TCS1 is not null  
    then 
      (cast(A.TOTALTAXVALUE as abap.curr( 15, 2 )) + cast(A.TCS1 as abap.curr( 15, 2 )))
    else
      cast(A.TOTALTAXVALUE as abap.curr(15,2))
    end as total_value_with_tcs,
//    A.TOTALWITHTCS as total_value_with_tcs,
    A.sold_to_region as RegionName,
    A.sold_to_region_name as PLACE_OF_SUPPLY,
    A.BillingDocumentDate,
    A.Product as Material,
    A.BillingDocumentItemText as ProductDescription,
    A.hsn_sac_code,
    A.FiscalPeriod,
    A.Segment as BusinessPlace,
    A.UOM1,
    A.BillingDocumentType,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.tot_taxable_value,
    A.AccountingExchangeRate   
}
  where A.AccountingDocument <> ' '
