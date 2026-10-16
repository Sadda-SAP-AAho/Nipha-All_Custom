@AbapCatalog.sqlViewName: 'YTEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZTESTPAYMENT'
define view ZTESTPAYMENT as select from I_PaymentTermsText
{
    Language ,
    PaymentTerms,
    PaymentTermsName
}
