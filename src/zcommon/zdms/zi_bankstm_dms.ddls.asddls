@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BANK Statement Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZI_BANKSTM_DMS 
as select from I_JournalEntry as a
{



    key a.CompanyCode as CompCode,
    key a.AccountingDocument as ActDoc,
    key a.FiscalYear as Fiscalyear,
    a.AccountingDocumentHeaderText as HeaderText,
  
    @Search.defaultSearchElement: true
    a.AccountingDocumentType as ActDocType,
    a.PostingDate as PostDate

}
