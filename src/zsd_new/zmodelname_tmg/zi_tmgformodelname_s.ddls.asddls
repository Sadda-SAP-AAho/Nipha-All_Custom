@EndUserText.label: 'TMG FOR MODEL NAME Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgForModelNameAll'
  }
}
define root view entity ZI_TmgForModelName_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_TMGFORMODELNAME'
  composition [0..*] of ZI_TmgForModelName as _TmgForModelName
{
  @UI.facet: [ {
    id: 'ZI_TmgForModelName', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG FOR MODEL NAME', 
    position: 1 , 
    targetElement: '_TmgForModelName'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgForModelName,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax
}
where I_Language.Language = $session.system_language
