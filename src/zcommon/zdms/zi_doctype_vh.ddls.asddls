@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Document Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_DOCTYPE_VH as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZDOC_TYPE' )
{
    @EndUserText.label: 'Value'
    key value_low as Value,
    @Semantics.text: true
    text as Description
}
