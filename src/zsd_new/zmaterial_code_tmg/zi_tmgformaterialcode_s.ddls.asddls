@EndUserText.label: 'TMG For Material Code Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'TmgForMaterialCoAll'
  }
}
define root view entity ZI_TmgForMaterialCode_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_TMGFORMATERIALCODE'
  composition [0..*] of ZI_TmgForMaterialCode as _TmgForMaterialCode
{
  @UI.facet: [ {
    id: 'ZI_TmgForMaterialCode', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'TMG For Material Code', 
    position: 1 , 
    targetElement: '_TmgForMaterialCode'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _TmgForMaterialCode,
  @UI.hidden: true
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax
}
where I_Language.Language = $session.system_language
