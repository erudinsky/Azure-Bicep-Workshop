param appServicePlanName string
param location string
param webApplicationName string
param tags object
param acrLogin string
param managedIdentityName string
param postgreSqlParams object
@secure()
param postgresPassword string
param psqlName string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
}

resource webApplication 'Microsoft.Web/sites@2021-03-01' = {
  name: webApplicationName
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acrLogin}/server:latest'
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '5000'
        }
        {
          name: 'POSTGRES_HOST'
          value: postgreSqlParams.properties.fullyQualifiedDomainName
        }
        {
          name: 'POSTGRES_USER'
          value: '${postgreSqlParams.properties.administratorLogin}@${psqlName}'
        }
        {
          name: 'POSTGRES_PASSWORD'
          value: postgresPassword
        }
        {
          name: 'POSTGRES_PORT'
          value: '5432'
        }
        {
          name: 'POSTGRES_NAME'
          value: 'abw_db'
        }
        {
          name: 'POSTGRES_SSLMODE'
          value: 'require'
        }
      ]
      acrUseManagedIdentityCreds: true
      acrUserManagedIdentityID: managedIdentity.properties.clientId
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
}

resource acrPullRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  // This is the AcrPull role, which is used to pull images from ACR. See https://learn.microsoft.com/azure/role-based-access-control/built-in-roles?wt.mc_id=MVP_387222
  name: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(managedIdentity.id, acrLogin, acrPullRoleDefinition.id)
  properties: {
    roleDefinitionId: acrPullRoleDefinition.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}
