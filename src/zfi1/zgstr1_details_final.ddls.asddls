@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Details Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'GSTR1 Dels' ,
                  typeNamePlural: 'GSTR1 Details Report'
                   }
//define view entity ZGSTR1_DETAILS_FINAL as select from ZGSTR1_DETAILS_FI_BASE2 as A
define view entity ZGSTR1_DETAILS_FINAL as select from ZGSTR1_DETAILS_FI_BASE_final1 as A
{
@UI.lineItem: [{position:10}]
@EndUserText.label: 'Journal Entry'
@UI.selectionField: [{ position: 10 }]
 key A.AccountingDocument ,
// @UI.lineItem: [{ position: 15 }]
   @UI.selectionField: [{ position: 15 }]
//   @Consumption.valueHelpDefinition: [{ entity: {
//    name: 'zsh_gstr1',
 //    element: 'ccode'
// } }]*/
 @UI.lineItem: [{position:15}]
 @EndUserText.label: 'Company Code'
 key A.CompanyCode,
 /* @UI.lineItem: [{ position: 20 }]
 @UI.selectionField: [{ position: 20 }]
@Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'fyear'
 } }]*/
 @UI.lineItem: [{position:20}]
 @UI.selectionField: [{ position: 20 }]
 @EndUserText.label: 'Fiscal Year'
 key A.FiscalYear,
  @UI.lineItem: [{position:25}]
 @EndUserText.label: 'Documnet Item'
 key A.AccountingDocumentItem,
 //@UI.lineItem: [{ position: 75 }]
  @UI.lineItem: [{position:29}]
 @EndUserText.label: 'FiscalPeriod'
 A.FiscalPeriod,
 @UI.lineItem: [{position:45}]
 @EndUserText.label: 'GL Account Name'
 A.GLAccountLongName,  //c.GLAccountName, old code
// @UI.lineItem: [{ position: 55, label: 'Customer' }]
// @UI.selectionField: [{ position: 25 }]
/* @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'Customer'*/
 @UI.lineItem: [{position:55}]
 @EndUserText.label: 'Customer.'
 A.Customer,
 //} }]
 @UI.lineItem: [{position:65}]
 @EndUserText.label: 'Customer GSTIN No.'
 A.CUSTOMER_GSTIN,
 //key a.AccountingDocument,
 /*@UI.lineItem: [{ position: 30 }]
 @UI.selectionField: [{ position: 30 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'CustomerName'
 } }]*/
 @UI.lineItem: [{position:85}]
 @EndUserText.label: 'Customer Name'
 A.CUSTOMER_NAME,
 //key a.CompanyCode,
 /*@UI.lineItem: [{ position: 35 }]
 @UI.selectionField: [{ position: 35 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'region_code'
 } }]
 @EndUserText.label: 'Region Code'*/
 @UI.lineItem: [{position:90}]
 @EndUserText.label: 'Region Code' 
     A.region_code,
 //key a.FiscalYear,
 //@UI.lineItem: [{ position: 40, label: 'SAP Document Number' }]
  @UI.lineItem: [{position:110}]
  @EndUserText.label: 'SAP Documnet Number'
     A.OriginalReferenceDocument,
 //    a.FiscalPeriod,
/* @UI.lineItem: [{ position: 45, label: 'Invoice Date' }]
 @UI.selectionField: [{ position: 45 }]
 @Consumption.valueHelpDefinition: [{
//     qualifier: '',
     entity: {
         name: 'zsh_gstr1',
         element: 'DocumentDate'
     },
     distinctValues: true,
     label: 'Invoice Date'  }]*/
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

//     presentationVariantQualifier: ''
  @UI.lineItem: [{position:120}]
  @EndUserText.label: 'Documnet Date'
  A.DocumentDate,
/* @UI.lineItem: [{ position: 50, label: 'Invoice Number' }] 
 @UI.selectionField: [{ position: 50 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'DocumentReferenceID'
 } }]*/
   @UI.lineItem: [{position:130}]
   @EndUserText.label: 'Invoice Number'
     A.DocumentReferenceID,
/* @UI.lineItem: [{ position: 55 }]
 @UI.selectionField: [{ position: 55 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'PostingDate'
 } }]*/
    @UI.lineItem: [{position:140}]
    @EndUserText.label: 'Posting Date'
     A.PostingDate,     
 //@UI.lineItem: [{ position: 60, label: 'Invoice Type' }]
    @UI.lineItem: [{position:145}]
    @EndUserText.label: 'Invoice Type'
     A.inv_type,
/* @UI.lineItem: [{ position: 65 }]
 @UI.selectionField: [{ position: 65 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr1',
     element: 'Plant'
 } }]*/
     @UI.lineItem: [{position:150}]
    @EndUserText.label: 'Plant'
     A.Plant,
 @UI.lineItem: [{ position: 170}]
     A.PlantName,
 @UI.lineItem: [{ position: 190 ,label: 'Material'}]
     A.Material,
 @UI.lineItem: [{ position: 220 ,label: 'Material Description'}]
     A.ProductDescription,
 @UI.lineItem: [{ position: 230 ,label: 'HSN/SAC Code'}]
     A.hsn_sac_code,
  @UI.lineItem: [{ position: 235 ,label: 'BusinessPlace'}]    
     A.BusinessPlace,
 @UI.lineItem: [{ position: 240 }]
     A.Segment,
 @UI.lineItem: [{ position: 265 }]
     A.SegmentName,
 @UI.lineItem: [{ position: 275, label: 'Place Of Supply' }]
     A.IN_GSTPlaceOfSupply,
 @UI.lineItem: [{ position: 285 }]
     A.shipping_bill_no,
 @UI.lineItem: [{ position: 295 }]
     A.shipping_bill_dt,
 @UI.lineItem: [{ position: 300 }]
     A.TransactionCurrency,
 @UI.lineItem: [{ position: 303, label: 'SAP Sales Unit' }]
   A.billing_unit,
 @UI.lineItem: [{ position: 306, label: 'Sales Unit' }]
   A.UOM1,
     ----------------- ADDED BY VIVEK---------------------
 @UI.lineItem: [{ position: 316, label: 'GL' }]    
     A.GLAccount,
     
 @UI.lineItem: [{ position: 321, label: 'Company code Currency' }] 
     A.CompanyCodeCurrency,
 //@UI.lineItem: [{ position: 140, label: 'GL Name' }] 
  //   c.GLAccountName as GL_Description,  
 //    e.GLAccountName as GL_Description,// old code 3.6.2024
     ----------------- ADDED BY VIVEK---------------------
 @UI.lineItem: [{ position: 330, label: 'Invoice No.' }]     
    A.BillingDocument,
  @UI.lineItem: [{ position: 340, label: 'Invoice Date' }]     
    A.BillingDocumentDate,
 @UI.lineItem: [{ position: 355, label: 'Invoice Qty.' }]
 @Semantics.quantity.unitOfMeasure: 'billing_unit'
    A.billing_qty,
 @UI.lineItem: [{ position: 360, label: 'Tax Base Amount' }]
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.base_amount,
 @UI.lineItem: [{ position: 370, label: 'CGST Rate' }]
 
     A.cgst_rate,
 @UI.lineItem: [{ position: 385, label: 'CGST Amt.' }]
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     A.CGST_AMOUNT,
 @UI.lineItem: [{ position: 390, label: 'SGST Rate' }]
     A.sgst_rate,
 @UI.lineItem: [{ position: 405, label: 'SGST Amt.' }]
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.SGST_AMOUNT,
 @UI.lineItem: [{ position: 410, label: 'IGST Rate' }]
     A.igst_rate,
 @UI.lineItem: [{ position: 425, label: 'IGST Amt.' }]
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    A.IGST_AMOUNT,
 @UI.lineItem: [{ position: 440, label: 'Total Tax Amt.' }]
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   A.tot_gst,
 //A.total_tax_value,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 @UI.lineItem: [{ position: 455, label: 'TCS Amt.' }] 
    A.TCS_AMT,   
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 @UI.lineItem: [{ position: 470, label: 'Total Invoice Amt.' }]
/* case when A.TCS_AMT <> 0
    then 
    //A.total_tax_value + A.TCS_AMT
        cast(A.base_with_gst  as abap.dec( 15, 2 )) + cast(A.TCS_AMT as abap.dec( 15, 2 ))
    else
        cast(A.base_with_gst  as abap.dec( 15, 2 ))
    end as total_value_with_tcs, */
  case when inv_type = 'EXP WITH TAX' then      
       cast(A.base_amount  as abap.dec( 15, 2 ))
      else
       cast(A.total_value_with_tcs1 as abap.dec( 15, 2 ))
      end as total_value_with_tcs1,   
 @UI.lineItem: [{ position: 480, label: 'Region Name' }] 
     A.RegionName,
 @UI.lineItem: [{ position: 490, label: 'Place Of Supply Name' }] 
     A.RegionName as PLACE_OF_SUPPLY  

/*select from ZGSTR1_DETAILS_BASE1 as a
//  left outer join I_JournalEntry as b on a.CompanyCode = b.CompanyCode
//      and a.FiscalYear = b.FiscalYear and a.Journal_Entry = b.AccountingDocument    
      
{
    @UI.identification: [{position:10}]
    @EndUserText.label: 'SAP Document Number'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 10 }]
key a.BillingDocument,
    @UI.lineItem: [{position:15}]
    @EndUserText.label: 'SAP Document item'
key a.BillingDocumentItem,
                @UI.lineItem: [{position:25}]
  //  @EndUserText.label: 'Invoice No'
//    a.DocumentReferenceID,
//                @UI.lineItem: [{position:34}]
    @EndUserText.label: 'Posting Date'
    a.posting_date,
        @UI.lineItem: [{position:52}]
    @EndUserText.label: 'Material'
    a.Product,
    @UI.lineItem: [{position:80}]
    @EndUserText.label: 'Product Description'
    a.BillingDocumentItemText,    
     @UI.lineItem: [{position:90}]
    @EndUserText.label: 'HSN Code'   
    a.hsn_sac_code,
    @UI.lineItem: [{position:95}]
    @EndUserText.label: 'Sales Unit'
    a.BaseUnit,        
    @UI.lineItem: [{position:100}]
    @EndUserText.label: 'Plant'
    a.Plant,
    @UI.lineItem: [{position:120}]
    @EndUserText.label: 'Plant Name'
    a.plant_name,
    @UI.lineItem: [{position:125}]
    @EndUserText.label: 'Place of Supply'  // ship to city name
    a.ship_to_cityname,
    @UI.lineItem: [{position:135}]         // Delivery No.
    @EndUserText.label: 'Shipping bill No'
    a.YY1_ShippingbillNo_BDH,   
    @UI.lineItem: [{position:145}]         // Delivery Date
    @EndUserText.label: 'Shipping bill Date'
    a.YY1_shippingbillDate_BDH, 
    @UI.lineItem: [{position:150}]
    @EndUserText.label: 'Currency'
    a.TransactionCurrency,
    @UI.lineItem: [{position:160}]
    @EndUserText.label: 'Journal Entry'
    a.AccountingDocument,     
    @UI.lineItem: [{position:165}]
    @EndUserText.label: 'Fiscal year'
    a.FiscalYear,
    @UI.lineItem: [{position:165}]
    @EndUserText.label: 'Fiscal Period'
    FiscalPeriod, 
   
//    @UI.lineItem: [{position:175}]
//    @EndUserText.label: 'Posting Date'
//    a.BillingDocumentDate as posting_date,   
    @UI.lineItem: [{position:185}]
    @EndUserText.label: 'Customer'
    a.sold_to_customer,
    @UI.lineItem: [{position:205}]
    @EndUserText.label: 'Customer Name'
    a.sold_to_name1,    
    @UI.lineItem: [{position:208}]
    @EndUserText.label: 'Customer Region'
    a.sold_to_region,
    @UI.lineItem: [{position:220}]
    @EndUserText.label: 'Customer Region Name'
    a.sold_to_region_name,    
    @UI.lineItem: [{position:240}]
    @EndUserText.label: 'Customer GSTN'       
    a.sold_to_gstin,  
    @UI.lineItem: [{position:255}]
    @EndUserText.label: 'Invoiced Quantity'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.inv_qty, 
          @UI.lineItem: [{position:275}]
    @EndUserText.label: 'Tax Base Amount'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.Taxable_value,
    @UI.lineItem: [{position:285}]
    @EndUserText.label: 'SGST RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.SGST_RATE,
        @UI.lineItem: [{position:305}]
    @EndUserText.label: 'SGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.SGST,    
    @UI.lineItem: [{position:315}]
    @EndUserText.label: 'CGST_RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.CGST_RATE,
        @UI.lineItem: [{position:335}]
    @EndUserText.label: 'CGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.CGST,
    @UI.lineItem: [{position:345}]
    @EndUserText.label: 'IGST RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.IGST_RATE,
        @UI.lineItem: [{position:365}]
    @EndUserText.label: 'IGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.IGST,
        @UI.lineItem: [{position:375}]
    @EndUserText.label: 'UGST RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.UGST_RATE,
        @UI.lineItem: [{position:395}]
    @EndUserText.label: 'UGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.UGST,
    @UI.lineItem: [{position:415}]
    @EndUserText.label: 'UGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    a.TOTALTAXVALUE,   
    @UI.lineItem: [{position:435}]
    @EndUserText.label: 'TCS Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.TCS,  
    @UI.lineItem: [{position:455}]
    @EndUserText.label: 'TCS'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.TOTALWITHTCS*/
  
    
    
    
    
    


}
where A.STO <> 'STO'
