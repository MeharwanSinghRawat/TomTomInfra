output "gateway_ids" {
  description = "IDs of the created Virtual Network Gateways"
  value       = { for k, v in azurerm_virtual_network_gateway.vnet_gateway : k => v.id }
}

output "gateway_names" {
  description = "Names of the created Virtual Network Gateways"
  value       = { for k, v in azurerm_virtual_network_gateway.vnet_gateway : k => v.name }
}

output "gateway_public_ip_ids" {
  description = "Public IP IDs created for the Gateways"
  value       = { for k, v in azurerm_public_ip.gateway_pip : k => v.id }
}

output "gateway_public_ip_addresses" {
  description = "Public IP addresses allocated to the Gateways"
  value       = { for k, v in azurerm_public_ip.gateway_pip : k => v.ip_address }
}
