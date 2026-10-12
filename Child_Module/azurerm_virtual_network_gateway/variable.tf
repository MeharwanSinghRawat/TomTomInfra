variable "virtual_network_gateways" {
  description = "Map of Virtual Network Gateways to create"
  type = map(object({
    name                  = string
    location              = string
    rg_name               = string
    vnet_name             = optional(string)
    subnet_id             = optional(string)
    type                  = optional(string, "Vpn")
    vpn_type              = optional(string, "RouteBased")
    sku                   = optional(string, "VpnGw1")
    generation            = optional(string, "Generation1")
    active_active         = optional(bool, false)
    enable_bgp            = optional(bool, false)
    create_public_ip      = optional(bool, true)
    public_ip_name        = optional(string)
    public_ip_address_id  = optional(string)
    ip_configuration_name = optional(string, "vnetGatewayConfig")
    zones                 = optional(list(string))
    bgp_settings = optional(object({
      asn         = number
      peer_weight = optional(number, 0)
    }))
    tags = optional(map(string))
  }))
  default = {}
}
