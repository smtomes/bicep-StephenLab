param location string = resourceGroup().location
param randomString string = uniqueString(resourceGroup().id)
param storageAccountName string = 'bicepps${randomString}'

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

resource StorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    allowCrossTenantReplication: true
    allowSharedKeyAccess: true
    defaultToOAuthAuthentication: false
    dnsEndpointType: 'Standard'
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: false
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
  }
}

resource RoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63')
  dependsOn: [
    ApplicationGroup
  ]
  properties: {
    roleDefinitionId: '1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63'
    principalId: 'f0d361e0-dc88-434e-a52e-6e414372c73c'
    principalType: 'ServicePrincipal'
  }
}
