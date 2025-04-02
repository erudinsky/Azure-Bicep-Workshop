targetScope = 'resourceGroup' // this can be removed as default targetScope is resourceGroup
@description('Storage Account name')
param name string = uniqueString(resourceGroup().id)
@description('Storage Account location')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccount string = storageAccount.name
