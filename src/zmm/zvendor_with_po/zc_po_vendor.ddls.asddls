@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composition view for vendor po'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: { typeName: 'Vendor for Po date validation' ,
                  typeNamePlural: 'Vendor for Po date validation'
                   }
define root view entity ZC_PO_VENDOR as projection on ZI_PO_VENDOR
{
      @UI.facet: [{ id: 'Supplier',
             purpose: #STANDARD,
             type: #IDENTIFICATION_REFERENCE,
             label: 'Vendor for Po date validation data',
             position: 10
      }]

      @UI: { lineItem: [{ position: 20 , label: 'Supplier'}],
      identification: [{ position: 20 , label: 'Supplier'}] }
      @UI.selectionField: [ { position: 20 } ]
      @Consumption.valueHelpDefinition: [{ entity : {
      name : 'I_supplier' ,
      element: 'Supplier'} }]
      @EndUserText.label: 'Supplier'
   key supplier,
         @UI: { lineItem: [{ position: 30 , label: 'Supplier Name'}],
      identification: [{ position: 30 , label: 'Supplier Name'}] }
//      @UI.selectionField: [ { position: 30 } ]
      @EndUserText.label: 'Certificate'
      SupplierName
}
