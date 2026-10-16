@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help to Get Details in Lines'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TaxCodeSum
  as select from I_TaxCodeRate as a
  join I_TaxCodeText as b on a.TaxCode = b.TaxCode
{
  key a.TaxCode,    
      abs( sum( a.ConditionRateRatio ) ) as GST,
      b.TaxCodeName
      
}
group by a.TaxCode, b.TaxCodeName
