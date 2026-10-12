output "dns_zone_ids" {
  description = "IDs of the created Private DNS Zones"
  value       = { for k, v in azurerm_private_dns_zone.dns_zone : k => v.id }
}

output "dns_zone_names" {
  description = "Names of the created Private DNS Zones"
  value       = { for k, v in azurerm_private_dns_zone.dns_zone : k => v.name }
}

output "vnet_link_ids" {
  description = "IDs of the created Virtual Network Links"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.vnet_link : k => v.id }
}
