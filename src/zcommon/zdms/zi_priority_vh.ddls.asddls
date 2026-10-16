@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Priority Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PRIORITY_VH as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZPRIORITY' )
{
    @EndUserText.label: 'Value'
    key value_low as Value,
    @Semantics.text: true
    text as Description
}
