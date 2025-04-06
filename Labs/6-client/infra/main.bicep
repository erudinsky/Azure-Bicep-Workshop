param staticSiteName string
param location string

resource staticSite 'Microsoft.Web/staticSites@2024-04-01' = {
  name: staticSiteName
  location: location
  sku: {
    name: 'free'
    tier: 'free'
  }
  tags: {
    'azd-service-name': 'web'
  }
  properties: {
    allowConfigFileUpdates: true
    buildProperties: {
      appLocation: '/Labs/6-client'
      appArtifactLocation: 'dist'
    }
  }
}
