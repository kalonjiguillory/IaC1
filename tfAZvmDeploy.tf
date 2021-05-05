provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "KGcomputeLab" {
  name     = "example-resources"
  location = "South Central US"
}

module "ubuntu" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.KGcomputeLab.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
}

module "windows" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.KGcomputeLab.name
  is_windows_image    = true
  vm_hostname         = "mywinvm" // line can be removed if only one VM module per resource group
  admin_password      = "ComplxP@ssw0rd!"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["winsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.KGcomputeLab.name
  subnet_prefixes     = ["10.0.2.0/24"]
  subnet_names        = ["subnet1"]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}

output "windows_vm_public_name" {
  value = module.windowsservers.public_ip_dns_name
}

