@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS FOR SO PRINT'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SO_PRINT
  as select from I_SalesOrder as A
{
      @EndUserText.label: 'Sales Order No'
      @UI.lineItem: [{ position: 10 , label: 'Sales Order No' }]
      @UI.selectionField: [{ position: 10 }]
  key A.SalesOrder,
      @EndUserText.label: 'Sales Order Type'
      @UI.lineItem: [{ position: 20 , label: 'Sales Order Type' }]
      @UI.selectionField: [{ position: 20 }]
      A.SalesOrderType,
      @EndUserText.label: 'Sales Order Date'
      @UI.lineItem: [{ position: 30 , label: 'Sales Order Date' }]
      @UI.selectionField: [{ position: 30 }]
      A.SalesOrderDate
}
