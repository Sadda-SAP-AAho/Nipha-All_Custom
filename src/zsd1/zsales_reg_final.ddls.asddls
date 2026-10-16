@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'Sales Reg.' ,
                  typeNamePlural: 'Sales Register Report'
                   }
define view entity ZSALES_REG_FINAL as select from ZSALES_REG_BASE
{
    @UI.identification: [{position:10}]
    @EndUserText.label: 'Billing Document'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 10 }]
key BillingDocument,
    @UI.lineItem: [{position:15}]
    @EndUserText.label: 'Billing Document item'
key BillingDocumentItem,
    @UI.lineItem: [{position:25}]
    @EndUserText.label: 'Item Text'
    BillingDocumentItemText,
    @UI.lineItem: [{position:30}]
    @EndUserText.label: 'Product Group'
    ProductGroup,
    @UI.lineItem: [{position:50}]
    @EndUserText.label: 'Product Group Name'
    MaterialGroupName,
    @UI.lineItem: [{position:65}]
    @EndUserText.label: 'Quantity'    
    BillingQuantityUnit,
    @UI.lineItem: [{position:70}]
    @EndUserText.label: 'Sales Group'
    SalesGroup,
    @UI.lineItem: [{position:75}]
    @EndUserText.label: 'Created By User'
    CreatedByUser,
    @UI.lineItem: [{position:95}]
    @EndUserText.label: 'Item Weight Unit'
    ItemWeightUnit,
    @UI.lineItem: [{position:110}]
    @EndUserText.label: 'Profit Center'
    ProfitCenter,
    @UI.lineItem: [{position:115}]
    @EndUserText.label: 'Additional Customer Group1'
    AdditionalCustomerGroup1,
    @UI.lineItem: [{position:120}]
    @EndUserText.label: 'Additional Customer Group2'
    AdditionalCustomerGroup2,
    @UI.lineItem: [{position:125}]
    @EndUserText.label: 'Additional Customer Group3'
    AdditionalCustomerGroup3,
    @UI.lineItem: [{position:130}]
    @EndUserText.label: 'Additional Customer Group4'
    AdditionalCustomerGroup4,
    @UI.lineItem: [{position:140}]
    @EndUserText.label: 'Additional Customer Group5'
    AdditionalCustomerGroup5,
    @UI.lineItem: [{position:142}]
    @EndUserText.label: 'Division'
    Division,
    @UI.lineItem: [{position:144}]
    @EndUserText.label: 'Distribution Channel'
    DistributionChannel,
    @UI.lineItem: [{position:154}]
    @EndUserText.label: 'Distribution Channel Name'
    DistributionChannelName,
    @UI.lineItem: [{position:158}]
    @EndUserText.label: 'CompanyCode'
    CompanyCode,
    @UI.lineItem: [{position:162}]
    @EndUserText.label: 'SalesOffice'
    SalesOffice,
    @UI.lineItem: [{position:165}]
    @EndUserText.label: 'Currency'
    TransactionCurrency,
    @UI.lineItem: [{position:168}]
    @EndUserText.label: 'Controlling Area'
    ControllingArea,
    @UI.lineItem: [{position:171}]
    @EndUserText.label: 'TaxCode'
    TaxCode,
    @UI.lineItem: [{position:181}]
    @EndUserText.label: 'SoldToParty'
    SoldToParty,
    @UI.lineItem: [{position:200}]
    @EndUserText.label: 'Product'
    Product,
    
     @UI.lineItem: [{position:208}]
    @EndUserText.label: 'HSN Code'   
    hsn_sac_code,
        @UI.lineItem: [{position:215}]
    @EndUserText.label: 'Product'
    ean_code,
        @UI.lineItem: [{position:220}]
    @EndUserText.label: 'Sales Doc. Itam Category'
    SalesDocumentItemCategory,
        @UI.lineItem: [{position:230}]
    @EndUserText.label: 'Sold To Customer'
    sold_to_customer,
        @UI.lineItem: [{position:245}]
    @EndUserText.label: 'Sold To Name1'
    sold_to_name1,
        @UI.lineItem: [{position:260}]
    @EndUserText.label: 'Sold To Name2'
    sold_to_name2,
        @UI.lineItem: [{position:275}]
    @EndUserText.label: 'Sold To Name3'
    sold_to_name3,
        @UI.lineItem: [{position:290}]
    @EndUserText.label: 'Sold To Name4'
    sold_to_name4,
        @UI.lineItem: [{position:305}]
    @EndUserText.label: 'Sold To City Name'
    sold_to_cityname,
        @UI.lineItem: [{position:315}]
    @EndUserText.label: 'Sold To Pin No.'
    sold_to_pin,
        @UI.lineItem: [{position:320}]
    @EndUserText.label: 'Sold To Region'
    sold_to_region,
        @UI.lineItem: [{position:335}]
    @EndUserText.label: 'Sold To Region Name'
    sold_to_region_name,

//  ship to party
        @UI.lineItem: [{position:345}]
    @EndUserText.label: 'Ship TO Customer'
    ship_to_customer,
        @UI.lineItem: [{position:360}]
    @EndUserText.label: 'Ship TO Name1'
    ship_to_name1,
        @UI.lineItem: [{position:375}]
    @EndUserText.label: 'Ship TO Name2'
    ship_to_name2,
        @UI.lineItem: [{position:390}]
    @EndUserText.label: 'Ship TO Name3'
    ship_to_name3,
        @UI.lineItem: [{position:405}]
    @EndUserText.label: 'Ship TO Name4'
    ship_to_name4,
        @UI.lineItem: [{position:415}]
    @EndUserText.label: 'Ship TO City Name'
    ship_to_cityname,
        @UI.lineItem: [{position:425}]
    @EndUserText.label: 'Ship TO Pin NO.'
    ship_to_pin,
        @UI.lineItem: [{position:430}]
    @EndUserText.label: 'Ship TO Region'
    ship_to_region,
        @UI.lineItem: [{position:445}]
    @EndUserText.label: 'Ship TO Region Name'
    ship_to_region_name,
//  payer to party
    @UI.lineItem: [{position:455}]
    @EndUserText.label: 'Payer to Customer'
    Payer_to_customer,
        @UI.lineItem: [{position:470}]
    @EndUserText.label: 'Payer to Name1'
    Payer_to_name1,
        @UI.lineItem: [{position:485}]
    @EndUserText.label: 'Payer to Name2'
    Payer_to_name2,
        @UI.lineItem: [{position:500}]
    @EndUserText.label: 'Payer to Name3'
    Payer_to_name3,
        @UI.lineItem: [{position:515}]
    @EndUserText.label: 'Payer to Name4'
    Payer_to_name4,
        @UI.lineItem: [{position:525}]
    @EndUserText.label: 'Payer to City Name'
    Payer_to_cityname,
        @UI.lineItem: [{position:532}]
    @EndUserText.label: 'Payer to Pin no.'
    Payer_to_pin,
        @UI.lineItem: [{position:540}]
    @EndUserText.label: 'Payer to Region'
    Payer_to_region,
        @UI.lineItem: [{position:555}]
    @EndUserText.label: 'Payer to Region Name'
    Payer_to_region_name,
    
        @UI.lineItem: [{position:565}]
    @EndUserText.label: 'Tax Reg. No.'    
    Tax_Reg_no,
            @UI.lineItem: [{position:570}]
    @EndUserText.label: 'Customer Account Assignement Group'
    CustomerAccountAssignmentGroup,
            @UI.lineItem: [{position:575}]
    @EndUserText.label: 'Mat Account Assignment Group'
    MatlAccountAssignmentGroup,
            @UI.lineItem: [{position:580}]
    @EndUserText.label: 'Sold To ac Group'
    SOLD_TO_AC_GROUP,
    
// plnat details
        @UI.lineItem: [{position:585}]
    @EndUserText.label: 'Plant'
    Plant,
            @UI.lineItem: [{position:600}]
    @EndUserText.label: 'Plant Name'
    plant_name,
            @UI.lineItem: [{position:610}]
    @EndUserText.label: 'Plant City'
    plant_city,
            @UI.lineItem: [{position:625}]
    @EndUserText.label: 'Plant Gstin No.'
    plant_gstin_no,
            @UI.lineItem: [{position:630}]
    @EndUserText.label: 'Plant Pin No.'
    plant_pin,
            @UI.lineItem: [{position:640}]
    @EndUserText.label: 'Plant State'
    plant_state,
            @UI.lineItem: [{position:645}]
    @EndUserText.label: 'Storage Location'
    StorageLocation,
            @UI.lineItem: [{position:660}]
    @EndUserText.label: 'Storage Location Name'
    StorageLocationName,
            @UI.lineItem: [{position:665}]
    @EndUserText.label: 'Plant Pan No.'
    PLANT_PAN_NO,
// delivery Details
        @UI.lineItem: [{position:675}]
    @EndUserText.label: 'Delivery Date'
    delivery_date,
            @UI.lineItem: [{position:685}]
    @EndUserText.label: 'PGI Date'
    pgi_date,
            @UI.lineItem: [{position:695}]
    @EndUserText.label: 'SAP Doc. Date'
    SAP_DOC_date,
// eway bill
        @UI.lineItem: [{position:705}]
    @EndUserText.label: 'E-Way Bill No'
    e_way_bill_no,
            @UI.lineItem: [{position:715}]
    @EndUserText.label: 'E-way Bill Dt.'
    e_way_bill_dt,
            @UI.lineItem: [{position:725}]
    @EndUserText.label: 'E-way Inv No.'
    e_way_inv_no,
            @UI.lineItem: [{position:735}]
    @EndUserText.label: 'E-way Inv no. Date'
    e_way_inv_no_dt,
    
  
  // INVOICE DETAILS
            @UI.lineItem: [{position:740}]
    @EndUserText.label: 'Clearing Status'
    Clearing_Status,
                @UI.lineItem: [{position:743}]
    @EndUserText.label: 'VET Country Code'
    vet_County_Code,
                @UI.lineItem: [{position:756}]
    @EndUserText.label: 'Customer Group'
    Customer_Group,
                @UI.lineItem: [{position:760}]
    @EndUserText.label: 'Dest Country Region'
    Dest_Country_Region,
                @UI.lineItem: [{position:770}]
    @EndUserText.label: 'Pricing Date'
    Pricing_Date,
                @UI.lineItem: [{position:775}]
    @EndUserText.label: 'Incoterms'
    Incoterms,
                @UI.lineItem: [{position:780}]
    @EndUserText.label: 'Incoterms Loc1'
    Incoterms_Location_1,
                @UI.lineItem: [{position:790}]
    @EndUserText.label: 'Journal Entry'
    Journal_Entry,
                @UI.lineItem: [{position:795}]
    @EndUserText.label: 'Posting Status'
    Posting_Status,
                @UI.lineItem: [{position:800}]
    @EndUserText.label: 'Pricing Procedure'
    Pricing_Procedure,
                @UI.lineItem: [{position:805}]
    @EndUserText.label: 'Terms Of Payment'
    Terms_of_Payment,
                @UI.lineItem: [{position:815}]
    @EndUserText.label: 'Vat Reg. No.'
    VAT_Registration_No,
                @UI.lineItem: [{position:818}]
    @EndUserText.label: 'UOM'
    UOM,
                @UI.lineItem: [{position:825}]
    @EndUserText.label: 'Case Config UOM'
    CASE_Config_UOM,
                @UI.lineItem: [{position:840}]
    @EndUserText.label: 'Sales order Qty'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit' 
    Sales_Order_Qty,
                @UI.lineItem: [{position:855}]
    @EndUserText.label: 'Delivery Qty'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    Delivery_Qty,
                @UI.lineItem: [{position:870}]
    @EndUserText.label: 'Invoice Qty'
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    inv_qty,
                @UI.lineItem: [{position:880}]
    @EndUserText.label: 'Batch'
    Batch,
                @UI.lineItem: [{position:890}]
    @EndUserText.label: 'Batch MFG Date'
    Batch_Mnf_Date,
                @UI.lineItem: [{position:900}]
    @EndUserText.label: 'Batch Exp Date'
    Batch_Expiry_Date,
                @UI.lineItem: [{position:905}]
    @EndUserText.label: 'MGRP1'
    SD_MGRP1,
                @UI.lineItem: [{position:910}]
    @EndUserText.label: 'MGRP2'
    SD_MGRP2,
                @UI.lineItem: [{position:915}]
    @EndUserText.label: 'MGRP3'
    SD_MGRP3,
                @UI.lineItem: [{position:920}]
    @EndUserText.label: 'MGRP4'
    SD_MGRP4,
                @UI.lineItem: [{position:925}]
    @EndUserText.label: 'MGRP5'
    SD_MGRP5,
                @UI.lineItem: [{position:935}]
    @EndUserText.label: 'PGI No.'
    PGI_No,

 //    h. 

 // invoice header
    @UI.lineItem: [{position:945}]
    @EndUserText.label: 'Cancelled Invoice'    
    CancelledBillingDocument,
                @UI.lineItem: [{position:955}]
    @EndUserText.label: 'Billing Doc Is Cancelled'
    BillingDocumentIsCancelled,
                @UI.lineItem: [{position:965}]
    @EndUserText.label: 'Document Ref. ID'
    DocumentReferenceID,
                @UI.lineItem: [{position:970}]
    @EndUserText.label: 'Fiscal year'
    FiscalYear,
                @UI.lineItem: [{position:980}]
    @EndUserText.label: 'Billing Doc Date'
    BillingDocumentDate,
                @UI.lineItem: [{position:1000}]
    @EndUserText.label: 'Sales Order'
 // sales order item
 
    SalesOrder,
                @UI.lineItem: [{position:1004}]
    @EndUserText.label: 'Sales Order Item'
    SalesOrderItem,
                @UI.lineItem: [{position:1020}]
    @EndUserText.label: 'Sales Order Item Text'
    SalesOrderItemText,
                @UI.lineItem: [{position:1030}]
    @EndUserText.label: 'Creation Date'
    CreationDate,
                @UI.lineItem: [{position:1045}]
    @EndUserText.label: 'Material By Customer'
    MaterialByCustomer,
                @UI.lineItem: [{position:1065}]
    @EndUserText.label: 'Purchase Order By Customer'
 // sales order header

    PurchaseOrderByCustomer,
                @UI.lineItem: [{position:1075}]
    @EndUserText.label: 'Customer PO Date'
    CustomerPurchaseOrderDate,
                @UI.lineItem: [{position:1086}]
    @EndUserText.label: 'SO Date'
    order_date,
 // SalesOrganizationText
             @UI.lineItem: [{position:1096}]
    @EndUserText.label: 'Sales Org Name'
    SalesOrganizationName,
 // ProfitCenterText
             @UI.lineItem: [{position:1106}]
    @EndUserText.label: 'Profit Center Name'
    ProfitCenterName,
 // DivisionText
             @UI.lineItem: [{position:1116}]
    @EndUserText.label: 'Dovision Name'
    DivisionName,
 // product
             @UI.lineItem: [{position:1126}]
    @EndUserText.label: 'Product Old ID'
    ProductOldID,
                @UI.lineItem: [{position:1130}]
    @EndUserText.label: 'Product Type'
    ProductType,
                @UI.lineItem: [{position:1135}]
    @EndUserText.label: 'Base Unit'
    BaseUnit,
 // delivery 
             @UI.lineItem: [{position:1145}]
    @EndUserText.label: 'Delivery Doc'
    DeliveryDocument,
                @UI.lineItem: [{position:1150}]
    @EndUserText.label: 'Delivery Doc Item'
    DeliveryDocumentItem,
  
    @UI.lineItem: [{position:1153}]
    @EndUserText.label: 'ST'
    ST,
// Condation
    @UI.lineItem: [{position:1163}]
    @EndUserText.label: 'Discount'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    discount,
        @UI.lineItem: [{position:1173}]
    @EndUserText.label: 'Taxable Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Taxable_value,
        @UI.lineItem: [{position:1183}]
    @EndUserText.label: 'Freight'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Freight,
        @UI.lineItem: [{position:1193}]
    @EndUserText.label: 'Base_price'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Base_price,
        @UI.lineItem: [{position:1203}]
    @EndUserText.label: 'Base_value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Base_value,
        @UI.lineItem: [{position:1213}]
    @EndUserText.label: 'Packaging_Fee'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Packaging_Fee,
        @UI.lineItem: [{position:1223}]
    @EndUserText.label: 'Pricing'
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    Pricing,
        @UI.lineItem: [{position:1233}]
    @EndUserText.label: 'Round off.'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Round_off,
        @UI.lineItem: [{position:1243}]
    @EndUserText.label: 'Nipha Internal Price'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Nipha_Internal_Price,
        @UI.lineItem: [{position:1253}]
    @EndUserText.label: 'Internal Price'
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    Internal_Price,
        @UI.lineItem: [{position:1263}]
    @EndUserText.label: 'FOB_Value'
    @Semantics.amount.currencyCode: 'TransactionCurrency'    
    FOB_Value,
        @UI.lineItem: [{position:1273}]
    @EndUserText.label: 'Commission'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Commission,
        @UI.lineItem: [{position:1283}]
    @EndUserText.label: 'Demurrage Chrg.'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Demurrage_Chrg,
        @UI.lineItem: [{position:1293}]
    @EndUserText.label: 'Defective_Allowance%'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Defective_Allowance_per,
        @UI.lineItem: [{position:1303}]
    @EndUserText.label: 'Additional Insurance'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Additional_Insurance,
        @UI.lineItem: [{position:1313}]
    @EndUserText.label: 'Insurance(-)'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Insurance_Less,
        @UI.lineItem: [{position:1323}]
    @EndUserText.label: 'Margin per unit'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Margin_per_unit,
        @UI.lineItem: [{position:1333}]
    @EndUserText.label: 'CGST_RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    CGST_RATE,
        @UI.lineItem: [{position:1343}]
    @EndUserText.label: 'CGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    CGST,
        @UI.lineItem: [{position:1353}]
    @EndUserText.label: 'SGST RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    SGST_RATE,
        @UI.lineItem: [{position:1363}]
    @EndUserText.label: 'SGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    SGST,
        @UI.lineItem: [{position:1373}]
    @EndUserText.label: 'IGST RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    IGST_RATE,
        @UI.lineItem: [{position:1383}]
    @EndUserText.label: 'IGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    IGST,
        @UI.lineItem: [{position:1393}]
    @EndUserText.label: 'UGST RATE'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    UGST_RATE,
        @UI.lineItem: [{position:1403}]
    @EndUserText.label: 'UGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    UGST,
        @UI.lineItem: [{position:1413}]
    @EndUserText.label: 'TCS'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    TCS,
        @UI.lineItem: [{position:1423}]
    @EndUserText.label: 'Tcs Base Rate'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    tcs_base_rate,
        @UI.lineItem: [{position:1433}]
    @EndUserText.label: 'Tcs Base'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    tcs_rate,
        @UI.lineItem: [{position:1443}]
    @EndUserText.label: 'Tcs Ltc'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    tcs_ltc,
        @UI.lineItem: [{position:1553}]
    @EndUserText.label: 'Integrated GST RT'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Integrated_GST_RT
 /*       @UI.lineItem: [{position:1563}]
    @EndUserText.label: 'Service Output Tex'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Service_Output_Tax,
        @UI.lineItem: [{position:1573}]
    @EndUserText.label: 'Selling Price'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Selling_Price,
        @UI.lineItem: [{position:1583}]
    @EndUserText.label: 'Base Price'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Base_Price,
        @UI.lineItem: [{position:1593}]
    @EndUserText.label: 'COGST Price'
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    COGS_Price,
    
        @UI.lineItem: [{position:1603}]
    @EndUserText.label: 'Sample Sale'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    Sample_Sale,
        @UI.lineItem: [{position:1613}]
    @EndUserText.label: 'FOC REvenue Revers'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    FOC_Revenue_Revers,    
    @UI.lineItem: [{position:1623}]
    @EndUserText.label: 'FOC GST Expense Transfer'
    @Semantics.amount.currencyCode: 'TransactionCurrency'  
    FOC_GST_Expense_Transfer,
        @UI.lineItem: [{position:1633}]
    @EndUserText.label: 'CSGT Rate'
    
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    CGST_RATE,
        @UI.lineItem: [{position:1643}]
    @EndUserText.label: 'CGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    CGST,
        @UI.lineItem: [{position:1653}]
    @EndUserText.label: 'SGST Rate'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    SGST_RATE,
        @UI.lineItem: [{position:1663}]
    @EndUserText.label: 'SGST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    SGST,
        @UI.lineItem: [{position:1673}]
    @EndUserText.label: 'IGST Rate'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    IGST_RATE,
        @UI.lineItem: [{position:1683}]
    @EndUserText.label: 'ISGT'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    IGST,
        @UI.lineItem: [{position:1693}]
    @EndUserText.label: 'UGST Rate'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    UGST_RATE,
        @UI.lineItem: [{position:1703}]
    @EndUserText.label: 'USGT'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    UGST,
        @UI.lineItem: [{position:1713}]
    @EndUserText.label: 'ST'
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    TCS*/


}
