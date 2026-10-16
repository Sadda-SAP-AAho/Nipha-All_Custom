@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 FI Details Base final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'GSTR1 Dels' ,
                  typeNamePlural: 'GSTR1 Details Report'
                   }
define view entity ZGSTR1_DETAILS_FI_BASE_final 
   as select from ZGSTR1_DETAILS_FI_BASE4 as A
{
 key A.CompanyCode,
 key A.AccountingDocument ,
 key A.FiscalYear,
 key cast(A.AccountingDocumentItem as abap.char(4)) as AccountingDocumentItem,
     A.AccountingDocumentType,
     A.GLAccountLongName,  //c.GLAccountName, old code
     A.CUSTOMER_GSTIN,
     A.CUSTOMER_NAME,
     A.region_code,
     A.Customer,
     A.OriginalReferenceDocument,
     A.DocumentDate,
     A.DocumentReferenceID,
     A.PostingDate,
     A.FiscalPeriod,     
     A.inv_type,
     A.Plant,
     A.PlantName,
     A.Material,
     A.ProductDescription,
     A.hsn_sac_code,
     A.BusinessPlace,
     A.Segment,
     A.SegmentName,
     cast(A.IN_GSTPlaceOfSupply as abap.char( 15 )) as IN_GSTPlaceOfSupply,
     A.shipping_bill_no,
     A.shipping_bill_dt,
     A.TransactionCurrency,
     A.billing_unit,
     A.GLAccount,
     A.CompanyCodeCurrency,
     A.BillingDocument,
     A.BillingDocumentDate,
     @Semantics.quantity.unitOfMeasure: 'billing_unit'
     case when AccountingDocumentType = 'DG'
        then A.billing_qty * -1
        else
        A.billing_qty
        end as billing_qty,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     case when AccountingDocumentType = 'DG'
        then A.base_amount * -1
        else
        A.base_amount
        end as base_amount,
     A.cgst_rate,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     case when AccountingDocumentType = 'DG'
        then
          A.CGST_AMOUNT *-1
        else
          A.CGST_AMOUNT
        end as CGST_AMOUNT,
     A.sgst_rate,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     case when AccountingDocumentType = 'DG'
        then
         A.SGST_AMOUNT *-1
        else
        A.SGST_AMOUNT
         end as SGST_AMOUNT,
     A.igst_rate,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     case when AccountingDocumentType = 'DG'
        then
        A.IGST_AMOUNT *-1
        else
        A.IGST_AMOUNT
       end as IGST_AMOUNT,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     case when ( A.CGST_AMOUNT > 000000000000.00 or A.IGST_AMOUNT > 000000000000.00 ) then
    cast(A.total_tax_value as abap.dec( 15, 2 ))   
     else 
     cast(A.base_amount as abap.dec( 15, 2 ))   //A.base_amount
     end as total_tax_value,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//     A.TCS_AMT,   
     cast(A.TCS_AMT as abap.dec( 15, 2 )) as TCS_AMT,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     cast(total_value_with_tcs as abap.dec( 15, 2 )) as total_value_with_tcs,
//     A.total_value_with_tcs,
     A.RegionName,
     A.RegionName as PLACE_OF_SUPPLY,
     A.UOM1,
     cast('    ' as abap.char( 4 )) as BillingDocumentType,
     case when (AccountingDocumentType = 'DG' or base_amount1 < 0 )
        then
         A.base_with_gst *-1
        else
        A.base_with_gst
         end as base_with_gst,
     case when ( AccountingDocumentType = 'DG' or base_amount1 < 0 )
        then
         A.tot_gst *-1
        else
        A.tot_gst
         end as tot_gst

       

 
}
where A.AccountingDocumentType <> 'RV'
union 
select from ZGSTR1_DETAILS_BASE4 as A
{
    key A.CompanyCode,
    key A.AccountingDocument,
    key A.FiscalYear,
    key cast(A.AccountingDocumentItem as abap.char(4)) as AccountingDocumentItem,//A.AccountingDocumentItem,
    A.AccountingDocumentType,
    A.GLAccountLongName,//GLAccountLongName,
    A.CUSTOMER_GSTIN,
    A.CUSTOMER_NAME,   
    A.region_code,
    A.customer,
    A.OriginalReferenceDocument,
    A.DocumentDate,
    A.DocumentReferenceID,
    A.PostingDate,
    A.FiscalPeriod,
    A.inv_type,
    A.Plant,
    A.plantname,
    A.Material,
    A.ProductDescription,
    A.hsn_sac_code,
    A.BusinessPlace,
    A.Segment,
    A.SegmentName,
    //A.IN_GSTPlaceOfSupply,
    cast(A.IN_GSTPlaceOfSupply as abap.char( 15 )) as IN_GSTPlaceOfSupply,
    A.shipping_bill_no,
    A.shipping_bill_dt,
    A.TransactionCurrency,
    A.billing_unit,
    A.GLAccount,
    A.CompanyCodeCurrency,
    A.BillingDocument,
    A.BillingDocumentDate,
    A.billing_qty,
 //   A.base_amount,
    cast(A.base_amount as abap.dec( 15, 2 ))  as base_amount,
    A.cgst_rate as cgst_rate,
    A.CGST_AMOUNT,
    A.sgst_rate as sgst_rate, 
    A.SGST_AMOUNT,
    A.igst_rate as igst_rate,
    A.IGST_AMOUNT,
//    A.total_tax_value,
    case when ( A.CGST_AMOUNT is not null or A.IGST_AMOUNT is not null ) then
//    A.total_tax_value
      cast(A.total_tax_value as abap.dec( 15, 2 ))  
    else
    cast(base_amount as abap.dec( 15, 2 ))  
    end as total_tax_value,
//  case when ( A.CGST_AMOUNT > '000000000000000.00' or A.IGST_AMOUNT > 0) then
/*   case when (( A.CGST_AMOUNT > 000000000000.00) or (A.IGST_AMOUNT > 000000000000.00 )) then
     A.total_tax_value
     else 
     A.base_amount
     end as */
//    A.total_tax_value,

    A.TCS_AMT,

    A.total_value_with_tcs,
    A.RegionName,
    A.PLACE_OF_SUPPLY,
    A.UOM1,
    A.BillingDocumentType,
   case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2'
       or A.base_amount2 < 0)
       then base_with_gst * -1
       else base_with_gst end as base_with_gst,
   case when (A.BillingDocumentType = 'S1' or A.BillingDocumentType = 'CBRE' or A.BillingDocumentType = 'G2' 
        or A.base_amount2 < 0)
       then tot_gst * -1
       else tot_gst end as tot_gst 

    
    
}
where A.AccountingDocumentType = 'RV'




/*as select from ZGSTR1_DETAILS_FI_BASE2 as A

 key A.AccountingDocument ,
 @UI.lineItem: [{ position: 15 }]
 @UI.selectionField: [{ position: 15 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'ccode'
 } }]
 key A.CompanyCode,
 @UI.lineItem: [{ position: 20 }]
 @UI.selectionField: [{ position: 20 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'fyear'
 } }]
 key A.FiscalYear,
 @UI.lineItem: [{ position: 75 }]
 A.GLAccountLongName,  //c.GLAccountName, old code
 @UI.lineItem: [{ position: 25, label: 'Customer GSTN' }]
 @UI.selectionField: [{ position: 25 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'Customer'
 } }]
 A.CUSTOMER_GSTIN,
 //key a.AccountingDocument,
 @UI.lineItem: [{ position: 30 }]
 @UI.selectionField: [{ position: 30 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'CustomerName'
 } }]
 A.CUSTOMER_NAME,
 //key a.CompanyCode,
 @UI.lineItem: [{ position: 35 }]
 @UI.selectionField: [{ position: 35 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'region_code'
 } }]
 @EndUserText.label: 'Region Code'
     A.region_code,
 //key a.FiscalYear,
 @UI.lineItem: [{ position: 40, label: 'SAP Document Number' }]
     A.OriginalReferenceDocument,
 //    a.FiscalPeriod,
 @UI.lineItem: [{ position: 45, label: 'Invoice Date' }]
 @UI.selectionField: [{ position: 45 }]
 @Consumption.valueHelpDefinition: [{
//     qualifier: '',
     entity: {
         name: 'zsh_gstr1',
         element: 'DocumentDate'
     },
     distinctValues: true,
//     useForValidation: true,
//     enabled: '',
//     additionalBinding: [{
//         localParameter: '',
//         localElement: '',
//         localConstant: '',
//         parameter: '',
//         element: '',
//         usage: 
//     }],
     label: 'Invoice Date'
//     presentationVariantQualifier: ''
 }]
     A.DocumentDate,
 @UI.lineItem: [{ position: 50, label: 'Invoice Number' }] 
 @UI.selectionField: [{ position: 50 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'DocumentReferenceID'
 } }]
     A.DocumentReferenceID,
 @UI.lineItem: [{ position: 55 }]
 @UI.selectionField: [{ position: 55 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'PostingDate'
 } }]
     A.PostingDate,     
 @UI.lineItem: [{ position: 60, label: 'Invoice Type' }]
     A.inv_type,
 @UI.lineItem: [{ position: 65 }]
 @UI.selectionField: [{ position: 65 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'Plant'
 } }]
     A.Plant,
 @UI.lineItem: [{ position: 70 }]
     A.PlantName,
 @UI.lineItem: [{ position: 75 }]
     A.Segment,
 @UI.lineItem: [{ position: 80 }]
     A.SegmentName,
 @UI.lineItem: [{ position: 85, label: 'Place Of Supply' }]
     A.IN_GSTPlaceOfSupply,
 @UI.lineItem: [{ position: 90 }]
     A.shipping_bill_no,
 @UI.lineItem: [{ position: 95 }]
     A.shipping_bill_dt,
 @UI.lineItem: [{ position: 100 }]
     A.TransactionCurrency,
 @UI.lineItem: [{ position: 105, label: 'Sales Unit' }]
     A.billing_unit,
     ----------------- ADDED BY VIVEK---------------------
 @UI.lineItem: [{ position: 115, label: 'GL' }]    
     A.GLAccount,
     
 @UI.lineItem: [{ position: 115, label: 'Company code Currency' }] 
     A.CompanyCodeCurrency,
 //@UI.lineItem: [{ position: 140, label: 'GL Name' }] 
  //   c.GLAccountName as GL_Description,  
 //    e.GLAccountName as GL_Description,// old code 3.6.2024
     ----------------- ADDED BY VIVEK---------------------
 @UI.lineItem: [{ position: 145, label: 'Invoice Qty.' }]
 @Semantics.quantity.unitOfMeasure: 'billing_unit'
    A.billing_qty,
 @UI.lineItem: [{ position: 150, label: 'Base Amt.' }]
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.base_amount,
 @UI.lineItem: [{ position: 155, label: 'CGST Rate' }]
 
     A.cgst_rate,
 @UI.lineItem: [{ position: 160, label: 'CGST Amt.' }]
 @Semantics.amount.currencyCode: 'TransactionCurrency'
     A.CGST_AMOUNT,
 @UI.lineItem: [{ position: 165, label: 'SGST Rate' }]
     A.sgst_rate,
 @UI.lineItem: [{ position: 170, label: 'SGST Amt.' }]
 @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.SGST_AMOUNT,
 @UI.lineItem: [{ position: 175, label: 'IGST Rate' }]
     A.igst_rate,
 @UI.lineItem: [{ position: 180, label: 'IGST Amt.' }]
 @Semantics.amount.currencyCode: 'TransactionCurrency'
    A.IGST_AMOUNT,
 @UI.lineItem: [{ position: 185, label: 'Total Tax Amt.' }]
 @Semantics.amount.currencyCode: 'TransactionCurrency' 
    A.total_tax_value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
 @UI.lineItem: [{ position: 190, label: 'TCS Amt.' }] 
    A.TCS_AMT,   
 @Semantics.amount.currencyCode: 'TransactionCurrency'
 @UI.lineItem: [{ position: 195, label: 'Total Invoice Amt.' }]
 case when A.TCS_AMT is not initial
    then A.total_tax_value + A.TCS_AMT
    else
         A.total_tax_value
    end as total_value_with_tcs,
//    A.total_value_wth_tcs,
   
 @UI.lineItem: [{ position: 200, label: 'Region Name' }] 
     A.RegionName,
 @UI.lineItem: [{ position: 205, label: 'Place Of Supply Name' }] 
     A.RegionName as PLACE_OF_SUPPLY  

/*    key AccountingDocument,
    key CompanyCode,
    key FiscalYear,
    AccountingDocumentType,
    FiscalPeriod,
    FinancialTransactionType,
    TransactionTypeDetermination,
    FinancialAccountType,
    TransactionCurrency,
    Customer,
    CUSTOMER_NAME,
    CUSTOMER_GSTIN,
    region_code,
    BusinessPlace,
    PostingDate,
    DocumentDate,
    TransactionCode,
    OriginalReferenceDocument,
    ReverseDocument,
    ReverseDocumentFiscalYear,
    IsReversal,
    IsReversed,
    AccountingDocCreatedByUser,
    DocumentReferenceID,
    base_amount,
    CGST_AMOUNT,
    cgst_rate,
    SGST_AMOUNT,
    sgst_rate,
    IGST_AMOUNT,
    TCS_AMT,
    igst_rate,
    Billing_doc,
    UNIT_OF_ENTRY,
    GST_PARTNER,
    PLACE_OF_SUPPLY,
    UOM,
    ControllingArea,
    Segment,
    ProfitCenter,
    ITEM_TEXT,
    Material,
    ProductDescription,
    Plant,
    PlantName,
    cgst_item,
    igst_item,
    billing_unit,
    billing_qty,
    shipping_bill_no,
    shipping_bill_dt,
    IGST_INF,
    inv_type,
    total_tax_value,
    total_value_wth_tcs*/

