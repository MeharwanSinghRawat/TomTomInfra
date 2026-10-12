variable "route_tables" {
  description = "Map of Route Tables to configure"
  type = map(object({
    name                          = string
    location                      = string
    rg_name                       = string
    disable_bgp_route_propagation = optional(bool, false)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
    tags = optional(map(string))
  }))
  default = {}
}

variable "route_table_associations" {
  description = "Map of Subnet to Route Table associations"
  type = map(object({
    subnet_id       = optional(string)
    subnet_name     = optional(string)
    vnet_name       = optional(string)
    rg_name         = optional(string)
    route_table_id  = optional(string)
    route_table_key = optional(string)
  }))
  default = {}
}
