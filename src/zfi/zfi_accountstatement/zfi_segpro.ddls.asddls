@AbapCatalog.sqlViewName: 'ZFISEGMENT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZFI_SEGPRO'
define view ZFI_SEGPRO as select from I_GLAccountLineItem
{
  key AccountingDocument,
    key Customer ,
     ProfitCenter ,
     Segment

} 
   group by 
          AccountingDocument,
          Customer ,
          ProfitCenter ,
          Segment
