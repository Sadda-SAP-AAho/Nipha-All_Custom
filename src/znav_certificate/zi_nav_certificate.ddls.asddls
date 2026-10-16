@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_NAV_Certificate as select from znav_cert
//composition of target_data_source_name as _association_name
{
    key supplier as Supplier,
    certificate as Certificate
//    _association_name // Make association public
}
