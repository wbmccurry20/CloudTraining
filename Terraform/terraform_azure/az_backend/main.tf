terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90.0"
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
  name     = TF_VAR_resource_group_name
  location = "eastus2"

  tags = {
    Environment = "Getting Started with Terraform"
    Team        = "DevOps"
  }
}

# Genrate random text for unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # generates a new ID only when resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "DW_storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "eastus2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "example" {
  name                  = "dwbackendcontainer"
  storage_account_name  = azurerm_storage_account.DW_storage.name
  container_access_type = "blob"
}
