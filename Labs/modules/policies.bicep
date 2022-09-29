targetScope = 'subscription'

param policy object
param location string

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'policyDefinition-${policy.name}'
  properties: {
    description: policy.policyDefinition.properties.description
    displayName: policy.policyDefinition.properties.displayName
    metadata: policy.policyDefinition.properties.metadata
    mode: policy.policyDefinition.properties.mode
    parameters: policy.policyDefinition.properties.parameters
    policyType: policy.policyDefinition.properties.policyType
    policyRule: policy.policyDefinition.properties.policyRule
  }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'policyAssignment-${policy.name}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: policy.policyDefinition.properties.description
    displayName: policy.name
    policyDefinitionId: policyDefinition.id
    parameters: policy.parameters
  }
}

output policyDefinitionId string = policyDefinition.id
output policyAssignmentId string = policyAssignment.id
