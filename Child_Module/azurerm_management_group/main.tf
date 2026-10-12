resource "azurerm_management_group" "mg" {
  for_each                   = var.management_groups
  name                       = each.value.name
  display_name               = lookup(each.value, "display_name", each.value.name)
  parent_management_group_id = lookup(each.value, "parent_management_group_id", null)
  subscription_ids           = lookup(each.value, "subscription_ids", [])
}
