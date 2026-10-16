@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DMS_BANKSTM000
  as select from zdms_bankstm as a
  left outer join ZI_GROUPED_DOC as b on b.RefObjectKey = concat(concat(concat(concat(a.comp_code,'-'),a.fiscal_year),'-'),a.act_doc) and  b.RefObjectType = 'PYMT'
  
{
  key a.comp_code as CompCode,
  key a.act_doc as ActDoc,
  key a.fiscal_year as Fiscalyear,
  a.act_doc_headertext as HeaderText,
  a.act_doc_type as ActDocType,
  b.DocCount,
  a.post_date as PostDate,
  @Semantics.user.createdBy: true
  a.created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  a.created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  a.changed_by as ChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  a.changed_at as ChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  a.local_changed_at as LocalChangedAt
}
