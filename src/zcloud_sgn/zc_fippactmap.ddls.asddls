@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_FIPPACTMAP'
define root view entity ZC_FIPPACTMAP
  provider contract transactional_query
  as projection on ZR_FIPPACTMAP
{
  key UUID,
  Gl,
  Prdcc,
  ActType,
  ActCat,
  LocalLastChangedAt
  
}
