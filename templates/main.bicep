targetScope = 'resourceGroup'

// Common params

param location string = resourceGroup().location
param resourcePrefix string
param tags object
param keyVaultName string

// 3. ACR

param acrName string = '${resourcePrefix}${uniqueString(location)}acr'
param acrSku string

// 4. PostgreSQL

param postgreSqlName string = '${resourcePrefix}${uniqueString(location)}psql'
param firewallRulesList array
param capacity int

// 5. WebApp

param appServicePlanName string = '${resourcePrefix}${uniqueString(location)}plan'
param webApplicationName string = '${resourcePrefix}${uniqueString(location)}webapp'

// 6. managedIdentity

param managedIdentityName string = '${resourcePrefix}${uniqueString(location)}mi'

// 7. StaticSite

param staticSiteName string = '${resourcePrefix}${uniqueString(location)}swa'
param repositoryUrl string
param branch string

module ACR 'modules/acr.bicep' = {
  name: 'acr'
  params: {
    location: location
    tags: tags
    acrName: acrName
    acrSku: acrSku
  }
}

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  scope: resourceGroup()
}

module postgreSQL 'modules/postgres.bicep' = {
  name: 'postgreSQL'
  params: {
    location: location
    capacity: capacity
    postgreSqlName: postgreSqlName
    tags: tags
    firewallRulesList: firewallRulesList
    administratorLogin: kv.getSecret('dbuser')
    administratorLoginPassword: kv.getSecret('dbpassword')
  }
}

module webApp 'modules/webapp.bicep' = {
  name: 'webApp'
  params: {
    appServicePlanName: appServicePlanName
    webApplicationName: webApplicationName
    location: location
    tags: tags
    acrLogin: ACR.outputs.acrLogin
    managedIdentityName: managedIdentityName
    postgreSqlParams: postgreSQL.outputs.psql
    psqlName: postgreSQL.outputs.psqlName
    postgresPassword: kv.getSecret('dbpassword')
  }
}

module staticSite 'modules/staticsite.bicep' = {
  name: 'staticSite'
  params: {
    staticSiteName: staticSiteName
    location: location
    repositoryToken: kv.getSecret('token')
    repositoryUrl: repositoryUrl
    branch: branch
    tags: tags
  }
}
