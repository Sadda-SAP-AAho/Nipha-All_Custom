@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Accounting doc item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity z_i_op_acc_doc_item as select distinct 
from C_SupplierInvoiceItemDEX as a
{
  key a.SupplierInvoice,
//  key ,
  key a.FiscalYear,
      min(a.SupplierInvoiceItem) as lineitem,
      concat(a.SupplierInvoice,a.FiscalYear) as org_ref_inv_no   
//      a.PurchaseOrder,
//      a.PurchaseOrderItem

      }
      group by
      a.SupplierInvoice,
      a.FiscalYear

            
 