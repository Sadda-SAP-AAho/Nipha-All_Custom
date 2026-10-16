@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR2 Entity 4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_GSTR2_DDL4 as select from zcds_gstr2_ddl3 as A
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
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    case when A.TOTPRCM_AMT is not initial
    then coalesce(get_numeric_value(A.TOTPRCM_AMT),0) + coalesce(get_numeric_value(A.TOT_INVOICE),0)
    else
       cast( A.TOT_INVOICE as abap.dec( 23, 2 ))
    end as  TOT_INVOICE,
   
//    A.TOT_INVOICE,
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
    case when (A.FLAG_BASE_AMT <> 0 and A.FLAG_BASE_AMT <0)
    then cast('NEGA' as abap.char( 4 ))
    else
         cast('PLUS' as abap.char( 4 ))
    end as FLAG1,
    case when ((A.GLAccount = '0045000300' or A.GLAccount = '0045000660' or
     A.GLAccount = '0045000330') and (A.AccountingDocumentType = 'KR'))
    then cast('YESKR' as abap.char( 5 ))
         when ((A.GLAccount = '0045000300' or A.GLAccount = '0045000660' or
     A.GLAccount = '0045000330' ) and (A.AccountingDocumentType <> 'KR'))
    then cast('NO_KR' as abap.char( 5 ))
    when((A.GLAccount = '0047000020') and (A.TaxCode = 'CA' or A.TaxCode = 'CB'
         or A.TaxCode = 'CC' or A.TaxCode = 'CD' or A.TaxCode = 'CE' or A.TaxCode = 'CF'
         or A.TaxCode = 'CG' or A.TaxCode = 'CH' or A.TaxCode = 'CI' or A.TaxCode = 'CJ'
         or A.TaxCode = 'CK' or A.TaxCode = 'CL'))
    then cast('YESKR' as abap.char( 5 ))
    when((A.GLAccount = '0047000020') and (A.TaxCode <> 'CA' and A.TaxCode <> 'CB'
         and A.TaxCode <> 'CC' and A.TaxCode <> 'CD' and A.TaxCode <> 'CE' and A.TaxCode <> 'CF'
         and A.TaxCode <> 'CG' and A.TaxCode <> 'CH' and A.TaxCode <> 'CI' and A.TaxCode <> 'CJ'
         and A.TaxCode <> 'CK' and A.TaxCode <> 'CL'))
    then cast('NO_KR' as abap.char( 5 ))  
    else
         cast('YESKR' as abap.char( 5 ))
    end as DOC_KR
    
       
}
where(A.GLAccount <> '0015000010' and A.GLAccount <> '0015000020' and A.GLAccount <> '0015000030'
      and A.GLAccount <> '0015000040' and A.GLAccount <> '0015000050' and A.GLAccount <> '0015000060'
      and A.GLAccount <> '0015000070' and A.GLAccount <> '0015000080' and A.GLAccount <> '0015000090'
      and A.GLAccount <> '0015000100' and A.GLAccount <> '0040010010' and A.GLAccount <> '0040010020'
      and A.GLAccount <> '0040010030' and A.GLAccount <> '0040010040' and A.GLAccount <> '0040010050'
      and A.GLAccount <> '0040010060' and A.GLAccount <> '0040010070' and A.GLAccount <> '0040010080'
      and A.GLAccount <> '0040010090' and A.GLAccount <> '0040010100' //and A.GLAccount <> '0047000020' 
      and A.GLAccount <> '0040030010' and A.GLAccount <> '0040030020'
      and A.GLAccount <> '0040030030' and A.GLAccount <> '0040030040' and A.GLAccount <> '0040030050'
      and A.GLAccount <> '0040030060' and A.GLAccount <> '0040030070' and A.GLAccount <> '0040030080'
      and A.GLAccount <> '0040030090' and A.GLAccount <> '0040030100'
      and A.GLAccount <> '0045000890')

//where A.GLAccount <> '0015000010'
