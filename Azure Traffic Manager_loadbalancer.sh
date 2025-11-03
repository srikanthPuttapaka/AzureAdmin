# RG CREATION
RG=AZUREB44TM1

echo "Creating Azure Resource Group"
az group create -l eastus2 -n ${RG}

#Vnet and Subnet Creation
echo "Creating Azure Virtual Network"
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.1.0.0/16 \
--subnet-name ${RG}-Subnet-1 --subnet-prefix 10.1.1.0/24 -l eastus2

az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n ${RG}-Subnet-2 \
--address-prefixes 10.1.2.0/24

az network vnet create -g ${RG} -n ${RG}-WEST2-vNET1 --address-prefix 10.2.0.0/16 \
--subnet-name ${RG}-WEST2-Subnet-1 --subnet-prefix 10.2.1.0/24 -l westus2

az network vnet subnet create -g ${RG} --vnet-name ${RG}-WEST2-vNET1 -n ${RG}-WEST2-Subnet-2 \
--address-prefixes 10.2.2.0/24

az network vnet create -g ${RG} -n ${RG}-CEINDIA-vNET1 --address-prefix 10.3.0.0/16 \
--subnet-name ${RG}-CEINDIA-Subnet-1 --subnet-prefix 10.3.1.0/24 -l centralindia

az network vnet subnet create -g ${RG} --vnet-name ${RG}-CEINDIA-vNET1 -n ${RG}-CEINDIA-Subnet-2 \
--address-prefixes 10.3.2.0/24

#NSG Creation
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow     --protocol Tcp --description "Allowing All Traffic For Now"

az network nsg create -g ${RG} -n ${RG}_WEST2_NSG1 --location westus2
az network nsg rule create -g ${RG} --nsg-name ${RG}_WEST2_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow     --protocol Tcp --description "Allowing All Traffic For Now"

az network nsg create -g ${RG} -n ${RG}_CEINDIA_NSG1 --location centralindia
az network nsg rule create -g ${RG} --nsg-name ${RG}_CEINDIA_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow     --protocol Tcp --description "Allowing All Traffic For Now"
 
 IMAGE='Canonical:ubuntu-24_04-lts:server:latest'

 # VM's Creation
 az vm create --resource-group ${RG} --name EASTUSVM01 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
--nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.1.1.4\
    --zone 3 --location eastus2 --os-disk-delete-option Delete --nic-delete-option Delete

IMAGE='Canonical:ubuntu-22_04-lts:server:latest'

 az vm create --resource-group ${RG} --name EASTUSVM02 --image $IMAGE --vnet-name ${RG}-vNET1 \
--subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2s \
--nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.1.1.5\
    --zone 3 --location eastus2 --os-disk-delete-option Delete --nic-delete-option Delete

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

az vm create --resource-group ${RG} --name WESTUS2VM01 --image $IMAGE --vnet-name ${RG}-WEST2-vNET1 \
--subnet ${RG}-WEST2-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
--nsg ${RG}_WEST2_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.2.1.4\
    --zone 2 --location westus2 --os-disk-delete-option Delete --nic-delete-option Delete


IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

az vm create --resource-group ${RG} --name CEINDIAVM01 --image $IMAGE --vnet-name ${RG}-CEINDIA-vNET1 \
--subnet ${RG}-CEINDIA-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
--nsg ${RG}_CEINDIA_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.3.1.4\
    --zone 2 --location centralindia --os-disk-delete-option Delete --nic-delete-option Delete

#sudo su - 
#apt update && apt install -y nginx net-tools jq
#service nginx status
#nano /var/www/html/index.nginx-debian.html
#check the Nginix service in Browser
