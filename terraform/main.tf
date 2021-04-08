terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.53.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "k8s"
  location = "centralus"
}

module "vnet" {
  source = "./modules/vnet"
  rgname = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  address_space = ["192.168.0.0/16"]
  vnet_name = "vnet"
  subnet_name = "vm-subnet"
  subnet_address_prefixes = ["192.168.0.0/24"]
}
 
module "nodes" {
  source = "./modules/nodes"
  rgname = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  for_each = toset(["master", "node01", "node02"])
  node-prefix = each.key
  vm_subnet = module.vnet.subnet_id
}
