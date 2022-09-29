## Lab 8 - Clean up

To avoid Azure charges let's clean up. 

## Task 8.1: Remove resource group
   
```bash

az group delete -g azure-bicep-workshop -y

```

## Task 8.2: Delete (purge) Key Vault:

![Purge KV](../.attachments/8-purge-kv.png)

## Task 8.3: IAM clean up

* Remove custom roles and role assignments
* Remove assignment of service principal (and service principal itself) that was used in DevOps part.

## Resources

[az cli](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-lates)

## Congratulations

Congratulations! You have completed this workshop. If you have a feedback please direct it via [@evgenyrudinsky](https://twitter.com/evgenyrudinsky) or contact via [my blog](https://erudinsky.com/). 