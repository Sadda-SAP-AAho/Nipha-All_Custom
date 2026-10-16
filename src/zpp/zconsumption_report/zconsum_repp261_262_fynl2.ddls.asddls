@AbapCatalog.sqlViewName: 'YCONREPFYNLL2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCONSUMPTION_REPP'
@Metadata.ignorePropagatedAnnotations: true
define view ZCONSUM_REPP261_262_FYNL2 
//    with parameters 
//    P_StartDate  : vdm_v_start_date ,
//    P_EndDate    : vdm_v_end_date 
    as select from  ZCONSUMPTION_REP_TEST261 as A 
                    left outer join ZCONSUMPTION_REP_TEST262 as b on ( b.ManufacturingOrder = A.ManufacturingOrder and b.Material = A.Material
                                                                      // and b.PostingDate = A.PostingDate
                                                                        )
    
    

{

A.ManufacturingOrder,
A.Material,
A.GoodsMovementType,
'' as PostingDate ,
//A.PostingDate,

( cast( case when A.QuantityInEntryUnit is not null then A.QuantityInEntryUnit  else 0 end as abap.dec( 13, 3 ) ) ) -
( cast( case when b.QuantityInEntryUnit is not null then b.QuantityInEntryUnit  else 0 end as abap.dec( 13, 3 ) ) ) as QuantityInEntryUnit

}

//where ManufacturingOrder2 is null






