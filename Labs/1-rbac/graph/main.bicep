param groups array = [
  {
    displayName: 'ABWOwner'
    mailEnabled: false
    mailNickname: 'ABWOwner'
    securityEnabled: true
    uniqueName: 'abwowner'
  }
  {
    displayName: 'ABWContributor'
    mailEnabled: false
    mailNickname: 'ABWContributor'
    securityEnabled: true
    uniqueName: 'abwcontributor'
  }
  {
    displayName: 'ABWReader'
    mailEnabled: false
    mailNickname: 'ABWReader'
    securityEnabled: true
    uniqueName: 'abwreader'
  }
]

module azureEntraGroup '../../modules/graph.bicep' = [
  for group in groups: {
    params: {
      displayName: group.displayName
      mailEnabled: group.mailEnabled
      mailNickname: group.mailNickname
      securityEnabled: group.securityEnabled
      uniqueName: group.uniqueName
    }
  }
]
