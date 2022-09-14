param keyVaultName string
param location string
param tags object
param dbuser string
@secure()
param dbpassword string
param token string
param tenantId string
param objectId string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: tenantId
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: objectId
        permissions: {
          secrets: [
            'all'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource user 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'dbuser'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
      exp: 30
      nbf: 30
    }
    value: dbuser
  }
}

resource password 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'dbpassword'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
      exp: 30
      nbf: 30
    }
    value: dbpassword
  }
}

resource ghtoken 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: 'token'
  parent: keyVault
  properties: {
    attributes: {
      enabled: true
      exp: 30
      nbf: 30
    }
    value: token
  }
}
