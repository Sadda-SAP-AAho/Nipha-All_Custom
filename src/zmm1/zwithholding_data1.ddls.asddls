@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Withholding data with purchase details 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZWITHHOLDING_DATA1 as select from ZWITHHOLDING_DATA as a left outer join z_i_op_acc_doc_item1 as b on 
  a.SupplierInvoice = b.SupplierInvoice and a.FiscalYear = b.FiscalYear and a.lineitem = b.lineitem
  and a.AccountingDocument = b.AccountingDocument and a.acc_fiscal_yr = b.acc_fiscal_yr

{
    key a.SupplierInvoice,
    key a.FiscalYear,
    key a.lineitem,
    a.org_ref_inv_no,
    a.DocumentCurrency,
    a.CompanyCode,
    a.acc_fiscal_yr,
    a.AccountingDocument,
    cast(b.InvoiceGrossAmount as abap.dec( 16, 2 )) as InvoiceGrossAmt,
    cast(b.SuplrInvcManuallyReducedAmount as abap.dec( 16, 2 )) as SuplrInvcManuallyReducedAmount,
    b.WithholdingTaxType,
    b.WithholdingTaxCode,
    b.WithholdingTaxPercent,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    b.WhldgTaxAmtInCoCodeCrcy,
 //   cast(b.WhldgTaxAmtInCoCodeCrcy as abap.dec( 16, 2 )) as WhldgTaxAmtInCoCodeCrcy,
    b.type_desc
}
