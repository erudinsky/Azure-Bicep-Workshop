targetScope = 'subscription'

param location string
param resourceGroupName string
param tags object
param tenantId string

// 0. Everything above RG

param subscriptionId string
param groups object

var roles = [
  {
    roleDefinition: json(loadTextContent('./roles/owner.json'))
    assigneeObjectId: groups.owner
  }
  {
    roleDefinition: json(loadTextContent('./roles/contributor.json'))
    assigneeObjectId: groups.contributor
  }
  {
    roleDefinition: json(loadTextContent('./roles/reader.json'))
    assigneeObjectId: groups.reader
  }
]

module roleDefinition './modules/roles.bicep' = [for role in roles: {
  name: '${role.roleDefinition.name}_deployment'
  params: {
    assignableScopes: 'subscriptions/${subscriptionId}'
    roleDefinition: role.roleDefinition
    assigneeObjectId: role.assigneeObjectId
  }
}]

// 1. RG

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
