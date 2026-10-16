@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Read Domain Values For ZDO_CH4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_READ_DOMAIN
//with parameters
//  p_domain_name : sxco_ad_object_name --abap.char(30)
//as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : $parameters.p_domain_name ) as Value
as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : 'ZDO_CH4' ) as Value
association [0..1] to DDCDS_CUSTOMER_DOMAIN_VALUE_T as _text on 
   Value.domain_name = _text.domain_name and 
   Value.value_position = _text.value_position and 
   _text.language = $session.system_language  
{
  //key Value.domain_name as Name,
  //key Value.value_position as ValuePosition,
    key Value.value_low as Value,
  //    _text( p_domain_name : $parameters.p_domain_name ).text as Description
      _text( p_domain_name : 'ZDO_CH4' ).text as Description
}
