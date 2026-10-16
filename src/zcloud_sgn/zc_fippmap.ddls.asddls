@AccessControl.authorizationCheck: #CHECK
//@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_FIPPMAP'
define root view entity ZC_FIPPMAP
  provider contract transactional_query
  as projection on ZR_FIPPMAP
{
  key UUID,
  Commcc1,
  Commcc2,
  Deptcc,
  Prdcc,
  Gl,
  ActType,
  ActCat,
  LocalLastChangedAt
  
}
