@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Withholding data with purchase details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZWITHHOLDING_DATA as select from z_i_op_acc_doc_item1
{
    key SupplierInvoice,
    key FiscalYear,
    key lineitem,
        org_ref_inv_no,
        DocumentCurrency,
        CompanyCode,
        acc_fiscal_yr,
//        cast(InvoiceGrossAmount as abap.dec( 16, 2 )) as InvoiceGrossAmt,
//        cast(SuplrInvcManuallyReducedAmount as abap.dec( 16, 2 )) as SuplrInvcManuallyReducedAmount,
//    WithholdingTaxType,
//    WithholdingTaxCode,
//    WithholdingTaxPercent,
//    cast(WhldgTaxAmtInCoCodeCrcy as abap.dec( 16, 2 )) as WhldgTaxAmtInCoCodeCrcy,
 //   type_desc,
    min(AccountingDocument) as AccountingDocument
 
}
group by
    SupplierInvoice,
    FiscalYear,
    lineitem,
    org_ref_inv_no,
    DocumentCurrency,
    CompanyCode,
    acc_fiscal_yr    
//    InvoiceGrossAmount,
/*    SuplrInvcManuallyReducedAmount,
    WithholdingTaxType,
    WithholdingTaxCode,
    WithholdingTaxPercent,
    WhldgTaxAmtInCoCodeCrcy,
    type_desc*/

