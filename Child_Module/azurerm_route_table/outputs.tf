output "route_table_ids" {
  description = "IDs of the created Route Tables"
  value       = { for k, v in azurerm_route_table.route_table : k => v.id }
}

output "route_table_names" {
  description = "Names of the created Route Tables"
  value       = { for k, v in azurerm_route_table.route_table : k => v.name }
}

output "route_table_subnets" {
  description = "Subnets associated with Route Tables"
  value       = { for k, v in azurerm_route_table.route_table : k => v.subnets }
}
