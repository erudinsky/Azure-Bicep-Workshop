# Lab 6 - Client with vuejs

In this lab we will look into client side part.

## Objectives

By the end of this lab, you will be able to:

1. Understand how to host a Vue.js client application using Azure Static Web Apps.
2. Modify and configure a Vue.js application to connect to a backend API.
3. Test the client application locally and deploy changes to Azure using GitHub workflows.

## Key Learnings

1. Learn how to configure Azure Static Web Apps for hosting Vue.js applications.
2. Understand the structure of a Vue.js project and identify key files for configuration.
3. Gain hands-on experience with modifying Vue.js components and settings to integrate with a backend API.
4. Explore the automated deployment process using GitHub workflows for Azure Static Web Apps.

---

To host our client's part (vue.js) we want to use [Static Web Apps](https://azure.microsoft.com/services/app-service/static/?wt.mc_id=MVP_387222#overview). Static Site Web Application resource has been provisioned as part of the main deployment, let's review it's template.

Review module `staticsite.bicep`:

```bicep

param staticSiteName string
param location string
param tags object
@secure()
param repositoryToken string
param repositoryUrl string
param branch string

resource staticSite 'Microsoft.Web/staticSites@2021-03-01' = {
  name: staticSiteName
  location: location
  tags: tags
  sku: {
    name: 'free'
    tier: 'free'
  }
  properties: {
    repositoryUrl: repositoryUrl
    branch: branch
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
    repositoryToken: repositoryToken
    buildProperties: {
      appLocation: 'Lab/6-client'
      appArtifactLocation: 'dist'
    }
  }
}

```

> ⚠️ `appLocation` in the template above is the absolute path in the repo.

`staticSites` is a special type of resource that provisions service to run [static site](https://erudinsky.com/2022/01/07/static-web-site-on-azure-with-azure-devops-and-bicep/). To learn more about Static Site resource and it's available parameters visit [template reference](https://learn.microsoft.com/azure/templates/microsoft.web/staticsites?tabs=bicep&wt.mc_id=MVP_387222).

## Task 6.1: Add changes to static site

Main dependencies:

* [Vuejs](https://vuejs.org/)
* [Vue CLI](https://cli.vuejs.org/)

```bash

6-client
├── azure-static-web-apps-config.json
├── azure.yaml
├── babel.config.js
├── infra
│   ├── main.bicep
│   └── main.parameters.json
├── node_modules
├── package-lock.json
├── package.json
├── public
│   ├── favicon.ico
│   └── index.html
└── src
    ├── App.vue
    ├── assets
    │   └── logo.png
    ├── axiosConfig.js <====== this needs change
    ├── components
    │   ├── Alert.vue
    │   ├── Books.vue
    │   └── Ping.vue
    ├── main.js
    └── router
        └── index.js

npm install # to install dependencies
npm run serve # to test application

```

Make sure to change baseURL in the files marked above with `this needs change`. Use your backend URL (the same the we used with postman in [Lab 5](5-Server-side.md). You can also test client app locally first and if everything works (check your client app via browser to see similar as below image) commit changes and push to git.

If everything went well you should be able to see the following. To test application find our the url of your app via the portal:

![Client's URL](../.attachments/6-client-url.png)

and test..

![vuejs](../.attachments/6-client-vuejs.png)

In GitHub in [Lab 4](4-Prepare-database.md) we deployed Static App that created workflow that runs everytime when there is change in git. The workflow was created from template by Azure Static Site service and can be found under `./.github/workflows/azure-static-web-apps-random-string.yml`

## Resources

* [vuejs getting started](https://v1.vuejs.org/guide/)
* [Template reference (Static Web)](https://learn.microsoft.com/azure/templates/microsoft.web/staticsites?tabs=bicep&wt.mc_id=MVP_387222)
* [Git howto](https://githowto.com/)

## Summary

In this lab we learnt how to configure and change our client side application.

Move to the next task [DevOps](7-DevOps.md).
