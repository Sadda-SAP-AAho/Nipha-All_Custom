@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 FI Details Base1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_FI_BASE1 as select from ZGSTR1_DETAILS_FI_BASE as A
   left outer join I_BillingDocumentItem as b on b.BillingDocument = A.Billing_doc
     and b.BillingDocumentItem = A.cgst_item
   left outer join I_BillingDocumentItem as c on c.BillingDocument = A.Billing_doc
     and c.BillingDocumentItem = A.igst_item
   left outer join I_BillingDocument as d on d.BillingDocument = A.Billing_doc
   left outer join I_GLAccountText as E on E.GLAccount = A.GLAccount and
   E.ChartOfAccounts = A.ChartOfAccounts and E.Language = 'E'
   left outer join I_SegmentText as f on f.Segment = A.Segment and f.Language = 'E'
   left outer join I_RegionText as g on g.Region = A.Region and g.Language = 'E'
   and g.Country = A.CUSTOMER_COUNTRY
   left outer join I_ProductPlantIntlTrd as h on h.Plant = A.Plant
    and h.Product = A.Material
{
    key A.AccountingDocument,
    key A.CompanyCode,
    key A.FiscalYear,
    key A.AccountingDocumentItem,
    A.AccountingDocumentType,
    A.FiscalPeriod,
    A.FinancialTransactionType,
    A.TransactionTypeDetermination,
    A.FinancialAccountType,
    A.TransactionCurrency,
    A.CompanyCodeCurrency,
//    A.TaxItemAcctgDocItemRef,
    A.Customer,
    A.CustomerFullName as CUSTOMER_NAME,
    A.TaxNumber3 as CUSTOMER_GSTIN,
     case A.Region
     when 'AN' then cast('35' as abap.char( 2 )) when 'AP' then cast('28' as abap.char( 2 ))
     when 'AR' then cast('12' as abap.char( 2 )) when 'AS' then cast('18' as abap.char( 2 ))
     when 'BR' then cast('10' as abap.char( 2 )) when 'CH' then cast('04' as abap.char( 2 ))
     when 'CT' then cast('22' as abap.char( 2 )) when 'DH' then cast('26' as abap.char( 2 ))
     when 'DL' then cast('07' as abap.char( 2 )) when 'GA' then cast('30' as abap.char( 2 ))
     when 'GJ' then cast('24' as abap.char( 2 )) when 'HP' then cast('02' as abap.char( 2 ))
     when 'HR' then cast('06' as abap.char( 2 )) when 'JH' then cast('20' as abap.char( 2 ))
     when 'JK' then cast('01' as abap.char( 2 )) when 'KA' then cast('29' as abap.char( 2 ))
     when 'KL' then cast('32' as abap.char( 2 )) when 'LA' then cast('38' as abap.char( 2 ))
     when 'LD' then cast('31' as abap.char( 2 )) when 'MH' then cast('27' as abap.char( 2 ))
     when 'ML' then cast('17' as abap.char( 2 )) when 'MN' then cast('14' as abap.char( 2 ))
     when 'MP' then cast('23' as abap.char( 2 )) when 'MZ' then cast('15' as abap.char( 2 ))
     when 'NL' then cast('13' as abap.char( 2 )) when 'OR' then cast('21' as abap.char( 2 ))
     when 'PB' then cast('03' as abap.char( 2 )) when 'PY' then cast('34' as abap.char( 2 ))
     when 'RJ' then cast('08' as abap.char( 2 )) when 'SK' then cast('11' as abap.char( 2 ))
     when 'AP' then cast('28' as abap.char( 2 )) when 'TG' then cast('36' as abap.char( 2 ))
     when 'TN' then cast('33' as abap.char( 2 )) when 'TR' then cast('16' as abap.char( 2 ))
     when 'UP' then cast('09' as abap.char( 2 )) when 'UT' then cast('05' as abap.char( 2 ))
     when 'WB' then cast('19' as abap.char( 2 )) when 'HR' then cast('06' as abap.char( 2 ))
     else A.Region end as region_code,
//    A.Region AS CUSTOMER_REGION,
    A.BusinessPlace,
    A.PostingDate,
    A.DocumentDate,
    A.TransactionCode,
    A.OriginalReferenceDocument,
    A.ReverseDocument,
    A.ReverseDocumentFiscalYear,
    A.IsReversal,
    A.IsReversed,
    A.AccountingDocCreatedByUser,
    A.DocumentReferenceID,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.base_amount,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.CGST_AMOUNT, 
    case when A.CGST_BASE_AMT is not initial
       then   
         round(cast( ((get_numeric_value(A.CGST_AMOUNT) / get_numeric_value(A.CGST_BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1)
       else
       round(cast( ((get_numeric_value(A.CGST_AMOUNT) / get_numeric_value(A.base_amount)) * 100) as abap.dec( 13, 2 ) ),1)
 //        cast( '00000000000000'  as abap.dec( 13, 2 ) )
       end as cgst_rate,   
    @Semantics.amount.currencyCode: 'TransactionCurrency'   
    A.SGST_AMOUNT, 
    case when A.SGST_BASE_AMT is not initial
       then     
         round(cast( ((get_numeric_value(A.SGST_AMOUNT) / get_numeric_value(A.SGST_BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1)
       else
         round(cast( ((get_numeric_value(A.SGST_AMOUNT) / get_numeric_value(A.base_amount)) * 100) as abap.dec( 13, 2 ) ),1)
 //         cast( '00000000000000'  as abap.dec( 13, 2 ) )
       end as sgst_rate,
     
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.IGST_AMOUNT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.TCS_AMT, 
    case when A.IGST_BASE_AMT is not initial
       then 
//         round(cast( ((get_numeric_value(A.IGST_AMOUNT) / get_numeric_value(A.IGST_BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1)
         round(cast( ((get_numeric_value(A.IGST_AMOUNT ) / get_numeric_value(A.IGST_BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1)
       else
       round(cast( ((get_numeric_value(A.IGST_AMOUNT) / get_numeric_value(A.base_amount)) * 100) as abap.dec( 13, 2 ) ),1)
//        cast( '00000000000000'  as abap.dec( 13, 2 ) )
       end as igst_rate,
    A.Billing_doc,
    A.UNIT_OF_ENTRY,
    A.GST_PARTNER,
    A.PLACE_OF_SUPPLY,
    A.UOM,
    A.ControllingArea,
    A.Segment,
    A.ProfitCenter,
    A.ITEM_TEXT,
    A.Material,
    A.ProductDescription,
    h.ConsumptionTaxCtrlCode as hsn_sac_code,
    A.Plant,
    A.PlantName,
    A.cgst_item,
    A.igst_item,
    coalesce( b.BillingQuantityUnit,c.BillingQuantityUnit ) as billing_unit,
    @Semantics.quantity.unitOfMeasure: 'billing_unit'
    coalesce( b.BillingQuantity,c.BillingQuantity ) as billing_qty,
    d.YY1_ShippingbillNo_BDH as shipping_bill_no,
    d.YY1_shippingbillDate_BDH as shipping_bill_dt,
    case when A.IGST_AMOUNT > 0 then 
    cast('YESIGST' as abap.char( 7 ))
    else
    cast('NOTIGST' as abap.char( 7 ))
    end as IGST_INF,
    E.GLAccountLongName,
    A.GLAccount,
    f.SegmentName,
    A.IN_GSTPlaceOfSupply,
    g.RegionName,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when A.SGST_AMOUNT <> 0
         then
           A.base_amount + A.CGST_AMOUNT + A.SGST_AMOUNT
         else
           A.base_amount
         end as total_tax_value_cgst,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
        case when A.IGST_AMOUNT <> 0
         then
           A.base_amount + A.IGST_AMOUNT
         else
           A.base_amount
         end as total_tax_value_isgt
    

}
 where A.AccountingDocumentType = 'RV' or A.AccountingDocumentType = 'DG' or
  A.AccountingDocumentType = 'DR' //or A.AccountingDocumentType = 'SA' 
