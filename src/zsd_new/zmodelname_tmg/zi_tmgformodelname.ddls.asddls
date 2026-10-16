@EndUserText.label: 'TMG FOR MODEL NAME'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForModelName
  as select from ZDT_MODELNAME
  association to parent ZI_TmgForModelName_S as _TmgForModelNameAll on $projection.SingletonID = _TmgForModelNameAll.SingletonID
{
  key CODE as Code,
  key LANGUAGE as Language,
  DESCRIPTION as Description,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForModelNameAll
}
