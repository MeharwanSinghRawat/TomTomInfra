output "firewall_policy_ids" {
  description = "IDs of the created Firewall Policies"
  value       = { for k, v in azurerm_firewall_policy.fw_policy : k => v.id }
}

output "firewall_policy_names" {
  description = "Names of the created Firewall Policies"
  value       = { for k, v in azurerm_firewall_policy.fw_policy : k => v.name }
}

output "rule_collection_group_ids" {
  description = "IDs of the created Rule Collection Groups"
  value       = { for k, v in azurerm_firewall_policy_rule_collection_group.rcg : k => v.id }
}
