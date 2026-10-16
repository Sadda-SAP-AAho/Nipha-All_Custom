@AbapCatalog.sqlViewName: 'ZPUR_REG_REPORT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report Final'
define view ZPUR_REG_REPORT as select distinct from ZPUR_PERCENTAGE
{
   key FiscalYear,
   key CompanyCode,
   key AccountingDocument, 
   GLAccount,
   TaxCode,
   DocumentReferenceID,
   BusinessPlace,
   TaxSection,
   @Semantics.amount.currencyCode: 'Currency'
   wit_base_amount,
//   WithholdingTaxAmount,
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
   GLAccountName,   
   ProfitCenter,
   CostCenter,
   Segment,
   TaxCodeName,
//   AmountInCompanyCodeCurrency,
   basic_inv_amt,
   cgst_amt,
   cgst_per,
   sgst_amt,
   sgst_per,
   igst_amt,
   igst_per,
   cgst_rcm_amt,
   cgst_rcm_per,
   sgst_rcm_amt,
   sgst_rcm_per,
   igst_rcm_amt,
   igst_rcm_per,
   no_credit_cgst_amt,
case when no_credit_cgst_amt < 0 then
cast (cast( no_credit_cgst_amt as abap.decfloat16 ) / cast( basic_inv_amt as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( no_credit_cgst_amt as abap.decfloat16 ) / cast( basic_inv_amt as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 )  as abap.decfloat16 ) end as nocr_cgst_per,
   no_credit_sgst_amt,
   case when no_credit_sgst_amt < 0 then
cast (cast(no_credit_sgst_amt as abap.decfloat16 ) / cast( basic_inv_amt as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( no_credit_sgst_amt as abap.decfloat16 ) / cast( basic_inv_amt as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 )  as abap.decfloat16 ) end as nocr_sgst_per,
   no_credit_igst_amt,
   case when no_credit_igst_amt < 0 then
cast (cast( no_credit_igst_amt as abap.decfloat16 ) / cast( basic_inv_amt as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( no_credit_igst_amt as abap.decfloat16 ) / cast( basic_inv_amt as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 )  as abap.decfloat16 ) end as nocr_igst_per,
   total_rcm_payable,
( cast( case when cgst_amt is not null then cgst_amt  else 0 end as abap.dec( 16, 3 ) ) ) + 
( cast( case when sgst_amt is not null then sgst_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when igst_amt is not null then igst_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when no_credit_cgst_amt is not null then no_credit_cgst_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when no_credit_sgst_amt is not null then no_credit_sgst_amt  else 0 end as abap.dec( 16, 3 ) ) ) + 
( cast( case when no_credit_igst_amt is not null then no_credit_igst_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when cgst_rcm_amt is not null then cgst_rcm_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when sgst_rcm_amt is not null then sgst_rcm_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when igst_rcm_amt is not null then igst_rcm_amt  else 0 end as abap.dec( 16, 3 ) ) )
 as total_tax_amount,
 ( cast( case when basic_inv_amt is not null then basic_inv_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when cgst_amt is not null then cgst_amt  else 0 end as abap.dec( 16, 3 ) ) ) + 
( cast( case when sgst_amt is not null then sgst_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when igst_amt is not null then igst_amt  else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when no_credit_cgst_amt is not null then no_credit_cgst_amt else 0 end as abap.dec( 16, 3 ) ) ) +
( cast( case when no_credit_sgst_amt is not null then no_credit_sgst_amt  else 0 end as abap.dec( 16, 3 ) ) ) + 
( cast( case when no_credit_igst_amt is not null then no_credit_igst_amt  else 0 end as abap.dec( 16, 3 ) ) ) -
( cast( case when total_rcm_payable is not null then total_rcm_payable * (-1) else 0 end as abap.dec( 16, 3 ) ) ) -
( cast( case when withholding_tax_amt is not null then withholding_tax_amt * (-1)  else 0 end as abap.dec( 16, 3 ) ) ) as total_inv_amt,
@Semantics.currencyCode
cast ('INR' as abap.cuky(5))  as Currency
}
