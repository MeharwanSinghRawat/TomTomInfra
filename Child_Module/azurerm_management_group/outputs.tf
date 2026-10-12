output "management_group_ids" {
  description = "IDs of the created Management Groups"
  value       = { for k, v in azurerm_management_group.mg : k => v.id }
}

output "management_group_names" {
  description = "Names of the created Management Groups"
  value       = { for k, v in azurerm_management_group.mg : k => v.name }
}
