terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
    }
  }
  backend "azurerm" {}
  required_version = "~> 1.10.4"
}

provider "azurerm" {
  features {}
}