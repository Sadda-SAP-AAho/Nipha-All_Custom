@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - GSTR1 ( Base Value )'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_gstr1_ddl2 as select from zcds_gstr1_tax_2 as a 
//OffsettingData
left outer join I_OperationalAcctgDocItem as b on a.AccountingDocument = b.AccountingDocument and a.CompanyCode = b.CompanyCode
and a.FiscalYear = b.FiscalYear and b.AccountingDocumentItemType = ' ' and b.FinancialAccountType = 'S'
and a.TaxItemAcctgDocItemRef = b.TaxItemAcctgDocItemRef
//OffsettingSalesData
left outer join I_OperationalAcctgDocItem as c on a.AccountingDocument = c.AccountingDocument and a.CompanyCode = c.CompanyCode
and a.FiscalYear = c.FiscalYear and c.AccountingDocumentItemType = 'R' and c.FinancialAccountType = 'S'
and a.TaxItemAcctgDocItemRef = c.SalesDocumentItem and c.Quantity > 0
left outer join I_BillingDocument as d on a.billingdoc = d.BillingDocument
left outer join I_BillingDocumentItem as e on a.billingdoc = e.BillingDocument and a.TaxItemAcctgDocItemRef = e.BillingDocumentItem
left outer join I_OperationalAcctgDocItem as j on a.AccountingDocument = j.AccountingDocument //TCS
 and a.CompanyCode = j.CompanyCode and a.FiscalYear = j.FiscalYear and a.TaxItemAcctgDocItemRef = j.TaxItemAcctgDocItemRef and j.AccountingDocumentItemType = 'T' 
 and j.FinancialAccountType = 'S' and j.TransactionTypeDetermination = 'JTC'
left outer join I_RegionText as k on a.IN_GSTPlaceOfSupply = k.Region and k.Country = 'IN' and k.Language = 'E'
left outer join I_OperationalAcctgDocItem as l on l.AccountingDocument = a.AccountingDocument and l.CompanyCode = a.CompanyCode
and l.FiscalYear = a.FiscalYear and l.AccountingDocumentItemType = 'R' and l.FinancialAccountType = 'S'
//and a.TaxItemAcctgDocItemRef = l.TaxItemAcctgDocItemRef 
and l.ProfitCenter <> '' and l.AccountingDocumentItem = '002'
left outer join I_OperationalAcctgDocItem as m on m.AccountingDocument = a.AccountingDocument and m.CompanyCode = a.CompanyCode
and m.FiscalYear = a.FiscalYear and m.AccountingDocumentItemType = ' ' and m.FinancialAccountType = 'S'
//and a.TaxItemAcctgDocItemRef = l.TaxItemAcctgDocItemRef 
and m.ProfitCenter <> '' and m.AccountingDocumentItem = '002'
{
 key a.AccountingDocument,
 key a.CompanyCode,
 key a.FiscalYear,
 key a.TaxItemAcctgDocItemRef,
 a.TaxNumber3,
 a.Customer,
 upper(a.CustomerName) as CustomerName,
 a.Region,
 a.OriginalReferenceDocument ,
 a.PostingDate,
 a.DocumentReferenceID,
 a.DocumentDate,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.AmountInTransactionCurrency,
 /*case when a.TaxNumber3 != ' ' then cast('B2B' as abap.char( 15 )) 
  //case when a.CompanyCodeCurrency <> 'INR' 
   when ( a.TransactionCurrency != 'INR' )//and a.TaxItemAcctgDocItemRef = '000000' )
     then cast('EXP WITHOUT TAX' as abap.char( 15 ))
   when ( a.TransactionCurrency <> 'INR' and a.IGST_AMT <> 0)
    then cast('EXP WITH TAX' as abap.char( 15 )) 
    else cast('B2C' as abap.char( 15 ))
 end as inv_type,*/
 a.CompanyCodeCurrency as CompanyCodeCurrency,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.BASE_AMT1, 
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 coalesce( a.BASE_AMT,a.BASE_AMT1 ) as BASE_AMT,
 round(cast( ((get_numeric_value(a.CGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as cgst_rate,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.CGST_AMT,
 round(cast( ((get_numeric_value(a.SGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as sgst_rate,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.SGST_AMT,
 round(cast( ((get_numeric_value(a.IGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as igst_rate,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.IGST_AMT,
 coalesce( a.ChartOfAccounts,coalesce( b.ChartOfAccounts,c.ChartOfAccounts )) as ChartOfAccounts,
 coalesce( a.Plant,coalesce( b.Plant,c.Plant )) as Plant,
 coalesce( b.GLAccount,c.GLAccount ) as GLAccount,
// coalesce( b.Segment,c.Segment ) as Segment,  // old code
// l.Segment,  // new code
   coalesce( l.Segment,m.Segment ) as Segment, 
 a.IN_GSTPlaceOfSupply,
 d.YY1_ShippingbillNo_BDH,
 d.YY1_shippingbillDate_BDH,
 d.BillingDocumentType, // added by vvk
 d.YY1_SalesType_BDH, // added by vvk
 d.SalesOrganization,
 a.CompanyCodeCurrencyDetnMethod,
 a.TransactionCurrency,
 a.AccountingDocumentType,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.TOT_TAX,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 abs(j.AmountInCompanyCodeCurrency) as TCS_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  case when d.SalesOrganization = '1001'
     then 
  (coalesce(abs(get_numeric_value(j.AmountInCompanyCodeCurrency)),0) + get_numeric_value(a.BASE_AMT))
// (coalesce(abs(get_numeric_value(j.AmountInCompanyCodeCurrency)),0) + (coalesce(get_numeric_value(a.BASE_AMT)) , (get_numeric_value(a.BASE_AMT1))))
    else
    (coalesce(abs(get_numeric_value(j.AmountInCompanyCodeCurrency)),0) + get_numeric_value(a.TOT_INVOICE))
  end  as tot_invoice,
 
 //a.TOT_INVOICE,
 case e.BillingQuantityUnit 
 when 'ST' then cast('PC' as abap.unit( 2 )) 
 when 'LE' then cast('AU' as abap.unit( 2 )) else e.BillingQuantityUnit end as BillingQuantityUnit,
 @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
 e.BillingQuantity,
 case a.Region
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
 else a.Region end as region_code,
 upper(a.RegionName) as RegionName,
 a.TaxCode,
 upper(k.RegionName) as plofsuppl_name
}
where ( a.AccountingDocumentType = 'RV' or a.AccountingDocumentType = 'DR'
or a.AccountingDocumentType = 'DG' or a.AccountingDocumentType = 'SA' )
//where a.TOT_TAX is not null // remove on 19-05-2024 vvk


