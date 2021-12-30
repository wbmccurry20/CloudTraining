output "resource_group_name" {
    description = "Name of the Azure resource group."
    value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
    description = "Name of the Azure storage account."
    value = azurerm_storage_account.DW_storage.name
}

output "container_name" {
    description = "Name of the Azure container."
    value = azurerm_storage_container.example.name
}