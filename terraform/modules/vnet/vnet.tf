resource "azurerm_virtual_network" "ansible-vnet" {
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.rgname
  name                = var.vnet_name
}

resource "azurerm_subnet" "ansible-subnet" {
  name                 = var.subnet_name
  virtual_network_name = azurerm_virtual_network.ansible-vnet.name
  address_prefixes     = var.subnet_address_prefixes
  resource_group_name  = azurerm_virtual_network.ansible-vnet.resource_group_name
}

resource "azurerm_network_security_group" "subnet-nsg" {
  name                = "${azurerm_subnet.ansible-subnet.name}-nsg"
  location            = var.location
  resource_group_name = var.rgname
  security_rule {
    name                       = "allowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "ansible-subnet-link-subnet-nsg" {
  subnet_id                 = azurerm_subnet.ansible-subnet.id
  network_security_group_id = azurerm_network_security_group.subnet-nsg.id
}
