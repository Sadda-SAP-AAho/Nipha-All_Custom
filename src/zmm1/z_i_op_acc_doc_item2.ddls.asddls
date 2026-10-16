@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Acounting doc item2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity z_i_op_acc_doc_item2 as select from z_i_op_acc_doc_item as a left outer join C_SupplierInvoiceDEX as b 
 on a.SupplierInvoice = b.SupplierInvoice and a.FiscalYear = b.FiscalYear
 //left outer join I_JournalEntry as c on c.OriginalReferenceDocument = a.org_ref_inv_no
 //left outer join Y_WITHHOLDING as e on e.AccountingDocument = c.AccountingDocument and e.CompanyCode = c.CompanyCode and e.FiscalYear = c.FiscalYear
 association [1..1] to I_SupplierInvoiceAPI01        as d       on  $projection.SupplierInvoice = d.SupplierInvoice
                                                                    and $projection.FiscalYear  = d.FiscalYear
                                                                                                                                   
                                                                    
 
{
    key a.SupplierInvoice,
    key a.FiscalYear,
        a.lineitem,
        a.org_ref_inv_no,
        b.DocumentCurrency,
        @Semantics.amount.currencyCode: 'DocumentCurrency'
        b.InvoiceGrossAmount,
/*        c.AccountingDocument,
        c.CompanyCode,
        c.FiscalYear as acc_fiscal_yr,*/
        @Semantics.amount.currencyCode: 'DocumentCurrency'
        d.SuplrInvcManuallyReducedAmount
/*        e.WithholdingTaxType,
        e.WithholdingTaxCode,
        e.WithholdingTaxPercent,
        @Semantics.amount.currencyCode: 'DocumentCurrency'
        e.WhldgTaxAmtInCoCodeCrcy,
        e.type_desc*/
             
        
}
