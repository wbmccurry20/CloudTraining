terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  cloud {
    organization = "dw_cloud"
    workspaces {
      name = "terraform_azure"
    }
  }
}

## remove provider block once running from root module
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "eastus2"

  tags = {
    Environment = "Getting Started with Terraform"
    Team        = "DevOps"
  }
}

resource "azurerm_storage_account" "DW_storage" {
  name                     = "dwstorage_tfe"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "dwbackendcontainer"
  storage_account_name  = azurerm_storage_account.DW_storage.name
  container_access_type = "blob"
}
