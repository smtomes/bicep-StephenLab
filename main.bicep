param location string = resourceGroup().location
param avdSecurityGroupId string

@description('Principal type of the assignee.')
@allowed([
  'Device'
  'ForeignGroup'
  'Group'
  'ServicePrincipal'
  'User'
])
param principalType string = 'Group'

@description('the id for the role definition of Virtual Desktop Users')
param RoleDefinitionId string = '1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63'

@description('the id of the principal that would get the permission')
param principalId string = avdSecurityGroupId

@description('the role definition is collected')
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

resource HostPool 'Microsoft.DesktopVirtualization/hostPools@2022-04-01-preview' = {
  name: 'Bicep_Test'
  location: location
  properties: {
    agentUpdate: {
      useSessionHostLocalTime: true
    }
    customRdpProperty: 'drivestoredirect:s:;audiomode:i:0;videoplaybackmode:i:0;redirectclipboard:i:1;redirectprinters:i:0;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:1;audiocapturemode:i:1;screen mode id:i:1;autoreconnection enabled:i:1;bandwidthautodetect:i:1;compression:i:0;camerastoredirect:s:*;'
    description: 'Stephen created this as a test using Bicep'
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    maxSessionLimit: 999999
    preferredAppGroupType: 'Desktop'
    publicNetworkAccess: 'Enabled'
    ring: 1
    startVMOnConnect: false
    validationEnvironment: false
  }
}

resource ApplicationGroup 'Microsoft.DesktopVirtualization/applicationGroups@2022-04-01-preview' = {
  name: 'BicepTestApplicationGroup'
  location: location
  kind: 'Desktop'
  properties: {
    applicationGroupType: 'Desktop'
    description: 'Bicep Test created by Stephen Tomes'
    friendlyName: 'Default Desktops'
    hostPoolArmPath: '/subscriptions/af32ce84-b1e3-44c1-bef5-6f2b30749285/resourceGroups/${resourceGroup().name}/providers/Microsoft.DesktopVirtualization/hostpools/${HostPool.name}'
  }
}
