data "azurerm_subnet" "gateway_subnet" {
  for_each = {
    for k, v in var.virtual_network_gateways : k => v
    if v.subnet_id == null && v.vnet_name != null && v.rg_name != null
  }
  name                 = "GatewaySubnet"
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

resource "azurerm_public_ip" "gateway_pip" {
  for_each = {
    for k, v in var.virtual_network_gateways : k => v
    if v.create_public_ip == true
  }
  name                = coalesce(each.value.public_ip_name, "${each.value.name}-pip")
  location            = each.value.location
  resource_group_name = each.value.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = lookup(each.value, "zones", null)
  tags                = lookup(each.value, "tags", null)
}

data "azurerm_public_ip" "existing_pip" {
  for_each = {
    for k, v in var.virtual_network_gateways : k => v
    if v.create_public_ip == false && v.public_ip_name != null
  }
  name                = each.value.public_ip_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  for_each            = var.virtual_network_gateways
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  type     = lookup(each.value, "type", "Vpn")
  vpn_type = lookup(each.value, "vpn_type", "RouteBased")
  sku      = lookup(each.value, "sku", "VpnGw1")

  active_active = lookup(each.value, "active_active", false)
  enable_bgp    = lookup(each.value, "enable_bgp", false)
  generation    = lookup(each.value, "generation", "Generation1")

  ip_configuration {
    name = lookup(each.value, "ip_configuration_name", "vnetGatewayConfig")
    public_ip_address_id = each.value.create_public_ip ? (
      azurerm_public_ip.gateway_pip[each.key].id
      ) : (
      each.value.public_ip_address_id != null ? each.value.public_ip_address_id : data.azurerm_public_ip.existing_pip[each.key].id
    )
    subnet_id = each.value.subnet_id != null ? each.value.subnet_id : data.azurerm_subnet.gateway_subnet[each.key].id
  }

  dynamic "bgp_settings" {
    for_each = lookup(each.value, "bgp_settings", null) != null ? [each.value.bgp_settings] : []
    content {
      asn         = bgp_settings.value.asn
      peer_weight = lookup(bgp_settings.value, "peer_weight", 0)
    }
  }

  tags = lookup(each.value, "tags", null)
}
