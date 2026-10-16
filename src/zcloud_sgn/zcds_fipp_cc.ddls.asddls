@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity - FI PP Cost Centre'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_fipp_cc as select distinct from I_OperationalAcctgDocItem as a
{
 a.CostCenter as fi_cc,
 case a.CostCenter
 when '300202A002' then cast('300202P002' as abap.char( 10 )) 
 when '300202A003' then cast('300202P003' as abap.char( 10 )) 
 when '300202A004' then cast('300202P004' as abap.char( 10 ))  
 when '300202A005' then cast('300202P005' as abap.char( 10 )) 
 when '300202A006' then cast('300202P006' as abap.char( 10 )) 
 when '300202A007' then cast('300202P007' as abap.char( 10 )) 
 when '300202A008' then cast('300202P008' as abap.char( 10 )) 
 when '300202A009' then cast('300202P009' as abap.char( 10 )) 
 when '300202A010' then cast('300202P010' as abap.char( 10 )) 
 when '300202A011' then cast('300202P011' as abap.char( 10 )) 
 when '300202A012' then cast('300202P012' as abap.char( 10 )) 
 when '300202A013' then cast('300202P013' as abap.char( 10 ))
 when '300202A014' then cast('300202P014' as abap.char( 10 )) 
 when '300202A015' then cast('300202P015' as abap.char( 10 )) 
 when '300202A016' then cast('300202P016' as abap.char( 10 )) 
 when '300202A017' then cast('300202P017' as abap.char( 10 )) 
 when '300202A018' then cast('300202P018' as abap.char( 10 )) 
 when '300202A019' then cast('300202P019' as abap.char( 10 )) 
 when '300202A020' then cast('300202P020' as abap.char( 10 )) 
 when '300202A021' then cast('300202P021' as abap.char( 10 )) 
 when '300202A022' then cast('300202P022' as abap.char( 10 )) 
 when '300202A023' then cast('300202P023' as abap.char( 10 )) 
 when '300202A024' then cast('300202P024' as abap.char( 10 )) 
 when '300202A025' then cast('300202P025' as abap.char( 10 )) 
 when '300202A026' then cast('300202P026' as abap.char( 10 )) 
 when '300302A002' then cast('300302P002' as abap.char( 10 ))
 when '300302A003' then cast('300302P003' as abap.char( 10 ))
 when '600102A002' then cast('600102P002' as abap.char( 10 )) 
 when '600102A003' then cast('600102P003' as abap.char( 10 )) 
 when '600102A004' then cast('600102P004' as abap.char( 10 )) 
 when '600102A005' then cast('600102P005' as abap.char( 10 )) 
 when '600102A006' then cast('600102P006' as abap.char( 10 )) 
 when '600102A007' then cast('600102P007' as abap.char( 10 )) 
 when '600102A008' then cast('600102P008' as abap.char( 10 )) 
 when '600102A009' then cast('600102P009' as abap.char( 10 )) 
 when '600102A010' then cast('600102P010' as abap.char( 10 )) 
 when '600102A011' then cast('600102P011' as abap.char( 10 )) 
 when '600102A012' then cast('600102P012' as abap.char( 10 )) 
 when '600102A013' then cast('600102P013' as abap.char( 10 ))  
 when '600102A014' then cast('600102P014' as abap.char( 10 ))  
 when '600102A015' then cast('600102P015' as abap.char( 10 )) 
 when '600102A016' then cast('600102P016' as abap.char( 10 )) 
 when '600102A017' then cast('600102P017' as abap.char( 10 )) 
 when '600102A018' then cast('600102P018' as abap.char( 10 )) 
 when '600102A019' then cast('600102P019' as abap.char( 10 )) 
 when '600102A020' then cast('600102P020' as abap.char( 10 )) 
 when '600102A021' then cast('600102P021' as abap.char( 10 )) 
 when '600102A022' then cast('600102P022' as abap.char( 10 )) 
 when '600102A023' then cast('600102P023' as abap.char( 10 )) 
 when '600102A024' then cast('600102P024' as abap.char( 10 )) 
 when '600102A025' then cast('600102P025' as abap.char( 10 )) 
 when '600102A026' then cast('600102P026' as abap.char( 10 )) 
 when '600102A027' then cast('600102P027' as abap.char( 10 )) 
 when '600102A028' then cast('600102P028' as abap.char( 10 )) 
 when '600102A029' then cast('600102P029' as abap.char( 10 ))  
 when '600102A030' then cast('600102P030' as abap.char( 10 )) 
 when '600102A031' then cast('600102P031' as abap.char( 10 )) 
 when '600102A032' then cast('600102P032' as abap.char( 10 )) 
 when '600102A033' then cast('600102P033' as abap.char( 10 )) 
 when '600102A034' then cast('600102P034' as abap.char( 10 )) 
 when '600102A035' then cast('600102P035' as abap.char( 10 )) 
 when '500101A002' then cast('500101P002' as abap.char( 10 )) 
 when '500101A003' then cast('500101P003' as abap.char( 10 )) 
 when '500101A004' then cast('500101P004' as abap.char( 10 )) 
 when '500101A005' then cast('500101P005' as abap.char( 10 )) 
 when '500101A006' then cast('500101P006' as abap.char( 10 )) 
 when '500101A007' then cast('500101P007' as abap.char( 10 )) 
 when '500101A008' then cast('500101P008' as abap.char( 10 )) 
 when '500101A009' then cast('500101P009' as abap.char( 10 ))  
 when '500101A010' then cast('500101P010' as abap.char( 10 )) 
 when '500101A011' then cast('500101P011' as abap.char( 10 )) 
 when '500101A012' then cast('500101P012' as abap.char( 10 )) 
 when '500101A013' then cast('500101P013' as abap.char( 10 )) 
 when '200102A002' then cast('200102P002' as abap.char( 10 )) 
 when '200102A003' then cast('200102P003' as abap.char( 10 )) 
 when '200102A004' then cast('200102P004' as abap.char( 10 )) 
 when '200102A005' then cast('200102P005' as abap.char( 10 )) 
 when '200102A006' then cast('200102P006' as abap.char( 10 )) 
 when '200102A007' then cast('200102P007' as abap.char( 10 )) 
 when '200102A008' then cast('200102P008' as abap.char( 10 )) 
 when '200102A009' then cast('200102P009' as abap.char( 10 )) 
 when '200102A010' then cast('200102P010' as abap.char( 10 )) 
 when '200102A011' then cast('200102P011' as abap.char( 10 )) 
 when '200102A012' then cast('200102P012' as abap.char( 10 )) 
 when '200102A013' then cast('200102P013' as abap.char( 10 )) 
 when '200102A014' then cast('200102P014' as abap.char( 10 )) 
 when '200102A020' then cast('200102P020' as abap.char( 10 )) 
 when '200102A022' then cast('200102P022' as abap.char( 10 )) 
 when '200102A023' then cast('200102P023' as abap.char( 10 )) 
 when '200102A024' then cast('200102P024' as abap.char( 10 )) 
 when '200102A025' then cast('200102P025' as abap.char( 10 )) 
 when '400102A002' then cast('400102P002' as abap.char( 10 )) 
 when '400102A003' then cast('400102P003' as abap.char( 10 )) 
 when '400102A004' then cast('400102P004' as abap.char( 10 )) 
 when '400102A005' then cast('400102P005' as abap.char( 10 )) 
 when '400102A006' then cast('400102P006' as abap.char( 10 )) 
 when '400102A007' then cast('400102P007' as abap.char( 10 )) 
 when '400102A008' then cast('400102P008' as abap.char( 10 )) 
 when '400102A009' then cast('400102P009' as abap.char( 10 )) 
 when '400102A010' then cast('400102P010' as abap.char( 10 )) 
 when '400102A011' then cast('400102P011' as abap.char( 10 )) 
 when '400102A012' then cast('400102P012' as abap.char( 10 )) 
 when '400102A013' then cast('400102P013' as abap.char( 10 )) 
 when '400102A014' then cast('400102P014' as abap.char( 10 )) 
 when '400102A015' then cast('400102P015' as abap.char( 10 )) 
 when '400102A016' then cast('400102P016' as abap.char( 10 )) 
 when '400102A017' then cast('400102P017' as abap.char( 10 )) 
 when '300203A002' then cast('300203P002' as abap.char( 10 )) 
 when '300302A027' then cast('300302P027' as abap.char( 10 )) 
 when '300303A011' then cast('300303P011' as abap.char( 10 )) 
 when '300304A004' then cast('300304P004' as abap.char( 10 )) 
 when '300401A014' then cast('300401P014' as abap.char( 10 )) 
 when '300405A004' then cast('300405P004' as abap.char( 10 )) 
 when '600102A013' then cast('600102P013' as abap.char( 10 )) 
 when '600103A018' then cast('600103P018' as abap.char( 10 )) 
 when '600104A036' then cast('600104P036' as abap.char( 10 )) 
 when '600105A011' then cast('600105P011' as abap.char( 10 )) 
 when '600106A007' then cast('600106P007' as abap.char( 10 )) 
 when '500101A014' then cast('500101P014' as abap.char( 10 )) 
 when '500105A004' then cast('500105P004' as abap.char( 10 )) 
 when '200102A026' then cast('200102P026' as abap.char( 10 )) 
 when '200103A002' then cast('200103P002' as abap.char( 10 )) 
 when '400104A004' then cast('400104P004' as abap.char( 10 )) 
 when '300201A001' then cast('300201P001' as abap.char( 10 )) 
 when '300301A001' then cast('300301P001' as abap.char( 10 )) 
 when '300401A001' then cast('300401P001' as abap.char( 10 )) 
 when '500101A001' then cast('500101P001' as abap.char( 10 )) 
 when '200101A001' then cast('200101P001' as abap.char( 10 )) 
 when '400101A001' then '400101P001' else cast('' as abap.char( 10 )) end as pp_cc 
}
where ( a.CostCenter = '300202A002' or a.CostCenter = '300202A003' or a.CostCenter = '300202A004' or a.CostCenter = '300202A005'
     or a.CostCenter = '300202A006' or a.CostCenter = '300202A007' or a.CostCenter = '300202A008' or a.CostCenter = '300202A009' or a.CostCenter = '300202A010'
     or a.CostCenter = '300202A011' or a.CostCenter = '300202A012' or a.CostCenter = '300202A013' or a.CostCenter = '300202A014'
     or a.CostCenter = '300202A015' or a.CostCenter = '300202A016' or a.CostCenter = '300202A017' or a.CostCenter = '300202A018'
     or a.CostCenter = '300202A019' or a.CostCenter = '300202A020' or a.CostCenter = '300202A021' or a.CostCenter = '300202A022'
     or a.CostCenter = '300202A023' or a.CostCenter = '300202A024' or a.CostCenter = '300202A025' or a.CostCenter = '300202A026'
     or a.CostCenter = '600102A002' or a.CostCenter = '600102A003' or a.CostCenter = '600102A004' or a.CostCenter = '600102A005'
     or a.CostCenter = '600102A006' or a.CostCenter = '600102A007' or a.CostCenter = '600102A008' or a.CostCenter = '600102A009'
     or a.CostCenter = '600102A010' or a.CostCenter = '600102A011' or a.CostCenter = '600102A012' or a.CostCenter = '600102A013'
     or a.CostCenter = '600102A014' or a.CostCenter = '600102A015' or a.CostCenter = '600102A016' or a.CostCenter = '600102A017'
     or a.CostCenter = '600102A018' or a.CostCenter = '600102A019' or a.CostCenter = '600102A020' or a.CostCenter = '600102A021'
     or a.CostCenter = '600102A022' or a.CostCenter = '600102A023' or a.CostCenter = '600102A024' or a.CostCenter = '600102A025'
     or a.CostCenter = '600102A027' or a.CostCenter = '600102A028' or a.CostCenter = '600102A029' or a.CostCenter = '600102A030'
     or a.CostCenter = '600102A031' or a.CostCenter = '600102A032' or a.CostCenter = '600102A033' or a.CostCenter = '600102A034'
     or a.CostCenter = '600102A035' or a.CostCenter = '500101A002' or a.CostCenter = '500101A003' or a.CostCenter = '500101A004'
     or a.CostCenter = '500101A005' or a.CostCenter = '500101A006' or a.CostCenter = '500101A007' or a.CostCenter = '500101A009'
     or a.CostCenter = '500101A010' or a.CostCenter = '500101A011' or a.CostCenter = '500101A012' or a.CostCenter = '500101A013'
     or a.CostCenter = '200102A002' or a.CostCenter = '200102A003' or a.CostCenter = '200102A004' or a.CostCenter = '200102A005'
     or a.CostCenter = '200102A006' or a.CostCenter = '200102A007' or a.CostCenter = '200102A008' or a.CostCenter = '200102A009'
     or a.CostCenter = '200102A010' or a.CostCenter = '200102A011' or a.CostCenter = '200102A012' or a.CostCenter = '200102A013'
     or a.CostCenter = '200102A014' or a.CostCenter = '200102A020' or a.CostCenter = '200102A022' or a.CostCenter = '200102A023'
     or a.CostCenter = '200102A024' or a.CostCenter = '200102A025' or a.CostCenter = '400102A002' or a.CostCenter = '400102A003'
     or a.CostCenter = '400102A004' or a.CostCenter = '400102A005' or a.CostCenter = '400102A006' or a.CostCenter = '400102A007'
     or a.CostCenter = '400102A008' or a.CostCenter = '400102A009' or a.CostCenter = '400102A010' or a.CostCenter = '400102A011'
     or a.CostCenter = '400102A012' or a.CostCenter = '400102A013' or a.CostCenter = '400102A014' or a.CostCenter = '400102A015'
     or a.CostCenter = '400102A016' or a.CostCenter = '400102A017' or a.CostCenter = '300203A002' or a.CostCenter = '300302A027'
     or a.CostCenter = '300303A011' or a.CostCenter = '300304A004' or a.CostCenter = '300401A014' or a.CostCenter = '300405A004'
     or a.CostCenter = '300401A014' or a.CostCenter = '300405A004' or a.CostCenter = '600102A013' or a.CostCenter = '600103A018'
     or a.CostCenter = '600104A036' or a.CostCenter = '600105A011' or a.CostCenter = '600106A007' or a.CostCenter = '500101A014'
     or a.CostCenter = '500105A004' or a.CostCenter = '200102A026' or a.CostCenter = '200103A002' or a.CostCenter = '200104A002'
     or a.CostCenter = '400102A018' or a.CostCenter = '400103A002' or a.CostCenter = '400104A004' or a.CostCenter = '300201A001'
     or a.CostCenter = '300301A001' or a.CostCenter = '300401A001' or a.CostCenter = '600101A001' or a.CostCenter = '500101A001'
     or a.CostCenter = '200101A001' or a.CostCenter = '400101A001' or a.CostCenter = '300302A002' or a.CostCenter = '300302A003')
