terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
    }
  }
  backend "azurerm" {}
  required_version = "~> 1.11.2"
}

provider "azurerm" {
  features {}
}