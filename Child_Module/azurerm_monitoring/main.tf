resource "azurerm_log_analytics_workspace" "workspace" {
  for_each = var.workspaces
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days
  tags                = each.value.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  for_each = var.diagnostic_settings
  name                       = each.value.name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace[each.value.workspace_key].id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = each.value.log_category_groups
    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = each.value.metric_categories
    content {
      category = enabled_metric.value
    }
  }
}
