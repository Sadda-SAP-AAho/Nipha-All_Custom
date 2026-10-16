@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Value Help'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SALESVH as select from I_SalesOrder as salesorder
inner join I_SalesOrderItem as item on salesorder.SalesOrder = item.SalesOrder
//inner join i_salesorderpartner as salespartner on salesorder.SalesOrder = salespartner.SalesOrder
inner join I_Customer as customer on salesorder.SoldToParty = customer.Customer
left outer join ZI_GROUPED_DOC as b on salesorder.SalesOrder = b.RefObjectKey and b.RefObjectType = 'SO'
left outer join ZR_USER_ITEM000 as _user on item.Plant = _user.Plant 
{
  @UI.lineItem: [{  position: 10}]
  @UI.identification: [{ position: 10 }]
  @UI.selectionField: [{ position: 10 }]
  key salesorder.SalesOrder,
  
  @UI.lineItem: [{  position: 20}]
  @UI.identification: [{ position: 20 }]
  @UI.selectionField: [{ position: 20 }]
  salesorder.SalesOrderType,
  
  
  @UI.lineItem: [{  position: 30}]
  @UI.identification: [{ position: 30 }]
  salesorder.SalesOrderDate,
  
//  @UI.selectionField: [{ position: 30 }]
//  @UI.lineItem: [{  position: 40}]
//  @UI.identification: [{ position: 40 }]
//  @ObjectModel.text.element: [ 'Supplier' ]
//  case when salesorder.SoldToParty is not initial then customer.Customer else salesorder.SalesOrder end as Supplier,
  
  @UI.lineItem: [{  position: 50}]
  @UI.identification: [{ position: 50 }]
  case when salesorder.SoldToParty is not initial then customer.CustomerFullName else customer.CustomerName end as CustomerName,
  
  @UI.lineItem: [{  position: 55}]
  @UI.identification: [{ position: 55 }]
  salesorder.SoldToParty,
  
  @UI.lineItem: [{  position: 60}]
  @UI.identification: [{ position: 60 }]
  salesorder.CustomerGroup,
  
  @UI.lineItem: [{  position: 65}]
  @UI.identification: [{ position: 65 }]
  salesorder.SalesOrganization,
  
  @UI.lineItem: [{  position: 70}]
  @UI.identification: [{ position: 70 }]
  salesorder.OrganizationDivision,

  @UI.lineItem: [{  position: 80}]
  @UI.identification: [{ position: 80 }]
  salesorder.PurchaseOrderByCustomer,
  
  @UI.lineItem: [{  position: 81}]
  @UI.identification: [{ position: 81 }]
  @EndUserText.label: 'Attachment Count'
  b.DocCount,
  
  @UI.lineItem: [{  position: 90}]
  @UI.identification: [{ position: 90 }]
  salesorder.CreatedByUser
  
}
where _user.Userid = $session.user
group by salesorder.SalesOrder, salesorder.SalesOrderType, salesorder.SalesOrderDate, salesorder.SoldToParty,
 customer.CustomerFullName, customer.CustomerName, salesorder.CustomerGroup, salesorder.SalesOrganization,
  salesorder.OrganizationDivision, salesorder.PurchaseOrderByCustomer, b.DocCount, salesorder.CreatedByUser
