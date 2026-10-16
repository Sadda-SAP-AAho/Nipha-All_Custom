@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - FI PP Cost Centre 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_fipp_cc2 as select distinct from I_OperationalAcctgDocItem as a
{
 cast( '300301A001' as abap.char( 10 ) ) as comm_cc2,
 a.CostCenter as fi_cc,
 case a.CostCenter
 when '300302A002' then cast('300302P002' as abap.char( 10 ))
 when '300302A003' then cast('300302P003' as abap.char( 10 ))
 when '300302A004' then cast('300302P004' as abap.char( 10 ))
 when '300302A005' then cast('300302P005' as abap.char( 10 ))
 when '300302A006' then cast('300302P006' as abap.char( 10 ))
 when '300302A007' then cast('300302P007' as abap.char( 10 ))
 when '300302A008' then cast('300302P008' as abap.char( 10 ))
 when '300302A009' then cast('300302P009' as abap.char( 10 ))
 when '300302A010' then cast('300302P010' as abap.char( 10 ))
 when '300302A011' then cast('300302P011' as abap.char( 10 ))
 when '300302A012' then cast('300302P012' as abap.char( 10 ))
 when '300302A013' then cast('300302P013' as abap.char( 10 ))
 when '300302A014' then cast('300302P014' as abap.char( 10 ))
 when '300302A015' then cast('300302P015' as abap.char( 10 ))
 when '300302A016' then cast('300302P016' as abap.char( 10 ))
 when '300302A017' then cast('300302P017' as abap.char( 10 ))
 when '300302A018' then cast('300302P018' as abap.char( 10 ))
 when '300302A019' then cast('300302P019' as abap.char( 10 ))
 when '300302A020' then cast('300302P020' as abap.char( 10 ))
 when '300302A021' then cast('300302P021' as abap.char( 10 ))
 when '300302A022' then cast('300302P022' as abap.char( 10 ))
 when '300302A023' then cast('300302P023' as abap.char( 10 ))
 when '300302A024' then cast('300302P024' as abap.char( 10 ))
 when '300302A025' then cast('300302P025' as abap.char( 10 ))
 when '300302A026' then cast('300302P026' as abap.char( 10 )) else cast('' as abap.char( 10 )) end as pp_cc
 
}
where ( a.CostCenter = '300302A002' or a.CostCenter = '300302A003'  or a.CostCenter = '300302A004' or
        a.CostCenter = '300302A005' or a.CostCenter = '300302A006'  or a.CostCenter = '300302A007' or 
        a.CostCenter = '300302A008' or a.CostCenter = '300302A009'  or a.CostCenter = '300302A010' or
        a.CostCenter = '300302A008' or a.CostCenter = '300302A009'  or a.CostCenter = '300302A010' or
        a.CostCenter = '300302A011' or a.CostCenter = '300302A012'  or a.CostCenter = '300302A013' or
        a.CostCenter = '300302A014' or a.CostCenter = '300302A015'  or a.CostCenter = '300302A016' or
        a.CostCenter = '300302A017' or a.CostCenter = '300302A018'  or a.CostCenter = '300302A019' or
        a.CostCenter = '300302A020' or a.CostCenter = '300302A021'  or a.CostCenter = '300302A022' or
        a.CostCenter = '300302A023' or a.CostCenter = '300302A024'  or a.CostCenter = '300302A025' or
        a.CostCenter = '300302A026'
        )
        
union all 

select distinct from I_OperationalAcctgDocItem as a
{
 cast( '300301A001' as abap.char( 10 ) ) as comm_cc2,
 a.CostCenter as fi_cc,
 case a.CostCenter
 when '300303A002' then cast('300303P002' as abap.char( 10 ))
 when '300303A003' then cast('300303P003' as abap.char( 10 ))
 when '300303A004' then cast('300303P004' as abap.char( 10 ))
 when '300303A005' then cast('300303P005' as abap.char( 10 ))
 when '300303A006' then cast('300303P006' as abap.char( 10 ))
 when '300303A007' then cast('300303P007' as abap.char( 10 ))
 when '300303A008' then cast('300303P008' as abap.char( 10 ))
 when '300303A009' then cast('300303P009' as abap.char( 10 ))
 when '300303A010' then cast('300303P010' as abap.char( 10 ))
 when '300303A011' then cast('300303P011' as abap.char( 10 ))
 when '300303A012' then cast('300303P012' as abap.char( 10 ))
 when '300303A013' then cast('300303P013' as abap.char( 10 ))
 when '300303A014' then cast('300303P014' as abap.char( 10 ))
 when '300303A015' then cast('300303P015' as abap.char( 10 ))
 when '300303A016' then cast('300303P016' as abap.char( 10 ))
 when '300303A017' then cast('300303P017' as abap.char( 10 )) else cast('' as abap.char( 10 )) end as pp_cc 
 
}
where ( a.CostCenter = '300303A002' or a.CostCenter = '300303A003'  or a.CostCenter = '300303A004' or
        a.CostCenter = '300303A005' or a.CostCenter = '300303A006'  or a.CostCenter = '300303A007' or 
        a.CostCenter = '300303A008' or a.CostCenter = '300303A009'  or a.CostCenter = '300303A010' or
        a.CostCenter = '300303A008' or a.CostCenter = '300303A009'  or a.CostCenter = '300303A010' or
        a.CostCenter = '300303A011' or a.CostCenter = '300303A012'  or a.CostCenter = '300303A013' or
        a.CostCenter = '300303A014' or a.CostCenter = '300303A015'  or a.CostCenter = '300303A016' or
        a.CostCenter = '300303A017' 
        )
        
union all 

select distinct from I_OperationalAcctgDocItem as a
{
 cast( '300301A001' as abap.char( 10 ) ) as comm_cc2,
 a.CostCenter as fi_cc,
 case a.CostCenter
 when '300304A002' then cast('300304P002' as abap.char( 10 ))
 when '300304A003' then cast('300304P003' as abap.char( 10 )) else cast('' as abap.char( 10 )) end as pp_cc
   
}
where ( a.CostCenter = '300304A002' or a.CostCenter = '300304A003'
        )
