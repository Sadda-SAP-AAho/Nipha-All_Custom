@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - GSTR2 Entity 3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_gstr2_ddl3 as select from zcds_gstr2_ddl1 as a
//BASEVALUELINE
left outer join I_OperationalAcctgDocItem as b on a.AccountingDocument = b.AccountingDocument and a.CompanyCode = b.CompanyCode 
and a.FiscalYear = b.FiscalYear and a.TaxItemAcctgDocItemRef = b.TaxItemAcctgDocItemRef and b.AccountingDocumentItemType <> 'T' 
//and ((b.AccountingDocumentType = 'RE' and b.Quantity <> 0) or b.AccountingDocumentType <> 'RE')
//association[0..1] to I_TaxCodeText as _c on a.TaxCode = _c.TaxCode and _c.TaxCalculationProcedure = '0TXIN'
left outer join I_OperationalAcctgDocItem as c on a.AccountingDocument = c.AccountingDocument //TCS
and a.CompanyCode = c.CompanyCode and a.FiscalYear = c.FiscalYear and c.TaxItemAcctgDocItemRef = a.TaxItemAcctgDocItemRef
and c.AccountingDocumentItemType = 'T' and c.TransactionTypeDetermination = 'JTC'
left outer join I_KR_BusinessPlace as d on a.BusinessPlace = d.Branch and a.CompanyCode = d.CompanyCode
left outer join I_SupplierAccountGroupText as e on a.SupplierAccountGroup = e.SupplierAccountGroup and e.Language = 'E'
left outer join I_Plant as f on b.Plant = f.Plant
left outer join I_SegmentText as g on b.Segment = g.Segment and g.Language = 'E'
left outer join I_ProfitCenterText as h on b.ProfitCenter = h.ProfitCenter and h.Language = 'E'
left outer join I_GLAccountText as i on b.GLAccount = i.GLAccount and b.ChartOfAccounts = i.ChartOfAccounts
and i.Language = 'E'
left outer join ZGL_DETAILS_FOR_GSTR as j on a.AccountingDocument = j.AccountingDocument
and a.CompanyCode = j.CompanyCode and a.FiscalYear = j.FiscalYear // added by vvk
left outer join ZGL_FOR_SR_IR as k on a.AccountingDocument = k.AccountingDocument
and a.CompanyCode = k.CompanyCode and a.FiscalYear = k.FiscalYear
//and a.AccountingDocumentItem = k.AccountingDocumentItem
{
 key a.AccountingDocument,
 key a.CompanyCode,
 key a.FiscalYear,
 key a.TaxItemAcctgDocItemRef,
 a.FiscalPeriod,
 a.TaxNumber3,
 a.Supplier,
 a.SupplierName,
 a.Region,
 a.RegionName,
 a.DocumentReferenceID,
 a.DocumentDate,
 a.OriginalReferenceDocument,
 a.CompanyCodeCurrency as CompanyCodeCurrency,
 a.TransactionTypeDetermination,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.TransactionTypeDetermination = 'JCN' or a.TransactionTypeDetermination = 'JIN' then abs(b.AmountInCompanyCodeCurrency)
      else a.BASE_AMT end as BASE_AMT,
 round(cast( ((get_numeric_value(a.CGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as cgst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRCGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.CGST_AMT as abap.dec( 23, 2 )) end as CGST_AMT,
 //a.CGST_AMT,
 round(cast( ((get_numeric_value(a.SGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as sgst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRSGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.SGST_AMT as abap.dec( 23, 2 )) end as SGST_AMT,
 //a.SGST_AMT,
 round(cast( ((get_numeric_value(a.IGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as igst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRIGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.IGST_AMT as abap.dec( 23, 2 )) end as IGST_AMT,
 //a.IGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 case when a.RCMRCGST_AMT <> 0.00 or a.RCMRIGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 ))
                                  else cast( a.TOT_TAX as abap.dec( 23, 2 )) end as TOT_TAX,
 //a.TOT_TAX,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 a.RCMRCGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMRSGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMRIGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.TOTRRCM_AMT, 
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 a.RCMPCGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMPSGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMPIGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.TOTPRCM_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 abs(c.AmountInCompanyCodeCurrency) as TCS_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
 case when a.TransactionTypeDetermination = 'JCN' or a.TransactionTypeDetermination = 'JIN' 
 then abs(coalesce(get_numeric_value(b.AmountInCompanyCodeCurrency),0)) - abs(coalesce(get_numeric_value(a.TOTPRCM_AMT),0))
 else coalesce(get_numeric_value(a.TOT_INVOICE),0) + coalesce(get_numeric_value(c.AmountInCompanyCodeCurrency),0)
               - abs(coalesce(get_numeric_value(a.TOTRRCM_AMT),0))
 end as TOT_INVOICE,
 a.IN_GSTPlaceOfSupply,
 a.BusinessPlace,
 d.BusinessPlaceName,
 d.TaxNumber1,
 b.GLAccount, 
 a.SupplierAccountGroup,
 e.AccountGroupName,
 a.PostingDate,
 case a.Country when 'IN' then cast( 'DOMESTIC' as abap.char( 15 )) else cast( 'IMPORT' as abap.char( 15 ))
 end as trans_type,
 a.AccountingDocumentCreationDate,
 a.CreationTime,
 a.AccountingDocumentType,
 a.AccountingDocumentTypeName,
 a.PersonFullName,
 case 
 when a.AccountingDocumentType = 'KR' then cast('Invoice - FI' as abap.char( 30 ))
 when a.AccountingDocumentType = 'KG' then cast('Debit Note - FI' as abap.char( 30 ))
 when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'S' then cast('Invoice' as abap.char( 30 ))
 when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'H' then cast('Debit Note' as abap.char( 30 )) 
 when a.IsReversal = 'X' then cast('Reversal Document' as abap.char( 30 ))
 when a.IsReversed = 'X' then cast('Reversed Document' as abap.char( 30 ))
 else ''
 end as doccat,
 b.Plant,
 f.PlantName,
 a.TaxCode,
 a.pan_no,
 a.TransactionCode,
 a.DocumentItemText,
 b.Segment,
 g.SegmentName,
 b.Product,
 b.TransactionCurrency,
 b.ProfitCenter,
 h.ProfitCenterName,
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
 else '' end as region_code,
 i.GLAccountName,  
 a.IsReversal,
 a.IsReversed,
 j.GLAccount as GL_Ac, // added by vvk
// j.GLAccountName as GL_Description,
 k.GLAccount as gl_ac1,
 k.GLAccountLongName as gl_long,
 case when k.GLAccount is not null
     then k.GLAccountLongName 
    else 
      j.GLAccountName
    end as GL_Description, // added by vvk
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
    a.FLAG_BASE_AMT
}
where a.TaxItemAcctgDocItemRef > '000000' and a.AccountingDocumentType <> 'RK'

//Invoice Reduction

union all

select from zcds_gstr2_ddl1 as a 
//BASEVALUELINE
left outer join I_OperationalAcctgDocItem as b on a.AccountingDocument = b.AccountingDocument and a.CompanyCode = b.CompanyCode 
and a.FiscalYear = b.FiscalYear and a.TaxItemAcctgDocItemRef = b.TaxItemAcctgDocItemRef and b.AccountingDocumentItemType <> 'T'
//and ((b.AccountingDocumentType = 'RE' and b.Quantity <> 0) or b.AccountingDocumentType <> 'RE')
//association[0..1] to I_TaxCodeText as _c on a.TaxCode = _c.TaxCode and _c.TaxCalculationProcedure = '0TXIN'
left outer join I_OperationalAcctgDocItem as c on a.AccountingDocument = c.AccountingDocument //TCS
and a.CompanyCode = c.CompanyCode and a.FiscalYear = c.FiscalYear and c.TaxItemAcctgDocItemRef = a.TaxItemAcctgDocItemRef
and c.AccountingDocumentItemType = 'T' and c.TransactionTypeDetermination = 'JTC'
left outer join I_KR_BusinessPlace as d on a.BusinessPlace = d.Branch and a.CompanyCode = d.CompanyCode
left outer join I_SupplierAccountGroupText as e on a.SupplierAccountGroup = e.SupplierAccountGroup and e.Language = 'E'
left outer join I_Plant as f on b.Plant = f.Plant
left outer join I_SegmentText as g on b.Segment = g.Segment and g.Language = 'E'
left outer join I_ProfitCenterText as h on b.ProfitCenter = h.ProfitCenter and h.Language = 'E'
left outer join I_GLAccountText as i on b.GLAccount = i.GLAccount and b.ChartOfAccounts = i.ChartOfAccounts
and i.Language = 'E'
left outer join ZGL_DETAILS_FOR_GSTR as j on a.AccountingDocument = j.AccountingDocument
and a.CompanyCode = j.CompanyCode and a.FiscalYear = j.FiscalYear // added by vvk
left outer join ZGL_FOR_SR_IR as k on a.AccountingDocument = k.AccountingDocument
and a.CompanyCode = k.CompanyCode and a.FiscalYear = k.FiscalYear
//and a.AccountingDocumentItem = k.AccountingDocumentItem
{
 key a.AccountingDocument,
 key a.CompanyCode,
 key a.FiscalYear,
 key a.TaxItemAcctgDocItemRef,
 a.FiscalPeriod,
 a.TaxNumber3,
 a.Supplier,
 a.SupplierName,
 a.Region,
 a.RegionName,
 a.DocumentReferenceID,
 a.DocumentDate,
 a.OriginalReferenceDocument,
 a.CompanyCodeCurrency as CompanyCodeCurrency,
 a.TransactionTypeDetermination,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.TransactionTypeDetermination = 'JCN' or a.TransactionTypeDetermination = 'JIN' then b.AmountInCompanyCodeCurrency
      else a.BASE_AMT end as BASE_AMT,
 round(cast( ((get_numeric_value(a.CGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as cgst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRCGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.CGST_AMT as abap.dec( 23, 2 )) end as CGST_AMT,
 //a.CGST_AMT,
 round(cast( ((get_numeric_value(a.SGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as sgst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRSGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.SGST_AMT as abap.dec( 23, 2 )) end as SGST_AMT,
 //a.SGST_AMT,
 round(cast( ((get_numeric_value(a.IGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as igst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRIGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.IGST_AMT as abap.dec( 23, 2 )) end as IGST_AMT,
 //a.IGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 case when a.RCMRCGST_AMT <> 0.00 or a.RCMRIGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 ))
                                  else cast( a.TOT_TAX as abap.dec( 23, 2 )) end as TOT_TAX,
 //a.TOT_TAX,
 a.RCMRCGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMRSGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMRIGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.TOTRRCM_AMT, 
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 a.RCMPCGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMPSGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMPIGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.TOTPRCM_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 abs(c.AmountInCompanyCodeCurrency) as TCS_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
 case when a.TransactionTypeDetermination = 'JCN' or a.TransactionTypeDetermination = 'JIN' 
 then coalesce(get_numeric_value(a.TOTPRCM_AMT),0) + coalesce(get_numeric_value(b.AmountInCompanyCodeCurrency),0)
 else coalesce(get_numeric_value(a.TOT_INVOICE),0) + coalesce(get_numeric_value(c.AmountInCompanyCodeCurrency),0) 
 end as TOT_INVOICE,
 a.IN_GSTPlaceOfSupply,
 a.BusinessPlace,
 d.BusinessPlaceName,
 d.TaxNumber1,
 b.GLAccount,  
 a.SupplierAccountGroup,
 e.AccountGroupName,
 a.PostingDate,
 case a.Country when 'IN' then cast( 'DOMESTIC' as abap.char( 15 )) else cast( 'IMPORT' as abap.char( 15 ))
 end as trans_type,
 a.AccountingDocumentCreationDate,
 a.CreationTime,
 a.AccountingDocumentType,
 a.AccountingDocumentTypeName,
 a.PersonFullName,
 case 
 when a.AccountingDocumentType = 'KR' then cast('Invoice - FI' as abap.char( 30 ))
 when a.AccountingDocumentType = 'KG' then cast('Debit Note - FI' as abap.char( 30 ))
 when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'S' then cast('Invoice' as abap.char( 30 )) 
 //when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'H' then cast('Debit Note' as abap.char( 30 )) // old Code 
 when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'H' then cast('Invoice' as abap.char( 30 )) // New code
 when a.IsReversal = 'X' then cast('Reversal Document' as abap.char( 30 ))
 when a.IsReversed = 'X' then cast('Reversed Document' as abap.char( 30 ))
 else ''
 end as doccat,
 b.Plant,
 f.PlantName,
 a.TaxCode,
 a.pan_no,
 a.TransactionCode,
 a.DocumentItemText,
 b.Segment,
 g.SegmentName,
 b.Product,
 b.TransactionCurrency,
 b.ProfitCenter,
 h.ProfitCenterName,
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
 else '' end as region_code,
 i.GLAccountName,   
 a.IsReversal,
 a.IsReversed,
 j.GLAccount as GL_Ac, // added by vvk
 k.GLAccount as gl_ac1,
 k.GLAccountLongName as gl_long,
 case when k.GLAccount is not null
    then 
     k.GLAccountLongName     
     else 
    j.GLAccountName //as GL_Description
 end as GL_Description, // added by vvk
// @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 a.FLAG_BASE_AMT
}
where a.TaxItemAcctgDocItemRef = '000001' and a.AccountingDocumentType = 'RK'

union all

select from zcds_gstr2_ddl1 as a 
//BASEVALUELINE
left outer join I_OperationalAcctgDocItem as b on a.AccountingDocument = b.AccountingDocument and a.CompanyCode = b.CompanyCode 
and a.FiscalYear = b.FiscalYear and b.TaxItemAcctgDocItemRef = '000001' and b.AccountingDocumentItemType <> 'T'
//and ((b.AccountingDocumentType = 'RE' and b.Quantity <> 0) or b.AccountingDocumentType <> 'RE')
//association[0..1] to I_TaxCodeText as _c on a.TaxCode = _c.TaxCode and _c.TaxCalculationProcedure = '0TXIN'
left outer join I_OperationalAcctgDocItem as c on a.AccountingDocument = c.AccountingDocument //TCS
and a.CompanyCode = c.CompanyCode and a.FiscalYear = c.FiscalYear and c.TaxItemAcctgDocItemRef = a.TaxItemAcctgDocItemRef
and c.AccountingDocumentItemType = 'T' and c.TransactionTypeDetermination = 'JTC'
left outer join I_KR_BusinessPlace as d on a.BusinessPlace = d.Branch and a.CompanyCode = d.CompanyCode
left outer join I_SupplierAccountGroupText as e on a.SupplierAccountGroup = e.SupplierAccountGroup and e.Language = 'E'
left outer join I_Plant as f on b.Plant = f.Plant
left outer join I_SegmentText as g on b.Segment = g.Segment and g.Language = 'E'
left outer join I_ProfitCenterText as h on b.ProfitCenter = h.ProfitCenter and h.Language = 'E'
left outer join I_GLAccountText as i on b.GLAccount = i.GLAccount and b.ChartOfAccounts = i.ChartOfAccounts
and i.Language = 'E'
left outer join ZGL_DETAILS_FOR_GSTR as j on a.AccountingDocument = j.AccountingDocument
and a.CompanyCode = j.CompanyCode and a.FiscalYear = j.FiscalYear // added by vvk
left outer join ZGL_FOR_SR_IR as k on a.AccountingDocument = k.AccountingDocument
and a.CompanyCode = k.CompanyCode and a.FiscalYear = k.FiscalYear
//and a.AccountingDocumentItem = k.AccountingDocumentItem
{
 key a.AccountingDocument,
 key a.CompanyCode,
 key a.FiscalYear,
 key a.TaxItemAcctgDocItemRef,
 a.FiscalPeriod,
 a.TaxNumber3,
 a.Supplier,
 a.SupplierName,
 a.Region,
 a.RegionName,
 a.DocumentReferenceID,
 a.DocumentDate,
 a.OriginalReferenceDocument,
 a.CompanyCodeCurrency as CompanyCodeCurrency,
 a.TransactionTypeDetermination,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.TransactionTypeDetermination = 'JCN' or a.TransactionTypeDetermination = 'JIN' then b.AmountInCompanyCodeCurrency
      else a.BASE_AMT end as BASE_AMT,
 round(cast( ((get_numeric_value(a.CGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as cgst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRCGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.CGST_AMT as abap.dec( 23, 2 )) end as CGST_AMT,
 //a.CGST_AMT,
 round(cast( ((get_numeric_value(a.SGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as sgst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRSGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.SGST_AMT as abap.dec( 23, 2 )) end as SGST_AMT,
 //a.SGST_AMT,
 round(cast( ((get_numeric_value(a.IGST_AMT) / get_numeric_value(a.BASE_AMT)) * 100) as abap.dec( 13, 2 ) ),1) as igst_rate,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when a.RCMRIGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 )) 
                                  else cast( a.IGST_AMT as abap.dec( 23, 2 )) end as IGST_AMT,
 //a.IGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 case when a.RCMRCGST_AMT <> 0.00 or a.RCMRIGST_AMT <> 0.00 then cast( 0.00 as abap.dec( 23, 2 ))
                                  else cast( a.TOT_TAX as abap.dec( 23, 2 )) end as TOT_TAX,
 //a.TOT_TAX,
 a.RCMRCGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMRSGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMRIGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.TOTRRCM_AMT, 
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 a.RCMPCGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMPSGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.RCMPIGST_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 a.TOTPRCM_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 abs(c.AmountInCompanyCodeCurrency) as TCS_AMT,
 //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
 case when a.TransactionTypeDetermination = 'JCN' or a.TransactionTypeDetermination = 'JIN' 
 then coalesce(get_numeric_value(a.TOTPRCM_AMT),0) + coalesce(get_numeric_value(b.AmountInCompanyCodeCurrency),0)
 else coalesce(get_numeric_value(a.TOT_INVOICE),0) + coalesce(get_numeric_value(c.AmountInCompanyCodeCurrency),0) 
 end as TOT_INVOICE,
 a.IN_GSTPlaceOfSupply,
 a.BusinessPlace,
 d.BusinessPlaceName,
 d.TaxNumber1,
 b.GLAccount, 
 a.SupplierAccountGroup,
 e.AccountGroupName,
 a.PostingDate,
 case a.Country when 'IN' then cast( 'DOMESTIC' as abap.char( 15 )) else cast( 'IMPORT' as abap.char( 15 ))
 end as trans_type,
 a.AccountingDocumentCreationDate,
 a.CreationTime,
 a.AccountingDocumentType,
 a.AccountingDocumentTypeName,
 a.PersonFullName,
 case 
 when a.AccountingDocumentType = 'KR' then cast('Invoice - FI' as abap.char( 30 ))
 when a.AccountingDocumentType = 'KG' then cast('Debit Note - FI' as abap.char( 30 ))
 when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'S' then cast('Invoice' as abap.char( 30 ))
 //when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'H' then cast('Debit Note' as abap.char( 30 )) // old code
 when a.AccountingDocumentType = 'RE' and b.DebitCreditCode = 'H' then cast('Invoice' as abap.char( 30 )) // new code
 when a.IsReversal = 'X' then cast('Reversal Document' as abap.char( 30 ))
 when a.IsReversed = 'X' then cast('Reversed Document' as abap.char( 30 ))
 else ''
 end as doccat,
 b.Plant,
 f.PlantName,
 a.TaxCode,
 a.pan_no,
 a.TransactionCode,
 a.DocumentItemText,
 b.Segment,
 g.SegmentName,
 b.Product,
 b.TransactionCurrency,
 b.ProfitCenter,
 h.ProfitCenterName,
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
 else '' end as region_code,
 i.GLAccountName, 
 a.IsReversal,
 a.IsReversed,
 j.GLAccount as GL_Ac, // added by vvk
 k.GLAccount as gl_ac1,
 k.GLAccountLongName as gl_long,
   case when k.GLAccount is not null
       then k.GLAccountLongName     
     else 
        j.GLAccountName 
     end as GL_Description,// added by vvk
//    @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
    a.FLAG_BASE_AMT // added by vvk
}
where a.TaxItemAcctgDocItemRef > '000001' and a.AccountingDocumentType = 'RK'

 





