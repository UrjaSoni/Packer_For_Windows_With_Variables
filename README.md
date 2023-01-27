# Build Windows Image with Packer Using a Variable Flag

# Prerequisite 

## Install
- [Packer CLI](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli )
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)


# How To
## Initialize Azure Resources
1. Login to Azure CLI

    ```az login```

2. Set subscription

    ```az account set --subscription {{SUBSCRIPTION_ID}}```

3. Create a resource group for the image

    ```az group create --name {{RESOURCE_GROUP_NAME}} --location {{LOCATION}}```

4. Create the Service Principal that has permission to build the image, and create/modify VMs

    ```az ad sp create-for-rbac --name packer-service-principal --role contributor --scopes /subscriptions/{{SUBSCRIPTION_ID}}```

    > Note: Save the output of this command for the next steps


5. Switch to desired OS directory

    ```cd windows```


6. Update environment variables values in set-variables file 

7. Run set-variables file
    
    ```./set-variables.ps1```


7. Validate environment variables are being set

    ```packer validate .```

## Build Image

1. Build Image

    ```packer build .```

## Deploy Image
Create an Azure VM based on our custom image

```az vm create --resource-group {{RESOURCE_GROUP_NAME}} --name {{VM_NAME}} --image {{IMAGE_NAME}} --admin-username azureuser --generate-ssh-keys```

## Test
Start the VM, open port 80, and view the Apache default webpage in browser

```az vm start -g {{RESOURCE_GROUP_NAME}} -n {{VM_NAME}} && az vm open-port --resource-group {{RESOURCE_GROUP_NAME}} --name {{VM_NAME}} --port 80 && open http://$(az vm show -d -g {{RESOURCE_GROUP_NAME}} -n {{VM_NAME}} --query publicIps -o tsv)/```


