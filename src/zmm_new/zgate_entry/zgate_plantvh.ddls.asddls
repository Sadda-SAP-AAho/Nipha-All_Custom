@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GATE ENTRY PLANT VALUE HELP'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZGATE_PLANTVH
  as select from I_PlantStdVH as A
    inner join   zuser_item   as B on A.Plant = B.plant
{
   key A.Plant as Plant , 
   A.PlantName as PlantName    
}
where B.userid =  $session.user
