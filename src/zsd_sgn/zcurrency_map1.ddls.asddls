@AbapCatalog.sqlViewName: 'ZCURRENCYMAP1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Currency Map'
define view zcurrency_map1 as select from zcurrency_map
{

 key currency_id as CurrencyId ,
 country as Country,
 description as Description
    
}
