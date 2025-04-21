metadata description = 'Creates an Azure Static Web Apps instance.'
param staticSiteName string
param location string
param repositoryUrl string
param branch string
param tags object = {}
param sku object = {
  name: 'Standard'
  tier: 'Standard'
}

resource staticSite 'Microsoft.Web/staticSites@2024-04-01' = {
  name: staticSiteName
  location: location
  tags: tags
  sku: sku
  properties: {
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
    repositoryUrl: repositoryUrl
    branch: branch
    buildProperties: {
      appLocation: 'Labs/6-client'
      appArtifactLocation: 'dist'
    }
  }
}

output uri string = 'https://${staticSite.properties.defaultHostname}'
