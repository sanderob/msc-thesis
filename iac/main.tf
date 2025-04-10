resource "azurerm_resource_group" "msc-rg" {
  name     = "msc-prod-rg"
  location = "Norway East"
}

module "core" {
  source = "./core"
}

module "poc-local" {
  source = "./poc-local"
  poc-local-vpn-shared-key = var.poc-local-vpn-shared-key
}

module "poc-cloud" {
  source                   = "./poc-cloud"
}