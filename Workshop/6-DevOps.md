## Introduction

![GitHub DevOps](../.attachments/lifecycle.png)

> [What is DevOps?](https://resources.github.com/devops/)

Up until now we were using personal account for deployment. Let's first generate [Service Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals#service-principal-object) and build our automation.

You can use portal and follow this tutorial, otherwise just drop the following into your CLI in order to generate SPN and assign contributor on Subscription.

```bash 

# Generate SPN using az cli (replace subscriptionId with your value)
# We decided to use `owner` role since we need role assignment permissions for managed identity

az ad sp create-for-rbac --name AzureBicepWorkshopSPN --role owner --scopes /subscriptions/
<subscriptionId> --sdk-auth

{
  "clientId": "<REDACTED>",
  "displayName": "<REDACTED>",
  "subscriptionId": "<REDACTED>",
  "tenantId": "<REDACTED>",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}

```

For our automation we will use GitHub. Navigate to your forked repository and start configuration, go ahead and add the following file and paste the following content `.github/workflows/azure-bicep-workshop.yml`:

> To better learn action's syntax review [this doc](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)

```yaml

on: [push]
name: azure-bicep-workshop

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment: dev
    env:
      ResourceGroupName: azure-bicep-workshop
      ResourceGroupLocation: westeurope
    steps:
    - uses: actions/checkout@master
    - uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    - uses: Azure/CLI@v1
      with:
        inlineScript: |
          #!/bin/bash
          az group create --name ${{ env.ResourceGroupName }} --location ${{ env.ResourceGroupLocation }}
          echo "Azure resource group created"

```

Also navigate to GitHub > Settings > Secrets and add new secret `AZURE_CREDENTIALS` and paste output from SPN (json with credentials). THis is simple action that uses special tasks and does login and creation of RG. Commit changes and run the action.

## Build and deploy

A typical cycle for IAC templates would be the following:

- [ARMTTK](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/test-toolkit) or [checkov](https://www.checkov.io/) checks
- Then generate immutable artifact
- Deploy to different environment (either automatically or with some additional chesk, quality gates and manual approvals)

We will use simplified process and deploy from agent our templates using Az CLI.

For that, let's create additional file in `.github/workflows`

```yaml

on: [push]
name: azure-bicep-workshop

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment: dev
    env:
      ResourceGroupName: azure-bicep-workshop
      ResourceGroupLocation: westeurope
    steps:
    - uses: actions/checkout@master
    - uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    - uses: Azure/CLI@v1
      with:
        inlineScript: |
          #!/bin/bash

          az deployment group validate \
            -f ./templates/main.init.bicep \
            -p ./templates/parameters.init.example.json 

          az deployment group what-if \
              -f ./templates/main.init.bicep \
              -p ./templates/parameters.init.example.json 

          az deployment group create \
              -f ./templates/main.init.bicep \
              -p ./templates/parameters.init.example.json 
                    
    - uses: Azure/CLI@v1
      with:
        inlineScript: |
          #!/bin/bash

          az deployment group validate \
            -f ./templates/main.bicep \
            -p ./templates/parameters.example.json 

          az deployment group what-if \
              -f ./templates/main.bicep \
              -p ./templates/parameters.example.json 

          az deployment group create \
              -f ./templates/main.bicep \
              -p ./templates/parameters.example.json 


```

Don't forget to [clean up](7-clean-up.md).