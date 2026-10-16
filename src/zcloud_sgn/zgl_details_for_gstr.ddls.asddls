@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gl Details for GSTR Summery report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGL_DETAILS_FOR_GSTR as select from I_OperationalAcctgDocItem as a
left outer join I_GLAccountText as b on b.GLAccount = a.GLAccount
 and b.ChartOfAccounts = a.ChartOfAccounts
 and b.Language = 'E' 
{
   key a.CompanyCode,
   key a.AccountingDocument,
   key a.FiscalYear,
    a.AccountingDocumentItem,
    a.GLAccount,
    b.GLAccountName
    
}
where a.AccountingDocumentItem = '002'
and ( a.DebitCreditCode = 'S' or a.DebitCreditCode = 'H')
