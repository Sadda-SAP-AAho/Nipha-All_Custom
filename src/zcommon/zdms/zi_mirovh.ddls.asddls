@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MIRO View'
@Metadata.allowExtensions: true
define view entity ZI_MIROVH as select from I_SupplierInvoiceAPI01 as a
inner join I_SuplrInvcItemPurOrdRefAPI01 as d on a.SupplierInvoice = d.SupplierInvoice and a.FiscalYear = d.FiscalYear
join I_Supplier as b on a.InvoicingParty = b.Supplier
left outer join I_BusinessPartner as e on b.Supplier = e.BusinessPartner 
left outer join ZI_GROUPED_DOC as c on  c.RefObjectKey = concat(concat(a.SupplierInvoice,'-'),a.FiscalYear) and c.RefObjectType = 'MIRO'
left outer join ZR_USER_ITEM000 as _user on d.Plant = _user.Plant 
{
    key a.SupplierInvoice,
    key a.FiscalYear,
    a.CompanyCode,
    a.DocumentDate,
    a.InvoicingParty,
    b.SupplierName,
    a.PostingDate,
    a.CreatedByUser,
    a.BusinessPlace,
    a.InvoiceReference,
    e.BusinessPartnerType,
    c.DocCount
}
where _user.Userid = $session.user
group by a.SupplierInvoice, a.FiscalYear, a.CompanyCode, a.DocumentDate, a.InvoicingParty, b.SupplierName, 
        a.PostingDate, a.CreatedByUser, a.BusinessPlace, a.InvoiceReference, c.DocCount, e.BusinessPartnerType
