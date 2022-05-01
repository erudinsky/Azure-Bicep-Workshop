## Getting started with Bicep

[Bicep](https://github.com/Azure/bicep) is an open source (MIT) domain-specific language to define [Infrastructure as Code (IaC) ](https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code)in **Azure**.

![](/.attachments/bicep-processing.png)

Advantages of Bicep:

* Immediately supports all resources types and API versions (both GA and preview);
* Simple syntax (comparing to ARM templates), [think of Bicep as a revision to the existing Azure Resource Manager template (ARM template) language](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/frequently-asked-questions#why-create-a-new-language-instead-of-using-an-existing-one); 
* Awesome first-class authing experience with [Bicep Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep);
* Repeatable results as bicep files are [idempotent](https://en.wikipedia.org/wiki/Idempotence) (meaning that you can deploy the same files many times and consistently getting the same results);
* Orchestration. Order of resources does not matter as Resource Manager orchestrates the deployment of interdependent resources so they're created in the correct order;
* Modularity - break down your bicep code into [modules](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules);
* Integration with Azure services such as Azure Policy, template specs and blueprints;
* Preview changes with `what-if` operation;
* No state or state files to manage (stated is stored in Azure);
* No cost and open source! Contributions are welcome, see [issues](https://github.com/Azure/bicep/contribute) and [guide](https://github.com/Azure/bicep/blob/985abdb65cb5407bebd6ce74319a113907a9a9f3/CONTRIBUTING.md) how to contribute.

## Bicep & ARM

[Decompile](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/decompile?tabs=azure-cli) from JSON to Bicep

Using the following bicep resource definition let's explore Azure Resource Manager.

```bicep
targetScope = 'resourceGroup' // this can be removed as default targetScope is resourceGroup
param location string = 'westeurope'
@description('Storage Account name')
var name = '${uniqueString(location)}rg'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

output storageAccount string = storageAccount.name
```

```bash

# NB! Check target tenant/subscription

az group create -g abw -l westeurope
az deployment group validate -f sandbox/main.bicep -g abw
az deployment group what-if -f sandbox/main.bicep -g abw
az deployment group create -f sandbox/main.bicep -g abw

# Export: RG > JSON

az group export --name abw > sandbox/main-exported.json

# Decompile: JSON > Bicep

az bicep decompile --file main-exported.json

```

### Target scope

By default, the target scope is set to resourceGroup. If you're deploying at the resource group level, you don't need to set the target scope in your Bicep file.

![Azure Scope](/.attachments/az-target-scopes.png)

Typical Bicep template file structure:

```bicep
targetScope = '<scope>'

@<decorator>(<argument>)
param <parameter-name> <parameter-data-type> = <default-value>

var <variable-name> = <variable-value>

resource <resource-symbolic-name> '<resource-type>@<api-version>' = {
  <resource-properties>
}

module <module-symbolic-name> '<path-to-file>' = {
  name: '<linked-deployment-name>'
  params: {
    <parameter-names-and-values>
  }
}

output <output-name> <output-data-type> = <output-value>
```

Use [bicep linter](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter) in IDE and CICD. [Default](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/linter#default-rules) set of linter rules are taken from [arm-ttk test cases](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-test-cases).

## Rest API exercise

https://docs.microsoft.com/en-us/rest/api/azure/

* [How to call Azure REST APIs with Postman](https://docs.microsoft.com/en-us/rest/api/azure/#how-to-call-azure-rest-apis-with-postman)
* [How to call Azure REST APIs with curl](https://docs.microsoft.com/en-us/rest/api/azure/#how-to-call-azure-rest-apis-with-curl)

In the latest azure-cli you can also use `az rest` method to work with REST API

Try calling with postman (make sure bearerToken has been generated and passed along with the request). Also for the second request add location variable with [region](https://docs.microsoft.com/en-us/azure/availability-zones/cross-region-replication-azure#azure-cross-region-replication-pairings-for-all-geographies) for the resource group.

* `GET https://management.azure.com/subscriptions/{{subscriptionId}}/resourcegroups?api-version=2020-09-01`
* `POST https://management.azure.com/subscriptions/{{subscriptionId}}/resourcegroups/azure-bicep-workshop?api-version=2020-09-01`

## Application reference

![Full Stack Application in Azure with Bicep](/.attachments/full-stack-with-bicep.png)

[![Deploy to Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/)
[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg)](http://armviz.io/#/?load=)

## Resources 

* [What is IaC?](https://www.youtube.com/watch?v=uETq8KKVUFY)
* [Infrastructure as Code (IaC): Comparing the Tools](https://techcommunity.microsoft.com/t5/itops-talk-blog/infrastructure-as-code-iac-comparing-the-tools/ba-p/3205045)
* [Bicep playground](https://aka.ms/bicepdemo)
* Resource explorer in Azure Portal

Move to the next [task - set Azure environment](2-Set-Azure-environment.md).