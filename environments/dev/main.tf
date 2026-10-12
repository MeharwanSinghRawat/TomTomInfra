module "resource_group" {
  source         = "../../Child_Module/azurerm_resource_group"
  resource_group = var.resource_group
}

module "virtual_network" {
  source          = "../../Child_Module/azurerm_virtual_network"
  virtual_network = var.virtual_network
  depends_on      = [module.resource_group]
}

module "vnet_peering" {
  source        = "../../Child_Module/azurerm_vnet_peering"
  vnet_peerings = var.vnet_peerings
  vnet_ids      = module.virtual_network.vnet_ids
  vnet_names    = module.virtual_network.vnet_names
  vnet_rg_names = module.virtual_network.vnet_resource_group_names
  depends_on    = [module.virtual_network]
}

module "subnet" {
  source     = "../../Child_Module/azurerm_subnet"
  subnet     = var.subnet
  depends_on = [module.virtual_network]
}

module "public_Ip" {
  source     = "../../Child_Module/azurerm_public_ip"
  public_ip  = var.public_ip
  depends_on = [module.resource_group, module.subnet]
}

module "network_interface" {
  source      = "../../Child_Module/azurerm_NetworkInterface"
  network_nic = var.network_nic
  depends_on  = [module.subnet, module.resource_group]
}

module "network_security_group" {
  source      = "../../Child_Module/azurerm_Network_Security_Group"
  network_nsg = var.network_nsg
  network_nic = var.network_nic
  depends_on  = [module.network_interface, module.resource_group]

}


module "azure_bastion" {
  source        = "../../Child_Module/azurerm_bastion"
  azure_bastion = var.azure_bastion
  depends_on    = [module.public_Ip]
}


module "virtual_machine" {
  source          = "../../Child_Module/azurerm_virtual_machines"
  virtual_machine = var.virtual_machine
  depends_on      = [module.network_interface, module.subnet, ]

}

module "application_gateway" {
  source               = "../../Child_Module/azurerm-application-gateway"
  application_gateways = var.application_gateways
  network_nic          = var.network_nic
  depends_on           = [module.network_interface, module.public_Ip]
}

module "firewall" {
  source     = "../../Child_Module/azurerm_firewall"
  firewall   = var.firewall
  depends_on = [module.subnet, module.public_Ip, module.resource_group]
}

module "monitoring" {
  source              = "../../Child_Module/azurerm_monitoring"
  workspaces          = var.monitoring_workspaces
  diagnostic_settings = var.monitoring_diagnostic_settings
  depends_on = [
    module.resource_group,
    module.virtual_network,
    module.subnet,
    module.public_Ip,
    module.network_interface,
    module.network_security_group,
    module.virtual_machine,
    module.application_gateway,
    module.firewall,
  ]
}

module "storage_account" {
  source          = "../../Child_Module/azurerm_storage_account"
  storage_account = var.storage_account
}

# module "keyvaults" {
#   source     = "../../Child_Module/azurerm_keyvault"
#   keyvaults  = var.keyvaults
#   depends_on = [module.resource_group]
# }

# module "vm_secret" {
#   source     = "../../Child_Module/azurerm_vm_secrets"
#   secret     = var.secret
#   depends_on = [module.keyvaults]
# }

