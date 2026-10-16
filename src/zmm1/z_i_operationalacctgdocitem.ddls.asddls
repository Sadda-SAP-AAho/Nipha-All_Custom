@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OPERATIONAL ACCTG DOC ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_OPERATIONALACCTGDOCITEM as select from I_OperationalAcctgDocItem
{
    key CompanyCode,
    key AccountingDocument,
    key FiscalYear,
        BusinessPlace,
        OriginalReferenceDocument
/*//    key AccountingDocumentItem,
    ChartOfAccounts,
//    AccountingDocumentItemType,
    ClearingDate,
    ClearingCreationDate,
    ClearingJournalEntryFiscalYear,
    ClearingDocFiscalYear,
    ClearingJournalEntry,
    ClearingAccountingDocument,
//    PostingKey,
//    FinancialAccountType,
    SpecialGLCode,
    SpecialGLTransactionType,
//    DebitCreditCode,
    BusinessArea,
    PartnerBusinessArea,
    TaxCode,
    TaxCountry,
    TaxRateValidityStartDate,
    WithholdingTaxCode,
    TaxType,
    TaxItemGroup,
//    TransactionTypeDetermination,
    ValueDate,
    AssignmentReference,
    DocumentItemText,
    InterestCalculationBlockReason,
    PartnerCompany,
    FinancialTransactionType,
    CorporateGroupAccount,
    PlanningLevel,
    ControllingArea,
    CostCenter,
    Project,
    OrderID,
    BillingDocument,
    SalesDocument,
//    SalesDocumentItem,
    ScheduleLine,
    ServiceDocumentType,
    ServiceDocument,
    ServiceDocumentItem,
    MasterFixedAsset,
    FixedAsset,
    AssetTransactionType,
    AssetValueDate,
    PersonnelNumber,
    IsSalesRelated,
//    LineItemDisplayIsEnabled,
//   IsOpenItemManaged,
    AddressAndBankIsSetManually,
    DownPaymentIsNetProcedure,
    IsNotCashDiscountLiable,
    SuplrInvcIsCapitalGoodsRelated,
    IsAutomaticallyCreated,
    IsUsedInPaymentTransaction,
    OperationalGLAccount,
//    GLAccount,
    Customer,
    Supplier,
    BranchAccount,
    IsBalanceSheetAccount,
    ProfitLossAccountType,
    SpecialGLAccountAssignment,
    DueCalculationBaseDate,
    PaymentTerms,
    CashDiscount1Days,
    CashDiscount2Days,
    NetPaymentDays,
    CashDiscount1Percent,
    CashDiscount2Percent,
    PaymentMethod,
    PaymentBlockingReason,
    FixedCashDiscount,
    HouseBank,
    BPBankAccountInternalID,
    TaxDistributionCode1,
    TaxDistributionCode2,
    TaxDistributionCode3,
    InvoiceReference,
    InvoiceReferenceFiscalYear,
    InvoiceItemReference,
    FollowOnDocumentType,
    AcctgDocItmCustomsTariffNumber,
    AcctgDocItmCstmsClearanceDate,
    StateCentralBankPaymentReason,
    SupplyingCountry,
    RecrrgSuplrInvcIsSrvcInvoice,
    InvoiceList,
    BillOfExchangeUsageDocument,
    BillOfExchangeUsage,
    DunningKey,
    DunningBlockingReason,
    LastDunningDate,
    DunningLevel,
    DunningArea,
    PaytSlipWthRefSubscriber,
    PaytSlipWthRefReference,
    PaytSlipWthRefCheckDigit,
    WithholdingTaxCertificate,
//    Material,
//    Product,
    Plant,
    PurchasingDocument,
//    PurchasingDocumentItem,
    AccountAssignmentNumber,
    IsCompletelyDelivered,
//    MaterialPriceControl,
    ValuationArea,
    InventoryValuationType,
    VATRegistration,
    DelivOfGoodsDestCountry,
    DelivOfGoodsOriginCountry,
    PaymentDifferenceReason,
//    ProfitCenter,
    JointVenture,
    JointVentureCostRecoveryCode,
    JointVentureEquityGroup,
    JointVenturePartner,
    TreasuryContractType,
    AssetContract,
    CashFlowType,
    TaxJurisdiction,
    REInternalFinNumber,
    RealEstateObject,
    SettlementReferenceDate,
    CommitmentItem,
    CommitmentItemShortID,
    CostObject,
    ProjectNetwork,
    OrderInternalBillOfOperations,
    OrderIntBillOfOperationsItem,
    WBSElementInternalID,
//    ProfitabilitySegment,
//    ProfitabilitySegment_2,
    JointVentureBillingType,
    JointVentureEquityType,
    IsEUTriangularDeal,
    CostOriginGroup,
    CompanyCodeCurrencyDetnMethod,
    ClearingIsReversed,
    PaymentMethodSupplement,
    AlternativeGLAccount,
    FundsCenter,
//    Fund,
    TaxCompanyCode,
    PartnerProfitCenter,
    Reference1IDByBusinessPartner,
    Reference2IDByBusinessPartner,
//    EarmarkedFundsDocument,
//    EarmarkedFundsDocumentItem,
    IsNegativePosting,
    PaymentCardItem,
    PaymentCardPaymentSettlement,
    CreditControlArea,
    AlternativePayeePayer,
    Reference3IDByBusinessPartner,
    DataExchangeInstruction1,
    DataExchangeInstruction2,
    DataExchangeInstruction3,
    DataExchangeInstruction4,
    BPActivityCodeGrossIncomeTax,
    Region,
    BPEmploymentTaxDistrType,
    HasPaymentOrder,
    PaymentReference,
    TaxDeterminationDate,
    ClearingItem,
    BusinessPlace,
    TaxSection,
    CostCtrActivityType,
    AccountsReceivableIsPledged,
    AcctsReceivablePledgingCode,
    BusinessProcess,
    GrantID,
    FunctionalArea,
    CustomerIsInExecution,
    FundedProgram,
    InvcItmIsExcldFrmPromptPaytAct,
    LedgerGLLineItem,
    Segment,
    PartnerSegment,
    PartnerFunctionalArea,
    HouseBankAccount,
    CostElement,
    ClearingIsLedgerGroupSpecific,
    TaxItemAcctgDocItemRef,
    PaymentServiceProvider,
    PaymentRefByPaytSrvcProvider,
    SEPAMandate,
    ReferenceDocumentType,
    OriginalReferenceDocument,
    ReferenceDocumentLogicalSystem,
    AccountingDocumentItemRef,
    FiscalPeriod,
    AccountingDocumentCategory,
    PostingDate,
    DocumentDate,
    AccountingDocumentType,
    NetDueDate,
    CashDiscount1DueDate,
    CashDiscount2DueDate,
    OffsettingAccount,
    OffsettingAccountType,
    OffsettingChartOfAccounts,
    PartnerFund,
    PartnerGrant,
    BudgetPeriod,
    PartnerBudgetPeriod,
    BranchCode,
    BillingPeriodOfPerfStartDate,
    BillingPeriodOfPerfEndDate,
    JointVentureProductionDate,
    OplAcctgDocItmCntrySpcfcRef1,
    PaymentReason,
    CashLedgerCompanyCode,
    CashLedgerAccount,
    PubSecBudgetAccountCoCode,
    PubSecBudgetAccount,
    FinancialServicesProductGroup,
    FinancialServicesBranch,
    FinancialDataSource,
    CustomerGroup,
    CustomerSupplierCountry,
    CustomerSupplierIndustry,
    CompanyCodeCurrency,
/*    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    AmountInCompanyCodeCurrency,
    FunctionalCurrency,
    @Semantics: { amount : {currencyCode: 'FunctionalCurrency'} }
    AmountInFunctionalCurrency,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBaseAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    ValuationDiffAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    CashDiscountAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBrkdwnAmount1InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBrkdwnAmount2InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBrkdwnAmount3InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    NonDcblTaxAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    InvoiceAmtInCoCodeCrcy,
    TransactionCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    AmountInTransactionCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    OriginalTaxBaseAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBaseAmountInTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxBaseAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    PlannedAmtInTransactionCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    CashDiscountBaseAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    CashDiscountAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    NetPaymentAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAmount1InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAmount2InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAmount3InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxExemptionAmt,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    NonDcblTaxAmountInTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    InvoiceAmountInFrgnCurrency,
    BalanceTransactionCurrency,
    @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
    AmountInBalanceTransacCrcy,
    AdditionalCurrency1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
    ValuationDiffAmtInAddlCrcy1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
    AmountInAdditionalCurrency1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    TaxAmountInAdditionalCurrency1,
    AdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
    AmountInAdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
    TaxAmountInAdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
    ValuationDiffAmtInAddlCrcy2,
    PaymentCurrency,
    @Semantics: { amount : {currencyCode: 'PaymentCurrency'} }
    AmountInPaymentCurrency,
    CreditControlAreaCurrency,
    @Semantics: { amount : {currencyCode: 'CreditControlAreaCurrency'} }
    HedgedAmount,
    BaseUnit,
    @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
    Quantity,
    GoodsMovementEntryUnit,
    @Semantics: { quantity : {unitOfMeasure: 'GoodsMovementEntryUnit'} }
    QuantityInEntryUnit,
    PurchasingDocumentPriceUnit,
    @Semantics: { quantity : {unitOfMeasure: 'PurchasingDocumentPriceUnit'} }
    PurchaseOrderQty,
    MaterialPriceUnitQty,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    AbsoluteAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    AbsoluteAmountInTransacCrcy,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    AbsltAmtInAdditionalCurrency1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    AbsltAmtInAdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} } 
    AbsltAmtInBalanceTransacCrcy,
    @Semantics: { amount : {currencyCode: 'FunctionalCurrency'} }
    AbsltAmtInFunctionalCurrency,
    @Semantics: { amount : {currencyCode: 'PaymentCurrency'} } 
    AbsltAmountInPaymentCurrency,
    @Semantics: { amount : {currencyCode: 'CreditControlAreaCurrency'} }   
    HedgedAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    PlannedAbsltAmtInTransCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    CashDiscAbsltAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    CashDiscountAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    CashDiscountAbsoluteBaseAmount,
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    InvoiceAbsltAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    InvoiceAbsltAmtInFrgnCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    NetPaymentAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    NonDcblTaxAbsltAmtInCoCodeCrcy,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    NonDcblTaxAbsltAmtInTransCrcy,
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxAbsltAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    TaxAbsoluteAmount,
     @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    TaxAbsltAmtInAddlCurrency1,
     @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    TaxAbsltAmtInAddlCurrency2,
       @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxAbsltBaseAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    TaxAbsltBaseAmountInTransCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriglTxAbsltBaseAmountInCCCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    OriginalTaxAbsoluteBaseAmount,
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    OriglTxAbsltBaseAmtInAddlCrcy1,
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    OriglTxAbsltBaseAmtInAddlCrcy2,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxBrkdwnAbsltAmt1InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxBrkdwnAbsltAmt2InCoCodeCrcy,   
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxBrkdwnAbsltAmt3InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAbsltAmt1InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAbsltAmt2InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAbsltAmt3InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxAbsoluteBaseAmt,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WhldgTaxExemptionAbsltAmount,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    ValnDiffAbsltAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    ValnDiffAbsltAmtInAddlCrcy1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    ValnDiffAbsltAmtInAddlCrcy2,
//    UnadjustedDebitCreditCode,
    NumberOfItems,
    EarmarkedFunds,
    EarmarkedFundsItem,
    IN_GSTPartner,
    IN_GSTPlaceOfSupply,
    IN_HSNOrSACCode,
    IN_InvoiceReferenceNumber,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriglTaxBaseAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriginalTaxBaseAmtInAddlCrcy1,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriginalTaxBaseAmtInAddlCrcy2,

    GLAccountAuthorizationGroup,
    SupplierBasicAuthorizationGrp,
    CustomerBasicAuthorizationGrp,
    AcctgDocTypeAuthorizationGroup,
    OrderType,
    SalesOrderType,
    AssetClass*/

}
group by
     CompanyCode,
     AccountingDocument,
     FiscalYear,
         BusinessPlace,
         OriginalReferenceDocument
     
/*//    key AccountingDocumentItem,
    ChartOfAccounts,
//    AccountingDocumentItemType,
    ClearingDate,
    ClearingCreationDate,
    ClearingJournalEntryFiscalYear,
    ClearingDocFiscalYear,
    ClearingJournalEntry,
    ClearingAccountingDocument,
//    PostingKey,
//    FinancialAccountType,
    SpecialGLCode,
    SpecialGLTransactionType,
//    DebitCreditCode,
    BusinessArea,
    PartnerBusinessArea,
    TaxCode,
    TaxCountry,
    TaxRateValidityStartDate,
    WithholdingTaxCode,
    TaxType,
    TaxItemGroup,
//    TransactionTypeDetermination,
    ValueDate,
    AssignmentReference,
    DocumentItemText,
    InterestCalculationBlockReason,
    PartnerCompany,
    FinancialTransactionType,
    CorporateGroupAccount,
    PlanningLevel,
    ControllingArea,
    CostCenter,
    Project,
    OrderID,
    BillingDocument,
    SalesDocument,
//    SalesDocumentItem,
    ScheduleLine,
    ServiceDocumentType,
    ServiceDocument,
    ServiceDocumentItem,
    MasterFixedAsset,
    FixedAsset,
    AssetTransactionType,
    AssetValueDate,
    PersonnelNumber,
    IsSalesRelated,
//    LineItemDisplayIsEnabled,
//   IsOpenItemManaged,
    AddressAndBankIsSetManually,
    DownPaymentIsNetProcedure,
    IsNotCashDiscountLiable,
    SuplrInvcIsCapitalGoodsRelated,
    IsAutomaticallyCreated,
    IsUsedInPaymentTransaction,
    OperationalGLAccount,
//    GLAccount,
    Customer,
    Supplier,
    BranchAccount,
    IsBalanceSheetAccount,
    ProfitLossAccountType,
    SpecialGLAccountAssignment,
    DueCalculationBaseDate,
    PaymentTerms,
    CashDiscount1Days,
    CashDiscount2Days,
    NetPaymentDays,
    CashDiscount1Percent,
    CashDiscount2Percent,
    PaymentMethod,
    PaymentBlockingReason,
    FixedCashDiscount,
    HouseBank,
    BPBankAccountInternalID,
    TaxDistributionCode1,
    TaxDistributionCode2,
    TaxDistributionCode3,
    InvoiceReference,
    InvoiceReferenceFiscalYear,
    InvoiceItemReference,
    FollowOnDocumentType,
    AcctgDocItmCustomsTariffNumber,
    AcctgDocItmCstmsClearanceDate,
    StateCentralBankPaymentReason,
    SupplyingCountry,
    RecrrgSuplrInvcIsSrvcInvoice,
    InvoiceList,
    BillOfExchangeUsageDocument,
    BillOfExchangeUsage,
    DunningKey,
    DunningBlockingReason,
    LastDunningDate,
    DunningLevel,
    DunningArea,
    PaytSlipWthRefSubscriber,
    PaytSlipWthRefReference,
    PaytSlipWthRefCheckDigit,
    WithholdingTaxCertificate,
//    Material,
//    Product,
    Plant,
    PurchasingDocument,
//    PurchasingDocumentItem,
    AccountAssignmentNumber,
    IsCompletelyDelivered,
//    MaterialPriceControl,
    ValuationArea,
    InventoryValuationType,
    VATRegistration,
    DelivOfGoodsDestCountry,
    DelivOfGoodsOriginCountry,
    PaymentDifferenceReason,
//    ProfitCenter,
    JointVenture,
    JointVentureCostRecoveryCode,
    JointVentureEquityGroup,
    JointVenturePartner,
    TreasuryContractType,
    AssetContract,
    CashFlowType,
    TaxJurisdiction,
    REInternalFinNumber,
    RealEstateObject,
    SettlementReferenceDate,
    CommitmentItem,
    CommitmentItemShortID,
    CostObject,
    ProjectNetwork,
    OrderInternalBillOfOperations,
    OrderIntBillOfOperationsItem,
    WBSElementInternalID,
//    ProfitabilitySegment,
//    ProfitabilitySegment_2,
    JointVentureBillingType,
    JointVentureEquityType,
    IsEUTriangularDeal,
    CostOriginGroup,
    CompanyCodeCurrencyDetnMethod,
    ClearingIsReversed,
    PaymentMethodSupplement,
    AlternativeGLAccount,
    FundsCenter,
//    Fund,
    TaxCompanyCode,
    PartnerProfitCenter,
    Reference1IDByBusinessPartner,
    Reference2IDByBusinessPartner,
//    EarmarkedFundsDocument,
//    EarmarkedFundsDocumentItem,
    IsNegativePosting,
    PaymentCardItem,
    PaymentCardPaymentSettlement,
    CreditControlArea,
    AlternativePayeePayer,
    Reference3IDByBusinessPartner,
    DataExchangeInstruction1,
    DataExchangeInstruction2,
    DataExchangeInstruction3,
    DataExchangeInstruction4,
    BPActivityCodeGrossIncomeTax,
    Region,
    BPEmploymentTaxDistrType,
    HasPaymentOrder,
    PaymentReference,
    TaxDeterminationDate,
    ClearingItem,
    BusinessPlace,
    TaxSection,
    CostCtrActivityType,
    AccountsReceivableIsPledged,
    AcctsReceivablePledgingCode,
    BusinessProcess,
    GrantID,
    FunctionalArea,
    CustomerIsInExecution,
    FundedProgram,
    InvcItmIsExcldFrmPromptPaytAct,
    LedgerGLLineItem,
    Segment,
    PartnerSegment,
    PartnerFunctionalArea,
    HouseBankAccount,
    CostElement,
    ClearingIsLedgerGroupSpecific,
    TaxItemAcctgDocItemRef,
    PaymentServiceProvider,
    PaymentRefByPaytSrvcProvider,
    SEPAMandate,
    ReferenceDocumentType,
    OriginalReferenceDocument,
    ReferenceDocumentLogicalSystem,
    AccountingDocumentItemRef,
    FiscalPeriod,
    AccountingDocumentCategory,
    PostingDate,
    DocumentDate,
    AccountingDocumentType,
    NetDueDate,
    CashDiscount1DueDate,
    CashDiscount2DueDate,
    OffsettingAccount,
    OffsettingAccountType,
    OffsettingChartOfAccounts,
    PartnerFund,
    PartnerGrant,
    BudgetPeriod,
    PartnerBudgetPeriod,
    BranchCode,
    BillingPeriodOfPerfStartDate,
    BillingPeriodOfPerfEndDate,
    JointVentureProductionDate,
    OplAcctgDocItmCntrySpcfcRef1,
    PaymentReason,
    CashLedgerCompanyCode,
    CashLedgerAccount,
    PubSecBudgetAccountCoCode,
    PubSecBudgetAccount,
    FinancialServicesProductGroup,
    FinancialServicesBranch,
    FinancialDataSource,
    CustomerGroup,
    CustomerSupplierCountry,
    CustomerSupplierIndustry,
    CompanyCodeCurrency,
/*    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    AmountInCompanyCodeCurrency,
    FunctionalCurrency,
    @Semantics: { amount : {currencyCode: 'FunctionalCurrency'} }
    AmountInFunctionalCurrency,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBaseAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    ValuationDiffAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    CashDiscountAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBrkdwnAmount1InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBrkdwnAmount2InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    TaxBrkdwnAmount3InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    NonDcblTaxAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    InvoiceAmtInCoCodeCrcy,
    TransactionCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    AmountInTransactionCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    OriginalTaxBaseAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBaseAmountInTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxBaseAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    PlannedAmtInTransactionCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    CashDiscountBaseAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    CashDiscountAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    NetPaymentAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAmount1InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAmount2InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAmount3InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxExemptionAmt,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    NonDcblTaxAmountInTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    InvoiceAmountInFrgnCurrency,
    BalanceTransactionCurrency,
    @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} }
    AmountInBalanceTransacCrcy,
    AdditionalCurrency1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
    ValuationDiffAmtInAddlCrcy1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
    AmountInAdditionalCurrency1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    TaxAmountInAdditionalCurrency1,
    AdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
    AmountInAdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
    TaxAmountInAdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
    ValuationDiffAmtInAddlCrcy2,
    PaymentCurrency,
    @Semantics: { amount : {currencyCode: 'PaymentCurrency'} }
    AmountInPaymentCurrency,
    CreditControlAreaCurrency,
    @Semantics: { amount : {currencyCode: 'CreditControlAreaCurrency'} }
    HedgedAmount,
    BaseUnit,
    @Semantics: { quantity : {unitOfMeasure: 'BaseUnit'} }
    Quantity,
    GoodsMovementEntryUnit,
    @Semantics: { quantity : {unitOfMeasure: 'GoodsMovementEntryUnit'} }
    QuantityInEntryUnit,
    PurchasingDocumentPriceUnit,
    @Semantics: { quantity : {unitOfMeasure: 'PurchasingDocumentPriceUnit'} }
    PurchaseOrderQty,
    MaterialPriceUnitQty,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    AbsoluteAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    AbsoluteAmountInTransacCrcy,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    AbsltAmtInAdditionalCurrency1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    AbsltAmtInAdditionalCurrency2,
    @Semantics: { amount : {currencyCode: 'BalanceTransactionCurrency'} } 
    AbsltAmtInBalanceTransacCrcy,
    @Semantics: { amount : {currencyCode: 'FunctionalCurrency'} }
    AbsltAmtInFunctionalCurrency,
    @Semantics: { amount : {currencyCode: 'PaymentCurrency'} } 
    AbsltAmountInPaymentCurrency,
    @Semantics: { amount : {currencyCode: 'CreditControlAreaCurrency'} }   
    HedgedAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    PlannedAbsltAmtInTransCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    CashDiscAbsltAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    CashDiscountAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    CashDiscountAbsoluteBaseAmount,
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    InvoiceAbsltAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    InvoiceAbsltAmtInFrgnCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    NetPaymentAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    NonDcblTaxAbsltAmtInCoCodeCrcy,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    NonDcblTaxAbsltAmtInTransCrcy,
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxAbsltAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    TaxAbsoluteAmount,
     @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    TaxAbsltAmtInAddlCurrency1,
     @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    TaxAbsltAmtInAddlCurrency2,
       @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxAbsltBaseAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    TaxAbsltBaseAmountInTransCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriglTxAbsltBaseAmountInCCCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
    OriginalTaxAbsoluteBaseAmount,
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    OriglTxAbsltBaseAmtInAddlCrcy1,
      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    OriglTxAbsltBaseAmtInAddlCrcy2,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxBrkdwnAbsltAmt1InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxBrkdwnAbsltAmt2InCoCodeCrcy,   
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    TaxBrkdwnAbsltAmt3InCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAbsltAmt1InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAbsltAmt2InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    TaxBrkdwnAbsltAmt3InTransCrcy,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxAbsoluteAmount,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WithholdingTaxAbsoluteBaseAmt,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    WhldgTaxExemptionAbsltAmount,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    ValnDiffAbsltAmtInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} } 
    ValnDiffAbsltAmtInAddlCrcy1,
    @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} } 
    ValnDiffAbsltAmtInAddlCrcy2,
//    UnadjustedDebitCreditCode,
    NumberOfItems,
    EarmarkedFunds,
    EarmarkedFundsItem,
    IN_GSTPartner,
    IN_GSTPlaceOfSupply,
    IN_HSNOrSACCode,
    IN_InvoiceReferenceNumber,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriglTaxBaseAmountInCoCodeCrcy,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriginalTaxBaseAmtInAddlCrcy1,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
    OriginalTaxBaseAmtInAddlCrcy2,

    GLAccountAuthorizationGroup,
    SupplierBasicAuthorizationGrp,
    CustomerBasicAuthorizationGrp,
    AcctgDocTypeAuthorizationGroup,
    OrderType,
    SalesOrderType,
    AssetClass*/
