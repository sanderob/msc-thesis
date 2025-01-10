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
  subscription_id = var.subscription_id
}