@AbapCatalog.sqlViewName: 'ZGSTR2_FINGL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_FINALGL'
define view ZGSTR2_FINALGL as select from I_OperationalAcctgDocItem as A 
left outer join ZGSTR2_GL2 as B on ( B.AccountingDocument = A.AccountingDocument and B.PurchasingDocument = A.PurchasingDocument and 
                                     B.PurchasingDocumentItem = A.PurchasingDocumentItem and B.PurchasingDocument is not initial 
                                     and B.CompanyCode = A.CompanyCode and B.FiscalYear = A.FiscalYear ) //added by Pintu on 20.11.25
                                     
left outer join ZGSTR2_GLKR as C on ( C.AccountingDocument = A.AccountingDocument and C.AccountingDocumentItem = A.AccountingDocumentItem and
                                      C.CompanyCode = A.CompanyCode and C.FiscalYear = A.FiscalYear and C.AccountingDocumentType = 'KR' )     
left outer join ZGSTR2_GLSA as D on ( D.AccountingDocument = A.AccountingDocument and D.AccountingDocumentItem = A.AccountingDocumentItem and
                                      D.CompanyCode = A.CompanyCode and D.FiscalYear = A.FiscalYear and D.AccountingDocumentType = 'SA' )                                                                        
{
A.AccountingDocument,
A.AccountingDocumentItem,
A.AccountingDocumentType,
A.CompanyCode,                  // added by Pintu on 20.11.25
A.FiscalYear,                   // added by Pintu on 20.11.25
B.GLACCOUNT_RE,
C.GLACCOUNT_KR,
D.GLACCOUNT_SA    
}
where B.GLACCOUNT_RE is not initial
   or C.GLACCOUNT_KR is not initial
   or D.GLACCOUNT_SA is not initial

   
