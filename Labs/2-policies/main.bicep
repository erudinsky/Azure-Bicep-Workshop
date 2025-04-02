targetScope = 'subscription'

param location string

// Policy as code

param policies array = [
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

module policyDefinition '../modules/policies.bicep' = [
  for policy in policies: {
    name: '${policy.name}_deployment'
    params: {
      location: location
      policy: policy
    }
  }
]
