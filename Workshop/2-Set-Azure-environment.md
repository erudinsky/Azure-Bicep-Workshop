## Azure CLI

Main dependencies:

* [Azure account](https://azure.microsoft.com/en-gb/free/)
* azure-cli 2.35.0 (or above)
* Bicep CLI version 0.5.6 (or above)

Make sure to use proper subscription. Double check listing resource groups.

```bash 

# list logged in accounts

az account list -o table

# set desired account

az account set -s <`subscriptionId` or `subscriptionName`>

# list resource groups

az group list -o table

```

## Deploying resource group and KeyVault with Bicep

Let's deploy resource group and some init resources with Bicep to `subscription` targetScope

```bash

tree templates # This is the folder with all templates used in with Workshop

templates
├── main.bicep
├── main.init.bicep
├── modules
│   ├── arc.bicep
│   ├── keyvault.bicep
│   ├── postgres.bicep
│   ├── roleAssignment.bicep
│   ├── roleDefinition.bicep
│   ├── staticsite.bicep
│   └── webapp.bicep
├── parameters.example.json
├── parameters.init.example.json
└── roles
    ├── contributor.json
    ├── owner.json
    └── reader.json

# To deploy RG and KV use the following commands:

az deployment sub validate -f templates/main.init.bicep -p templates/parameters.init.example.json -l eastus2 -resourcePrefix abw
az deployment sub what-if -f templates/main.init.bicep -p templates/parameters.init.example.json -l eastus2 -resourcePrefix abw
az deployment sub create -f templates/main.init.bicep -p templates/parameters.init.example.json -l eastus2 -resourcePrefix abw

```

NB! This step also uses module with Azure KeyVault and add a couple of secrets for communications between parts of our application (server <> db).

You'll be prompted to enter `dbuser` and `dbpassword` and `token` from GH account (for static app deployment) and they'll be stored in Azure KeyVault's secrets. We will consume them from our Server Side App.

At the end of this step you should have the following:

* Three custom role definitions and three role assignments of these roles to subscription scope
* Resource Group 
* KeyVault with 2 secrets (dbuser and dbpassword)

Deployment of management groups, policies and RBAC is one of the fundamental part of Azure Landing Zones. You can learn more about it in this project exploring [high-level deployment flow](https://github.com/Azure/ALZ-Bicep/wiki/DeploymentFlow#high-level-deployment-flow). In this workshop we only cover a little bit of policies and RBAC.

![High level deployment flow - Azure Landing Zones w/ Bicep](../.attachments/high-level-deployment-flow.png)

## Deploy the rest of the resources

```bash 

tree templates # This is the folder with all templates used in with Workshop

templates
├── main.bicep
├── main.init.bicep
├── modules
│   ├── arc.bicep
│   ├── keyvault.bicep
│   ├── postgres.bicep
│   ├── roleAssignment.bicep
│   ├── roleDefinition.bicep
│   ├── staticsite.bicep
│   └── webapp.bicep
├── parameters.example.json
├── parameters.init.example.json
└── roles
    ├── contributor.json
    ├── owner.json
    └── reader.json

# To deploy the rest of the resources use the following command:

az deployment group create -f templates/main.bicep -p templates/parameters.example.json 

```

This step will deploy the following resources: 

* PSQL
* Web App and Web App Plan
* Static App
* Managed Identity
* Azure Container Registry

![Azure Bicep Resources](../.attachments/azure-bicep-workshop-resources.png)

Hope you can see the above then move to the next [task - prepare database](3-Prepare-database.md).