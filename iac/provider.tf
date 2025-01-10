terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14"
    }
  }
  backend "azurerm" {}
  required_version = "~> 1.10.4"
}

provider "azurerm" {
  features {}
  tenant_id       = "bf34d03a-c205-4d66-be38-2905964b5c5b"
  subscription_id = "d1bbe07c-713a-4149-8c8e-313060b62dd0"
  client_id       = "6eac731a-8b06-403f-8f44-8fc0f54cf642"
  client_secret   = var.client_secret
}