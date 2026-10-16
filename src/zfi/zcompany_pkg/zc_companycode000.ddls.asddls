@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZCOMPANYCODE000'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_COMPANYCODE000
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_COMPANYCODE000
  association [1..1] to ZR_COMPANYCODE000 as _BaseEntity on $projection.COMPANYCODE = _BaseEntity.COMPANYCODE
{
  key CompanyCode,
  CompanyName,
  Address,
  Cin,
  Pan,
  GstNo,
  Fssai,
  RegNo,
  Remark1,
  Remark2,
  Remark3,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LocalLastChangedAt,
  _BaseEntity
}
