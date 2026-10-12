resource "azurerm_management_group_policy_assignment" "mg_assignment" {
  for_each             = var.management_group_assignments
  name                 = each.value.name
  management_group_id  = each.value.management_group_id
  policy_definition_id = each.value.policy_definition_id
  display_name         = lookup(each.value, "display_name", null)
  description          = lookup(each.value, "description", null)
  enforce              = lookup(each.value, "enforce", true)
  parameters           = lookup(each.value, "parameters", null)
  location             = lookup(each.value, "location", null)

  dynamic "identity" {
    for_each = lookup(each.value, "identity_type", null) != null ? [each.value.identity_type] : []
    content {
      type = identity.value
    }
  }

  dynamic "non_compliance_message" {
    for_each = lookup(each.value, "non_compliance_messages", [])
    content {
      content = non_compliance_message.value
    }
  }
}

resource "azurerm_subscription_policy_assignment" "sub_assignment" {
  for_each             = var.subscription_assignments
  name                 = each.value.name
  subscription_id      = each.value.subscription_id
  policy_definition_id = each.value.policy_definition_id
  display_name         = lookup(each.value, "display_name", null)
  description          = lookup(each.value, "description", null)
  enforce              = lookup(each.value, "enforce", true)
  parameters           = lookup(each.value, "parameters", null)
  location             = lookup(each.value, "location", null)

  dynamic "identity" {
    for_each = lookup(each.value, "identity_type", null) != null ? [each.value.identity_type] : []
    content {
      type = identity.value
    }
  }

  dynamic "non_compliance_message" {
    for_each = lookup(each.value, "non_compliance_messages", [])
    content {
      content = non_compliance_message.value
    }
  }
}
