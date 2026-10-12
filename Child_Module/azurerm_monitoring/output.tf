output "workspace_ids" {
  description = "Resource IDs of the created Log Analytics workspaces, keyed by the input map key."
  value       = { for key, workspace in azurerm_log_analytics_workspace.workspace : key => workspace.id }
}

output "diagnostic_setting_ids" {
  description = "Resource IDs of the created diagnostic settings, keyed by the input map key."
  value       = { for key, setting in azurerm_monitor_diagnostic_setting.diagnostic_setting : key => setting.id }
}
