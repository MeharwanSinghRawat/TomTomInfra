output "management_group_assignment_ids" {
  description = "IDs of the created Management Group Policy Assignments"
  value       = { for k, v in azurerm_management_group_policy_assignment.mg_assignment : k => v.id }
}

output "subscription_assignment_ids" {
  description = "IDs of the created Subscription Policy Assignments"
  value       = { for k, v in azurerm_subscription_policy_assignment.sub_assignment : k => v.id }
}

output "management_group_assignment_identities" {
  description = "Principal IDs of SystemAssigned identities for Management Group assignments"
  value = {
    for k, v in azurerm_management_group_policy_assignment.mg_assignment :
    k => try(v.identity[0].principal_id, null)
  }
}

output "subscription_assignment_identities" {
  description = "Principal IDs of SystemAssigned identities for Subscription assignments"
  value = {
    for k, v in azurerm_subscription_policy_assignment.sub_assignment :
    k => try(v.identity[0].principal_id, null)
  }
}
