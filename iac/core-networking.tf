resource "azurerm_virtual_network" "vnet" {
  name                = "msc-vnet"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
  address_space = [
    "10.0.0.0/16"
  ]
}

resource "azurerm_subnet" "fortideceptor-subnet" {
  name                 = "fortideceptor-subnet"
  resource_group_name  = azurerm_resource_group.msc-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    "10.0.1.0/24"
  ]
}

resource "azurerm_subnet" "decoy-subnet" {
  name                 = "decoy-subnet"
  resource_group_name  = azurerm_resource_group.msc-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [
    "10.0.2.0/24"
  ]
}

resource "azurerm_network_security_group" "fortideceptor-subnet-nsg" {
  name                = "fortideceptor-subnet-nsg"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name

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
    protocol                   = "Tcp"
    direction                  = "Inbound"
    access                     = "Allow"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
  }

  security_rule {
    name                       = "AllowPorts"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    access                     = "Allow"
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

resource "azurerm_network_security_group" "decoy-subnet-nsg" {
  name                = "decoy-subnet-nsg"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
}

resource "azurerm_subnet_network_security_group_association" "decoy-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.decoy-subnet.id
  network_security_group_id = azurerm_network_security_group.decoy-subnet-nsg.id
}

resource "azurerm_network_security_group" "fortideceptor-decoy-nic-1-nsg" {
  name                = "fortideceptor-decoy-nic-1-nsg"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 900
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                   = "AllowDecoyPocVMInbound"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "*"
    source_port_range      = "*"
    destination_port_range = "*"
    source_address_prefixes = [
      "10.1.1.4/32",
      "77.106.154.138/32"
    ]
    destination_address_prefix = "10.0.2.11/32"
  }
}

resource "azurerm_network_interface_security_group_association" "fortideceptor-decoy-nic-1-nsg-association" {
  network_interface_id      = azurerm_network_interface.fortideceptor-decoy-nic.id
  network_security_group_id = azurerm_network_security_group.fortideceptor-decoy-nic-1-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "fortideceptor-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.fortideceptor-subnet.id
  network_security_group_id = azurerm_network_security_group.fortideceptor-subnet-nsg.id
}

resource "azurerm_public_ip" "fortideceptor-public-ip" {
  name                = "fortideceptor-public-ip"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
}