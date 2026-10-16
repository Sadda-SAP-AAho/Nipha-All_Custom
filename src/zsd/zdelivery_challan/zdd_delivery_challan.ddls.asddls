@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition for Delivery Challan'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDD_DELIVERY_CHALLAN
  as select from I_BillingDocument
{
       @Search.defaultSearchElement: true
       @UI.selectionField   : [{ position:1 }]
       @UI.lineItem   : [{ position:1, label:'Billing Document' }]

  key  BillingDocument,

       @EndUserText.label: 'Billing Document Type'
       @Search.defaultSearchElement: true
       @UI.selectionField   : [{ position:2 }]
       @UI.lineItem   : [{ position:2, label:'Billing Document Type' }]
       BillingDocumentType,
       
       @EndUserText.label: 'Creation Date'
       //@Search.defaultSearchElement: true
       @UI.selectionField   : [{ position:3 }]
       @UI.lineItem   : [{ position:3, label:'Creation Date' }]

       CreationDate
}
where BillingDocumentType = 'F8'
