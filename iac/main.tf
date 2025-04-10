resource "azurerm_resource_group" "msc-rg" {
  name     = "msc-prod-rg"
  location = "Norway East"
}

module "core" {
  source = "./core"
}

module "poc-cloud" {
  source = "./poc-local"
}

module "poc-cloud" {
  source                   = "./poc-cloud"
  poc-local-vpn-shared-key = module.poc-local.poc-local-vpn-shared-key
}