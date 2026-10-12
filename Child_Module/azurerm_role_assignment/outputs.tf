output "role_assignment_ids" {
  description = "IDs of the created Role Assignments"
  value       = { for k, v in azurerm_role_assignment.role_assignment : k => v.id }
}

output "custom_role_ids" {
  description = "IDs of the created Custom Role Definitions"
  value       = { for k, v in azurerm_role_definition.custom_role : k => v.role_definition_resource_id }
}
