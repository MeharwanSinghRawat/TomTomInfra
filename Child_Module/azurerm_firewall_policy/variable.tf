variable "firewall_policies" {
  description = "Map of Azure Firewall Policies to create"
  type = map(object({
    name                     = string
    rg_name                  = string
    location                 = string
    sku                      = optional(string, "Standard")
    threat_intelligence_mode = optional(string, "Alert")
    base_policy_id           = optional(string)
    dns = optional(object({
      proxy_enabled = optional(bool, false)
      servers       = optional(list(string))
    }))
    tags = optional(map(string))
  }))
  default = {}
}

variable "rule_collection_groups" {
  description = "Map of Firewall Policy Rule Collection Groups"
  type = map(object({
    name                = string
    firewall_policy_id  = optional(string)
    firewall_policy_key = optional(string)
    priority            = number
    network_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_ip_groups = optional(list(string))
        destination_ports     = list(string)
      }))
    })), [])
    application_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name              = string
        source_addresses  = optional(list(string))
        destination_fqdns = optional(list(string))
        destination_urls  = optional(list(string))
        web_categories    = optional(list(string))
        protocols = optional(list(object({
          type = string
          port = number
        })), [])
      }))
    })), [])
    nat_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                = string
        protocols           = list(string)
        source_addresses    = optional(list(string))
        destination_address = optional(string)
        destination_ports   = optional(list(string))
        translated_address  = optional(string)
        translated_port     = optional(number)
      }))
    })), [])
  }))
  default = {}
}
