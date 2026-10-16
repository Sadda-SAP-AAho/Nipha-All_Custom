@AbapCatalog.sqlViewName: 'ZGSTR2PER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_FORPERCENT'
define view ZGSTR2_FORPERCENT as select from    ZGSTR2_BEFORE_FINAL                        
{
key CompanyCode,
key FiscalYear,
key AccountingDocument,
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
Material,
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
//NoCR_CGST,
//NoCR_SGST,
AMOUNT_CR_IGST,
GLACCOUNTS,
GLAccountLongName,
TOTAL_RCM_PAYABLE,
AMT_NOCRRE_TBACSI,
AMT_CR_CGST,
BUSINESS_PLACE_GSTIN,
OriginalReferenceDocument, 
Plant,
PLANTNAME,
TCS_AMOUNT,


case when AccountingDocumentType = 'RE'  then 
case when  TaxCode = 'BA' or TaxCode = 'BB' or TaxCode = 'BC' or TaxCode = 'BD' or
           TaxCode = 'BI' or TaxCode = 'BJ' or TaxCode = 'BK' or TaxCode = 'BL' then
AMT_NOCRRE_TBACSI when TaxCode = 'DA' or TaxCode = 'DB' or TaxCode = 'DC' or TaxCode = 'DD' or
                         TaxCode = 'DI' or TaxCode = 'DJ' or TaxCode = 'DK' or TaxCode = 'DL' then
AMLOUNT_RCM_TBA else TAX_BASE_AMOUNT end 

when AccountingDocumentType = 'KR' or AccountingDocumentType = 'KG' or AccountingDocumentType = 'SA' then
case when  TaxCode = 'BA' or TaxCode = 'BB' or TaxCode = 'BC' or TaxCode = 'BD' or 
           TaxCode = 'BI' or TaxCode = 'BJ' or TaxCode = 'BK' or TaxCode = 'BL'  then
AMLOUNT_NOCR_TBA when TaxCode = 'DA' or TaxCode = 'DB' or TaxCode = 'DC' or TaxCode = 'DD' or
                         TaxCode = 'DI' or TaxCode = 'DJ' or TaxCode = 'DK' or TaxCode = 'DL' then
AMLOUNT_RCM_TBA else TAX_BASE_AMOUNT end end  as TBA_AMOUNT,


case when AccountingDocumentType = 'RE' then
cast ( AMOUNT_CRRE_CGST as  abap.dec( 23, 2 ) ) else cast( AMT_CR_CGST as abap.dec( 23, 2 ) ) end as NoCR_CGST,

case when AccountingDocumentType = 'RE' then
cast ( AMOUNT_CRRE_CGST as  abap.dec( 23, 2 ) ) else cast( AMT_CR_CGST as abap.dec( 23, 2 ) ) end as NoCR_SGST,

AccountingDocCreatedByUser

}
