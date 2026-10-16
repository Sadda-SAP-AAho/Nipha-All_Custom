@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZCOMPANYCODE000'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_COMPANYCODE000
  as select from ZCOMPANYCODE
{
  key company_code as CompanyCode,
  company_name as CompanyName,
  address as Address,
  cin as Cin,
  pan as Pan,
  gst_no as GstNo,
  fssai as Fssai,
  reg_no as RegNo,
  remark1 as Remark1,
  remark2 as Remark2,
  remark3 as Remark3,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
}
