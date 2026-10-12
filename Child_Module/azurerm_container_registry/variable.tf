variable "container_registries" {
  description = "Map of Azure Container Registries to create"
  type = map(object({
    name                          = string
    rg_name                       = string
    location                      = string
    sku                           = optional(string, "Premium")
    admin_enabled                 = optional(bool, false)
    public_network_access_enabled = optional(bool, true)
    zone_redundancy_enabled       = optional(bool, false)
    tags                          = optional(map(string))
  }))
  default = {}
}
