@AbapCatalog.sqlViewName: 'ZGSTRGL2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_GL2'
define view ZGSTR2_GL2 as select from ZMMR01_GL as A
left outer join I_OperationalAcctgDocItem as B on ( B.OriginalReferenceDocument = A.MATYEAR and B.PurchasingDocument = A.PurchasingDocument and B.PurchasingDocumentItem = A.PurchasingDocumentItem 
                                                    and B.CompanyCode = A.CompanyCode and B.FiscalYear = A.FiscalYear )  // added by Pintu on 20.11.25
{
 A.AccountingDocument,
 A.FiscalYear,
 A.CompanyCode,
 A.PurchasingDocument,
 A.PurchasingDocumentItem,
 A.MaterialDocument,
 A.MaterialDocumentItem,
 A.MaterialDocumentYear,  
 B.GLAccount,
 B.GLAccount as GLACCOUNT_RE  
}
where B.AccountingDocumentItemType = 'M'
  and B.PurchasingDocument is not initial
  and B.PurchaseOrderQty <> 0

  
