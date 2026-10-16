@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help : FI Cost Centre with G/L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_ficc_sh as select distinct from I_OperationalAcctgDocItem as a
left outer join I_CostCenterText as c on a.CostCenter = c.CostCenter and a.ControllingArea = c.ControllingArea and c.Language = 'E'
left outer join I_GLAccountText as b on a.GLAccount = b.GLAccount and a.ChartOfAccounts = b.ChartOfAccounts and b.Language = 'E'
{
  key a.CostCenter,
  key a.GLAccount,
      b.GLAccountName,
      c.CostCenterName
}
where a.CostCenter <> ''
