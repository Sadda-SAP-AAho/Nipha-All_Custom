@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant DMS CDS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity  ZC_PLANT_DMS as select from ZR_TABLE_PLANT000 as A

left outer join ZI_GROUPED_DOC as b on  A.PlantCode    = b.RefObjectKey
                                        and b.RefObjectType = 'PLNT'

left outer join ZR_USER_ITEM000 as _user on A.PlantCode = _user.Plant 
{
 key A.PlantCode   as Plant,
  A.PlantName1 as PlantName,
  A.GstinNo    as GSTINNumber,
  A.StateName  as StateName,
  A.StateCode1 as StateCode,
  A.Address1,
  b.DocCount as DocumentCount,
  A.CreatedBy

}
where _user.Userid = $session.user

