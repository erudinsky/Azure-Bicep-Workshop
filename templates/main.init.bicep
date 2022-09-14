targetScope = 'subscription'

param location string
param resourceGroupName string
param tags object
param tenantId string

// 0. Everything above RG

// RBAC as code

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

// Policy as code

param policies array =  [
  // 1
  {
    name: 'a_tag_policy.json'
    policyDefinition: json(loadTextContent('./policies/a_tag_policy.json'))
    parameters: {}
  }
  // 2
  {
    name: 'allowed_location.json'
    policyDefinition: json(loadTextContent('./policies/allowed_location.json'))
    parameters: {}
  }
]

module policyDefinition 'modules/policies.bicep' = [for policy in policies: {
  name: '${policy.name}_deployment'
  params: {
    location: location
    policy: policy
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
