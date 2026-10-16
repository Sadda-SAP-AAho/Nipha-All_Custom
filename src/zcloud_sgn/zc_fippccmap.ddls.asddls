@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_FIPPCCMAP'
define root view entity ZC_FIPPCCMAP
  provider contract transactional_query
  as projection on ZR_FIPPCCMAP
{
  key UUID,
  Commcc,
  Deptcc,
  Prdcc,
  LocalLastChangedAt
  
}
