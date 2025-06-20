# resource "azurerm_virtual_network_peering" "poc-decoy-vnet-peering" {
#   name                      = "poc-decoy-vnet-peering"
#   resource_group_name       = azurerm_resource_group.msc-rg.name
#   virtual_network_name      = azurerm_virtual_network.poc-vnet.name
#   remote_virtual_network_id = azurerm_virtual_network.vnet.id
# 
#   allow_virtual_network_access           = true
#   allow_forwarded_traffic                = true
#   allow_gateway_transit                  = false
#   only_ipv6_peering_enabled              = false
#   peer_complete_virtual_networks_enabled = false
#   use_remote_gateways                    = false
# 
#   local_subnet_names = [
#     azurerm_subnet.poc-subnet-1.name
#   ]
# 
#   remote_subnet_names = [
#     azurerm_subnet.decoy-subnet.name
#   ]
# 
#   triggers = {
#     remote_address_space = join(",", azurerm_virtual_network.vnet.address_space)
#   }
# }
# 
# resource "azurerm_virtual_network_peering" "decoy-poc-vnet-peering" {
#   name                      = "decoy-poc-vnet-peering"
#   resource_group_name       = azurerm_resource_group.msc-rg.name
#   virtual_network_name      = azurerm_virtual_network.vnet.name
#   remote_virtual_network_id = azurerm_virtual_network.poc-vnet.id
# 
#   allow_virtual_network_access           = true
#   allow_forwarded_traffic                = true
#   allow_gateway_transit                  = false
#   only_ipv6_peering_enabled              = false
#   peer_complete_virtual_networks_enabled = false
#   use_remote_gateways                    = false
# 
#   local_subnet_names = [
#     azurerm_subnet.decoy-subnet.name
#   ]
# 
#   remote_subnet_names = [
#     azurerm_subnet.poc-subnet-1.name
#   ]
# }
# 
# resource "azurerm_virtual_network" "poc-vnet" {
#   name                = "poc-vnet"
#   location            = azurerm_resource_group.msc-rg.location
#   resource_group_name = azurerm_resource_group.msc-rg.name
#   address_space = [
#     "10.1.0.0/16"
#   ]
# }
# 
# resource "azurerm_subnet" "poc-subnet-1" {
#   name                 = "poc-subnet-1"
#   resource_group_name  = azurerm_resource_group.msc-rg.name
#   virtual_network_name = azurerm_virtual_network.poc-vnet.name
#   address_prefixes = [
#     "10.1.1.0/24"
#   ]
# }
# 
# resource "azurerm_network_security_group" "poc-vnet-nsg" {
#   name                = "poc-vnet-nsg"
#   location            = azurerm_resource_group.msc-rg.location
#   resource_group_name = azurerm_resource_group.msc-rg.name
# 
#   security_rule {
#     name                         = "DenySubnet"
#     priority                     = 1000
#     direction                    = "Outbound"
#     access                       = "Deny"
#     protocol                     = "*"
#     source_port_range            = "*"
#     destination_port_range       = "*"
#     source_address_prefix        = "*"
#     destination_address_prefixes = azurerm_subnet.decoy-subnet.address_prefixes
#   }
# 
#   security_rule {
#     name                       = "AllowDecoy"
#     priority                   = 900
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "${azurerm_linux_virtual_machine.poc-vm.private_ip_address}/32"
#     destination_address_prefix = "10.0.2.11/32"
#   }
#   security_rule {
#     name                       = "AllowSSH"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
# 
# resource "azurerm_subnet_network_security_group_association" "poc-subnet-1-nsg-association" {
#   subnet_id                 = azurerm_subnet.poc-subnet-1.id
#   network_security_group_id = azurerm_network_security_group.poc-vnet-nsg.id
# }
# 
# resource "azurerm_network_security_group" "poc-nic-nsg" {
#   name                = "poc-nic-nsg"
#   location            = azurerm_resource_group.msc-rg.location
#   resource_group_name = azurerm_resource_group.msc-rg.name
# 
#   security_rule {
#     name                       = "AllowSSH"
#     priority                   = 100
#     protocol                   = "Tcp"
#     direction                  = "Inbound"
#     access                     = "Allow"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#   }
# }
# 
# resource "azurerm_network_interface_security_group_association" "poc-nic-nsg-association" {
#   network_interface_id      = azurerm_network_interface.poc-nic.id
#   network_security_group_id = azurerm_network_security_group.poc-nic-nsg.id
# }
