@EndUserText.label: 'DATABASE FOR BANK DETAILS'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DatabaseForBankDeta
  as select from ZDT_BNKDETLS
  association to parent ZI_DatabaseForBankDeta_S as _DatabaseForBankDAll on $projection.SingletonID = _DatabaseForBankDAll.SingletonID
{
  key ACCOUNTNO as Accountno,
  key IFSC as Ifsc,
  BANKDETAILS as Bankdetails,
  MICR as Micr,
  RTGS as Rtgs,
  @Semantics.user.createdBy: true
  CREATED_BY as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CREATED_AT as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  @Consumption.hidden: true
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _DatabaseForBankDAll
}
