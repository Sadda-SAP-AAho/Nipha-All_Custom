@AbapCatalog.sqlViewName: 'ZGSTR2_CRIGCSG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZGSTR2_NOCRTBAREIGCSG'
define view ZGSTR2_NOCRTBAREIGCSG as select from I_OperationalAcctgDocItem as A 
left outer join ZGSTR2_NOCREDIT_TBA as B on ( B.AccountingDocument = A.AccountingDocument and B.TaxItem = A.AccountingDocumentItem and 
                                              B.CompanyCode = A.CompanyCode and B.FiscalYear = A.FiscalYear and B.AMLOUNT_NOCRRE_TBA > 0 )
left outer join ZGSTR2_NOCREDIT_TBA2 as C on ( C.AccountingDocument = A.AccountingDocument and C.TaxItem = A.AccountingDocumentItem and 
                                               C.CompanyCode = A.CompanyCode and C.FiscalYear = A.FiscalYear and C.AMLOUNT_NOCRRE_TBAIG > 0 )
{ 
key A.AccountingDocument,
key A.AccountingDocumentItem,
key A.CompanyCode,
key A.FiscalYear,
A.TaxItemGroup,
B.AMLOUNT_NOCRRE_TBA as AMT_NOCRTBA_RECSG,
B.TaxItem,
B.TaxCode,
C.AMLOUNT_NOCRRE_TBAIG,


case when B.AMLOUNT_NOCRRE_TBA <> 0 then 
     B.AMLOUNT_NOCRRE_TBA  
else  C.AMLOUNT_NOCRRE_TBAIG  
end as AMLOUNT_NOCRRE_TBA

}
