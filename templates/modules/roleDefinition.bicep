targetScope = 'subscription'

param roleDefinition object
param assignableScopes string
param type string = 'customRole'

resource roleDefinitionResource 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(roleDefinition.name)
  properties: {
    assignableScopes: [
      assignableScopes
    ]
    description: roleDefinition.description
    permissions: roleDefinition.permissions
    roleName: '${roleDefinition.roleName}'
    type: type
  }
}

output roleDefinitionId string = roleDefinitionResource.id

