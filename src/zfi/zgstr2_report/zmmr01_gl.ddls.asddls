@AbapCatalog.sqlViewName: 'ZGSTR2GL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZMMR01_GL'
define view ZMMR01_GL as select from I_OperationalAcctgDocItem as A 
left outer join I_MaterialDocumentItem_2 as B on ( B.PurchaseOrder = A.PurchasingDocument and B.PurchaseOrderItem = A.PurchasingDocumentItem 
                                                    and B.CompanyCode = A.CompanyCode and B.MaterialDocumentYear = A.FiscalYear ) // added by Pintu on 20.11.25
{
 A.AccountingDocument,
 A.FiscalYear,
 A.CompanyCode,
 A.PurchasingDocument,
 A.PurchasingDocumentItem,
 B.MaterialDocument,
 B.MaterialDocumentItem,
 B.MaterialDocumentYear, 
 concat( B.MaterialDocument,MaterialDocumentYear )  as MATYEAR
}
where A.AccountingDocumentType = 'RE'
  and A.PurchasingDocument is not initial

  
