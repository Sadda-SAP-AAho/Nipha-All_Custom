@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - GSTR2 View 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_gstr2_ddl1 as select from I_OperationalAcctgDocItem as a
left outer join I_Supplier as b on a.Supplier = b.Supplier
left outer join I_RegionText as i on b.Country = i.Country and b.Region = i.Region and i.Language = 'E'
left outer join I_JournalEntry as f on a.CompanyCode = f.CompanyCode and a.AccountingDocument = f.AccountingDocument
 and a.FiscalYear = f.FiscalYear 
left outer join I_BusinessUserBasic as l on f.AccountingDocCreatedByUser = l.UserID
left outer join I_AccountingDocumentTypeText as m on f.AccountingDocumentType = m.AccountingDocumentType and m.Language = 'E'
left outer join I_OperationalAcctgDocItem as e on a.AccountingDocument = e.AccountingDocument //CGST
 and a.CompanyCode = e.CompanyCode and a.FiscalYear = e.FiscalYear and e.AccountingDocumentItemType = 'T' 
 and e.FinancialAccountType = 'S' and e.TransactionTypeDetermination = 'JIC'
left outer join I_OperationalAcctgDocItem as c on e.AccountingDocument = c.AccountingDocument //SGST
 and e.CompanyCode = c.CompanyCode and e.FiscalYear = c.FiscalYear and e.TaxItemAcctgDocItemRef = c.TaxItemAcctgDocItemRef
 and ( c.TransactionTypeDetermination = 'JIS' or c.TransactionTypeDetermination = 'JIU' ) and c.AccountingDocumentItemType = 'T'
left outer join I_OperationalAcctgDocItem as h on a.AccountingDocument = h.AccountingDocument //IGST
 and a.CompanyCode = h.CompanyCode and a.FiscalYear = h.FiscalYear and h.AccountingDocumentItemType = 'T' 
 and h.FinancialAccountType = 'S' and ( h.TransactionTypeDetermination = 'JII' or h.TransactionTypeDetermination = 'JIM' )
left outer join I_OperationalAcctgDocItem as d on e.AccountingDocument = d.AccountingDocument //RCMRCGST
and e.CompanyCode = d.CompanyCode and e.FiscalYear = d.FiscalYear and e.TaxItemAcctgDocItemRef = d.TaxItemAcctgDocItemRef
and d.TransactionTypeDetermination = 'JRC' and d.AccountingDocumentItemType = 'T'
left outer join I_OperationalAcctgDocItem as g on h.AccountingDocument = g.AccountingDocument //RCMRIGST
and h.CompanyCode = g.CompanyCode and h.FiscalYear = g.FiscalYear and h.TaxItemAcctgDocItemRef = g.TaxItemAcctgDocItemRef
and g.TransactionTypeDetermination = 'JRI' and g.AccountingDocumentItemType = 'T'
left outer join I_OperationalAcctgDocItem as j on a.AccountingDocument = j.AccountingDocument //RCMPCGST
and a.CompanyCode = j.CompanyCode and a.FiscalYear = j.FiscalYear and j.TransactionTypeDetermination = 'JCN'
and j.AccountingDocumentItemType = 'T'
left outer join I_OperationalAcctgDocItem as k on a.AccountingDocument = k.AccountingDocument //RCMPIGST
and a.CompanyCode = k.CompanyCode and a.FiscalYear = k.FiscalYear and k.TransactionTypeDetermination = 'JIN'
and k.AccountingDocumentItemType = 'T'
 {
 key a.AccountingDocument,
 key a.CompanyCode,
 key a.FiscalYear,
 key a.AccountingDocumentItem,
 a.FiscalPeriod,
 a.CompanyCodeCurrency,
 a.TransactionCurrency,
 a.BusinessPlace,
 a.DocumentItemText,
 b.Supplier,
 b.SupplierName,
 b.SupplierAccountGroup,
 b.TaxNumber3,
 b.Region,
 b.Country,
 substring(b.TaxNumber3,3,10) as pan_no,
 i.RegionName,
 f.PostingDate,
 f.DocumentDate,
 f.OriginalReferenceDocument,
 f.DocumentReferenceID,
 f.AccountingDocumentCreationDate,
 f.CreationTime,
 f.AccountingDocumentType,
 f.AccountingDocCreatedByUser,
 f.IsReversal,
 f.IsReversed,
 f.TransactionCode,
 l.PersonFullName,
 m.AccountingDocumentTypeName,
 coalesce(coalesce(j.TaxCode,k.TaxCode),coalesce(e.TaxCode,h.TaxCode)) as TaxCode,
 coalesce(coalesce(j.ChartOfAccounts,k.ChartOfAccounts),coalesce( e.ChartOfAccounts,h.ChartOfAccounts )) as ChartOfAccounts,
 a.IN_GSTPlaceOfSupply,
 coalesce(coalesce(j.TaxItemAcctgDocItemRef,k.TaxItemAcctgDocItemRef),coalesce( e.TaxItemAcctgDocItemRef,h.TaxItemAcctgDocItemRef )) as TaxItemAcctgDocItemRef,
 coalesce(coalesce(j.TransactionTypeDetermination,k.TransactionTypeDetermination),coalesce( e.TransactionTypeDetermination, h.TransactionTypeDetermination )) as TransactionTypeDetermination,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce(e.TaxBaseAmountInCoCodeCrcy,h.TaxBaseAmountInCoCodeCrcy)) as BASE_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 coalesce(e.TaxBaseAmountInCoCodeCrcy,h.TaxBaseAmountInCoCodeCrcy) as FLAG_BASE_AMT, 
 //When RCM Recv(JRC/JRS/JRI) is present -> no CGST/SGST/IGST value will flow in Normal GST columns 
 //                                      -> Original CGST/SGST/IGST value will flow in RCM GST columns
 //Else                                  -> Absolute/Positive CGST/SGST/IGST value will flow in Normal GST Columns
 
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(e.AmountInCompanyCodeCurrency) as CGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(c.AmountInCompanyCodeCurrency) as SGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 abs(h.AmountInCompanyCodeCurrency) as IGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(coalesce((e.AmountInCompanyCodeCurrency * 2),h.AmountInCompanyCodeCurrency )) as TOT_TAX,
 
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 case when d.AmountInCompanyCodeCurrency <> 0.00 then 
 cast(e.AmountInCompanyCodeCurrency as abap.dec( 23, 2 )) end as RCMRCGST_AMT,
 //e.AmountInCompanyCodeCurrency as RCMRCGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
 case when d.AmountInCompanyCodeCurrency <> 0.00 then 
 cast(c.AmountInCompanyCodeCurrency as abap.dec( 23, 2 )) end as RCMRSGST_AMT,
 //abs(d.AmountInCompanyCodeCurrency) as RCMRSGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 case when g.AmountInCompanyCodeCurrency <> 0.00 then  
 cast(h.AmountInCompanyCodeCurrency as abap.dec( 23, 2 )) end as RCMRIGST_AMT, 
 //abs(g.AmountInCompanyCodeCurrency) as RCMRIGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case when d.AmountInCompanyCodeCurrency <> 0.00 or g.AmountInCompanyCodeCurrency <> 0.00 then 
 cast(coalesce((e.AmountInCompanyCodeCurrency * 2),h.AmountInCompanyCodeCurrency) as abap.dec( 23, 2 )) end as TOTRRCM_AMT,
 //abs(coalesce((d.AmountInCompanyCodeCurrency * 2),g.AmountInCompanyCodeCurrency)) as TOTRRCM_AMT,
 
 //Both sets of (JRC/JRS/JRI) and (JCN/JSN/JIN) values will flow in RCM Pay. Columns
 
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 coalesce(j.AmountInCompanyCodeCurrency,d.AmountInCompanyCodeCurrency) as RCMPCGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 coalesce(j.AmountInCompanyCodeCurrency,d.AmountInCompanyCodeCurrency) as RCMPSGST_AMT, 
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
 coalesce(k.AmountInCompanyCodeCurrency,g.AmountInCompanyCodeCurrency) as RCMPIGST_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 coalesce( coalesce((j.AmountInCompanyCodeCurrency * 2),k.AmountInCompanyCodeCurrency), 
           coalesce((d.AmountInCompanyCodeCurrency * 2),g.AmountInCompanyCodeCurrency) )
 as TOTPRCM_AMT,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 abs(
     coalesce( ((e.AmountInCompanyCodeCurrency * 2) + e.TaxBaseAmountInCoCodeCrcy), (h.AmountInCompanyCodeCurrency + h.TaxBaseAmountInCoCodeCrcy) )) as TOT_INVOICE 
 }
where a.FinancialAccountType = 'K'
