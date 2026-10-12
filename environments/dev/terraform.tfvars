resource_group = {
  rg1 = {
    rg_name    = "hub-and-spoke-rg"
    location   = "east us"
    managed_by = "azurerm_user_assigned_identity.test"
  }
}

virtual_network = {
  Hubvnet = {
    vnet_name     = "HubVnet"
    rg_name       = "hub-and-spoke-rg"
    location      = "east us"
    address_space = ["10.0.0.0/16"]
  }

  spoke1vnet = {
    vnet_name     = "spokevnet1"
    rg_name       = "hub-and-spoke-rg"
    location      = "east us"
    address_space = ["10.1.0.0/16"]
  }
}

vnet_peerings = {
  hub_to_spoke1 = {
    name                         = "HubVnet-to-spokevnet1"
    local_vnet                   = "Hubvnet"
    remote_vnet                  = "spoke1vnet"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }

  spoke1_to_hub = {
    name                         = "spokevnet1-to-HubVnet"
    local_vnet                   = "spoke1vnet"
    remote_vnet                  = "Hubvnet"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}

subnet = {
  aplicationgtw = {
    subnet_name      = "AppgatewaySubnet"
    vnet_name        = "HubVnet"
    rg_name          = "hub-and-spoke-rg"
    address_prefixes = ["10.0.3.0/24"]
  }

  frontendsubnet = {
    subnet_name      = "frontendsubnet"
    vnet_name        = "spokevnet1"
    rg_name          = "hub-and-spoke-rg"
    address_prefixes = ["10.1.1.0/24"]
  }

  backendsubnet = {
    subnet_name      = "backendsubnet"
    vnet_name        = "spokevnet1"
    rg_name          = "hub-and-spoke-rg"
    address_prefixes = ["10.1.2.0/24"]
  }
  subnet1 = {
    subnet_name      = "AzureFirewallSubnet"
    vnet_name        = "HubVnet"
    rg_name          = "hub-and-spoke-rg"
    address_prefixes = ["10.0.0.0/26"]
  }


  subnet4 = {
    subnet_name      = "GatewaySubnet"
    vnet_name        = "HubVnet"
    rg_name          = "hub-and-spoke-rg"
    address_prefixes = ["10.0.1.0/27"]
  }

}

public_ip = {
  appgateway = {
    pip_name          = "App-gateway-pip"
    rg_name           = "hub-and-spoke-rg"
    location          = "east us"
    allocation_method = "Static"
    sku               = "Standard"
  }
  bastion_pip = {
    pip_name          = "bastion-pip"
    rg_name           = "hub-and-spoke-rg"
    location          = "east us"
    allocation_method = "Static"
    sku               = "Standard"
  }
  firewall_pip = {
    pip_name          = "firewall-pip"
    rg_name           = "hub-and-spoke-rg"
    location          = "east us"
    allocation_method = "Static"
    sku               = "Standard"
    zones             = ["1", "2", "3"]
  }
}

network_nic = {
  nic1 = {
    nic_name                      = "frontnic"
    location                      = "east us"
    rg_name                       = "hub-and-spoke-rg"
    ip_config_name                = "internal"
    private_ip_meth               = "Dynamic"
    subnet_name                   = "frontendsubnet"
    vnet_name                     = "spokevnet1"
    nsg_key                       = "nsg1"
    enable_accelerated_networking = true
    tags = {
      environment = "dev"
      owner       = "mehar"
    }
  }
  nic2 = {
    nic_name             = "backendnic"
    location             = "east us"
    rg_name              = "hub-and-spoke-rg"
    ip_config_name       = "internal"
    private_ip_meth      = "Dynamic"
    subnet_name          = "backendsubnet"
    vnet_name            = "spokevnet1"
    nsg_key              = "nsg2"
    enable_ip_forwarding = true
  }
}

virtual_machine = {
  vm1 = {
    vm_name  = "mehar-linux-vm1"
    rg_name  = "hub-and-spoke-rg"
    location = "East US"
    vm_size  = "Standard_DC1ds_v3"
    nic_name = "frontnic"
    username = "Useradmin"
    password = "Useradmin@1234"
  }

  vm2 = {
    vm_name  = "mehar-linux-vm2"
    rg_name  = "hub-and-spoke-rg"
    location = "East US"
    vm_size  = "Standard_DC1ds_v3"
    nic_name = "backendnic"
    username = "Useradmin"
    password = "Useradmin@1234"
  }
}

network_nsg = {
  nsg1 = {
    nsg_name = "front-nsg"
    location = "eastus"
    rg_name  = "hub-and-spoke-rg"
    rules = [
      {
        rule_name                  = "allow-http"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  nsg2 = {
    nsg_name = "backend-nsg"
    location = "eastus"
    rg_name  = "hub-and-spoke-rg"
    rules = [
      {
        rule_name                  = "allow-sql"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}

azure_bastion = {
  bastion1 = {
    bastion_name       = "azure-bastion"
    location           = "eastus"
    rg_name            = "hub-and-spoke-rg"
    vnet_name          = "HubVnet"
    bastion_subnetname = "AzureBastionSubnet"
    address_prefixes   = ["10.0.2.0/26"]
    pip_name           = "bastion-pip"
  }
}

application_gateways = {
  appgw1 = {
    name        = "mehar-appgateway"
    rg_name     = "hub-and-spoke-rg"
    location    = "eastus"
    subnet_name = "AppgatewaySubnet"
    vnet_name   = "HubVnet"
    pip_name    = "App-gateway-pip"
    sku = {
      name     = "Standard_v2"
      tier     = "Standard_v2"
      capacity = 2
    }
    gateway_ip_configuration = {
      name = "my-gateway-ip-configuration"
    }

    frontend_ports = {
      http = {
        name = "frontend-port-80"
        port = 80
      }
    }

    frontend_ip_configurations = {
      public = {
        name = "frontend-ip"
      }
    }

    backend_address_pools = {
      pool1 = {
        name = "backend-pool"
      }
    }
    backend_http_settings = {
      http = {
        name                  = "http-setting"
        cookie_based_affinity = "Disabled"
        path                  = "/"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 60
      }
    }

    http_listeners = {
      listener1 = {
        name               = "http-listener"
        ip_config_name     = "frontend-ip"
        frontend_port_name = "frontend-port-80"
        protocol           = "Http"
      }
    }
    request_routing_rules = {
      rule1 = {
        name                       = "routing-rule"
        priority                   = 9
        rule_type                  = "Basic"
        http_listener_name         = "http-listener"
        backend_address_pool_name  = "backend-pool"
        backend_http_settings_name = "http-setting"
      }
    }

    vm_backend_association = {
      vm1 = {
        backend_pool_name    = "backend-pool"
        ip_config_name       = "internal"
        nic_name             = "frontnic"
        rg_name              = "hub-and-spoke-rg"
        username_secret_name = "vm-admin-username"
        password_secret_name = "vm-admin-password"
      }

      vm2 = {
        backend_pool_name    = "backend-pool"
        ip_config_name       = "internal"
        nic_name             = "backendnic"
        rg_name              = "hub-and-spoke-rg"
        username_secret_name = "vm-admin-username"
        password_secret_name = "vm-admin-password"
      }
    }
  }
}

firewall = {

  firewall01 = {
    firewall_name = "firewall1"
    rg_name       = "hub-and-spoke-rg"
    location      = "eastus"
    sku_name      = "AZFW_VNet"
    sku_tier      = "Standard"
    pip_name      = "firewall-pip"
    vnet_name     = "HubVnet"
    subnet_name   = "AzureFirewallSubnet"

    private_ip_ranges = [
      "10.0.0.0/8",
      "172.16.0.0/12"
    ]

    threat_intel_mode = "Alert"

    zones = [
      "1",
      "2",
      "3"
    ]

  }

}



storage_account = {
  sa1 = {
    name                     = "meharstorage001"
    resource_group_name      = "hub-and-spoke-rg"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
    # tags = {
    #   environment = "dev"
    #   project     = "infra"
    # }
  }
}




# keyvaults = {
#   kv-eastus = {
#     keyvault_name              = "mehar-kv"
#     location                   = "East US"
#     rg_name                    = "hub-and-spoke-rg"
#     sku_name                   = "premium"
#     soft_delete_retention_days = 30
#     key_permissions            = ["Create", "Get", "List"]
#     secret_permissions         = ["Set", "List", "Get", "Delete", "Recover"]
#   }
# }

# secret = {
#   username = {
#     keyvault_name = "mehar-kv"
#     rg_name       = "hub-and-spoke-rg"
#     secret_name   = "vm-admin-username"
#     length        = 8
#     lower         = true
#     upper         = false
#     special       = false
#   }
#   password = {
#     keyvault_name    = "mehar-kv"
#     rg_name          = "hub-and-spoke-rg"
#     secret_name      = "vm-admin-password"
#     length           = 16
#     special          = true
#     override_special = "!@#"
#   }
# }