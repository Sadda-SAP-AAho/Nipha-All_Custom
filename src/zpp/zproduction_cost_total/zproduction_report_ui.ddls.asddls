@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPRODUCTION_REPORT_UI'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPRODUCTION_REPORT_UI
with parameters
    Fromto : vdm_v_start_date,
    endto  : vdm_v_end_date

as select from ZPRODUCTION_COST_TOTAL_CAL_FNL ( Fromto : $parameters.Fromto , endto : $parameters.endto )

{
      
    @UI.identification: [{position:10}]
    @EndUserText.label: 'Order_No'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 //
    @UI.selectionField: [{ position: 10 }]
    @Consumption.filter.mandatory: true //
    key Order_No,
    key GoodsMovement,
    @UI.identification: [{position:20}]
    @EndUserText.label: 'Plant'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 //
    @UI.selectionField: [{ position: 20 }] 
    @Consumption.filter.mandatory: true   //
    key Plant,

    @UI.lineItem: [{position:30}]
    @EndUserText.label: 'header_material'
    key header_material ,
    @UI.lineItem: [{position:40}]
    @EndUserText.label: 'Component'
    key Component,
    @UI.lineItem: [{position:50}]
    @EndUserText.label: 'Withdraw_qty'
    key Withdraw_qty,
    @UI.lineItem: [{position:60}]
    @EndUserText.label: 'Confirm_qty'
    key Confirm_qty,
//    @UI.lineItem: [{position:70}]
//    @EndUserText.label: 'PostingDate'
//    @Consumption.filter.mandatory: true
    @UI.identification: [{position:70}]
    @EndUserText.label: 'PostingDate'
    @Search.defaultSearchElement: true //
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 70 }]
    @Consumption.filter.mandatory: true  //
    key PostingDate,
    @UI.lineItem: [{position:80}]
    @EndUserText.label: 'Header__Unit_Price_standard'
    key Header__Unit_Price_standard,
    @UI.lineItem: [{position:90}]
    @EndUserText.label: 'Header_Unit_Price_moving'
    key Header_Unit_Price_moving,
    @UI.lineItem: [{position:100}]
    @EndUserText.label: 'Currency'
    key Currency,
    @UI.lineItem: [{position:105}]
    @EndUserText.label: 'Component__Unit_Price_standard'
    key Component__Unit_Price_standard,
    @UI.lineItem: [{position:110}]
    @EndUserText.label: 'Component_Unit_Price_moving'
    key Component_Unit_Price_moving,
    @UI.lineItem: [{position:115}]
    @EndUserText.label: 'Component_Amount'
    Component_Amount,
     @UI.lineItem: [{position:120}]
    @EndUserText.label: 'Activity_Quantity1'
    Activity_Quantity1,
    @UI.lineItem: [{position:125}]
    @EndUserText.label: 'Activity_Unit1'
    Activity_Unit1,
     @UI.lineItem: [{position:130}]
    @EndUserText.label: 'Activity_Name1'
    Activity_Name1,
    @UI.lineItem: [{position:135}]
    @EndUserText.label: 'Activity1_Unit_Price'
    Activity1_Unit_Price,
    @UI.lineItem: [{position:140}]
    @EndUserText.label: 'Activity1_Amount'
    Activity1_Amount,
    @UI.lineItem: [{position:145}]
    @EndUserText.label: 'Activity_Quantity2'
    Activity_Quantity2,
     @UI.lineItem: [{position:150}]
    @EndUserText.label: 'Activity_Unit2'
    Activity_Unit2,
    @UI.lineItem: [{position:155}]
    @EndUserText.label: 'Activity_Name2'
    Activity_Name2,
    @UI.lineItem: [{position:160}]
    @EndUserText.label: 'Activity2_Unit_Price'
    Activity2_Unit_Price,
    @UI.lineItem: [{position:165}]
    @EndUserText.label: 'Activity2_Amount'
    Activity2_Amount,
    @UI.lineItem: [{position:170}]
    @EndUserText.label: 'Activity_Quantity3'
    Activity_Quantity3,
    @UI.lineItem: [{position:175}]
    @EndUserText.label: 'Activity_Unit3'
    Activity_Unit3,
    @UI.lineItem: [{position:180}]
    @EndUserText.label: 'Activity_Name3'
    Activity_Name3,
    @UI.lineItem: [{position:185}]
    @EndUserText.label: 'Activity3_Unit_Price'
    Activity3_Unit_Price,
    @UI.lineItem: [{position:190}]
    @EndUserText.label: 'Activity3_Amount'
    Activity3_Amount,
    @UI.lineItem: [{position:195}]
    @EndUserText.label: 'Activity_Quantity4'
    Activity_Quantity4,
    
    
    @UI.lineItem: [{position:200}]
    @EndUserText.label: 'Activity_Unit4'
    Activity_Unit4,
     @UI.lineItem: [{position:205}]
    @EndUserText.label: 'Activity_Name4'
    Activity_Name4,
    @UI.lineItem: [{position:210}]
    @EndUserText.label: 'Activity4_Unit_Price'
    Activity4_Unit_Price,
    @UI.lineItem: [{position:215}]
    @EndUserText.label: 'Activity4_Amount'
    Activity4_Amount,
    @UI.lineItem: [{position:220}]
    @EndUserText.label: 'Activity_Quantity5'
    Activity_Quantity5,
     @UI.lineItem: [{position:225}]
    @EndUserText.label: 'Activity_Unit5'
    Activity_Unit5,
    @UI.lineItem: [{position:230}]
    @EndUserText.label: 'Activity_Name5'
    Activity_Name5,
    @UI.lineItem: [{position:235}]
    @EndUserText.label: 'Activity5_Unit_Price'
    Activity5_Unit_Price,
    @UI.lineItem: [{position:240}]
    @EndUserText.label: 'Activity5_Amount'
    Activity5_Amount,
    @UI.lineItem: [{position:245}]
    @EndUserText.label: 'Activity_Quantity6'
    Activity_Quantity6,
    @UI.lineItem: [{position:250}]
    @EndUserText.label: 'Activity_Unit6'
    Activity_Unit6,
    @UI.lineItem: [{position:255}]
    @EndUserText.label: 'Activity_Name6'
    Activity_Name6,
    @UI.lineItem: [{position:260}]
    @EndUserText.label: 'Activity6_Unit_Price'
    Activity6_Unit_Price,
    @UI.lineItem: [{position:265}]
    @EndUserText.label: 'Activity6_Amount'
    Activity6_Amount,
    @UI.lineItem: [{position:270}]
    @EndUserText.label: 'Header_Amount'
    Header_Amount,
    @UI.lineItem: [{position:275}]
    @EndUserText.label: 'Total_Amt'
    Total_Amt
 
}
//where PostingDate >= $parameters.Fromto and 
//PostingDate <= $parameters.endto

