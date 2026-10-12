resource "azurerm_recovery_services_vault" "vault" {
  for_each            = var.recovery_vaults
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  sku                 = lookup(each.value, "sku", "Standard")
  soft_delete_enabled = lookup(each.value, "soft_delete_enabled", true)
  storage_mode_type   = lookup(each.value, "storage_mode_type", "GeoRedundant")
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_backup_policy_vm" "vm_policy" {
  for_each            = var.vm_backup_policies
  name                = each.value.name
  resource_group_name = each.value.rg_name
  recovery_vault_name = each.value.recovery_vault_name != null ? each.value.recovery_vault_name : azurerm_recovery_services_vault.vault[each.value.recovery_vault_key].name
  timezone            = lookup(each.value, "timezone", "UTC")

  backup {
    frequency = lookup(each.value, "frequency", "Daily")
    time      = lookup(each.value, "time", "23:00")
  }

  retention_daily {
    count = lookup(each.value, "retention_daily_count", 30)
  }

  dynamic "retention_weekly" {
    for_each = lookup(each.value, "retention_weekly", null) != null ? [each.value.retention_weekly] : []
    content {
      count    = retention_weekly.value.count
      weekdays = retention_weekly.value.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = lookup(each.value, "retention_monthly", null) != null ? [each.value.retention_monthly] : []
    content {
      count    = retention_monthly.value.count
      weekdays = lookup(retention_monthly.value, "weekdays", null)
      weeks    = lookup(retention_monthly.value, "weeks", null)
    }
  }
}
