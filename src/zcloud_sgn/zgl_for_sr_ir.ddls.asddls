@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL for Sr Ir'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGL_FOR_SR_IR as select from I_OperationalAcctgDocItem
as a right outer join I_PurOrdAccountAssignmentAPI01 as b
on b.PurchaseOrder = a.PurchasingDocument //and b.
left outer join I_GLAccountTextRawData as c on c.GLAccount = b.GLAccount
and c.Language = 'E' 
{
   key a.AccountingDocument,
   key a.CompanyCode,
   key a.FiscalYear,
//   key a.AccountingDocumentItem,
       a.AccountingDocumentItemType,
       b.PurchaseOrder,
//       b.PurchaseOrderItem,
       b.GLAccount,
       c.ChartOfAccounts,
       c.GLAccountLongName,
       c.GLAccountName 
}
where a.AccountingDocumentItemType = 'W'
group by a.AccountingDocument,a.CompanyCode,a.FiscalYear,
//a.AccountingDocumentItem,
a.AccountingDocumentItemType,b.PurchaseOrder,b.GLAccount,c.ChartOfAccounts,
c.GLAccountLongName,c.GLAccountName 
