@EndUserText.label: 'ZCONSUMPTION_REP_DEL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCONSUMPTION_DEL_QTY 

    as select from  I_MfgOrderConfirmation as A
                                                    
{
     A.ManufacturingOrder,
     A.Plant,
     cast( sum(A.ConfYieldQtyInProductionUnit) as abap.dec( 13,3 ) ) as Delivery_Quantity

//    A.PostingDate
    

}

where A.IsReversal = '' and A.IsReversed = ''

group by
     A.ManufacturingOrder,
     A.Plant
//     A.PostingDate
