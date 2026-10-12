variable "workspaces" {
  description = "Log Analytics workspaces to create, keyed by a caller-defined name."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "PerGB2018")
    retention_in_days   = optional(number, 30)
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "diagnostic_settings" {
  description = "Diagnostic settings to send resource logs and metrics to a workspace created by this module."
  type = map(object({
    name                = string
    target_resource_id  = string
    workspace_key       = string
    log_categories      = optional(set(string), [])
    log_category_groups = optional(set(string), [])
    metric_categories   = optional(set(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for setting in values(var.diagnostic_settings) :
      length(setting.log_categories) + length(setting.log_category_groups) + length(setting.metric_categories) > 0
    ])
    error_message = "Each diagnostic setting must enable at least one log category, log category group, or metric category."
  }
}
