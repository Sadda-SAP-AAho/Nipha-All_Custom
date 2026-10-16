@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase reg condation view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPURCHASE_REGISTER_CON as select from I_PurchaseOrderItemAPI01 as a left outer join I_PurOrdItmPricingElementAPI01 as b
on a.PurchaseOrder = b.PurchaseOrder and a.PurchaseOrderItem = b.PurchaseOrderItem 
and ( b.ConditionType = 'ZBCD' or b.ConditionType = 'ZCDB' ) and b.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as c
on a.PurchaseOrder = c.PurchaseOrder and a.PurchaseOrderItem = c.PurchaseOrderItem 
and ( c.ConditionType = 'ZL02' or c.ConditionType = 'ZDC2' )
and c.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as D
on a.PurchaseOrder = D.PurchaseOrder and a.PurchaseOrderItem = D.PurchaseOrderItem and D.ConditionType = 'ZINS' and D.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as E
on a.PurchaseOrder = E.PurchaseOrder and a.PurchaseOrderItem = E.PurchaseOrderItem and E.ConditionType = 'ZPCK' and E.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as F
on a.PurchaseOrder = F.PurchaseOrder and a.PurchaseOrderItem = F.PurchaseOrderItem and F.ConditionType = 'ZFRT' and F.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as G
on a.PurchaseOrder = G.PurchaseOrder and a.PurchaseOrderItem = G.PurchaseOrderItem and G.ConditionType = 'ZCFA' and G.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as H
on a.PurchaseOrder = H.PurchaseOrder and a.PurchaseOrderItem = H.PurchaseOrderItem and H.ConditionType = 'ZOTH' and H.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as I
on a.PurchaseOrder = I.PurchaseOrder and a.PurchaseOrderItem = I.PurchaseOrderItem and I.ConditionType = 'ZFRB' and I.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as J
on a.PurchaseOrder = J.PurchaseOrder and a.PurchaseOrderItem = J.PurchaseOrderItem and J.ConditionType = 'ZSWC' and J.ConditionAmount <> 0
left outer join I_PurOrdItmPricingElementAPI01 as K
on a.PurchaseOrder = K.PurchaseOrder and a.PurchaseOrderItem = K.PurchaseOrderItem and K.ConditionType = 'ZWCS' and K.ConditionAmount <> 0
{
    key a.PurchaseOrder,
    key a.PurchaseOrderItem,
        cast(b.ConditionRateValue as abap.dec( 12, 2 )) as BDC_RATE_Value,
//        b.ConditionRateValue as BDC_RATE_Value,
        b.ConditionCurrency as BDC_CURR,
        @Semantics.amount.currencyCode: 'BDC_CURR'
        b.ConditionAmount as BDC_RATE_AMT,
        cast(b.ConditionAmount as abap.dec( 12, 2 )) as BDC_RATE_AMT1,
        
        cast(c.ConditionRateValue as abap.dec( 12, 2 )) as DIS_IMP_RATE_Value,
//        c.ConditionRateValue as DIS_IMP_RATE_Value,
        c.ConditionCurrency as DIS_IMP_CURR,
//        @Semantics.amount.currencyCode: 'DIS_IMP_CURR'
//        c.ConditionAmount as DIS_IMP_AMT,
        cast(c.ConditionAmount as abap.dec( 15, 2 )) as DIS_IMP_AMT,
        cast(c.ConditionAmount as abap.dec( 15, 2 )) as DIS_IMP_AMT1,
        
        cast(D.ConditionRateValue as abap.dec( 12, 2 )) as INS_RATE_Value,
//        D.ConditionRateValue as INS_RATE_Value,
        D.ConditionCurrency as INS_IMP_CURR,
//        @Semantics.amount.currencyCode: 'INS_IMP_CURR'
//        D.ConditionAmount as INS_IMP_AMT,
        cast(D.ConditionAmount as abap.dec( 15, 2 )) as INS_IMP_AMT,
        
        cast(E.ConditionRateValue as abap.dec( 12, 2 )) as PCK_RATE_Value,
//        E.ConditionRateValue as PCK_RATE_Value,
        E.ConditionCurrency as PCK_IMP_CURR,
 //       @Semantics.amount.currencyCode: 'PCK_IMP_CURR'
//        E.ConditionAmount as PCK_IMP_AMT,
        cast(E.ConditionAmount as abap.dec( 15, 2 )) as PCK_IMP_AMT,
        
        cast(F.ConditionRateValue as abap.dec( 12, 2 )) as FRT_RATE_Value,
//        F.ConditionRateValue as FRT_RATE_Value,
        F.ConditionCurrency as FRT_IMP_CURR,
 //       @Semantics.amount.currencyCode: 'FRT_IMP_CURR'
 //       F.ConditionAmount as FRT_IMP_AMT,
        cast(F.ConditionAmount as abap.dec( 15, 2 )) as FRT_IMP_AMT,
        
        cast(G.ConditionRateValue as abap.dec( 12, 2 )) as CFA_RATE_Value,
//        G.ConditionRateValue as CFA_RATE_Value,
        G.ConditionCurrency as CFA_IMP_CURR,
 //       @Semantics.amount.currencyCode: 'CFA_IMP_CURR'
 //       G.ConditionAmount as CFA_IMP_AMT,
        cast(G.ConditionAmount as abap.dec( 15, 2 )) as CFA_IMP_AMT,
        
        cast(H.ConditionRateValue as abap.dec( 12, 2 )) as OTH_RATE_Value,
//        H.ConditionRateValue as OTH_RATE_Value,
        H.ConditionCurrency as OTH_IMP_CURR,
//        @Semantics.amount.currencyCode: 'OTH_IMP_CURR'
//        H.ConditionAmount as OTH_IMP_AMT,
        cast(H.ConditionAmount as abap.dec( 15, 2 )) as OTH_IMP_AMT,
        
        cast(I.ConditionRateValue as abap.dec( 12, 2 )) as FRB_IMP_value,
//        I.ConditionRateValue as OTH_RATE_Value,
        I.ConditionCurrency as FRB_IMP_CURR,
 //       @Semantics.amount.currencyCode: 'FRB_IMP_CURR'
 //       I.ConditionAmount as FRB_IMP_AMT,
        cast(I.ConditionAmount as abap.dec( 15, 2 )) as FRB_IMP_AMT,
        
       cast(J.ConditionRateValue as abap.dec( 12, 2 )) as SWC_VALUE,
//        I.ConditionRateValue as OTH_RATE_Value,
        J.ConditionCurrency as SWC_CURR,
        @Semantics.amount.currencyCode: 'SWC_CURR'
        J.ConditionAmount as SWC_AMT,
        cast(J.ConditionAmount as abap.dec( 15, 2 )) as SWC_AMT1,
        
        cast(K.ConditionRateValue as abap.dec( 12, 2 )) as WCS_VALUE,
//        I.ConditionRateValue as OTH_RATE_Value,
        K.ConditionCurrency as WCS_CURR,
        @Semantics.amount.currencyCode: 'WCS_CURR'
        K.ConditionAmount as WCS_AMT,
        cast(K.ConditionAmount as abap.dec( 15, 2 )) as WCS_AMT1
        
                
        
        
}
