resource "azurerm_resource_group" "msc-rg" {
  name     = "msc-prod-rg"
  location = "Norway East"
}

resource "azurerm_resource_provider_registration" "peering-feature" {
  name = "Microsoft.Network"

  feature {
    name       = "AllowMultiplePeeringLinksBetweenVnets"
    registered = true
  }
}