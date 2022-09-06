targetScope = 'subscription'

param roleAssignmentNameGuid string = guid(roleDefinitionId, assigneeObjectId)
param roleDefinitionId string
param assigneeObjectId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentNameGuid
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: assigneeObjectId
  }
}

output roleAssignment string = roleAssignment.id
