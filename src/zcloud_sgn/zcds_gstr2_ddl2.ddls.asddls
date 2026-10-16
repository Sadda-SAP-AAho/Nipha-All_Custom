@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - GSTR2 (Final View)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'GSTR2' ,
                  typeNamePlural: 'GSTR2 Summary Report'
                   }
@UI.presentationVariant: [{ sortOrder: [{ by: 'AccountingDocument', direction: #ASC }] }]
define view entity zcds_gstr2_ddl2 as select from ZCDS_GSTR2_DDL5 as a


{
 @UI.lineItem: [{ position: 10 }]
 @UI.selectionField: [{ position: 10 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr2',
     element: 'acdoc'
 } }]
 key a.AccountingDocument,
 @UI.lineItem: [{ position: 15 }]
 @UI.selectionField: [{ position: 15 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr2',
     element: 'ccode'
 } }]
 key a.CompanyCode,
 @UI.lineItem: [{ position: 20 }]
 @UI.selectionField: [{ position: 20 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr2',
     element: 'fyear'
 } }]
 //@EndUserText.label: 'FYear'
 key a.FiscalYear,
 @UI.lineItem: [{ position: 25 }] 
 key a.TaxCode,
 @UI.lineItem: [{ position: 28 }] 
 @UI.selectionField: [{ position: 25 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zsh_gstr2',
     element: 'Supplier'
 } }]
     a.Supplier,
 @UI.lineItem: [{ position: 35 }]
     a.SupplierName,
 @UI.lineItem: [{ position: 40, label: 'Invoice Number' }]
     a.DocumentReferenceID,
 @UI.lineItem: [{ position: 45, label: 'Invoice Date' }]
     a.DocumentDate,
 @UI.lineItem: [{ position: 50, label: 'SAP Document Number' }]
     a.OriginalReferenceDocument,
 @UI.lineItem: [{ position: 55, label: 'Tax Base Amt.' }]
 //    case when a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'RK'
 case when a.AccountingDocumentType = 'RK'  
     or a.FLAG1 = 'NEGA' //  added by vvk
     or ( a.AccountingDocumentType = 'KR' and a.IsReversal = 'X' )
     or ( a.AccountingDocumentType = 'RE' and a.IsReversal = 'X' ) 
     then ( sum( cast(a.BASE_AMT as abap.dec( 23, 2 )) ) * -1 ) else sum( cast(a.BASE_AMT as abap.dec( 23, 2 )) )
     end as BASE_AMT,
 @UI.lineItem: [{ position: 60, label: 'CGST Rate' }]
     a.cgst_rate,
 @UI.lineItem: [{ position: 65, label: 'CGST Amt.' }]
//     case when a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'RK'
     case when  a.AccountingDocumentType = 'RK'
     or a.FLAG1 = 'NEGA' //  added by vvk
     or ( a.AccountingDocumentType = 'KR' and a.IsReversal = 'X' )
     or ( a.AccountingDocumentType = 'RE' and a.IsReversal = 'X' )
     then ( sum( cast(a.CGST_AMT as abap.dec( 23, 2 )) ) * -1 ) else sum( cast(a.CGST_AMT as abap.dec( 23, 2 )) )
     end as CGST_AMT,
 @UI.lineItem: [{ position: 70, label: 'SGST Rate' }]
     a.sgst_rate,
 @UI.lineItem: [{ position: 75, label: 'SGST Amt.' }]
//     case when a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'RK'
     case when  a.AccountingDocumentType = 'RK'
     or a.FLAG1 = 'NEGA' //  added by vvk
     or ( a.AccountingDocumentType = 'KR' and a.IsReversal = 'X' )
     or ( a.AccountingDocumentType = 'RE' and a.IsReversal = 'X' )
     then ( sum( cast(a.SGST_AMT as abap.dec( 23, 2 )) ) * -1 ) else sum( cast(a.SGST_AMT as abap.dec( 23, 2 )) )
     end as SGST_AMT,
 @UI.lineItem: [{ position: 80, label: 'IGST Rate' }]
     a.igst_rate,
 @UI.lineItem: [{ position: 85, label: 'IGST Amt.' }]
 //    case when a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'RK'
 case when a.AccountingDocumentType = 'RK'
     or a.FLAG1 = 'NEGA' //  added by vvk
     or ( a.AccountingDocumentType = 'KR' and a.IsReversal = 'X' )
     or ( a.AccountingDocumentType = 'RE' and a.IsReversal = 'X' )
     then ( sum( cast(a.IGST_AMT as abap.dec( 23, 2 )) ) * -1 ) else sum( cast(a.IGST_AMT as abap.dec( 23, 2 )) )
     end as IGST_AMT,
 @UI.lineItem: [{ position: 90, label: 'Total Tax Amt.' }] 
//     case when a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'RK'
case when  a.AccountingDocumentType = 'RK'
     or a.FLAG1 = 'NEGA' //  added by vvk
     or ( a.AccountingDocumentType = 'KR' and a.IsReversal = 'X' )
     or ( a.AccountingDocumentType = 'RE' and a.IsReversal = 'X' )
     then ( sum( cast(a.TOT_TAX as abap.dec( 23, 2 )) ) * -1 ) else sum( cast(a.TOT_TAX as abap.dec( 23, 2 )) )
     end as TOT_TAX,
 @UI.lineItem: [{ position: 95, label: 'RCM Recv. CGST Amt.' }] 
     sum( cast(a.RCMRCGST_AMT as abap.dec( 23, 2 )) ) as RCMRCGST_AMT,
 @UI.lineItem: [{ position: 100, label: 'RCM Recv. SGST Amt.' }] 
     sum( cast(a.RCMRSGST_AMT as abap.dec( 23, 2 )) ) as RCMRSGST_AMT,
 @UI.lineItem: [{ position: 105, label: 'RCM Recv. IGST Amt.' }] 
     sum( cast(a.RCMRIGST_AMT as abap.dec( 23, 2 )) ) as RCMRIGST_AMT,
 @UI.lineItem: [{ position: 110, label: 'Total RCM Recv. Amt.' }] 
     sum( cast(a.TOTRRCM_AMT as abap.dec( 23, 2 )) ) as TOTRRCM_AMT,
 @UI.lineItem: [{ position: 115, label: 'RCM Pay. CGST Amt.' }]
     sum( cast(a.RCMPCGST_AMT as abap.dec( 23, 2 )) ) as RCMPCGST_AMT,
 @UI.lineItem: [{ position: 120, label: 'RCM Pay. SGST Amt.' }]
     sum( cast(a.RCMPSGST_AMT as abap.dec( 23, 2 )) ) as RCMPSGST_AMT,
 @UI.lineItem: [{ position: 125, label: 'RCM Pay. IGST Amt.' }]
     sum( cast(a.RCMPIGST_AMT as abap.dec( 23, 2 )) ) as RCMPIGST_AMT, 
 @UI.lineItem: [{ position: 130, label: 'Total RCM Pay. Amt.' }] 
     sum( cast(a.TOTPRCM_AMT as abap.dec( 23, 2 )) ) as TOTPRCM_AMT,  
 @UI.lineItem: [{ position: 135, label: 'TCS Amt.' }]
//     case when a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'RK'
case when a.AccountingDocumentType = 'RK'
     or a.FLAG1 = 'NEGA' //  added by vvk
     or ( a.AccountingDocumentType = 'KR' and a.IsReversal = 'X' )
     or ( a.AccountingDocumentType = 'RE' and a.IsReversal = 'X' )
     then ( sum( cast(a.TCS_AMT as abap.dec( 23, 2 )) ) * -1 ) else sum( cast(a.TCS_AMT as abap.dec( 23, 2 )) )
     end as TCS_AMT,      
 @UI.lineItem: [{ position: 140, label: 'Total Invoice Amt.' }]
//     case when a.AccountingDocumentType = 'KG' or a.AccountingDocumentType = 'RK'
     case when a.AccountingDocumentType = 'RK'
     or a.FLAG1 = 'NEGA' //  added by vvk
     or ( a.AccountingDocumentType = 'KR' and a.IsReversal = 'X' )
     or ( a.AccountingDocumentType = 'RE' and a.IsReversal = 'X' )
     then ( sum( cast(a.TOT_INVOICE as abap.dec( 23, 2 )) ) * -1 ) else sum( cast(a.TOT_INVOICE as abap.dec( 23, 2 )) )
     end as TOT_INVOICE,
 @UI.lineItem: [{ position: 145 }]   
     a.FiscalPeriod,
 @UI.lineItem: [{ position: 155 }]  
     a.PostingDate, 
 @UI.lineItem: [{ position: 160 }]   
     a.AccountingDocumentType,
 @UI.lineItem: [{ position: 175 }]  
     a.AccountingDocumentTypeName,
 @UI.lineItem: [{ position: 180 }]   
     a.BusinessPlace,  
 @UI.lineItem: [{ position: 185 }]  
     a.BusinessPlaceName, 
 @UI.lineItem: [{ position: 190,label:'Business Place GSTN' }]  
     a.TaxNumber1, 
 @UI.lineItem: [{ position: 195 }]  
     a.Region, 
 @UI.lineItem: [{ position: 200,label:'Region Code' }]  
     a.region_code, 
 @UI.lineItem: [{ position: 205 }]  
     a.RegionName, 
 @UI.lineItem: [{ position: 210 }]  
     a.SupplierAccountGroup,
 @UI.lineItem: [{ position: 215 }]  
     a.AccountGroupName, 
 @UI.lineItem: [{ position: 220,label:'Supplier PAN' }]  
     a.pan_no,
 @UI.lineItem: [{ position: 225 }]  
     a.TransactionCode,
 @UI.lineItem: [{ position: 230 }]   
     a.TransactionCurrency,
 @UI.lineItem: [{ position: 235,label: 'Supplier GSTN' }]  
     a.TaxNumber3, 
     //-----------------added by vvk--------------------
 @UI.lineItem: [{ position: 240,label: 'GL Ac' }]   
     a.GL_Ac,
 @UI.lineItem: [{ position: 245,label: 'GL Description' }]  
//   case when b.GLAccount is not null
//     then b.GLAccountLongName
//     else
     a.GL_Description
//     end as GL_Description     //*/   

     //---------------------added by vvk --------------------- 
             
}
//where TOT_TAX is not null
where BASE_AMT is not null

group by AccountingDocument,CompanyCode,FiscalYear,TaxCode,Supplier,SupplierName,DocumentReferenceID,DocumentDate,
         OriginalReferenceDocument,cgst_rate,sgst_rate,igst_rate,FiscalPeriod,PostingDate,AccountingDocumentType,
         AccountingDocumentTypeName,BusinessPlace,BusinessPlaceName,TaxNumber1,Region,region_code,RegionName,
         SupplierAccountGroup,AccountGroupName,pan_no,TransactionCode,TransactionCurrency,TaxNumber3,IsReversal,
         GL_Ac,GL_Description,FLAG1 //  added by vvk
         



