@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity 3 - Cost Report (C. View)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'COSTRPT' ,
                  typeNamePlural: 'Cost Report'
                   }
@UI.presentationVariant: [{ sortOrder: [{ by: 'GLAccount', direction: #ASC }] }]
define view entity zcds_costrpt_ddl3  
as select distinct from zcds_costrpt_ddl1    as a
left outer join zcds_costrpt_ddl4s as b on a.GLAccount = b.GLAccount and a.FiscalPeriod = b.FiscalPeriod and a.ActType = b.ActType //GL Balance Calc.
left outer join zcds_costrpt_ddl5s as c on a.GLAccount = c.GLAccount and a.FiscalPeriod = c.FiscalPeriod and a.ActType = c.ActType
{
 @UI.lineItem: [{ position: 10 }]
 @UI.selectionField: [{ position: 10 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zcds_costrpt_sh',
     element: 'GLAccount'
 } }]
 key a.GLAccount,
 @UI.lineItem: [{ position: 15 }]
 @UI.selectionField: [{ position: 15 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zcds_costrpt_sh',
     element: 'CostCenter'
 } }] 
 key a.CostCenter,
 @UI.lineItem: [{ position: 20 }]
 @UI.selectionField: [{ position: 20 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zcds_costrpt_sh',
     element: 'FiscalPeriod'
 } }]
 key a.FiscalPeriod,
 
  @UI.lineItem: [{ position: 40 }]
 key a.ManufacturingOrder,
 
//  @UI.lineItem: [{ position: 22 }]
//  @UI.selectionField: [{ position: 22 }]
// $parameters.Fromto as fromDate,
// 
//   @UI.lineItem: [{ position: 23 }]
//  @UI.selectionField: [{ position: 23 }]
// $parameters.endto as endDate,
 
 @UI.lineItem: [{ position: 25, label: 'MO Posting Date' }]
// @UI.selectionField: [{ position: 25 }]
// @Consumption.valueHelpDefinition: [{ entity: {
//     name: 'zcds_costrpt_sh',
//     element: 'MO_POSTINGDATE'
// } }]
 a.MO_POSTINGDATE,
 
  @UI.lineItem: [{ position: 30, label: 'GL Posting Date' }]
// @UI.selectionField: [{ position: 30 }]
// @Consumption.valueHelpDefinition: [{ entity: {
//     name: 'zcds_costrpt_sh',
//     element: 'PostingDate'
// } }]
 a.PostingDate,
 
 @UI.lineItem: [{ position: 35, label: 'Activity Type' }]
 a.ActType,
 //a.GLAccountName,

 //a.CostCenterName,
 @UI.hidden: true
 a.CompanyCodeCurrency,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 @UI.lineItem: [{ position: 45, label: 'G/L Amount' }]
 a.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,
 @UI.lineItem: [{ position: 50 }] 
 a.GLAccountName,
 //a.ActType,
 @UI.lineItem: [{ position: 55, label: 'Activity Name' }]  
 a.CostCtrActivityTypeName,
 @UI.lineItem: [{ position: 60, label: 'Activity Unit' }] 
 //@UI.hidden: true
 case a.OpWorkQuantityUnit
 when 'LE' then 'AU' when 'STD' then 'HR' when 'ST' then 'HR' when 'L' then 'LTR' else a.OpWorkQuantityUnit 
 end as OpWorkQuantityUnit,
 //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit' 
 @UI.lineItem: [{ position: 65, label: 'Activity Value' }]
 cast(a.act as abap.dec( 23, 3 )) as act,
 @UI.lineItem: [{ position: 70, label: 'Activity Rate' }] 
 //cast( (get_numeric_value(b.AmountInCompanyCodeCurrency) / c.act) as abap.dec( 23, 2 )) as act_rate,
 cast( cast(b.AmountInCompanyCodeCurrency as abap.dec(23,3)) / c.act as abap.dec( 23, 3 )) as act_rate,
 @UI.lineItem: [{ position: 75, label: 'Activity Amt.' }] 
 //cast( (a.act * sum(get_numeric_value(b.AmountInCompanyCodeCurrency))) / a.act as abap.dec( 23, 2 ) ) as act_val,
 cast( (a.act * cast(b.AmountInCompanyCodeCurrency as abap.dec(23,3)) / c.act) as abap.dec( 23, 3 ) ) as act_val,
 @UI.lineItem: [{ position: 80, label: 'Production Cost Centre' }] 
 a.Prdcc,
 @UI.lineItem: [{ position: 85 }] 
 a.WorkCenter,
 @UI.lineItem: [{ position: 90 }] 
 a.WorkCenterText,
 @UI.lineItem: [{ position: 95 }]
// a.ManufacturingOrder,
 a.CostCenterName,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 @UI.lineItem: [{ position: 100, label: 'Consolidated G/L Amt.' }] 
 b.AmountInCompanyCodeCurrency as cons_glamt,
 @UI.lineItem: [{ position: 105 }] 
 a.WorkCenterInternalID,
 //@Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
 @UI.lineItem: [{ position: 110, label: 'Consolidated Activity Amt.' }]
 c.act as tot_act,
 @UI.lineItem: [{ position: 115 }] 
 a.ProfitCenter,
 @UI.lineItem: [{ position: 120 }] 
 a.FiscalYear
}

group by a.GLAccount,a.CostCenter,a.FiscalPeriod,a.MO_POSTINGDATE,a.PostingDate,a.ActType,a.ManufacturingOrder,a.CompanyCodeCurrency,
a.AmountInCompanyCodeCurrency,a.GLAccountName,a.CostCtrActivityTypeName,a.OpWorkQuantityUnit,a.act,a.Prdcc,a.WorkCenter,
a.WorkCenterText,a.CostCenterName,a.WorkCenterInternalID,b.AmountInCompanyCodeCurrency,c.act,a.ProfitCenter,a.FiscalYear

