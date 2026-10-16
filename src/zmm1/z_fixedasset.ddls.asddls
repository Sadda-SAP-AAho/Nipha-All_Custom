@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Asset Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_FIXEDASSET as select from I_FixedAsset as a left outer join I_MasterFixedAsset as b on
   a.CompanyCode = b.CompanyCode and a.MasterFixedAsset = b.MasterFixedAsset
{
    key a.CompanyCode,
    key a.MasterFixedAsset,
    key a.FixedAsset,
        a.AssetClass,
        b.MasterFixedAssetDescription
}
group by 
        a.CompanyCode,
        a.MasterFixedAsset,
        a.FixedAsset,
        a.AssetClass,
        b.MasterFixedAssetDescription
