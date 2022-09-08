## Clean up

To avoid Azure charges let's clean up. 

```bash

az group delete -g azure-bicep-workshop -y

```

Don't forget to purge deleted KVs:

![Purge KV](../.attachments/purge-kv.png)

## Resources

[az cli](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-lates)