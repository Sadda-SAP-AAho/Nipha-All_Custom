@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 Details Base'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_DETAILS_BASE as select from I_BillingDocumentItem
as a
left outer join I_BillingDocument as b on b.BillingDocument = a.BillingDocument
left outer join I_SalesOrderItem as c on c.SalesOrder = a.SalesDocument 
and c.SalesOrderItem = a.SalesDocumentItem
left outer join I_SalesOrder as d on d.SalesOrder = a.SalesDocument 
left outer join I_SalesOrganizationText as e on e.SalesOrganization = a.SalesOrganization
    and e.Language = 'E'
left outer join I_ProfitCenterText as f on f.ProfitCenter = a.ProfitCenter
    and f.Language = 'E' and f.ControllingArea = a.ControllingArea
left outer join I_DivisionText as g on g.Division = a.Division
    and g.Language = 'E'
left outer join I_Product as h on h.Product = a.Product
left outer join I_BillingDocumentItemPrcgElmnt as i on i.BillingDocument = a.BillingDocument
    and i.BillingDocumentItem = a.BillingDocumentItem 
    and ( i.ConditionType = 'ZDM1' or i.ConditionType = 'ZDIS' or i.ConditionType = 'ZMDP' )
left outer join I_BillingDocumentItemPrcgElmnt as J on J.BillingDocument = a.BillingDocument
    and J.BillingDocumentItem = a.BillingDocumentItem 
    and ( J.ConditionType = 'ZASS' or J.ConditionType = 'ZEXF' or J.ConditionType = 'ZNVL' )
left outer join I_BillingDocumentItemPrcgElmnt as k on k.BillingDocument = a.BillingDocument
    and k.BillingDocumentItem = a.BillingDocumentItem 
    and ( k.ConditionType = 'ZBSV' or k.ConditionType = 'ZCIF' )//and k.ConditionIsManuallyChanged = 'X'
left outer join I_BillingDocumentItemPrcgElmnt as l on l.BillingDocument = a.BillingDocument
    and l.BillingDocumentItem = a.BillingDocumentItem 
    and ( l.ConditionType = 'ZFRE' or l.ConditionType = 'ZFRT' or l.ConditionType = 'ZFRN'
    or l.ConditionType = 'ZVA1' or l.ConditionType = 'ZTRP' )//and l.ConditionIsManuallyChanged = 'X'
left outer join I_BillingDocumentItemPrcgElmnt as m on m.BillingDocument = a.BillingDocument
    and m.BillingDocumentItem = a.BillingDocumentItem 
    and m.ConditionType = 'ZPEX' //and m.ConditionIsManuallyChanged = 'X'
left outer join I_BillingDocumentItemPrcgElmnt as n on n.BillingDocument = a.BillingDocument
    and n.BillingDocumentItem = a.BillingDocumentItem 
    and ( n.ConditionType = 'ZPAC' or n.ConditionType = 'ZPCH' )//and n.ConditionIsManuallyChanged = 'X'
left outer join I_BillingDocumentItemPrcgElmnt as o on o.BillingDocument = a.BillingDocument
    and o.BillingDocumentItem = a.BillingDocumentItem 
    and (o.ConditionType = 'ZPR1' or o.ConditionType = 'ZPR2' or o.ConditionType = 'ZMP1' )//and o.ConditionIsManuallyChanged = 'X'
left outer join I_BillingDocumentItemPrcgElmnt as p on p.BillingDocument = a.BillingDocument
    and p.BillingDocumentItem = a.BillingDocumentItem 
    and p.ConditionType = 'ZDIF' //and p.ConditionIsManuallyChanged = 'X' 
left outer join I_BillingDocumentItemPrcgElmnt as q on q.BillingDocument = a.BillingDocument
    and q.BillingDocumentItem = a.BillingDocumentItem 
    and q.ConditionType = 'JOCG'  
left outer join I_BillingDocumentItemPrcgElmnt as r on r.BillingDocument = a.BillingDocument
    and r.BillingDocumentItem = a.BillingDocumentItem 
    and r.ConditionType = 'JOSG' 
left outer join I_BillingDocumentItemPrcgElmnt as s on s.BillingDocument = a.BillingDocument
    and s.BillingDocumentItem = a.BillingDocumentItem 
    and s.ConditionType = 'JOIG' 
left outer join I_BillingDocumentItemPrcgElmnt as za on a.BillingDocument = za.BillingDocument
    and a.BillingDocumentItem = za.BillingDocumentItem 
    and za.ConditionType = 'JOUG'

left outer join I_BillingDocumentItemPrcgElmnt as t on t.BillingDocument = a.BillingDocument
    and t.BillingDocumentItem = a.BillingDocumentItem 
    and ( t.ConditionType = 'JTC1' or t.ConditionType = 'JTC2' )
left outer join I_BillingDocumentItemPrcgElmnt as u on u.BillingDocument = a.BillingDocument
    and u.BillingDocumentItem = a.BillingDocumentItem 
    and u.ConditionType = 'ZVPR'
left outer join I_DeliveryDocumentItem as v on v.DeliveryDocument = a.ReferenceSDDocument
    and v.DeliveryDocumentItem = a.ReferenceSDDocumentItem
left outer join I_ProductUnitsOfMeasure as w on w.Product = a.Product
    and w.BaseUnit = a.BillingQuantityUnit and w.AlternativeUnit = 'ST'
left outer join I_ProductUnitsOfMeasure as x on x.Product = a.Product
    and x.BaseUnit = a.BillingQuantityUnit and x.AlternativeUnit = 'TO'
    
/*left outer join I_BillingDocumentItemPrcgElmnt as y on y.BillingDocument = a.BillingDocument
    and y.BillingDocumentItem = a.BillingDocumentItem and y.ConditionType = 'ZPEX' 
left outer join I_BillingDocumentItemPrcgElmnt as z on z.BillingDocument = a.BillingDocument
    and z.BillingDocumentItem = a.BillingDocumentItem and z.ConditionType = 'ZDM1'*/

left outer join I_ProductDescription as zb on a.Product = zb.ProductDescription and zb.Language = 'E'
left outer join ZINVOICE_CUSTOMER as zc on a.BillingDocument = zc.BillingDocument
left outer join ZINVOICE_SHIP_TO_PARTY as zd on a.BillingDocument = zd.BillingDocument
left outer join ZINVOICE_PAYER_TO_PARTY as ze on a.BillingDocument = ze.BillingDocument
left outer join I_BillingDocumentBasic as zf on a.BillingDocument = zf.BillingDocument
left outer join  I_CnsldtnDistributionChannelT as zg on a.DistributionChannel = zg.DistributionChannel and
 zg.Language = 'E' 
left outer join zplant as zi on a.Plant = zi.Plant
left outer join I_StorageLocation as zj on a.Plant = zj.Plant and a.StorageLocation
= zj.StorageLocation
left outer join I_DeliveryDocument as zk on a.ReferenceSDDocument = zk.DeliveryDocument
left outer join I_IN_ElectronicDocInvoice as zl on a.BillingDocument = zl.ElectronicDocSourceKey
left outer join I_Batch as zm on zm.Material = a.Product  and zm.Batch = a.Batch 
and zm.Plant = a.Plant
//left outer join I_ProductUnitsOfMeasure as zn on zn.Product = a.Product
// and zn.BaseUnit = 'ST'//a.BaseUnit 
left outer join I_BillingDocumentItemPrcgElmnt as zo on zo.BillingDocument = a.BillingDocument
    and zo.BillingDocumentItem = a.BillingDocumentItem 
    and zo.ConditionType = 'ZPR0'   
left outer join I_BillingDocumentItemPrcgElmnt as zp on zp.BillingDocument = a.BillingDocument
    and zp.BillingDocumentItem = a.BillingDocumentItem 
    and zp.ConditionType = 'ZFOB'
left outer join I_BillingDocumentItemPrcgElmnt as zq on zq.BillingDocument = a.BillingDocument
    and zq.BillingDocumentItem = a.BillingDocumentItem 
    and zq.ConditionType = 'ZCOM'
left outer join I_BillingDocumentItemPrcgElmnt as zr on zr.BillingDocument = a.BillingDocument
    and zr.BillingDocumentItem = a.BillingDocumentItem 
    and zr.ConditionType = 'ZDRG'
left outer join I_BillingDocumentItemPrcgElmnt as zs on zs.BillingDocument = a.BillingDocument
    and zs.BillingDocumentItem = a.BillingDocumentItem 
    and zs.ConditionType = 'ZDFA'   
left outer join I_BillingDocumentItemPrcgElmnt as zt on zt.BillingDocument = a.BillingDocument
    and zt.BillingDocumentItem = a.BillingDocumentItem 
    and zt.ConditionType = 'ZINS'   
left outer join I_BillingDocumentItemPrcgElmnt as zu on zu.BillingDocument = a.BillingDocument
    and zu.BillingDocumentItem = a.BillingDocumentItem 
    and zu.ConditionType = 'ZISN'   
left outer join I_BillingDocumentItemPrcgElmnt as zv on zv.BillingDocument = a.BillingDocument
    and zv.BillingDocumentItem = a.BillingDocumentItem 
    and zv.ConditionType = 'ZPRF'
    
    
left outer join I_BillingDocumentItemPrcgElmnt as zw on zw.BillingDocument = a.BillingDocument
    and zw.BillingDocumentItem = a.BillingDocumentItem 
    and zw.ConditionType = 'JTCB'   
left outer join I_BillingDocumentItemPrcgElmnt as zx on zx.BillingDocument = a.BillingDocument
    and zx.BillingDocumentItem = a.BillingDocumentItem 
    and zx.ConditionType = 'JTC3'   
left outer join I_BillingDocumentItemPrcgElmnt as zy on zy.BillingDocument = a.BillingDocument
    and zy.BillingDocumentItem = a.BillingDocumentItem 
    and zy.ConditionType = 'ZOIG'  
 left outer join I_MaterialDocumentItem_2 as zzm on 
   zzm.DeliveryDocument = a.ReferenceSDDocument and zzm.MaterialDocumentItem = '0001'
 left outer join I_CnsldtnMaterialGroupT as ZZN on ZZN.MaterialGroup = a.ProductGroup
 and ZZN.Language = 'E'  
 left outer join I_ProductPlantIntlTrd as zzo on a.Plant = zzo.Plant
 and a.Product = zzo.Product
 left outer join I_UnitOfMeasure  as zzl on zzl.UnitOfMeasure = a.BaseUnit

/*left outer join I_BillingDocumentItemPrcgElmnt as zz on zz.BillingDocument = a.BillingDocument
    and zz.BillingDocumentItem = a.BillingDocumentItem 
    and zz.ConditionType = 'ZMOT'   
 left outer join I_BillingDocumentItemPrcgElmnt as zza on zza.BillingDocument = a.BillingDocument
    and zza.BillingDocumentItem = a.BillingDocumentItem 
    and zza.ConditionType = 'ZMR1'
 left outer join I_BillingDocumentItemPrcgElmnt as zzb on zzb.BillingDocument = a.BillingDocument
    and zzb.BillingDocumentItem = a.BillingDocumentItem 
    and zzb.ConditionType = 'ZMR2'  
    
    
left outer join I_BillingDocumentItemPrcgElmnt as zzc on zzc.BillingDocument = a.BillingDocument
    and zzc.BillingDocumentItem = a.BillingDocumentItem 
    and zzc.ConditionType = 'ZREB'   
left outer join I_BillingDocumentItemPrcgElmnt as zzd on zzd.BillingDocument = a.BillingDocument
    and zzd.BillingDocumentItem = a.BillingDocumentItem 
    and zzd.ConditionType = 'ZRM1'   
left outer join I_BillingDocumentItemPrcgElmnt as zze on zze.BillingDocument = a.BillingDocument
    and zze.BillingDocumentItem = a.BillingDocumentItem 
    and zze.ConditionType = 'ZRM2'   
 left outer join I_BillingDocumentItemPrcgElmnt as zzf on zzf.BillingDocument = a.BillingDocument
    and zzf.BillingDocumentItem = a.BillingDocumentItem 
    and zzf.ConditionType = 'ZSOT'
 left outer join I_BillingDocumentItemPrcgElmnt as zzg on zzg.BillingDocument = a.BillingDocument
    and zzg.BillingDocumentItem = a.BillingDocumentItem 
    and zzg.ConditionType = 'PCE2'
 left outer join I_BillingDocumentItemPrcgElmnt as zzh on zzh.BillingDocument = a.BillingDocument
    and zzh.BillingDocumentItem = a.BillingDocumentItem 
    and zzh.ConditionType = 'PPR0' 
 left outer join I_BillingDocumentItemPrcgElmnt as zzi on zzi.BillingDocument = a.BillingDocument
    and zzi.BillingDocumentItem = a.BillingDocumentItem 
    and zzi.ConditionType = 'PCIP'  
 left outer join I_BillingDocumentItemPrcgElmnt as zzj on zzj.BillingDocument = a.BillingDocument
    and zzj.BillingDocumentItem = a.BillingDocumentItem 
    and zzj.ConditionType = 'ZSMP'
 left outer join I_BillingDocumentItemPrcgElmnt as zzk on zzk.BillingDocument = a.BillingDocument
    and zzk.BillingDocumentItem = a.BillingDocumentItem 
    and zzk.ConditionType = 'ZSM1' 
 left outer join I_BillingDocumentItemPrcgElmnt as zzl on zzl.BillingDocument = a.BillingDocument
    and zzl.BillingDocumentItem = a.BillingDocumentItem 
    and zzl.ConditionType = 'PCIP'  */
    
                      
{
  // invoice item
    a.BillingDocument,
    a.BillingDocumentItem,
    a.BillingDocumentItemText,
    a.ProductGroup,

    ZZN.MaterialGroupName,
    a.BillingQuantityUnit,
    a.CreatedByUser,
    a.ItemWeightUnit,
    a.ProfitCenter,
    a.Division,
    a.DistributionChannel,
    zg.DistributionChannelName,
    a.CompanyCode,
    a.SalesOffice,
    a.TransactionCurrency,
    a.ControllingArea,
    a.TaxCode,
    a.SoldToParty,
    a.Product,
    zzo.ConsumptionTaxCtrlCode as hsn_sac_code,
    a.InternationalArticleNumber as ean_code,
    a.AdditionalCustomerGroup1,
    a.AdditionalCustomerGroup2,
    a.AdditionalCustomerGroup3,
    a.AdditionalCustomerGroup4,
    a.AdditionalCustomerGroup5,
    a.SalesGroup,
//    zb.ProductDescription,
    a.BillingDocumentItemText as ProductDescription, 
    a.SalesDocumentItemCategory,
// sold to party
//    zc.
    zc.sold_to_customer,
    zc.sold_to_name1,
    zc.sold_to_name2,
    zc.sold_to_name3,
    zc.sold_to_name4,
    zc.sold_to_cityname,
    zc.sold_to_pin,
    zc.sold_to_region,
    zc.sold_to_region_name,
    zc.sold_to_gstin,
//  ship to party
    zd.ship_to_customer,
    zd.ship_to_name1,
    zd.ship_to_name2,
    zd.ship_to_name3,
    zd.ship_to_name4,
    zd.ship_to_cityname,
    zd.ship_to_pin,
    zd.ship_to_region,
    zd.ship_to_region_name,
//  payer to party
    ze.Payer_to_customer,
    ze.Payer_to_name1,
    ze.Payer_to_name2,
    ze.Payer_to_name3,
    ze.Payer_to_name4,
    ze.Payer_to_cityname,
    ze.Payer_to_pin,
    ze.Payer_to_region,
    ze.Payer_to_region_name,
    zf.VATRegistration as Tax_Reg_no,
    zf.CustomerAccountAssignmentGroup,
    a.MatlAccountAssignmentGroup,
    zc.SOLD_TO_AC_GROUP,
// plnat details
    a.Plant,
  //  zi.OrganizationName1 as plant_name,
    zi.PlantName as plant_name,
    zi.CityName as plant_city,
    zi.plant_gstin_no as plant_gstin_no,
    zi.PostalCode as plant_pin,
    zi.RegionName as plant_state,
    a.StorageLocation,
    zj.StorageLocationName,
    zi.PLANT_PAN_NO,
// delivery Details
    zk.LastChangeDate as delivery_date,
    zk.ActualGoodsMovementDate as pgi_date,
    zk.ActualGoodsMovementDate as SAP_DOC_date,
// eway bill
    zl.IN_EDocEInvcEWbillNmbr as e_way_bill_no,
    zl.IN_EDocEInvcEWbillCreateDate as e_way_bill_dt,
    zl.IN_ElectronicDocInvcRefNmbr as e_way_inv_no,
    zl.IN_ElectronicDocAcknDate as e_way_inv_no_dt,
// INVOICE DETAILS
    zf.InvoiceClearingStatus as Clearing_Status,
    zf.VATRegistrationCountry as vet_County_Code,
    zf.CustomerGroup as Customer_Group,
    b.Country as Dest_Country_Region,
    d.PricingDate as Pricing_Date,
    zf.IncotermsClassification as Incoterms,
    zf.IncotermsLocation1 as Incoterms_Location_1,
    zf.AccountingDocument as Journal_Entry,
    zf.AccountingPostingStatus as Posting_Status,
    zf.SDPricingProcedure as Pricing_Procedure,
    zf.CustomerPaymentTerms as Terms_of_Payment,
    zf.VATRegistrationCountry as VAT_Registration_No,
    a.BaseUnit as UOM,
    zzl.UnitOfMeasure_E as UOM1,
    w.QuantityNumerator as CASE_Config_UOM,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit' 
    c.CommittedDelivQtyInOrdQtyUnit as Sales_Order_Qty,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    v.ActualDeliveryQuantity as Delivery_Qty,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    a.BillingQuantity as inv_qty,
    a.Batch,
    zm.ManufactureDate as Batch_Mnf_Date,
    zm.ShelfLifeExpirationDate as Batch_Expiry_Date,
    a.AdditionalMaterialGroup1 as SD_MGRP1,
    a.AdditionalMaterialGroup2 as SD_MGRP2,
    a.AdditionalMaterialGroup3 as SD_MGRP3,
    a.AdditionalMaterialGroup4 as SD_MGRP4,
    a.AdditionalMaterialGroup5 as SD_MGRP5,
    zzm.MaterialDocument as PGI_No,
 //    h. 

 // invoice header
    b.CancelledBillingDocument,
    b.BillingDocumentIsCancelled,
    b.DocumentReferenceID,
    b.FiscalYear,
    b.BillingDocumentDate,
    b.BillingDocumentType,
    b.YY1_shippingbillDate_BDH,
    b.YY1_ShippingbillNo_BDH,
    b.AccountingExchangeRate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    b.YY1_Exchangerate_BDH,
    b.StatisticsCurrency,
    
    
   
 // sales order item
    c.SalesOrder,
    c.SalesOrderItem,
    c.SalesOrderItemText,
    c.CreationDate,
    c.MaterialByCustomer,
 // sales order header
    d.PurchaseOrderByCustomer,
    d.CustomerPurchaseOrderDate,
    d.CreationDate as order_date,
 // SalesOrganizationText
    e.SalesOrganizationName,
 // ProfitCenterText
    f.ProfitCenterName,
 // DivisionText
    g.DivisionName,
 // product
    h.ProductOldID,
    h.ProductType,
    h.BaseUnit,
 // delivery 
    v.DeliveryDocument,
    v.DeliveryDocumentItem,
 // ProductUnitsOfMeasure
    w.BaseUnit as ST,
 //   x.BaseUnit as TON,
 // accounting details

    
 // Condation
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    i.ConditionAmount as discount,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    J.ConditionAmount as Taxable_value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    l.ConditionAmount as Freight,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    m.ConditionAmount as Base_price,

    @Semantics.amount.currencyCode: 'TransactionCurrency'
    k.ConditionAmount as Base_value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    n.ConditionAmount as Packaging_Fee,

    @Semantics.amount.currencyCode: 'TransactionCurrency'
    o.ConditionAmount as Pricing,
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    p.ConditionAmount as Round_off,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    u.ConditionAmount as Nipha_Internal_Price,
    
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    zo.ConditionAmount as Internal_Price,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zp.ConditionAmount as FOB_Value,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zq.ConditionAmount as Commission,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zr.ConditionAmount as Demurrage_Chrg,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zs.ConditionAmount as Defective_Allowance_per,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zt.ConditionAmount as Additional_Insurance,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zu.ConditionAmount as Insurance_Less,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zv.ConditionAmount as Margin_per_unit,
    
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    q.ConditionRateValue as CGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    q.ConditionAmount as CGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    r.ConditionRateValue as SGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    r.ConditionAmount as SGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    s.ConditionRateValue as IGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    s.ConditionAmount as IGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    za.ConditionRateValue as UGST_RATE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    za.ConditionAmount as UGST,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    t.ConditionAmount as TCS,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zw.ConditionRateValue as tcs_base_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zw.ConditionAmount as tcs_rate,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zx.ConditionAmount as tcs_ltc,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    zy.ConditionAmount as Integrated_GST_RT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when q.ConditionAmount is not null
    then 
   //  coalesce(get_numeric_value(a.TOT_INVOICE),0) + coalesce(get_numeric_value(c.AmountInCompanyCodeCurrency),0) 
    q.ConditionAmount + r.ConditionAmount
    when s.ConditionAmount is not null
    then 
    s.ConditionAmount
    end as tot_isgt_sgst,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    case when s.ConditionAmount is not initial then  
    abs(get_numeric_value(s.ConditionAmount)) 
//+ abs(get_numeric_value(za.ConditionAmount))
    else
    abs(get_numeric_value(r.ConditionAmount)) + 
    abs(get_numeric_value(q.ConditionAmount)) 
//    +abs(get_numeric_value(za.ConditionAmount)) 
    end as tot_taxable_value,
//    za.ConditionAmount as TOTALTAXVALUE,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    abs(get_numeric_value(J.ConditionAmount)) + abs(get_numeric_value(q.ConditionAmount)) + 
    abs(get_numeric_value(r.ConditionAmount)) + 
    abs(get_numeric_value(s.ConditionAmount)) +
    abs(get_numeric_value(za.ConditionAmount)) + 
    abs(get_numeric_value(t.ConditionAmount)) as TOTALWITHTCS

//    (get_numeric_value(j.AmountInCompanyCodeCurrency))
    
    
   
 
    
}
