#HUG RG CREATION
RG='AZB39-HUB-RG'

az group create --location eastus -n ${RG}

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.39.0.0/16 \
    --subnet-name jump-svr-subnet-1 --subnet-prefix 10.39.1.0/24 -l eastus
az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n AzureFirewallSubnet \
    --address-prefixes 10.39.10.0/24
az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n GatewaySubnet \
    --address-prefixes 10.39.20.0/24
az network vnet subnet create -g ${RG} --vnet-name ${RG}-vNET1 -n AzureBastionSubnet \
    --address-prefixes 10.39.30.0/24

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name JUMPLINUXVM1 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet jump-svr-subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.39.1.4 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete

# az vm create --resource-group ${RG} --name JUMPWINVM1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
#     --subnet jump-svr-subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
#     --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 10.38.1.5 \
#     --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete

#SPOKE1-RG CREATION
RG='AZB39-SP1-RG'

az group create --location eastus -n ${RG}

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 172.16.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefix 172.16.1.0/24 -l eastus

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SP1LINUXVM1 --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.10 \
    --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete

# az vm create --resource-group ${RG} --name SP1-WINSVR1 --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
#     --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
#     --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.16.1.11 \
#     --zone 1 --os-disk-delete-option Delete --nic-delete-option Delete

#SPOKE2-RG CREATION
RG='AZB39-SP2-RG'

az group create --location westus -n ${RG}

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 172.17.0.0/16 \
    --subnet-name ${RG}-Subnet-1 --subnet-prefix 172.17.1.0/24 -l westus

echo "Creating NSG and NSG Rule"
az network nsg create -g ${RG} -n ${RG}_NSG1 -l westus
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allowing All Traffic For Now"
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allowing ICMP Traffic For Now"

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

echo "Creating Virtual Machines"
az vm create --resource-group ${RG} --name SP2LINUXVM1 --location westus --image $IMAGE --vnet-name ${RG}-vNET1 \
    --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B1s \
    --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.17.1.10 \
    --os-disk-delete-option Delete --nic-delete-option Delete

# az vm create --resource-group ${RG} --name SP1WIN --image Win2022Datacenter --vnet-name ${RG}-vNET1 \
#     --subnet ${RG}-Subnet-1 --admin-username adminsree --admin-password "India@123456" --size Standard_B2ms \
#     --nsg ${RG}_NSG1 --storage-sku StandardSSD_LRS --private-ip-address 172.17.1.11 \
#     --os-disk-delete-option Delete --nic-delete-option Delete  --public-ip-address ""
