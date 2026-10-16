@EndUserText.label: 'DATABASE TABLE FOR MANUFACTURE SERIES PP'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DatabaseTableForAll'
  }
}
define root view entity ZI_DatabaseTableForManPP_S
  as select from I_Language
    left outer join ZDBMANUSRSPP on 0 = 0
  composition [0..*] of ZI_DatabaseTableForManPP as _DatabaseTableForMan
{
  @UI.facet: [ {
    id: 'ZI_DatabaseTableForManPP', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'DATABASE TABLE FOR MANUFACTURE SERIES PP', 
    position: 1 , 
    targetElement: '_DatabaseTableForMan'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DatabaseTableForMan,
  @UI.hidden: true
  max( ZDBMANUSRSPP.LOCAL_LAST_CHANGED_AT ) as LastChangedAtMax
}
where I_Language.Language = $session.system_language
