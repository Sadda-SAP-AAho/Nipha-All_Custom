@AbapCatalog.sqlViewName: 'ZGSTR2SUP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZMMR01_SUPPLIER'
define view ZMMR01_SUPPLIER as select from I_OperationalAcctgDocItem as A 
left outer join I_Supplier as B on ( B.Supplier = A.Supplier )
left outer join I_RegionText as C on ( C.Region = B.Region and C.Country = B.Country and C.Language = 'E' )
{
A.AccountingDocument,
A.FiscalYear,
A.CompanyCode,
A.Supplier,
A.FinancialAccountType,
A.IN_GSTPlaceOfSupply,
B.SupplierName,
B.TaxNumber3,
B.Region,
C.RegionName   
}
where FinancialAccountType = 'K'
group by
A.AccountingDocument,
A.FiscalYear,
A.CompanyCode,
A.Supplier,
A.FinancialAccountType,
A.IN_GSTPlaceOfSupply,
B.SupplierName,
B.TaxNumber3,
B.Region,
C.RegionName     
