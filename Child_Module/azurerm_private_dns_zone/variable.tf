variable "dns_zones" {
  description = "Map of Private DNS Zones to create"
  type = map(object({
    name    = string
    rg_name = string
    tags    = optional(map(string))
  }))
  default = {}
}

variable "vnet_links" {
  description = "Map of Virtual Network Links for Private DNS Zones"
  type = map(object({
    name                 = string
    rg_name              = string
    dns_zone_name        = optional(string)
    dns_zone_key         = optional(string)
    vnet_id              = string
    registration_enabled = optional(bool, false)
    tags                 = optional(map(string))
  }))
  default = {}
}
