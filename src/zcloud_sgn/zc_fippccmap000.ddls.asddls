@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_FIPPCCMAP000'
define root view entity ZC_FIPPCCMAP000
  provider contract transactional_query
  as projection on ZR_FIPPCCMAP000
{
  key UUID,
  Commcc,
  Deptcc,
  Prdcc,
  LocalLastChangedAt
  
}
