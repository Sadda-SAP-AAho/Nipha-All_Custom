@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity 1 - Cost Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_costrpt_ddl1 as select from I_OperationalAcctgDocItem as a
left outer join I_GLAccountText as b on a.GLAccount = b.GLAccount and a.ChartOfAccounts = b.ChartOfAccounts and b.Language = 'E'
left outer join I_CostCenterText as c on a.CostCenter = c.CostCenter and a.ControllingArea = c.ControllingArea and c.Language = 'E'
inner join ZR_FIPPMAP as d on (a.CostCenter = d.Commcc1 and a.GLAccount = d.Gl) 
or (a.CostCenter = d.Commcc2 and a.GLAccount = d.Gl) or (a.CostCenter = d.Deptcc and a.GLAccount = d.Gl)
inner join zcds_costrpt_ddl2 as e on d.Prdcc = e.CostCenter  and e.ManufacturingOrder <> '' 
left outer join I_CostCenterActivityTypeText as f on d.ActType = f.CostCtrActivityType and f.Language = 'E'
//Check activity type 
inner join I_WorkCenterCostCenter as g on e.WorkCenterInternalID = g.WorkCenterInternalID and d.Prdcc = g.CostCenter
and g.CostCtrActivityType = d.ActType
left outer join I_MfgOrderConfirmation as H on H.ManufacturingOrder = e.ManufacturingOrder 
//Check activity type 
{
  a.GLAccount,
  b.GLAccountName,
  a.CostCenter,
  c.CostCenterName,
  a.FiscalYear,
  a.FiscalPeriod,
  a.PostingDate,
  a.CompanyCodeCurrency as CompanyCodeCurrency,  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  a.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,
  d.Prdcc,
  d.ActType,
  f.CostCtrActivityTypeName,
  d.ActCat, 
  e.WorkCenterInternalID,
  e.WorkCenter,
  e.WorkCenterText,
  e.ManufacturingOrder,
  e.ProfitCenter,
  H.PostingDate as MO_POSTINGDATE,
  case d.ActCat
  when 'ACT1' then e.OpWorkQuantityUnit1
  when 'ACT2' then e.OpWorkQuantityUnit2
  when 'ACT3' then e.OpWorkQuantityUnit3
  when 'ACT4' then e.OpWorkQuantityUnit4
  when 'ACT5' then e.OpWorkQuantityUnit5
  when 'ACT6' then e.OpWorkQuantityUnit6
  end as OpWorkQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
  case d.ActCat
  when 'ACT1' then e.act1
  when 'ACT2' then e.act2
  when 'ACT3' then e.act3
  when 'ACT4' then e.act4
  when 'ACT5' then e.act5
  when 'ACT6' then e.act6
  end as act
  //d.CostCenter as prd_cc,
  //d.WorkCenterInternalID,
  //d.WorkCenter,
  //d.WorkCenterText,
  //d.ManufacturingOrder,  
  //d.OpWorkQuantityUnit1,
  //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit1'
  //d.act1,
  //d.OpWorkQuantityUnit2,
  //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit2'
  //d.act2,
  //d.OpWorkQuantityUnit3,
  //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit3'
  //d.act3,
  //d.OpWorkQuantityUnit4,
  //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit4'
  //d.act4, 
  //d.OpWorkQuantityUnit5,
  //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit5'
  //d.act5,
  //d.OpWorkQuantityUnit6,
  //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit6'
  //d.act6
}
//where ( a.GLAccount = '0048000110' or a.GLAccount = '0040000020' or a.GLAccount = '0045000900' 
//     or a.GLAccount = '0045000940' or a.GLAccount = '0045000910' or a.GLAccount = '0043000010' ) 
where a.CostCenter <> '' 
//     and ( a.CostCenter = '300202A002' or a.CostCenter = '300202A003' or a.CostCenter = '300202A004' or a.CostCenter = '300202A005'
//     or a.CostCenter = '300202A006' or a.CostCenter = '300202A007' or a.CostCenter = '300202A009' or a.CostCenter = '300202A010'
//     or a.CostCenter = '300202A011' or a.CostCenter = '300202A012' or a.CostCenter = '300202A013' or a.CostCenter = '300202A014'
//     or a.CostCenter = '300202A015' or a.CostCenter = '300202A016' or a.CostCenter = '300202A017' or a.CostCenter = '300202A018'
//     or a.CostCenter = '300202A019' or a.CostCenter = '300202A020' or a.CostCenter = '300202A021' or a.CostCenter = '300202A022'
//     or a.CostCenter = '300202A023' or a.CostCenter = '300202A024' or a.CostCenter = '300202A025' or a.CostCenter = '300202A026'
//     or a.CostCenter = '600102A002' or a.CostCenter = '600102A003' or a.CostCenter = '600102A004' or a.CostCenter = '600102A005'
//     or a.CostCenter = '600102A006' or a.CostCenter = '600102A007' or a.CostCenter = '600102A008' or a.CostCenter = '600102A009'
//     or a.CostCenter = '600102A010' or a.CostCenter = '600102A011' or a.CostCenter = '600102A012' or a.CostCenter = '600102A013'
//     or a.CostCenter = '600102A014' or a.CostCenter = '600102A015' or a.CostCenter = '600102A016' or a.CostCenter = '600102A017'
//     or a.CostCenter = '600102A018' or a.CostCenter = '600102A019' or a.CostCenter = '600102A020' or a.CostCenter = '600102A021'
//     or a.CostCenter = '600102A022' or a.CostCenter = '600102A023' or a.CostCenter = '600102A024' or a.CostCenter = '600102A025'
//     or a.CostCenter = '600102A027' or a.CostCenter = '600102A028' or a.CostCenter = '600102A029' or a.CostCenter = '600102A030'
//     or a.CostCenter = '600102A031' or a.CostCenter = '600102A032' or a.CostCenter = '600102A033' or a.CostCenter = '600102A034'
//     or a.CostCenter = '600102A035' or a.CostCenter = '500101A002' or a.CostCenter = '500101A003' or a.CostCenter = '500101A004'
//     or a.CostCenter = '500101A005' or a.CostCenter = '500101A006' or a.CostCenter = '500101A007' or a.CostCenter = '500101A009'
//     or a.CostCenter = '500101A010' or a.CostCenter = '500101A011' or a.CostCenter = '500101A012' or a.CostCenter = '500101A013'
//     or a.CostCenter = '200102A002' or a.CostCenter = '200102A003' or a.CostCenter = '200102A004' or a.CostCenter = '200102A005'
//     or a.CostCenter = '200102A006' or a.CostCenter = '200102A007' or a.CostCenter = '200102A008' or a.CostCenter = '200102A009'
//     or a.CostCenter = '200102A010' or a.CostCenter = '200102A011' or a.CostCenter = '200102A012' or a.CostCenter = '200102A013'
//     or a.CostCenter = '200102A014' or a.CostCenter = '200102A020' or a.CostCenter = '200102A022' or a.CostCenter = '200102A023'
//     or a.CostCenter = '200102A024' or a.CostCenter = '200102A025' or a.CostCenter = '400102A002' or a.CostCenter = '400102A003'
//     or a.CostCenter = '400102A004' or a.CostCenter = '400102A005' or a.CostCenter = '400102A006' or a.CostCenter = '400102A007'
//     or a.CostCenter = '400102A008' or a.CostCenter = '400102A009' or a.CostCenter = '400102A010' or a.CostCenter = '400102A011'
//     or a.CostCenter = '400102A012' or a.CostCenter = '400102A013' or a.CostCenter = '400102A014' or a.CostCenter = '400102A015'
//     or a.CostCenter = '400102A016' or a.CostCenter = '400102A017' or a.CostCenter = '300203A002' or a.CostCenter = '300302A027'
//     or a.CostCenter = '300303A011' or a.CostCenter = '300304A004' or a.CostCenter = '300401A014' or a.CostCenter = '300405A004'
//     or a.CostCenter = '300401A014' or a.CostCenter = '300405A004' or a.CostCenter = '600102A013' or a.CostCenter = '600103A018'
//     or a.CostCenter = '600104A036' or a.CostCenter = '600105A011' or a.CostCenter = '600106A007' or a.CostCenter = '500101A014'
//     or a.CostCenter = '500105A004' or a.CostCenter = '200102A026' or a.CostCenter = '200103A002' or a.CostCenter = '200104A002'
//     or a.CostCenter = '400102A018' or a.CostCenter = '400103A002' or a.CostCenter = '400104A004' or a.CostCenter = '300201A001'
//     or a.CostCenter = '300301A001' or a.CostCenter = '300401A001' or a.CostCenter = '600101A001' or a.CostCenter = '500101A001'
//     or a.CostCenter = '200101A001' or a.CostCenter = '400101A001' or a.CostCenter = '300302A002' or a.CostCenter = '300302A003' 
//     or a.CostCenter = '300303A020' )
//group by a.GLAccount,b.GLAccountName,a.CostCenter,c.CostCenterName,d.WorkCenter,d.WorkCenterText,d.ManufacturingOrder,
//         a.FiscalPeriod,a.PostingDate,a.CompanyCodeCurrency,
//         a.CompanyCodeCurrency,d.OpWorkQuantityUnit1,d.act1,d.act2,d.act3,d.act4,d.act5,d.act6,d.CostCenter,
//         d.OpWorkQuantityUnit2,d.OpWorkQuantityUnit3,d.OpWorkQuantityUnit4,d.OpWorkQuantityUnit5,d.OpWorkQuantityUnit6,
//         g.ActType,h.CostCtrActivityTypeName,g.ActCat,
//         e.ActType,f.ActType,g.ActType,e.ActCat,f.ActCat,g.ActCat,e.Deptcc,f.Deptcc,g.Deptcc
//         ,g.Deptcc
        
