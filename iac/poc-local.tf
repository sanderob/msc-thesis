
resource "azurerm_virtual_network" "poc-local-vnet" {
  name                = "poc-local-vnet"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
  address_space = [
    "10.2.0.0/16"
  ]
}

resource "azurerm_subnet" "poc-local-subnet-1" {
  name                 = "poc-local-gateway-subnet"
  resource_group_name  = azurerm_resource_group.msc-rg.name
  virtual_network_name = azurerm_virtual_network.poc-vnet.name
  address_prefixes = [
    "10.2.1.0/24"
  ]
}

resource "azurerm_network_security_group" "poc-local-vnet-nsg" {
  name                = "poc-local-vnet-nsg"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
}

resource "azurerm_subnet_network_security_group_association" "poc-local-subnet-1-nsg-association" {
  subnet_id                 = azurerm_subnet.poc-local-subnet-1.id
  network_security_group_id = azurerm_network_security_group.poc-local-vnet-nsg.id
}

resource "azurerm_public_ip" "poc-local-public-ip" {
  name                = "poc-local-ip"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
}
