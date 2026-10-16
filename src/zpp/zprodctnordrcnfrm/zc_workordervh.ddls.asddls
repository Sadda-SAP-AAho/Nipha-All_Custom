@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINATION FOR WRORDR VH'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_WORKORDERVH as select distinct from I_WorkCenter as workcenter
   {
   key workcenter.WorkCenter,
   workcenter.Plant,
   _Text.WorkCenterText
    
} 
