@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Import Po Data for purchase reg.2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZIMPORT_PO_DATA2 as select from ZIMPORT_PO_DATA1 as a left outer join I_OperationalAcctgDocItem as b 
                                              on b.OriginalReferenceDocument =  (concat(a.SupplierInvoice,a.FiscalYear))
                                              and b.TaxItemAcctgDocItemRef = a.SupplierInvoiceItem
                                              and b.IsAutomaticallyCreated = 'X'
                                              and b.TransactionTypeDetermination = 'JIM'
                                              and b.TaxType = 'V'
{
    key a.PurchaseOrder,
    key a.PurchaseOrderItem,
        a.PurchaseOrderType,
        a.SupplierInvoice,
        a.FiscalYear,
        a.SupplierInvoiceItem,
        ltrim( a.SupplierInvoiceItem , '0' ) as Supplier_Invoice_Item,
        a.SuplrInvcDeliveryCostCndnType,
        b.CompanyCodeCurrency,
        b.TransactionCurrency,
//        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
//        b.TaxBaseAmountInCoCodeCrcy,
        @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
        b.TaxAbsltBaseAmountInTransCrcy as TaxBaseAmountInCoCodeCrcy,
        @Semantics: { amount : {currencyCode: 'TransactionCurrency'} } 
        b.TaxAbsltBaseAmountInTransCrcy,
        cast(b.TaxAbsltBaseAmountInTransCrcy as abap.dec( 23, 2 )) as TaxBaseAmountInCoCodeCrcy_2
//        cast(b.TaxBaseAmountInCoCodeCrcy as abap.dec( 23, 2 )) as TaxBaseAmountInCoCodeCrcy_2

}
where a.SuplrInvcDeliveryCostCndnType <> ''
