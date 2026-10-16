@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINATION OF MATERILA ISSUE PRINT'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_MATERIAL_ISSUE as select from I_MaterialDocumentItem_2
{

    @UI.selectionField: [{ position: 10 }]
    @EndUserText.label: 'Material Document'
   // @Consumption.filter.mandatory: true
    @UI.lineItem: [{ position: 10 }]
    key MaterialDocument    ,
    @UI.selectionField: [{ position: 20 }]
    @EndUserText.label: 'PLANT'
    @Consumption.filter.mandatory: true
    @UI.lineItem: [{ position: 20 }]
        Plant  
        
    
      
     
    
    
} 
