@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@ObjectModel.sapObjectNodeType.name: 'ZTABLE_PLANT000'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_TABLE_PLANT000
  as select from ztable_plant
{
  key comp_code             as CompCode,
  key plant_code            as PlantCode,
      company_name          as CompanyName,
      plant_name1           as PlantName1,
      plant_name2           as PlantName2,
      address1              as Address1,
      address2              as Address2,
      address3              as Address3,
      city                  as City,
      district              as District,
      state_code1           as StateCode1,
      state_code2           as StateCode2,
      state_name            as StateName,
      pin                   as Pin,
      country               as Country,
      cin_no                as CinNo,
      gstin_no              as GstinNo,
      pan_no                as PanNo,
      tan_no                as TanNo,
      email                 as Email,
      fssai_no              as FssaiNo,
      mob_no                as MobNo,
      remark1               as Remark1,
      remark2               as Remark2,
      remark3               as Remark3,
      weightpath            as Weightpath,
      weightpath_out        as WeightpathOut,
      emailtocustomer       as Emailtocustomer,
      fromemail             as Fromemail,
      ccmails               as Ccmails,
      storagelocation       as Storagelocation,
      gspusername           as Gspusername,
      gsppassword           as Gsppassword,
      ewbusername           as Ewbusername,
      ewbpassword           as Ewbpassword,
      businessplace         as Businessplace,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt
}
