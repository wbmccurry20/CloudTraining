output "resource_group_name" {
  description = "Name of the Azure resource group."
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "The location of the resource group."
  value = azurerm_resource_group.rg.location
}

output "storage_account_name" {
  description = "Name of the Azure storage account."
  value       = azurerm_storage_account.DW_storage.name
}

output "container_name" {
  description = "Name of the Azure container."
  value       = azurerm_storage_container.example.name
}

output "storage_account_uri" {
  description = "The endpoint URL for blob storage."
  value = azurerm_storage_account.DW_storage.primary_blob_endpoint
}