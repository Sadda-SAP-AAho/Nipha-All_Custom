@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 Entity 5'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_GSTR2_DDL5 as select from ZCDS_GSTR2_DDL4 as A
{
    key A.AccountingDocument,
    key A.CompanyCode,
    key A.FiscalYear,
    key A.TaxItemAcctgDocItemRef,
    A.FiscalPeriod,
    A.TaxNumber3,
    A.Supplier,
    A.SupplierName,
    A.Region,
    A.RegionName,
    A.DocumentReferenceID,
    A.DocumentDate,
    A.OriginalReferenceDocument,
    A.CompanyCodeCurrency,
    A.TransactionTypeDetermination,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.BASE_AMT,
    A.cgst_rate,
    A.CGST_AMT,
    A.sgst_rate,
    A.SGST_AMT,
    A.igst_rate,
    A.IGST_AMT,
    A.TOT_TAX,
    A.RCMRCGST_AMT,
    A.RCMRSGST_AMT,
    A.RCMRIGST_AMT,
    A.TOTRRCM_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.RCMPCGST_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.RCMPSGST_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.RCMPIGST_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.TOTPRCM_AMT,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.TCS_AMT,
    A.TOT_INVOICE,
    A.IN_GSTPlaceOfSupply,
    A.BusinessPlace,
    A.BusinessPlaceName,
    A.TaxNumber1,
    A.GLAccount,
    A.SupplierAccountGroup,
    A.AccountGroupName,
    A.PostingDate,
    A.trans_type,
    A.AccountingDocumentCreationDate,
    A.CreationTime,
    A.AccountingDocumentType,
    A.AccountingDocumentTypeName,
    A.PersonFullName,
    A.doccat,
    A.Plant,
    A.PlantName,
    A.TaxCode,
    A.pan_no,
    A.TransactionCode,
    A.DocumentItemText,
    A.Segment,
    A.SegmentName,
    A.Product,
    A.TransactionCurrency,
    A.ProfitCenter,
    A.ProfitCenterName,
    A.region_code,
    A.GLAccountName,
    A.IsReversal,
    A.IsReversed,
    A.GL_Ac,
    A.gl_ac1,
    A.gl_long,
    A.GL_Description,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.FLAG_BASE_AMT,
    A.FLAG1
}
where A.DOC_KR <> 'NO_KR'
//where( A.GLAccount <> '0045000300' and A.AccountingDocumentType <> 'KR')
//where A.GLAccount <> '0015000010'
