terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27"
    }
  }
  backend "azurerm" {}
  required_version = "~> 1.11.4"
}

provider "azurerm" {
  features {}
}