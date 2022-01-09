# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = module.az_backend.resource_group_name
    storage_account_name = module.az_backend.storage_account_name
    container_name       = module.az_backend.container_name
    key                  = "terraform.tfstate"
  }
  # SWITCH TO REMOTE BACKEND
  # cloud {
  #   organization = "dw_cloud"
  #   workspaces {
  #     name = "terraform_azure"
  #  }
  # }
 }

provider "azurerm" {
  features {}
}

#INSTANTIATE CHILD MODULE
module "az_backend" {
  source = "./az_backend"
}

# REMOVING TO PASS FROM CHILD MODULE
# resource "azurerm_resource_group" "rg" {
#   name     = "tf_azure_rg"
#   location = "eastus2"
  
#   tags = {
#     Environment = "tf_azure"
#     Team = "DevOps"
#   }
# }

# virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus2"
  resource_group_name = module.az_backend.resource_group_name
}

# subnet
resource "azurerm_subnet" "terraformSubnet" {
  name                 = "tf_subnet"
  resource_group_name  = module.az_backend.resource_group_name
  # needs to be a variable
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes      = ["10.0.1.0/24"]

}

# public IPs
resource "azurerm_public_ip" "terraformpublicip" {
  allocation_method   = "Dynamic"
  location            = "eastus2"
  name                = "tf_publicIP"
  resource_group_name = module.az_backend.resource_group_name

  tags = {
    environment = "tf_azure"
  }
}

# network security and rules
resource "azurerm_network_security_group" "terraformnsg" {
  location            = "eastus2"
  name                = "tfnsg"
  resource_group_name = module.az_backend.resource_group_name

  security_rule {
    access    = "Allow"
    direction = "Inbound"
    name      = "SSH"
    priority  = 1001
    protocol  = "TCP"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "tf_azure"
  }
}

# network interface
resource "azurerm_network_interface" "terraformnic" {
  location            = "eastus2"
  name                = "tfnic"
  resource_group_name = module.az_backend.resource_group_name
  ip_configuration {
    name                          = "tfnicConfig"
    subnet_id                     = azurerm_subnet.terraformSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraformpublicip.id
  }

  tags = {
    environment = "tf_azure"
  }
}

# create security group
resource "azurerm_application_security_group" "app_securitygroup" {
  name                = "tf_azure_sg"
  location            = module.az_backend.resource_group_location
  resource_group_name = module.az_backend.resource_group_name
}

# Connect security group to network interface
resource "azurerm_network_interface_application_security_group_association" "terraformExample" {
    network_interface_id          = azurerm_network_interface.terraformnic.id
    application_security_group_id = azurerm_application_security_group.app_securitygroup.id
}

# Genrate random text for unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # generates a new ID only when resource group is defined
    resource_group = module.az_backend.resource_group_name
  }
  byte_length = 8
}

# REMOVING TO PASS FROM CHILD MODULE
# resource "azurerm_storage_account" "terraformStorageAcct" {
#   account_replication_type = "LRS"
#   account_tier             = "Standard"
#   location                 = "eastus2"
#   name                     = "diag${random_id.randomId.hex}"
#   resource_group_name      = module.az_backend.resource_group_name

#   tags = {
#     environment = "tf_azure"
#   }
# }

# Create (and display) an SSH key
resource "tls_private_key" "terraform_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" {
  value     = tls_private_key.terraform_ssh.private_key_pem
  sensitive = true
}

# Create VM
resource "azurerm_linux_virtual_machine" "terraformVM" {
  location              = "eastus2"
  name                  = "tf_azure_vm"
  network_interface_ids = [azurerm_network_interface.terraformnic.id]
  resource_group_name   = module.az_backend.resource_group_name
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "azure_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name = "tfvm"
  admin_username = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    public_key = tls_private_key.terraform_ssh.public_key_openssh
    username   = "azureuser"
  }

  boot_diagnostics {
    storage_account_uri = module.az_backend.storage_account_uri
  }

  tags = {
    environment = "tf_azure"
  }
}

# NOTES: The machine will be created with a new SSH public key. To get the corresponding private key, run terraform output -raw tls_private_key. Save the output to a file on the local machine and use it to log in to the virtual machine.