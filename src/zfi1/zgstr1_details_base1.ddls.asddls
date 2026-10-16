@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Details Base report 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_BASE1 as select from ZGSTR1_DETAILS_BASE as a
//  left outer join ZBILLING_TO_ACCOUNTING as b on b.BillingDocument = a.BillingDocument
 left outer join ZBILLING_TO_ACCOUNTING as b on b.BillingDocument = a.BillingDocument
      
{

key a.BillingDocument,
key a.BillingDocumentItem,
//    a.DocumentReferenceID,
//
    cast(substring(a.BillingDocumentItem,3,6) as abap.char( 4 )) as BillingDocumentItem1,
    a.BillingDocumentDate,
    a.Product,
    a.BillingDocumentItemText,       
    a.hsn_sac_code,
    a.BaseUnit,        
    a.Plant,
    case when a.Plant = '1000'
      then cast('0000001000' as abap.char( 10 ))
       when a.Plant = '2001'
       then cast('0000002000' as abap.char( 10 ))
       when a.Plant ='4001'
       then cast('0000004000' as abap.char( 10 ))
       when a.Plant = '5001'
       then cast('0000005000' as abap.char( 10 ))
       when a.Plant = '6001'
       then cast('0000006000' as abap.char( 10 ))
       when (a.Plant = '3001' or a.Plant = '3002' or a.Plant = '3003'
             or a.Plant = '3004' or a.Plant = '3005')
       then cast('0000003000' as abap.char( 10 ))  
       end as Segment,
    a.plant_name,
    a.ship_to_cityname,
    a.DeliveryDocument,   
    a.delivery_date, 
    a.TransactionCurrency,
    b.AccountingDocument,
    b.OriginalReferenceDocument,
    b.DocumentReferenceID,
    b.CompanyCodeCurrency,
    b.AccountingDocumentType,
    b.FiscalPeriod,
    b.PostingDate,
    a.BillingDocumentType,   
   // b.AccountingDocumentItem,   
    b.FiscalYear,
    b.CompanyCode,
    b.DocumentDate,
    a.BillingDocumentDate as posting_date,   
    a.sold_to_customer,
    a.sold_to_name1,    
    a.sold_to_region,
    a.sold_to_region_name,         
    a.sold_to_gstin,

    a.YY1_shippingbillDate_BDH,
    a.YY1_ShippingbillNo_BDH,  
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.inv_qty, 
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.TransactionCurrency <> 'INR' then
      ( cast(a.Taxable_value  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.Taxable_value as abap.dec( 15, 2 ))
       end as base_amount1,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.TransactionCurrency <> 'INR' then
      ( cast(a.Taxable_value  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.Taxable_value as abap.dec( 15, 2 ))
       end as base_amount2,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.Taxable_value,
    a.SGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
     case when a.TransactionCurrency <> 'INR' then
      ( cast(a.SGST  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.SGST as abap.dec( 15, 2 ))
       end as SGST1,
   @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.SGST,    
    a.CGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
         case when a.TransactionCurrency <> 'INR' then
      ( cast(a.CGST  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.CGST as abap.dec( 15, 2 ))
       end as CGST1,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.CGST,
    a.IGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.TransactionCurrency <> 'INR' then
      ( cast(a.IGST  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.IGST as abap.dec( 15, 2 ))
       end as IGST1,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.IGST,
    a.UGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.TransactionCurrency <> 'INR' then
      ( cast(a.UGST  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.UGST as abap.dec( 15, 2 ))
       end as UGST1,
       @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.UGST,    
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.TransactionCurrency <> 'INR' then
      ( cast(a.tot_isgt_sgst  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.tot_isgt_sgst as abap.dec( 15, 2 ))
       end as TOTALTAXVALUE1,
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    a.tot_isgt_sgst as TOTALTAXVALUE,   
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.TransactionCurrency <> 'INR' then
      ( cast(a.TCS  as abap.dec( 15, 2 )) * cast(a.AccountingExchangeRate as abap.dec(10,3)))
       else
       cast(a.TCS as abap.dec( 15, 2 ))
       end as TCS1,
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    a.TCS,  
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when a.TCS is not null
    then 
    a.tot_isgt_sgst + a.TCS 
    else
    a.tot_isgt_sgst
    end as TOTALWITHTCS,
    case when a.IGST > 0 then 
    cast('YESIGST' as abap.char( 7 ))
    else
    cast('NOTIGST' as abap.char( 7 ))
    end as IGST_INF,
    a.AccountingExchangeRate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.YY1_Exchangerate_BDH,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    cast(a.AccountingExchangeRate as abap.curr( 10, 3 )) as acc_exc,
    a.UOM1,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    a.tot_taxable_value
    

    
}
