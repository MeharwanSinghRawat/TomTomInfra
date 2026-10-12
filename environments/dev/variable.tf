variable "resource_group" {
  type = map(object({
    rg_name    = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

variable "virtual_network" {
  type = map(object({
    vnet_name               = string
    rg_name                 = string
    location                = string
    address_space           = list(string)
    dns_servers             = optional(list(string))
    edge_zone               = optional(string)
    bgp_community           = optional(string)
    flow_timeout_in_minutes = optional(number)
    tags                    = optional(map(string))
  }))
}

variable "vnet_peerings" {
  type = map(object({
    name                         = string
    local_vnet                   = string
    remote_vnet                  = string
    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_gateway_transit        = optional(bool)
    use_remote_gateways          = optional(bool)
  }))
  default = {}
}


variable "subnet" {
  type = map(object({
    subnet_name                           = string
    vnet_name                             = string
    rg_name                               = string
    address_prefixes                      = list(string)
    service_endpoints                     = optional(list(string))
    private_endpoint_network_policies     = optional(string)
    private_link_service_network_policies = optional(string)
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })))
  }))
}


variable "public_ip" {
  type = map(object({
    pip_name                = string
    rg_name                 = string
    location                = string
    allocation_method       = string
    sku                     = optional(string)
    idle_timeout_in_minutes = optional(number)
    domain_name_label       = optional(string)
    ip_version              = optional(string)
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    reverse_fqdn            = optional(string)
    tags                    = optional(map(string))
  }))
}

variable "network_nic" {
  type = map(object({
    nic_name                      = string
    location                      = string
    rg_name                       = string
    ip_config_name                = string
    private_ip_meth               = string
    subnet_name                   = string
    vnet_name                     = string
    nsg_key                       = optional(string)
    enable_accelerated_networking = optional(bool)
    enable_ip_forwarding          = optional(bool)
    dns_servers                   = optional(list(string))
    private_ip_address            = optional(string)
    private_ip_address_version    = optional(string)
    public_ip_address_id          = optional(string)
    primary                       = optional(bool)
    tags                          = optional(map(string))
  }))
}

# variable "virtual_machine" {
#   type = map(object({
#     vm_name        = string
#     rg_name        = string
#     location       = string
#     vm_size        = string
#     admin_username = string
#     admin_password = string
#     nic_name       = string
#   }))
# }

variable "virtual_machine" {
  type = map(object({
    vm_name  = string
    rg_name  = string
    location = string
    vm_size  = string
    nic_name = string
    # keyvault_name = string   # KV jahan secrets store hai
    username = string
    password = string
  }))
}



variable "network_nsg" {
  description = "Map of Network Security Groups and their rules"
  type = map(object({
    nsg_name = string
    location = string
    rg_name  = string
    rules = optional(list(object({
      rule_name                  = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
}


variable "azure_bastion" {
  description = "Bastion setup configuration"
  type = map(object({
    bastion_name       = string
    location           = string
    rg_name            = string
    vnet_name          = string
    bastion_subnetname = string
    address_prefixes   = list(string)
    pip_name           = string
  }))
}

variable "application_gateways" {
  description = "Application Gateway configuration"
  type = map(object({
    name        = string
    rg_name     = string
    location    = string
    pip_name    = string
    subnet_name = string
    vnet_name   = string

    sku = object({
      name     = string
      tier     = string
      capacity = number
    })

    gateway_ip_configuration = object({
      name = string
    })

    frontend_ports = map(object({
      name = string
      port = number
    }))

    frontend_ip_configurations = map(object({
      name = string
    }))

    backend_address_pools = map(object({
      name = string
    }))

    backend_http_settings = map(object({
      name                  = string
      cookie_based_affinity = string
      path                  = string
      port                  = number
      protocol              = string
      request_timeout       = number
    }))

    http_listeners = map(object({
      name               = string
      ip_config_name     = string
      frontend_port_name = string
      protocol           = string
    }))

    request_routing_rules = map(object({
      name                       = string
      priority                   = number
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))

    vm_backend_association = optional(map(object({
      backend_pool_name    = string
      ip_config_name       = string
      nic_name             = string
      rg_name              = string
      username_secret_name = optional(string)
      password_secret_name = optional(string)
    })), {})
  }))
}

variable "firewall" {
  type = map(object({
    firewall_name = string
    rg_name       = string
    location      = string
    sku_name      = string
    sku_tier      = string
    pip_name      = optional(string)
    vnet_name     = optional(string)
    subnet_name   = optional(string)

    firewall_policy_id = optional(string)

    dns_servers       = optional(list(string))
    dns_proxy_enabled = optional(bool)
    private_ip_ranges = optional(list(string))
    threat_intel_mode = optional(string)
    zones             = optional(list(string))
    tags              = optional(map(string))

    ip_configuration = optional(list(object({
      name                 = string
      subnet_id            = optional(string)
      public_ip_address_id = optional(string)
    })))

    management_ip_configuration = optional(list(object({
      mic_name             = string
      subnet_id            = string
      public_ip_address_id = string
    })))

    virtual_hub = optional(list(object({
      virtual_hub_id  = string
      public_ip_count = optional(number)
    })))
  }))
}

variable "monitoring_workspaces" {
  description = "Log Analytics workspaces to create for Azure Monitor."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "PerGB2018")
    retention_in_days   = optional(number, 30)
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "monitoring_diagnostic_settings" {
  description = "Azure Monitor diagnostic settings; workspace_key must match a key in monitoring_workspaces."
  type = map(object({
    name                = string
    target_resource_id  = string
    workspace_key       = string
    log_categories      = optional(set(string), [])
    log_category_groups = optional(set(string), [])
    metric_categories   = optional(set(string), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for setting in values(var.monitoring_diagnostic_settings) :
      length(setting.log_categories) + length(setting.log_category_groups) + length(setting.metric_categories) > 0
    ])
    error_message = "Each monitoring diagnostic setting must enable at least one log category, log category group, or metric category."
  }
}


variable "storage_account" {
  description = "Map of storage accounts"
  type = map(object({
    name                      = string
    resource_group_name       = string
    location                  = string
    account_tier              = string
    account_replication_type  = string
    account_kind              = optional(string)
    access_tier               = optional(string)
    enable_https_traffic_only = optional(bool)
    min_tls_version           = optional(string)
    is_hns_enabled            = optional(bool)
    tags                      = optional(map(string))
  }))
}



# variable "keyvaults" {
#   description = "Map of Key Vault configurations"
#   type = map(object({
#     keyvault_name              = string
#     location                   = string
#     rg_name                    = string
#     sku_name                   = optional(string)
#     soft_delete_retention_days = optional(number)
#     key_permissions            = optional(list(string))
#     secret_permissions         = optional(list(string))
#   }))
# }

# variable "secret" {

# }