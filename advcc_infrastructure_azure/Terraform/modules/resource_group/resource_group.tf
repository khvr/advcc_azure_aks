resource "azurerm_resource_group" "ResourceGroup" {
  name     = var.resourceGroupName
  location = var.location
}

output "res_group_name" {
  value = azurerm_resource_group.ResourceGroup.name
}
