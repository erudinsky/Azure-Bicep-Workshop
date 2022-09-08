## Prerequisited

Main dependencies:

* Python 3.10.2
* [flask](https://flask.palletsprojects.com/en/2.1.x/)
* pip for package management

Virtual environments enable you to have an isolated space on your computer for Python projects, ensuring that each of your projects can have its own set of dependencies that won’t disrupt any of your other projects.

```bash

cd <server_direcrtory>
python3 -m venv env
source env/bin/activate

```

## Application 

```bash

/server
├── Dockerfile
├── app.py
├── requirements.txt
└── seed.py

python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
python3 app.py

```

Application uses 

`flask_cors` for CORS support (allows call application's routes from another domain since vuejs will live in a separate server).
`psycopg2` - postgreSQL client

make sure to have the following environment variables, otherwise set them up (development):

```bash
 
export POSTGRES_USER=postgres
export POSTGRES_PORT=5432
export POSTGRES_PASSWORD=secret
export POSTGRES_HOST=localhost
export POSTGRES_NAME=abw_db
export POSTGRES_SSLMODE=prefer

env | grep POSTGRES # to make sure they've set up succesfully

 ```

> For Production `POSTGRES_SSLMODE` should be set to `require`. Read about SSL Mode Descriptions [here](https://www.postgresql.org/docs/9.1/libpq-ssl.html)


Validate if the application runs with `flask run`, type in browser the following: 

* http://localhost:5000/health <--- should respond with `"I am fine!"`
* http://localhost:5000/books <--- should return json with several boosk (we've added as seeds earlier)

Stop running application with `CTRL+C`.

## Dockerize

Review Dockerfile, build, tag and push image to ACR.

```Dockerfile
FROM python:latest
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY app.py app.py
COPY seed.py seed.py
CMD [ "python", "app.py"]
```

```bash

# Get a list of all ACR in the account (mainly to get the name of the ACR)

az acr list -o table

# Login to ACR

az acr login -n <acrname>
Login Succeeded

# build with tag and push

docker build -t <your_acr>.azurecr.io/server .
docker push <your_acr>.azurecr.io/server

# Run dockerized application (-p 5000:5000 maps container's port to host's port so I can access)

docker run -p 5000:5000 <your_acr>.azurecr.io/server

```

## Web App with Bicep

To host our flask application in production let's use Web App (PaaS service that gives 99.99% SLA and is easy to scale and maintain). The Web App as well as it's App Service Plan, Managed Identiy and ACR have been provisioned as part of the main deployment, let's review it's template:

```bicep 

// main.bicep

// WebApp

param appServicePlanName string = '${resourcePrefix}${uniqueString(location)}plan'
param webApplicationName string = '${resourcePrefix}${uniqueString(location)}webapp'

module webApp 'modules/webapp.bicep' = {
  name: webApplicationName
  params: {
    appServicePlanName: appServicePlanName
    webApplicationName: webApplicationName
    location: location
    tags: tags
    acrLogin: ACR.outputs.acrLogin
    managedIdentityName: managedIdentityName
  }
}

// modules/webapp.bicep

param appServicePlanName string
param location string
param webApplicationName string
param tags object
param acrLogin string
param managedIdentityName string

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
  // This is the AcrPull role, which is used to pull images from ACR. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
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

```

### Managed identity

![](../.attachments/when-use-managed-identities.png)

There are two types of managed identities:

* System-assigned. Some Azure services allow you to enable a managed identity directly on a service instance. When you enable a system-assigned managed identity, an identity is created in Azure AD. The identity is tied to the lifecycle of that service instance. When the resource is deleted, Azure automatically deletes the identity for you. By design, only that Azure resource can use this identity to request tokens from Azure AD.
* User-assigned. You may also create a managed identity as a standalone Azure resource. You can create a user-assigned managed identity and assign it to one or more instances of an Azure service. For user-assigned managed identities, the identity is managed separately from the resources that use it.

## Working with API

Now that we have API deployed, let's play with it. Check `/postman` folder and get exported collection.

![Postman collection](/.attachments/postman.png)

Make sure to change baseURL in variables (this is FQDN of your App Service). 

## Resources

* [Builtin roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles)
* [Web App resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites?tabs=bicep)
* [Managed Identity](https://docs.microsoft.com/en-us/azure/templates/microsoft.managedidentity/userassignedidentities?tabs=bicep)

Move to the next [task - client with vuejs](5-Client-with-vuejs.md).