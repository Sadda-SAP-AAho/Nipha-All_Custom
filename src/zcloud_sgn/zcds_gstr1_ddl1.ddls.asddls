@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - GSTR1 Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'GSTR1' ,
                  typeNamePlural: 'GSTR1 Summary Report'
                   }
@UI.presentationVariant: [{ sortOrder: [{ by: 'AccountingDocument', direction: #ASC }] }]
define view entity zcds_gstr1_ddl1 as select from ZCDS_GSTR1_DDL3 as a 
left outer join I_Plant as b on a.Plant = b.Plant
left outer join I_GLAccountText as c on a.GLAccount = c.GLAccount and a.ChartOfAccounts = c.ChartOfAccounts and c.Language = 'E'
left outer join I_SegmentText as d on a.Segment = d.Segment and d.Language = 'E'
left outer join ZGL_DETAILS_FOR_GSTR as e on e.AccountingDocument = a.AccountingDocument
and e.CompanyCode = a.CompanyCode and e.FiscalYear = a.FiscalYear // added by vvk
//define view entity zcds_gstr1_ddl1 as select from zcds_gstr1_tax_2 as a 
{
 @UI.lineItem: [{ position: 10 }]
 @UI.selectionField: [{ position: 10 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'acdoc'
 } }]
 key a.AccountingDocument ,
 @UI.lineItem: [{ position: 15 }]
 @UI.selectionField: [{ position: 15 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'ccode'
 } }]
 key a.CompanyCode,
 @UI.lineItem: [{ position: 20 }]
 @UI.selectionField: [{ position: 20 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'fyear'
 } }]
 key a.FiscalYear,
 @UI.lineItem: [{ position: 75 }]
 key e.GLAccountName,  //c.GLAccountName, old code
 @UI.lineItem: [{ position: 25, label: 'Customer GSTN' }]
 @UI.selectionField: [{ position: 25 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'Customer'
 } }]
 a.TaxNumber3,
 //key a.AccountingDocument,
 @UI.lineItem: [{ position: 30 }]
 @UI.selectionField: [{ position: 30 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'CustomerName'
 } }]
 a.CustomerName,
 //key a.CompanyCode,
 @UI.lineItem: [{ position: 35 }]
 @UI.selectionField: [{ position: 35 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'region_code'
 } }]
 @EndUserText.label: 'Region Code'
     a.region_code,
 //key a.FiscalYear,
 @UI.lineItem: [{ position: 40, label: 'SAP Document Number' }]
     a.OriginalReferenceDocument,
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
     a.DocumentDate,
 @UI.lineItem: [{ position: 50, label: 'Invoice Number' }] 
 @UI.selectionField: [{ position: 50 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'DocumentReferenceID'
 } }]
     a.DocumentReferenceID,
 @UI.lineItem: [{ position: 55 }]
 @UI.selectionField: [{ position: 55 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'PostingDate'
 } }]
     a.PostingDate,     
 @UI.lineItem: [{ position: 60, label: 'Invoice Type' }]
     a.inv_type,
 @UI.lineItem: [{ position: 65 }]
 @UI.selectionField: [{ position: 65 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'Plant'
 } }]
     a.Plant,
 @UI.lineItem: [{ position: 70 }]
     b.PlantName,
 @UI.lineItem: [{ position: 75 }]
     a.Segment,
 @UI.lineItem: [{ position: 80 }]
     d.SegmentName,
 @UI.lineItem: [{ position: 85, label: 'Place Of Supply' }]
     a.IN_GSTPlaceOfSupply,
 @UI.lineItem: [{ position: 90 }]
     a.YY1_ShippingbillNo_BDH,
 @UI.lineItem: [{ position: 95 }]
     a.YY1_shippingbillDate_BDH,
 @UI.lineItem: [{ position: 100 }]
     a.TransactionCurrency,
 @UI.lineItem: [{ position: 105, label: 'Sales Unit' }]
     a.BillingQuantityUnit,
     ----------------- ADDED BY VIVEK---------------------
 @UI.lineItem: [{ position: 115, label: 'GL' }]    
     e.GLAccount,
 @UI.lineItem: [{ position: 140, label: 'GL Name' }] 
  //   c.GLAccountName as GL_Description,  
     e.GLAccountName as GL_Description,// old code 3.6.2024
     ----------------- ADDED BY VIVEK---------------------
 @UI.lineItem: [{ position: 145, label: 'Invoice Qty.' }]
     sum( cast(a.BillingQuantity as abap.dec( 13, 2 )) ) as TOT_BILLQTY,
 @UI.lineItem: [{ position: 150, label: 'Base Amt.' }]
     sum( cast(a.BASE_AMT as abap.dec( 23, 2 )) ) as BASE_AMT,
 @UI.lineItem: [{ position: 155, label: 'CGST Rate' }]
     a.cgst_rate,
 @UI.lineItem: [{ position: 160, label: 'CGST Amt.' }]
     sum( cast(a.CGST_AMT as abap.dec( 23, 2 )) ) as CGST_AMT,
 @UI.lineItem: [{ position: 165, label: 'SGST Rate' }]
     a.sgst_rate,
 @UI.lineItem: [{ position: 170, label: 'SGST Amt.' }]
     sum( cast(a.SGST_AMT as abap.dec( 23, 2 )) ) as SGST_AMT,
 @UI.lineItem: [{ position: 175, label: 'IGST Rate' }]
     a.igst_rate,
 @UI.lineItem: [{ position: 180, label: 'IGST Amt.' }]
     sum( cast(a.IGST_AMT as abap.dec( 23, 2 )) ) as IGST_AMT,
 @UI.lineItem: [{ position: 185, label: 'Total Tax Amt.' }] 
     sum( cast(a.TOT_TAX as abap.dec( 23, 2 )) ) as TOT_TAX, 
 @UI.lineItem: [{ position: 190, label: 'TCS Amt.' }] 
     sum( cast(a.TCS_AMT as abap.dec( 23, 2 )) ) as TOT_TCS,      
 @UI.lineItem: [{ position: 195, label: 'Total Invoice Amt.' }]
     sum( cast(a.tot_invoice  as abap.dec( 23, 2 )) ) as TOT_INVOICE,
   
 @UI.lineItem: [{ position: 200, label: 'Region Name' }] 
     a.RegionName,
 @UI.lineItem: [{ position: 205, label: 'Place Of Supply Name' }] 
     a.plofsuppl_name          
}
//where TOT_TAX is not null
group by a.AccountingDocument,a.CompanyCode,a.FiscalYear,a.TaxNumber3,a.CustomerName,a.region_code,a.OriginalReferenceDocument,a.DocumentDate,a.DocumentReferenceID,
         a.PostingDate,
         a.inv_type,
         a.Plant,b.PlantName,c.GLAccountName,d.SegmentName,a.IN_GSTPlaceOfSupply,
         a.YY1_ShippingbillNo_BDH,a.YY1_shippingbillDate_BDH,a.TransactionCurrency,a.BillingQuantityUnit,
         e.GLAccount,e.GLAccountName, // added by vvk
         a.cgst_rate,a.sgst_rate,a.igst_rate,a.RegionName,a.plofsuppl_name,
         a.AccountingDocumentType,a.Segment
         
         
         

