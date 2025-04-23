
resource "azurerm_virtual_network" "poc-local-vnet" {
  name                = "poc-local-vnet"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
  address_space = [
    "10.2.0.0/16"
  ]
}

resource "azurerm_subnet" "poc-local-subnet-1" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.msc-rg.name
  virtual_network_name = azurerm_virtual_network.poc-local-vnet.name
  address_prefixes = [
    "10.2.1.0/24"
  ]
}

resource "azurerm_virtual_network_peering" "poc-local-decoy-vnet-peering" {
  name                      = "poc-local-decoy-vnet-peering"
  resource_group_name       = azurerm_resource_group.msc-rg.name
  virtual_network_name      = azurerm_virtual_network.poc-local-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  allow_virtual_network_access           = true
  allow_forwarded_traffic                = true
  allow_gateway_transit                  = false
  only_ipv6_peering_enabled              = false
  peer_complete_virtual_networks_enabled = false
  use_remote_gateways                    = false

  local_subnet_names = [
    azurerm_subnet.poc-local-subnet-1.name
  ]

  remote_subnet_names = [
    azurerm_subnet.decoy-subnet.name
  ]

  triggers = {
    remote_address_space = join(",", azurerm_virtual_network.vnet.address_space)
  }
}

resource "azurerm_virtual_network_peering" "decoy-poc-local-vnet-peering" {
  name                      = "decoy-poc-local-vnet-peering"
  resource_group_name       = azurerm_resource_group.msc-rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.poc-local-vnet.id

  allow_virtual_network_access           = true
  allow_forwarded_traffic                = true
  allow_gateway_transit                  = false
  only_ipv6_peering_enabled              = false
  peer_complete_virtual_networks_enabled = false
  use_remote_gateways                    = false

  local_subnet_names = [
    azurerm_subnet.decoy-subnet.name
  ]

  remote_subnet_names = [
    azurerm_subnet.poc-local-subnet-1.name
  ]
}

resource "azurerm_network_security_group" "poc-local-vnet-nsg" {
  name                = "poc-local-vnet-nsg"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name

  security_rule {
    name                         = "DenySubnet"
    priority                     = 1000
    direction                    = "Outbound"
    access                       = "Deny"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefixes = azurerm_subnet.decoy-subnet.address_prefixes
  }

  security_rule {
    name                       = "AllowDecoy"
    priority                   = 900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "192.168.1.0/24" # FortiGate LAN Range
    destination_address_prefix = "10.0.2.12/32"
  }
}

resource "azurerm_subnet_network_security_group_association" "poc-local-subnet-1-nsg-association" {
  subnet_id                 = azurerm_subnet.poc-local-subnet-1.id
  network_security_group_id = azurerm_network_security_group.poc-local-vnet-nsg.id
}