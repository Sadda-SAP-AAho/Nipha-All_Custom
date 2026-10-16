@EndUserText.label: 'Parameter Entity For Generating DRC Data'
define abstract entity ZI_DRCDATAGEN_PARAM
{
  @EndUserText.label: 'Plant'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } }]
  Plant        : werks_d;

  @EndUserText.label: 'Document Date'
  DocumentDate : abap.dats;

}
