resource "azurerm_container_registry" "acr" {
  for_each                      = var.container_registries
  name                          = each.value.name
  resource_group_name           = each.value.rg_name
  location                      = each.value.location
  sku                           = lookup(each.value, "sku", "Premium")
  admin_enabled                 = lookup(each.value, "admin_enabled", false)
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  zone_redundancy_enabled       = lookup(each.value, "zone_redundancy_enabled", false)
  tags                          = lookup(each.value, "tags", null)
}
