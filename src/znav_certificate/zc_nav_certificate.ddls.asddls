@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'composition view'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo: { typeName: 'NDAs Certificate' ,
                  typeNamePlural: 'NDAs Certificate'
                   }
define root view entity ZC_NAV_Certificate
  as projection on ZI_NAV_Certificate
{
      @UI.facet: [{ id: 'Supplier',
             purpose: #STANDARD,
             type: #IDENTIFICATION_REFERENCE,
             label: 'NDAs  Certificate Data',
             position: 10
      }]

      @UI: { lineItem: [{ position: 20 , label: 'Supplier'}],
      identification: [{ position: 20 , label: 'Supplier'}] }
      @UI.selectionField: [ { position: 20 } ]
      @Consumption.valueHelpDefinition: [{ entity : {
      name : 'I_supplier' ,
      element: 'Supplier'} }]
      @EndUserText.label: 'Supplier'
  key Supplier,
      @UI: { lineItem: [{ position: 30 , label: 'Certificate'}],
      identification: [{ position: 30 , label: 'Certificate'}] }
//      @UI.selectionField: [ { position: 30 } ]
      @EndUserText.label: 'Certificate'
      Certificate
}
