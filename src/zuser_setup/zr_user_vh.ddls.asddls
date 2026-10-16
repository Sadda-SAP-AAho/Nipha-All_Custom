@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help For User'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_USER_VH 
  as select from I_User
{
      @ObjectModel.text.element: [ 'UserDescription' ]
      @UI.textArrangement: #TEXT_FIRST
  key UserID,
      UserDescription
}
