@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity zc_plantvh
  as select from    zuser_header as A
    left outer join zuser_item   as B on A.userid = B.userid
    left outer join I_Plant      as C on C.Plant = B.plant
{
  key C.Plant,
      C.PlantName

}
where
  B.userid = $session.user
