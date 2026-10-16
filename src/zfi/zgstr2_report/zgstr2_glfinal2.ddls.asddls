@AbapCatalog.sqlViewName: 'ZGSTRGLFINAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_GLFINAL2'
define view ZGSTR2_GLFINAL2 as select from I_OperationalAcctgDocItem as A 
left outer join ZGSTR2_FINALGL as B on ( B.AccountingDocument = A.AccountingDocument and B.AccountingDocumentItem = A.AccountingDocumentItem 
                                        and B.CompanyCode = A.CompanyCode and B.FiscalYear = A.FiscalYear )  // added by Pintu on 20.11.25

{
A.AccountingDocument,
A.AccountingDocumentItem,
A.AccountingDocumentType,
A.CompanyCode,                  // added by Pintu on 20.11.25
A.FiscalYear,                   // added by Pintu on 20.11.25
B.GLACCOUNT_RE,
B.GLACCOUNT_KR,
B.GLACCOUNT_SA,
 case when A.AccountingDocumentType = 'RE' then B.GLACCOUNT_RE
      when A.AccountingDocumentType = 'KR' then B.GLACCOUNT_KR  
      when A.AccountingDocumentType = 'SA' then B.GLACCOUNT_SA else '' end  as GLACCOUNTS    
}
where B.GLACCOUNT_RE is not initial
   or B.GLACCOUNT_KR is not initial
   or B.GLACCOUNT_SA is not initial

   
