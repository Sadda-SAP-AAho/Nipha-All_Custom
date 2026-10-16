@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Cost Report ZCOSTRPT_DDL11'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZCOSTRPT_DDL11
with parameters  
    P_StartDate : vdm_v_start_date,
    P_EndDate   : vdm_v_end_date
as select from zcostrpt_ddl1( 
        P_StartDate: $parameters.P_StartDate, 
        P_EndDate: $parameters.P_EndDate 
    ) as b
    left outer join ZCost_Reverse as a 
        on a.AccountingDocument = b.AccountingDocument
{
  b.GLAccount,
  b.GLAccountName,
  b.CostCenter,
  b.CostCenterName,
  b.AccountingDocument,
  b.FiscalYear,
  b.FiscalPeriod,
  b.PostingDate,
  b.CompanyCodeCurrency,  
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  b.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  b.totAmountInCompanyCodeCurrency,
  b.prdcc,
  b.ActType,
  b.CostCtrActivityTypeName,
  b.ActCat, 
  b.WorkCenterInternalID,
  b.WorkCenter,
  b.WorkCenterText,
  b.ManufacturingOrder,
  b.ProfitCenter,
  b.MO_POSTINGDATE,
  b.OpWorkQuantityUnit,
  @Semantics.quantity.unitOfMeasure: 'OpWorkQuantityUnit'
  b.act
}
where 
b.MO_POSTINGDATE >= $parameters.P_StartDate
and b.MO_POSTINGDATE  <= $parameters.P_EndDate
and a.AccountingDocument is null
//    b.PostingDate >= $parameters.P_StartDate
//    and b.PostingDate <= $parameters.P_EndDate
//    and a.AccountingDocument is null

