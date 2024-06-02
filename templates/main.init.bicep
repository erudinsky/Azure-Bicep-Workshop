// 1. RG

targetScope = 'subscription'

param location string
param resourceGroupName string
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// 2. Keyvault

param resourcePrefix string = 'abw'
param keyVaultName string = '${resourcePrefix}${uniqueString(location)}kv'
@secure()
param dbuser string
@secure()
param dbpassword string
@secure()
param token string
param tenantId string
param objectId string

module keyVault 'modules/keyvault.bicep' = {
  name: 'keyVault'
  scope: rg
  params: {
    keyVaultName: keyVaultName
    location: location
    tags: tags
    tenantId: tenantId
    objectId: objectId
    dbuser: dbuser
    dbpassword: dbpassword
    token: token
  }
}
