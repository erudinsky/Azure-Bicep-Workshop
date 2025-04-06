extension microsoftGraphV1

param displayName string
param mailEnabled bool
param mailNickname string
param securityEnabled bool
param uniqueName string

resource group 'Microsoft.Graph/groups@v1.0' = {
     displayName: displayName
     mailEnabled: mailEnabled
     mailNickname: mailNickname
     securityEnabled: securityEnabled
     uniqueName: uniqueName
}
