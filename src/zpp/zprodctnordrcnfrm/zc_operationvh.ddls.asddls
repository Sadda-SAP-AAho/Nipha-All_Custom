@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINATION FOR OPERATION VH'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_OPERATIONVH as select from I_ManufacturingOrderOperation
{
    key ManufacturingOrder,
    key ManufacturingOrderOperation_2,
    ManufacturingOrderSequence as Sequence,
    @Semantics.quantity.unitOfMeasure: 'OperationUnit'
    OpTotalConfirmedYieldQty as ConfirmedYieldQuantity,
    @Semantics.quantity.unitOfMeasure: 'OperationUnit'
    OpTotalConfirmedScrapQty as ConfirmedScrapQuantity,
    @Semantics.quantity.unitOfMeasure: 'OperationUnit'
    OperationConfirmedReworkQty as ConfirmedReworkQuantity,
    @Semantics.quantity.unitOfMeasure: 'OperationUnit'
    OpPlannedYieldQuantity as PlannedYieldQuantity,
    OperationUnit,
    Plant,
    OperationControlProfile
    
    
}
