variable "recovery_vaults" {
  description = "Map of Recovery Services Vaults to create"
  type = map(object({
    name                = string
    location            = string
    rg_name             = string
    sku                 = optional(string, "Standard")
    soft_delete_enabled = optional(bool, true)
    storage_mode_type   = optional(string, "GeoRedundant")
    tags                = optional(map(string))
  }))
  default = {}
}

variable "vm_backup_policies" {
  description = "Map of VM Backup Policies"
  type = map(object({
    name                  = string
    rg_name               = string
    recovery_vault_name   = optional(string)
    recovery_vault_key    = optional(string)
    timezone              = optional(string, "UTC")
    frequency             = optional(string, "Daily")
    time                  = optional(string, "23:00")
    retention_daily_count = optional(number, 30)
    retention_weekly = optional(object({
      count    = number
      weekdays = list(string)
    }))
    retention_monthly = optional(object({
      count    = number
      weekdays = optional(list(string))
      weeks    = optional(list(string))
    }))
  }))
  default = {}
}
