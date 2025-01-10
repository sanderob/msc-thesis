resource "azurerm_virtual_network" "vnet" {
  name                = "msc-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space = [
    "10.0.0.0/16"
  ]
}

resource "azurerm_subnet" "fortideceptor-subnet" {
  name                 = "fortideceptor-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    "10.0.1.0/24"
  ]
}

resource "azurerm_subnet" "decoy-subnet" {
  name                 = "decoy-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    "10.0.2.0/24"
  ]
}

resource "azurerm_network_security_group" "fortideceptor-subnet-nsg" {
  name                = "fortideceptor-subnet-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "Allow_ports"
    protocol                   = "tcp"
    direction                  = "Inbound"
    priority                   = 200
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_ranges = [
      "443",
      "8443",
      "445"
    ]
  }
}

resource "azurerm_subnet_network_security_group_association" "fortideceptor-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.fortideceptor-subnet.id
  network_security_group_id = azurerm_network_security_group.fortideceptor-subnet-nsg.id
}

resource "azurerm_public_ip" "fortideceptor-public-ip" {
  name                = "fortideceptor-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
}