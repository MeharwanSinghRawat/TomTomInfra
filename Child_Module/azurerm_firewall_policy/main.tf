resource "azurerm_firewall_policy" "fw_policy" {
  for_each                 = var.firewall_policies
  name                     = each.value.name
  resource_group_name      = each.value.rg_name
  location                 = each.value.location
  sku                      = lookup(each.value, "sku", "Standard")
  threat_intelligence_mode = lookup(each.value, "threat_intelligence_mode", "Alert")
  base_policy_id           = lookup(each.value, "base_policy_id", null)

  dynamic "dns" {
    for_each = lookup(each.value, "dns", null) != null ? [each.value.dns] : []
    content {
      proxy_enabled = lookup(dns.value, "proxy_enabled", false)
      servers       = lookup(dns.value, "servers", null)
    }
  }

  tags = lookup(each.value, "tags", null)
}

resource "azurerm_firewall_policy_rule_collection_group" "rcg" {
  for_each           = var.rule_collection_groups
  name               = each.value.name
  firewall_policy_id = each.value.firewall_policy_id != null ? each.value.firewall_policy_id : azurerm_firewall_policy.fw_policy[each.value.firewall_policy_key].id
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = lookup(each.value, "network_rule_collections", [])
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = lookup(rule.value, "source_addresses", null)
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)
          destination_addresses = lookup(rule.value, "destination_addresses", null)
          destination_ip_groups = lookup(rule.value, "destination_ip_groups", null)
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = lookup(each.value, "application_rule_collections", [])
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name              = rule.value.name
          source_addresses  = lookup(rule.value, "source_addresses", null)
          destination_fqdns = lookup(rule.value, "destination_fqdns", null)
          destination_urls  = lookup(rule.value, "destination_urls", null)
          web_categories    = lookup(rule.value, "web_categories", null)

          dynamic "protocols" {
            for_each = lookup(rule.value, "protocols", [])
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = lookup(each.value, "nat_rule_collections", [])
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols
          source_addresses    = lookup(rule.value, "source_addresses", null)
          destination_address = lookup(rule.value, "destination_address", null)
          destination_ports   = lookup(rule.value, "destination_ports", null)
          translated_address  = lookup(rule.value, "translated_address", null)
          translated_port     = lookup(rule.value, "translated_port", null)
        }
      }
    }
  }
}
