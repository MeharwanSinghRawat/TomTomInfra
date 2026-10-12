output "recovery_vault_ids" {
  description = "IDs of the created Recovery Services Vaults"
  value       = { for k, v in azurerm_recovery_services_vault.vault : k => v.id }
}

output "recovery_vault_names" {
  description = "Names of the created Recovery Services Vaults"
  value       = { for k, v in azurerm_recovery_services_vault.vault : k => v.name }
}

output "vm_backup_policy_ids" {
  description = "IDs of the created VM Backup Policies"
  value       = { for k, v in azurerm_backup_policy_vm.vm_policy : k => v.id }
}
