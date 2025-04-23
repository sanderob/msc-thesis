resource "azurerm_public_ip" "poc-local-public-ip" {
  name                = "poc-local-ip"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  ip_version          = "IPv4"
}

resource "azurerm_virtual_network_gateway" "poc-local-vnet-gateway" {
  name                = "poc-local-vnet-gateway"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  sku = "VpnGw5"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.poc-local-public-ip.id
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.poc-local-subnet-1.id
  }
}

resource "azurerm_local_network_gateway" "poc-local-local-gateway" {
  name                = "fortigate-local-gateway"
  resource_group_name = azurerm_resource_group.msc-rg.name
  location            = azurerm_resource_group.msc-rg.location
  gateway_address     = "77.106.154.138"
  address_space       = ["10.3.0.0/16"]
}


resource "azurerm_virtual_network_gateway_connection" "poc-local-fortigate-local-connection" {
  name                = "fortigate-local-connection"
  location            = azurerm_resource_group.msc-rg.location
  resource_group_name = azurerm_resource_group.msc-rg.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.poc-local-vnet-gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.poc-local-local-gateway.id

  shared_key = var.poc-local-vpn-shared-key
}