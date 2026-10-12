data "azurerm_subscription" "current" {}

locals {
  cost_tag_policy = jsondecode(file("../../policies/governance/require-cost-tag.json"))
}

resource "azurerm_policy_definition" "require_cost_tag" {
  name         = "require-cost-tag"
  policy_type  = "Custom"
  mode         = local.cost_tag_policy.properties.mode
  display_name = local.cost_tag_policy.properties.displayName
  description  = local.cost_tag_policy.properties.description
  metadata     = jsonencode(local.cost_tag_policy.properties.metadata)
  parameters   = jsonencode(local.cost_tag_policy.properties.parameters)
  policy_rule  = jsonencode(local.cost_tag_policy.properties.policyRule)
}

resource "azurerm_subscription_policy_assignment" "require_cost_tag" {
  name                 = "require-cost-tag"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.require_cost_tag.id
  display_name         = "Require the Cost tag"
  description          = "Denies supported resources that do not have the Cost tag."
  enforce              = true

  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
  })
}
