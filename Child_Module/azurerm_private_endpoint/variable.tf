variable "private_endpoints" {
  description = "Map of Private Endpoints to configure"
  type = map(object({
    name        = string
    location    = string
    rg_name     = string
    subnet_id   = optional(string)
    subnet_name = optional(string)
    vnet_name   = optional(string)

    private_service_connection = object({
      name                           = string
      private_connection_resource_id = string
      subresource_names              = optional(list(string))
      is_manual_connection           = optional(bool, false)
      request_message                = optional(string)
    })

    private_dns_zone_group = optional(object({
      name                 = string
      private_dns_zone_ids = list(string)
    }))

    ip_configuration = optional(object({
      name               = string
      private_ip_address = string
      subresource_name   = optional(string)
      member_name        = optional(string)
    }))

    tags = optional(map(string))
  }))
  default = {}
}
