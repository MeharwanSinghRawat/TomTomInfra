resource "azurerm_role_definition" "custom_role" {
  for_each    = var.custom_roles
  name        = each.value.name
  scope       = each.value.scope
  description = lookup(each.value, "description", null)

  permissions {
    actions          = lookup(each.value.permissions, "actions", [])
    not_actions      = lookup(each.value.permissions, "not_actions", [])
    data_actions     = lookup(each.value.permissions, "data_actions", [])
    not_data_actions = lookup(each.value.permissions, "not_data_actions", [])
  }

  assignable_scopes = lookup(each.value, "assignable_scopes", [each.value.scope])
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each                         = var.role_assignments
  scope                            = each.value.scope
  role_definition_name             = lookup(each.value, "role_definition_name", null)
  role_definition_id               = lookup(each.value, "role_definition_id", null)
  principal_id                     = each.value.principal_id
  skip_service_principal_aad_check = lookup(each.value, "skip_service_principal_aad_check", false)
  description                      = lookup(each.value, "description", null)
}
