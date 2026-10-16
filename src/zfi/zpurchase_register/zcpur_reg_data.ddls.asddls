@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Consumption Data'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCPUR_REG_DATA as projection on ZIPUR_REG_DATA
{   
   key FiscalYear,
   key CompanyCode,
   key AccountingDocument,
   key GLAccount, 
   Key TaxCode,
   DocumentReferenceID,
   BusinessPlace,
   TaxSection,
   @Semantics.amount.currencyCode: 'Currency'
   wit_base_amount,
//   @Semantics.amount.currencyCode: 'Currency'
//   WithholdingTaxAmount,
   @Semantics.amount.currencyCode: 'Currency'
   withholding_tax_amt,
   WithholdingTaxCode,
   DocumentDate,
   PostingDate,
   AccountingDocumentType,
   DocumentItemText,
   Supplier,
   SupplierFullName,
   IN_GSTPlaceOfSupply,
   TaxNumber3,
   BusinessPartnerPanNumber,
   SupplierAccountGroup,
//   GLAccount,
   GLAccountName,   
   ProfitCenter,
   CostCenter,
   Segment,
   TaxCodeName,  
   @Semantics.amount.currencyCode: 'Currency'
    basic_inv_amt,
//   @Semantics.amount.currencyCode: 'Currency'
//   AmountInCompanyCodeCurrency,
   @Semantics.amount.currencyCode: 'Currency'
   cgst_amt,
   cgst_per,
   @Semantics.amount.currencyCode: 'Currency'
   sgst_amt,
   sgst_per,
   @Semantics.amount.currencyCode: 'Currency'
   igst_amt,
   igst_per,
   @Semantics.amount.currencyCode: 'Currency'
   cgst_rcm_amt,
   cgst_rcm_per,
   @Semantics.amount.currencyCode: 'Currency'
   sgst_rcm_amt,
   sgst_rcm_per,
   @Semantics.amount.currencyCode: 'Currency'
   igst_rcm_amt,
   igst_rcm_per,
   no_credit_cgst_amt,
   nocr_cgst_per,
   no_credit_sgst_amt,
   nocr_sgst_per,
   no_credit_igst_amt,
   nocr_igst_per,
   total_rcm_payable,
   total_tax_amount,
   total_inv_amt,
   Currency
}
