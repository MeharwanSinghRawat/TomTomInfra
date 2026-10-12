resource "azurerm_private_dns_zone" "dns_zone" {
  for_each            = var.dns_zones
  name                = each.value.name
  resource_group_name = each.value.rg_name
  tags                = lookup(each.value, "tags", null)
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  for_each              = var.vnet_links
  name                  = each.value.name
  resource_group_name   = each.value.rg_name
  private_dns_zone_name = each.value.dns_zone_name != null ? each.value.dns_zone_name : azurerm_private_dns_zone.dns_zone[each.value.dns_zone_key].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = lookup(each.value, "registration_enabled", false)
  tags                  = lookup(each.value, "tags", null)
}
