output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_uri" {
  value = azurerm_storage_account.DW_storage.primary_blob_endpoint
}

output "storage_account_name" {
  value = azurerm_storage_account.DW_storage.name
}

output "container_name" {
  value = azurerm_storage_container.example.name
}