targetScope = 'subscription'

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

module roleDefinition './../modules/roles.bicep' = [for role in roles: {
  name: '${role.roleDefinition.name}_deployment'
  params: {
    assignableScopes: 'subscriptions/${subscriptionId}'
    roleDefinition: role.roleDefinition
    assigneeObjectId: role.assigneeObjectId
  }
}]
