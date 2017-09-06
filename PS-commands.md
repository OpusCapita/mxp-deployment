New-AzureRmResourceGroupDeployment -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG -TemplateUri https://raw.githubusercontent.com/OpusCapita/mxp-deployment/master/deploy-mxp-dev.json -TemplateParameterUri https://raw.git
hubusercontent.com/OpusCapita/mxp-deployment/master/mxp-dev-params.json

alt.


New-AzureRmResourceGroupDeployment -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG -TemplateFile deploy-mxp-dev.json -TemplateParameterFile mxp-dev-params.json

Remove-AzureRmResourceGroupDeployment -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG



# Login to azure resource-group

    Add-AzureRmAccount -SubscriptionId dafcede0-1826-41b6-b8c4-795b16aa7136


Stop-AzureRmResourceGroupDeployment -ResourceGroupName Messaging_Platform_DevTest_RG

# Do deployment on local json files

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name FirstShot -ResourceGroupName Messaging_Platform_DevTest_RG -TemplateFile deploy-mxp-dev.json -TemplateParameterFile mxp-dev-params.json


# How to create VM's

Make sure you have installed the azure_cli package

1. SSH into the server
2. sudo waagent -deprovision+user -force
3. az vm deallocate --resource-group Messaging_Platform_DevTest_RG --name mxp-is
4. az vm generalize --resource-group Messaging_Platform_DevTest_RG --name mxp-is
5. az image create --resource-group Messaging_Platform_DevTest_RG --name mxp-is-vanilla-1.0 --source mxp-is


# json files to be used

* mpx-dev-create-vm.json        - will create a plain RHEL 7.3 server
* mxp-dev-create-vm-ubuntu.json - will crete a plain ubuntu 16.1 server
* mxp-dev-ext-lb.json - will create lb in front of pub subnetwork
* mxp-dev-createnetwork.json - creates the network and the subnets. OBS, don't run it.

# param files to be used

* mxp-dev-create-egw-server-param.json -
* mxp-dev-create-front
