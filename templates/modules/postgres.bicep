param postgreSqlName string
param location string
param tags object
param firewallRulesList array
@secure()
param administratorLogin string
@secure()
param administratorLoginPassword string
param capacity int

resource postgreSql 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: postgreSqlName
  location: location
  tags: tags
  sku: {
    capacity: capacity
    family: 'Gen5'
    name: 'B_Gen5_1'
    size: '12288'
    tier: 'Basic'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    infrastructureEncryption: 'Disabled'
    sslEnforcement: 'Enabled'
    publicNetworkAccess: 'Enabled'
    storageProfile: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
      storageAutogrow: 'Enabled'
      storageMB: 5120
    }
    version: '11'
    createMode: 'Default'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource firewallRules 'Microsoft.DBforPostgreSQL/servers/firewallRules@2017-12-01' = [
  for firewallRule in firewallRulesList: {
    name: firewallRule.name
    parent: postgreSql
    properties: {
      endIpAddress: firewallRule.endIpAddress
      startIpAddress: firewallRule.startIpAddress
    }
  }
]

output psql object = postgreSql
output psqlName string = postgreSql.name
