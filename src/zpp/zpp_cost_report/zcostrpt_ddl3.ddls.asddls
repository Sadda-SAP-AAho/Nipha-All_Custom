@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Report DDL3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcostrpt_ddl3
with parameters
     P_StartDate : vdm_v_start_date ,
     P_EndDate   : vdm_v_end_date   
 as select from ZCOSTRPT_DDL11( P_StartDate:$parameters.P_StartDate , P_EndDate: $parameters.P_EndDate ) as a
 left outer join Ztot_actvalue( P_StartDate:$parameters.P_StartDate , P_EndDate:$parameters.P_EndDate  ) as b on
                              a.GLAccount = b.GLAccount and a.FiscalPeriod = b.FiscalPeriod and a.FiscalYear = b.FiscalYear
//                            a.ActType = b.ActType and a.MO_POSTINGDATE = b.MO_POSTINGDATE and a.ActCat = b.ActCat
{
 @UI.lineItem: [{ position: 35 }]             //...................
 @UI.selectionField: [{ position: 35 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zcostrpt_sh' , //'zcds_costrpt_sh',
     element: 'GLAccount'
 } }]
 key a.GLAccount, 
 @UI.lineItem: [{ position: 55 }]              //----------------------
 @UI.selectionField: [{ position: 55 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zcostrpt_sh', //'zcds_costrpt_sh',
     element: 'CostCenter'
 } }] 
 key a.CostCenter,
 @UI.lineItem: [{ position: 10 }]        //...................
 @UI.selectionField: [{ position: 10 }]
 @Consumption.valueHelpDefinition: [{ entity: {
     name: 'zcostrpt_sh',   //'zcds_costrpt_sh',
     element: 'FiscalPeriod'
 } }]
 key a.FiscalPeriod,

 
  @UI.lineItem: [{ position: 30 , label: 'Manufacturing Order'}]              //...................
 key a.ManufacturingOrder,
 
  @UI.lineItem: [{ position: 65, label: 'Activity Type' }]   //-------------
  key a.ActType,
 
 @UI.lineItem: [{ position: 90, label: 'Activity HR (Actual)' }]  //'Activity Value' //----------------
 key cast(a.act as abap.dec( 23, 3 )) as act,
 
   @UI.lineItem: [{ position: 15 , label: 'Fiscal Year'}]    //................... 
 a.FiscalYear,

 @UI.lineItem: [{ position: 20, label: 'MO Posting Date' }]   //...................
 a.MO_POSTINGDATE,
 
  @UI.lineItem: [{ position: 25, label: 'GL Posting Date' }]  //...................
 a.PostingDate,
 

 @UI.hidden: true
 a.CompanyCodeCurrency,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 @UI.lineItem: [{ position: 45, label: 'G/L Amount' }]               //-----------
 a.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,
 @UI.lineItem: [{ position: 40, label: 'G/L Account Name'  }]     //---------------
 a.GLAccountName,

 @UI.lineItem: [{ position: 70, label: 'Activity Name' }]  ///------------------
 a.CostCtrActivityTypeName,
 @UI.lineItem: [{ position: 95, label: 'Activity Unit' }]   //---------------
 //@UI.hidden: true
 case a.OpWorkQuantityUnit
 when 'LE' then 'AU' when 'STD' then 'HR' when 'ST' then 'HR' when 'L' then 'LTR' else a.OpWorkQuantityUnit 
 end as OpWorkQuantityUnit,
// @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit' 
// @UI.lineItem: [{ position: 90, label: 'Activity HR (Actual)' }]  //'Activity Value' //----------------
// cast(a.act as abap.dec( 23, 3 )) as act,
 @UI.lineItem: [{ position: 85, label: 'Activity Rate (Actual)' }]   //'Activity Rate'   //-----------------  //11.08.25
// //cast( (get_numeric_value(b.AmountInCompanyCodeCurrency) / c.act) as abap.dec( 23, 2 )) as act_rate,
 case when a.totAmountInCompanyCodeCurrency <> 0  and b.act <> 0 then 
 cast( cast(a.totAmountInCompanyCodeCurrency as abap.dec(23,3)) / b.act as abap.dec( 23, 3 )) end as act_rate,       //11.08.25
 @UI.lineItem: [{ position: 100, label: 'Activity Amt. (Actual)' }]    //'Activity Amt.'  //---------------   //11.08.25
// //cast( (a.act * sum(get_numeric_value(b.AmountInCompanyCodeCurrency))) / a.act as abap.dec( 23, 2 ) ) as act_val,
//// cast( (a.act * cast(a.AmountInCompanyCodeCurrency as abap.dec(23,3)) / b.act) as abap.dec( 23, 3 ) ) as act_val, //11.08.25
case when a.totAmountInCompanyCodeCurrency <> 0  and b.act <> 0 and a.act <> 0 then 
// cast( (b.act * cast(a.AmountInCompanyCodeCurrency as abap.dec(23,3)) / b.act ) as abap.dec( 23, 3 ) ) end as act_val, //11.08.25
 cast(cast( cast(a.totAmountInCompanyCodeCurrency as abap.dec(23,3)) / b.act as abap.dec( 23, 3 ))   
 * a.act as abap.dec( 23,3 )) end as act_val,
 @UI.lineItem: [{ position: 105, label: 'Production Cost Centre' }]  //------------------
 a.prdcc,
 @UI.lineItem: [{ position: 110, label: 'Work Centre' }]  //-------------
 a.WorkCenter,
 @UI.lineItem: [{ position: 115, label: 'Work Center Text' }]   //-------------
 a.WorkCenterText,
 @UI.lineItem: [{ position: 125 }]
// a.ManufacturingOrder,
 a.CostCenterName,
 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 @UI.lineItem: [{ position: 75, label: 'G/L Amt Posted by Finance/Month' } ] //'Consolidated G/L Amt.' }] //--------------
// a.AmountInCompanyCodeCurrency as cons_glamt,
 a.totAmountInCompanyCodeCurrency,
 @UI.lineItem: [{ position: 120, label: 'Object ID' }]   //-------------
 a.WorkCenterInternalID,
// @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
 @UI.lineItem: [{ position: 80, label: 'Consolidated Activity Amt./Month' }]   //--------------------
 cast(b.act as abap.dec(23,3)) as tot_act,        // 11.08.25
// b.act as tot_act,
 @UI.lineItem: [{ position: 50 }]    //--------------
 a.ProfitCenter
 
}

group by a.GLAccount,a.CostCenter,a.FiscalPeriod,a.PostingDate,a.MO_POSTINGDATE,a.ActType,a.ManufacturingOrder,a.CompanyCodeCurrency,
a.AmountInCompanyCodeCurrency,a.GLAccountName,a.CostCtrActivityTypeName,a.OpWorkQuantityUnit,a.act,a.prdcc,a.WorkCenter,
a.WorkCenterText,a.CostCenterName,a.WorkCenterInternalID,a.AmountInCompanyCodeCurrency,a.ProfitCenter,a.FiscalYear,b.act,
    a.totAmountInCompanyCodeCurrency

