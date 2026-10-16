@EndUserText.label: 'DATABASE FOR BANK DETAILS Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'DatabaseForBankDAll'
  }
}
define root view entity ZI_DatabaseForBankDeta_S
  as select from I_Language
    left outer join ZDT_BNKDETLS on 0 = 0
  composition [0..*] of ZI_DatabaseForBankDeta as _DatabaseForBankDeta
{
  @UI.facet: [ {
    id: 'ZI_DatabaseForBankDeta', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'DATABASE FOR BANK DETAILS', 
    position: 1 , 
    targetElement: '_DatabaseForBankDeta'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _DatabaseForBankDeta,
  @UI.hidden: true
  max( ZDT_BNKDETLS.LOCAL_LAST_CHANGED_AT ) as LastChangedAtMax
}
where I_Language.Language = $session.system_language
