resource "azurerm_public_ip" "ansible-master-pip" {
  allocation_method   = "Dynamic"
  location            = var.location
  resource_group_name = var.rgname
  name                = "${var.node-prefix}-pip"

}
resource "azurerm_network_interface" "ansible-master-nic" {
  name                = "${var.node-prefix}-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansible-master-pip.id
  }
}

resource "azurerm_linux_virtual_machine" "ansible-master-vm" {
  name                = "${var.node-prefix}-vm"
  location            = var.location
  resource_group_name = var.rgname
  size                = "Standard_DS1_v2"
  admin_username      = "ansibleadmin"
  network_interface_ids = [
    azurerm_network_interface.ansible-master-nic.id,
  ]

  admin_ssh_key {
    username   = "ansibleadmin"
    public_key = file("~/sshkeys/anskey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "ansible-master-vm-extension" {
  name                 = "${var.node-prefix}-vm-extension"
  virtual_machine_id   = azurerm_linux_virtual_machine.ansible-master-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo apt update && sudo apt install software-properties-common && sudo apt-add-repository --yes --update ppa:ansible/ansible && sudo apt install -y ansible"
    }
SETTINGS
}

