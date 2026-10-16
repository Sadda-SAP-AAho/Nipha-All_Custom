@EndUserText.label: 'DATABASE TABLE FOR MANUFACTURE SERIES MM'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DatabaseTableForAll'
  }
}
define root view entity ZI_DatabaseTableForMan_S
  as select from I_Language
    left outer join ZMNUFCTRESERMM on 0 = 0
  composition [0..*] of ZI_DatabaseTableForMan as _DatabaseTableForMan
{
  @UI.facet: [ {
    id: 'ZI_DatabaseTableForMan', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'DATABASE TABLE FOR MANUFACTURE SERIES MM', 
    position: 1 , 
    targetElement: '_DatabaseTableForMan'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DatabaseTableForMan,
  @UI.hidden: true
  max( ZMNUFCTRESERMM.LOCAL_LAST_CHANGED_AT ) as LastChangedAtMax
}
where I_Language.Language = $session.system_language
