# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
cloud {
  organization = "cloud_learning"
  workspaces {
    name = "terraform_azure"
  }
}
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "eastus2"
  
  tags = {
    Environment = "Getting Started with Terraform"
    Team = "DevOps"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name          = "myTFVnet"
  address_space = ["10.0.0.0/16"]
  location      = "eastus2"
  resource_group_name = azurerm_resource_group.rg.name
}


