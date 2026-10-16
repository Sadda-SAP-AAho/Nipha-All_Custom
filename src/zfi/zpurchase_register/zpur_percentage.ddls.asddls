@AbapCatalog.sqlViewName: 'ZPUR_PERCENTAGE1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZPUR_PERCENTAGE'
define view ZPUR_PERCENTAGE as select distinct from ZPURCHASE_REGISTER as a left outer join ZPUR_REG_WITH1 as b 
  on a.AccountingDocument = b.AccountingDocument and a.CompanyCode = b.CompanyCode and a.FiscalYear = b.FiscalYear
  and a.AccountingDocumentItem = b.AccountingDocumentItem
{  key a.AccountingDocument, 
   key a.FiscalYear,
   key a.CompanyCode,
   a.GLAccount,
   a.DocumentReferenceID,
   a.BusinessPlace,
   a.TaxSection,
   @Semantics.amount.currencyCode: 'Currency'
   b.wit_base_amount,
//   WithholdingTaxAmount,
   b.withholding_tax_amt,
   b.WithholdingTaxCode,
   a.DocumentDate,
   a.PostingDate,
   a.AccountingDocumentType,
   a.DocumentItemText,
   a.Supplier,
   a.SupplierFullName,
   a.IN_GSTPlaceOfSupply,
   a.TaxNumber3,
   a.BusinessPartnerPanNumber,
   a.SupplierAccountGroup,
   a.GLAccountName,   
   a.ProfitCenter,
   a.CostCenter,
   a.Segment,
   a.TaxCode,
   a.TaxCodeName,
//   AmountInCompanyCodeCurrency,
   a.basic_inv_amt,
   a.cgst_amt,
   a.sgst_amt,
   a.igst_amt,
   a.cgst_rcm_amt,
   a.sgst_rcm_amt,
   a.igst_rcm_amt,
case when a.basic_inv_amt is not initial  then
cast((cast( a.cgst_amt as abap.decfloat16) / cast(a.basic_inv_amt as abap.decfloat16))  * cast( 100  as abap.decfloat16 ) as abap.decfloat16) else 0 end as cgst_per,
//cast((cast( cgst_amt as abap.decfloat16) / cast(basic_inv_amt as abap.decfloat16))  * cast( 100  as abap.decfloat16 ) as abap.decfloat16) as cgst_per,
case when a.basic_inv_amt is not initial  then
cast( (cast( a.sgst_amt as abap.decfloat16) / cast(a.basic_inv_amt as abap.decfloat16) ) * cast(100 as abap.decfloat16)  as abap.decfloat16) else 0 end as sgst_per,
case when a.basic_inv_amt is not initial  then
cast( (cast( a.igst_amt as abap.decfloat16) / cast(a.basic_inv_amt as abap.decfloat16) ) * cast(100 as abap.decfloat16)  as abap.decfloat16) else 0 end as igst_per,
case when a.basic_inv_amt is not initial  then
cast( (cast( a.cgst_rcm_amt as abap.decfloat16) / cast(a.basic_inv_amt as abap.decfloat16) ) * cast(100 as abap.decfloat16)  as abap.decfloat16) else 0 end as cgst_rcm_per,
case when a.basic_inv_amt is not initial  then
cast( (cast( a.sgst_rcm_amt as abap.decfloat16) / cast(a.basic_inv_amt as abap.decfloat16) ) * cast(100 as abap.decfloat16)  as abap.decfloat16) else 0 end as sgst_rcm_per,
case when a.basic_inv_amt is not initial  then
cast( (cast( a.igst_rcm_amt as abap.decfloat16) / cast(a.basic_inv_amt as abap.decfloat16) ) * cast(100 as abap.decfloat16)  as abap.decfloat16) else 0 end as igst_rcm_per,
   a.no_credit_cgst_amt,
   a.no_credit_sgst_amt,
   a.no_credit_igst_amt,
   a.total_rcm_payable,
//count(distinct AccountingDocument) as count1,
@Semantics.currencyCode
cast ('INR' as abap.cuky(5))  as Currency
}group by
a.FiscalYear,
a.CompanyCode,
a.AccountingDocument,
a.DocumentReferenceID,
a.BusinessPlace,
a.TaxSection,
b.wit_base_amount,
//WithholdingTaxAmount,
b.withholding_tax_amt,
b.WithholdingTaxCode,
a.DocumentDate,
a.PostingDate,
a.AccountingDocumentType,
a.DocumentItemText,
a.Supplier,
a.SupplierFullName,
a.IN_GSTPlaceOfSupply,
a.TaxNumber3,
a.BusinessPartnerPanNumber,
a.SupplierAccountGroup,
a.GLAccount,
a.GLAccountName,   
a.ProfitCenter,
a.CostCenter,
a.Segment,
a.TaxCode,
a.TaxCodeName,
//AmountInCompanyCodeCurrency,
a.basic_inv_amt,
a.cgst_amt,
a.sgst_amt,
a.igst_amt,
a.cgst_rcm_amt,
a.sgst_rcm_amt,
a.igst_rcm_amt,
a.no_credit_cgst_amt,
a.no_credit_sgst_amt,
a.no_credit_igst_amt,
a.total_rcm_payable
;
 