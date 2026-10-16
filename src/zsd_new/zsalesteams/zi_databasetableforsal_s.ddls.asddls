@EndUserText.label: 'DATABASE TABLE FOR SALES TEAMS Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DatabaseTableForAll'
  }
}
define root view entity ZI_DatabaseTableForSal_S
  as select from I_Language
    left outer join ZDT_SALESTM on 0 = 0
  composition [0..*] of ZI_DatabaseTableForSal as _DatabaseTableForSal
{
  @UI.facet: [ {
    id: 'ZI_DatabaseTableForSal', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'DATABASE TABLE FOR SALES TEAMS', 
    position: 1 , 
    targetElement: '_DatabaseTableForSal'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DatabaseTableForSal,
  @UI.hidden: true
  max( ZDT_SALESTM.LOCAL_LAST_CHANGED_AT ) as LastChangedAtMax
}
where I_Language.Language = $session.system_language
