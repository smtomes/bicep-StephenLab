targetScope = 'resourceGroup' 

@description('Principal type of the assignee.')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string = 'ServicePrincipal'

@description('the id for the role defintion, to define what permission should be assigned')
param RoleDefinitionId string = '1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63'

@description('the id of the principal that would get the permission')
param principalId string = '568cc44f-71c6-41b9-9969-13e988ca5e9c'

@description('the role deffinition is collected')
resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: RoleDefinitionId
}

resource RoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, RoleDefinitionId, principalId)
  properties: {
    roleDefinitionId: roleDefinition.id
    principalId: principalId
    principalType: principalType
  }
}
