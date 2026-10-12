data "azurerm_subnet" "subnet" {
  for_each = {
    for k, v in var.private_endpoints : k => v
    if v.subnet_id == null && v.subnet_name != null && v.vnet_name != null && v.rg_name != null
  }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = var.private_endpoints
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  subnet_id = each.value.subnet_id != null ? each.value.subnet_id : data.azurerm_subnet.subnet[each.key].id

  private_service_connection {
    name                           = each.value.private_service_connection.name
    private_connection_resource_id = each.value.private_service_connection.private_connection_resource_id
    subresource_names              = lookup(each.value.private_service_connection, "subresource_names", null)
    is_manual_connection           = lookup(each.value.private_service_connection, "is_manual_connection", false)
    request_message                = lookup(each.value.private_service_connection, "request_message", null)
  }

  dynamic "private_dns_zone_group" {
    for_each = lookup(each.value, "private_dns_zone_group", null) != null ? [each.value.private_dns_zone_group] : []
    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  dynamic "ip_configuration" {
    for_each = lookup(each.value, "ip_configuration", null) != null ? [each.value.ip_configuration] : []
    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = lookup(ip_configuration.value, "subresource_name", null)
      member_name        = lookup(ip_configuration.value, "member_name", null)
    }
  }

  tags = lookup(each.value, "tags", null)
}
