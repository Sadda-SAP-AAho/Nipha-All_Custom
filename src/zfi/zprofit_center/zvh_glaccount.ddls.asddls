@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for GL Account Search help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVH_GLACCOUNT 
as select from I_GLAccount as a
left outer join I_GLAccountText as b on b.GLAccount = a.GLAccount
{
  key a.GLAccount,
     b.GLAccountLongName  
}
