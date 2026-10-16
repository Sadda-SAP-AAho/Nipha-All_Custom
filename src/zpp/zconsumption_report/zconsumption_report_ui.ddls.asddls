@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPORT_UI'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCONSUMPTION_REPORT_UI as select from ZCONSUMPTION_REP_CAL
{
    
    @UI.identification: [{position:10}]
    @EndUserText.label: 'Order_No'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 10 }]
    @Consumption.filter.mandatory: true
    key Order_No,
//    key GoodsMovement,
    @UI.identification: [{position:15}]
    @EndUserText.label: 'Plant'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 15 }] 
    @Consumption.filter.mandatory: true   
    key Plant,
    @UI.identification: [{position:70}]
    @EndUserText.label: 'Header_Material'
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8 
    @UI.selectionField: [{ position: 70 }]    
    key Header_Material,
    @UI.lineItem: [{position:30}]
    @EndUserText.label: 'Component'
    key Material_Number,
//    @UI.identification: [{position:35}]
//    @EndUserText.label: 'PostingDate'
//    @Search.defaultSearchElement: true
//    @Search.fuzzinessThreshold: 0.8 
//    @UI.selectionField: [{ position: 35 }]    
//    key PostingDate,
    
//    @UI.lineItem: [{position:16}]
//    @EndUserText.label: 'SHIFT'    
//    key SHIFT,
    @UI.lineItem: [{position:17}]
    @EndUserText.label: 'StartDate'    
    StartDate,
    @UI.lineItem: [{position:19}]
    @EndUserText.label: 'EndDate'    
    EndDate,
    @UI.lineItem: [{position:20}]
    @EndUserText.label: 'Product_Base_Qty'    
    Base_Qty,
    @UI.lineItem: [{position:25}]
    @EndUserText.label: 'Component_Qty/BOM'    
     Component_Base_Qty,
    @UI.lineItem: [{position:40}]
    @EndUserText.label: 'Component_withdrawn_Quantity'
    Quantity_withdrawn,
     @UI.lineItem: [{position:45}]
    @EndUserText.label: 'Production Quantity'
    Delivery_Quantity ,
    @UI.lineItem: [{position:50}]
    @EndUserText.label: 'Component_Requirment_Qty'
    Requirment_Qty ,
    @UI.lineItem: [{position:52}]
    @EndUserText.label: 'Header_Product_Description'
    Header_Product_Description,
    @UI.lineItem: [{position:55}]
    @EndUserText.label: 'Description'
    Description,
    @UI.lineItem: [{position:60}]
    @EndUserText.label: 'User_Name'
    User_Name,
     @UI.lineItem: [{position:65}]
    @EndUserText.label: 'Difference'
//    Difference,
//    case when Quantity_withdrawn is not initial  then Quantity_withdrawn else 0 - Requirment_Qty end  as Difference 
    ( cast( case when Quantity_withdrawn is not null then Quantity_withdrawn  else 0 end as abap.dec( 13, 3 ) ) ) -
      cast( case when Requirment_Qty is not null then Requirment_Qty  else 0 end as abap.dec( 13, 3 ) )  as Difference
//     @UI.lineItem: [{position:70}]
//    @EndUserText.label: 'IsReversa_or_IsReversed'
//    IsReversa_or_IsReversed 
    
}
