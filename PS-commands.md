New-AzureRmResourceGroupDeployment -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG -TemplateUri https://raw.githubusercontent.com/OpusCapita/mxp-deployment/master/deploy-mxp-dev.json -TemplateParameterUri https://raw.git
hubusercontent.com/OpusCapita/mxp-deployment/master/mxp-dev-params.json

alt.


New-AzureRmResourceGroupDeployment -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG -TemplateFile deploy-mxp-dev.json -TemplateParameterFile mxp-dev-params.json

Remove-AzureRmResourceGroupDeployment -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG




Add-AzureRmAccount -SubscriptionId dafcede0-1826-41b6-b8c4-795b16aa7136


Stop-AzureRmResourceGroupDeployment -ResourceGroupName Messaging_Platform_DevTest_RG

New-AzureRmResourceGroupDeployment -Mode Incremental -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG -TemplateFile deploy-mxp-dev.json -TemplateParameterFile mxp-dev-params.json


# How to create VM's

Make sure you have installed the azure_cli package

1. SSH into the server
2. sudo waagent -deprovision+user -force
3. az vm deallocate --resource-group Messaging_Platform_DevTest_RG --name mxp-is
4. az vm generalize --resource-group Messaging_Platform_DevTest_RG --name mxp-is
5. az image create --resource-group Messaging_Platform_DevTest_RG --name mxp-is-vanilla-1.0 --source mxp-is


# Output from create VM image

``
PS $ az image create --resource-group Messaging_Platform_DevTest_RG --name mxp-is-vanilla-1.0 --source mxp-is
{
  "id": "/subscriptions/dafcede0-1826-41b6-b8c4-795b16aa7136/resourceGroups/Messaging_Platform_DevTest_RG/providers/Microsoft.Compute/images/mxp-is-vanilla-1.0",
  "location": "westeurope",
  "name": "mxp-is-vanilla-1.0",
  "provisioningState": "Succeeded",
  "resourceGroup": "Messaging_Platform_DevTest_RG",
  "sourceVirtualMachine": {
    "id": "/subscriptions/dafcede0-1826-41b6-b8c4-795b16aa7136/resourceGroups/Messaging_Platform_DevTest_RG/providers/Microsoft.Compute/virtualMachines/mxp-is",
    "resourceGroup": "Messaging_Platform_DevTest_RG"
  },
  "storageProfile": {
    "dataDisks": [],
    "osDisk": {
      "blobUri": null,
      "caching": "ReadWrite",
      "diskSizeGb": null,
      "managedDisk": {
        "id": "/subscriptions/dafcede0-1826-41b6-b8c4-795b16aa7136/resourceGroups/Messaging_Platform_DevTest_RG/providers/Microsoft.Compute/disks/mxp-is_OsDisk_1_d5597dcb53794f719e86c0839300073f",
        "resourceGroup": "Messaging_Platform_DevTest_RG"
      },
      "osState": "Generalized",
      "osType": "Linux",
      "snapshot": null,
      "storageAccountType": null
    }
  },
  "tags": null,
  "type": "Microsoft.Compute/images"
}

``
