output "private_endpoint_ids" {
  description = "IDs of the created Private Endpoints"
  value       = { for k, v in azurerm_private_endpoint.private_endpoint : k => v.id }
}

output "private_endpoint_network_interfaces" {
  description = "Network interface IDs associated with Private Endpoints"
  value       = { for k, v in azurerm_private_endpoint.private_endpoint : k => v.network_interface }
}

output "private_ip_addresses" {
  description = "Private IP addresses allocated to the Private Endpoints"
  value = {
    for k, v in azurerm_private_endpoint.private_endpoint :
    k => try(v.private_service_connection[0].private_ip_address, null)
  }
}
