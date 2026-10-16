@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINATION FOR PO VALUE HLP'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_PRDCORDRVH as select from I_MfgOrderSequence as production
join I_MfgBOOMaterialAssignment as  Op  on Op.BillOfOperationsGroup = production.BillOfOperationsGroup
   {
   key production.ManufacturingOrder,   
   Op.Product ,
   production.BillOfOperationsGroup,
   production.BillOfOperationsVariant
    
}
