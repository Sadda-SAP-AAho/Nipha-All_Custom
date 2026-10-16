@AbapCatalog.sqlViewName: 'ZGSTR2_REP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_REPORT'
define view ZGSTR2_REPORT 
as select from   ZGSTR2_FORPERCENT                       
{
key CompanyCode,
key FiscalYear,
key AccountingDocument,
key Material,
AccountingDocumentItem,
AccountingDocumentType,
FiscalPeriod,
PostingDate,
DocumentDate,
TaxCode,
BaseUnit,
FunctionalCurrency,
AccountingDocumentCreationDate,
DocumentReferenceID,
BusinessPlace,
ProfitCenter,
Segment,
Quantity,
IN_HSNOrSACCode,
GoodsMovementEntryUnit,
TransactionTypeDetermination,
BusinessPlaceName,
ProfitCenterName,
SegmentName,
Supplier,
SupplierName,
GSTIN,
Region,
RegionName,
IN_GSTPlaceOfSupply,
ProductDescription,
TaxCodeName,
TBA_AMOUNT,
TAX_BASE_AMOUNT,
AMLOUNT_NOCR_TBA,
AMOUNT_JIC,
AMOUNT_JIC as AMOUNT_JIS,
AMOUNT_JII,
AMOUNT_JIM,
AMOUNT_PAYCGST,
AMOUNT_PAYCGST as AMOUNT_PAYSGST,
AMOUNT_PAYIGST,
AMOUNT_CR_CGST,
AMOUNT_CR_CGST as AMOUNT_CR_SGST,
NoCR_CGST,
NoCR_SGST,
AMOUNT_CR_IGST,
GLACCOUNTS,
GLAccountLongName,
TOTAL_RCM_PAYABLE,
'' as TOTAL_INVOICE_AMOUNT,
'' as TOTAL_TAX_VALUE,
BUSINESS_PLACE_GSTIN,
OriginalReferenceDocument, 
Plant,
PLANTNAME,
TCS_AMOUNT,

////////////////////////////////////////////////////
case when  TBA_AMOUNT <> 0.00 then
case when AMOUNT_JIC < 0  then
cast (cast( AMOUNT_JIC as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( AMOUNT_JIC as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as abap.decfloat16 )  as abap.decfloat16 ) end else 0 end as CGST_PER,

case when  TBA_AMOUNT <> 0.00 then
case when AMOUNT_JIC < 0 then
cast (cast( AMOUNT_JIC as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( AMOUNT_JIC as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as abap.decfloat16 ) as abap.decfloat16 ) end else 0 end as SGST_PER,

case when  TBA_AMOUNT <> 0.00 then
case when  AMOUNT_JII < 0 then
cast (cast( AMOUNT_JII as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( AMOUNT_JII as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as abap.decfloat16 ) as abap.decfloat16 ) end else 0 end as IGST_PER,

////////////////////////////////////////////////////////////////////

case when AMOUNT_JIM <> 0 then 
( cast( 18 as abap.decfloat16 ) ) else 0 end as JIM_PER,

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
case when  TBA_AMOUNT <> 0.00 then
case when NoCR_CGST < 0 then
cast (cast( NoCR_CGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( NoCR_CGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 )  as abap.decfloat16 ) end else 0 end as NOCR_CGST_PER,

case when  TBA_AMOUNT <> 0.00 then
case when NoCR_CGST < 0 then
cast (cast( NoCR_CGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( NoCR_CGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 )  as abap.decfloat16 ) end else 0 end as NOCR_SGST_PER,

case when  TBA_AMOUNT <> 0.00 then
case when AMOUNT_CR_IGST < 0 then
cast (cast( AMOUNT_CR_IGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( AMOUNT_CR_IGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 )  as abap.decfloat16 ) end else 0 end as NOCR_IGST_PER,
////////////////////////////////////
////////////////////////////////////
case when  TBA_AMOUNT <> 0.00 then
case when AMOUNT_PAYCGST < 0 then
cast (cast( AMOUNT_PAYCGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( AMOUNT_PAYCGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) as abap.decfloat16 ) end else 0 end as RCM_CGST_PER,

case when  TBA_AMOUNT <> 0.00 then
case when AMOUNT_PAYCGST < 0 then
cast (cast( AMOUNT_PAYCGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as  abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( AMOUNT_PAYCGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) as abap.decfloat16 ) end else 0 end as RCM_SGST_PER,

case when  TBA_AMOUNT <> 0.00 then
case when AMOUNT_PAYIGST < 0 then 
cast (cast( AMOUNT_PAYIGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 ) * cast( -1 as  abap.decfloat16 ) as abap.decfloat16 ) else
cast (cast( AMOUNT_PAYIGST as abap.decfloat16 ) / cast( TBA_AMOUNT as abap.decfloat16 ) * cast( 100 as  abap.decfloat16 )  as abap.decfloat16 ) end else 0 end as RCM_IGST_PER,
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

( cast( case when AMOUNT_JIC is not null then AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when AMOUNT_JIC is not null then AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_JII is not null then AMOUNT_JII  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_JIM is not null then AMOUNT_JIM  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when NoCR_CGST is not null then NoCR_CGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when NoCR_SGST is not null then NoCR_SGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_CR_IGST is not null then AMOUNT_CR_IGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_PAYCGST is not null then AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when AMOUNT_PAYCGST is not null then AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_PAYIGST is not null then AMOUNT_PAYIGST  else 0 end as abap.dec( 23, 2 ) ) ) as TOTAL_TAX_AMT,

( cast( case when TBA_AMOUNT is not null then TBA_AMOUNT  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_JIC is not null then AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when AMOUNT_JIC is not null then AMOUNT_JIC  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_JII is not null then AMOUNT_JII  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_JIM is not null then AMOUNT_JIM  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when NoCR_CGST is not null then NoCR_CGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when NoCR_SGST is not null then NoCR_SGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_CR_IGST is not null then AMOUNT_CR_IGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_PAYCGST is not null then AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) + 
( cast( case when AMOUNT_PAYCGST is not null then AMOUNT_PAYCGST  else 0 end as abap.dec( 23, 2 ) ) ) +
( cast( case when AMOUNT_PAYIGST is not null then AMOUNT_PAYIGST  else 0 end as abap.dec( 23, 2 ) ) ) as TOTAL_INVOICE_AMT,

AccountingDocCreatedByUser

}
