@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase register basic2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurchase_Register_BASE2 as select from I_OperationalAcctgDocItem  as A
   {
    A.OriginalReferenceDocument,
    A.PurchasingDocument,
    A.PurchasingDocumentItem,
    A.CompanyCodeCurrency,
    A.GoodsMovementEntryUnit,
    @Semantics: { quantity : {unitOfMeasure: 'GoodsMovementEntryUnit'} }
    A.QuantityInEntryUnit,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum(AmountInCompanyCodeCurrency)  as net_amount 
    
   }
   where  TransactionTypeDetermination = 'FR1'
   group by
    A.OriginalReferenceDocument,
    A.PurchasingDocument,
    A.CompanyCodeCurrency,
    A.PurchasingDocumentItem,
    A.QuantityInEntryUnit,
    A.GoodsMovementEntryUnit
