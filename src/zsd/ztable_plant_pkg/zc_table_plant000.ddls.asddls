@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
//@ObjectModel: {
//  sapObjectNodeType.name: 'ZTABLE_PLANT000'
//}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_TABLE_PLANT000
  provider contract transactional_query
  as projection on ZR_TABLE_PLANT000
  association [1..1] to ZR_TABLE_PLANT000 as _BaseEntity on  $projection.CompCode  = _BaseEntity.CompCode
                                                         and $projection.PlantCode = _BaseEntity.PlantCode
{
  key CompCode,
  key PlantCode,
      CompanyName,
      PlantName1,
      PlantName2,
      Address1,
      Address2,
      Address3,
      City,
      District,
      StateCode1,
      StateCode2,
      StateName,
      Pin,
      Country,
      CinNo,
      GstinNo,
      PanNo,
      TanNo,
      Email,
      FssaiNo,
      MobNo,
      Remark1,
      Remark2,
      Remark3,
      Weightpath,
      WeightpathOut,
      Emailtocustomer,
      Fromemail,
      Ccmails,
      Storagelocation,
      Gspusername,
      Gsppassword,
      Ewbusername,
      Ewbpassword,
      Businessplace,
      @Semantics: {
        user.createdBy: true
      }
      CreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      CreatedAt,
      @Semantics: {
        user.localInstanceLastChangedBy: true
      }
      LocalLastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LastChangedAt,
      _BaseEntity
}
