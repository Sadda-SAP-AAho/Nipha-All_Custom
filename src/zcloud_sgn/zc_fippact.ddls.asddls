@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_FIPPACT'
define root view entity ZC_FIPPACT
  provider contract transactional_query
  as projection on ZR_FIPPACT
{
  key UUID,
  Gl,
  Prdcc,
  ActType,
  LocalLastChangedAt
  
}
