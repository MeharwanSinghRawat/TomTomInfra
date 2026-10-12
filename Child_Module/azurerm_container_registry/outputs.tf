output "registry_ids" {
  description = "IDs of the created Container Registries"
  value       = { for k, v in azurerm_container_registry.acr : k => v.id }
}

output "registry_login_servers" {
  description = "Login servers for the Container Registries"
  value       = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}

output "registry_admin_usernames" {
  description = "Admin usernames for the Container Registries"
  value       = { for k, v in azurerm_container_registry.acr : k => v.admin_username }
}
