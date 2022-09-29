targetScope = 'subscription'

param roleDefinition object
param assignableScopes string
param type string = 'customRole'
param assigneeObjectId string


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

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(roleDefinitionResource.id, assigneeObjectId)
  properties: {
    roleDefinitionId: roleDefinitionResource.id
    principalId: assigneeObjectId
  }
}

output roleDefinitionId string = roleDefinitionResource.id
output roleAssignment string = roleAssignment.id
