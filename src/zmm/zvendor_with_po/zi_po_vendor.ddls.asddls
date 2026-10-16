@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor for po interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PO_VENDOR as select from zpo_vendor as a left outer join I_Supplier as b on a.supplier = b.Supplier
//composition of target_data_source_name as _association_name
{
   key a.supplier as supplier, 
       b.SupplierName as SupplierName
//    _association_name // Make association public
}
