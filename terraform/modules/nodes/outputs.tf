output "public_ip" {
  value = azurerm_public_ip.ansible-master-pip.ip_address
}
