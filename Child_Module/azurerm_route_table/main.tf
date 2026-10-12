resource "azurerm_route_table" "route_table" {
  for_each                      = var.route_tables
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.rg_name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", false)

  dynamic "route" {
    for_each = lookup(each.value, "routes", [])
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = lookup(each.value, "tags", null)
}

data "azurerm_subnet" "subnet" {
  for_each = {
    for k, v in var.route_table_associations : k => v
    if v.subnet_id == null && v.subnet_name != null && v.vnet_name != null && v.rg_name != null
  }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each = var.route_table_associations

  subnet_id = each.value.subnet_id != null ? each.value.subnet_id : data.azurerm_subnet.subnet[each.key].id
  route_table_id = each.value.route_table_id != null ? each.value.route_table_id : (
    lookup(azurerm_route_table.route_table, each.value.route_table_key, null) != null ?
    azurerm_route_table.route_table[each.value.route_table_key].id : null
  )
}
