data "azurerm_network_interface" "nic" {
  for_each            = var.virtual_machine
  name                = each.value.nic_name
  resource_group_name = each.value.rg_name
}

data "azurerm_client_config" "current" {}

# Example: Using the secret in custom_data (base64) for VM
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.virtual_machine
  name                            = each.value.vm_name
  resource_group_name             = each.value.rg_name
  location                        = each.value.location
  size                            = each.value.vm_size
  admin_username                  = each.value.username
  admin_password                  = each.value.password
  disable_password_authentication = false
  network_interface_ids = [
    data.azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

}







# data "azurerm_client_config" "current" {}

# # Assume Key Vault already exists
# data "azurerm_key_vault" "kv" {
#   for_each            = var.virtual_machine
#   name                = each.value.keyvault_name # existing KV name
#   resource_group_name = each.value.rg_name
# }


# data "azurerm_key_vault_secret" "vm_password" {
#   for_each     = var.virtual_machine
#   name         = each.value.password_secret_name  # secret name in KV
#   key_vault_id = data.azurerm_key_vault.kv[each.key].id
# }


# resource "azurerm_linux_virtual_machine" "vm" {
#   for_each = var.virtual_machine
#   name                            = each.value.vm_name
#   resource_group_name             = each.value.rg_name
#   location                        = each.value.location
#   size                            = each.value.vm_size
#   admin_username                  = each.value.admin_username
#   admin_password                  = each.value.admin_password
#   disable_password_authentication = false
#   network_interface_ids = [
#     data.azurerm_network_interface.nic[each.key].id
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

# custom_data = base64encode(<<-EOT
#   #!/bin/bash
#   apt update -y
#   apt install nginx git -y

#   cd /home
#   git clone https://github.com/devopsinsiders/StreamFlix.git

#   # Clear default html folder and copy app
#   rm -rf /var/www/html/*
#   cp -r StreamFlix/* /var/www/html/

#   # Enable and restart nginx
#   systemctl enable nginx
#   systemctl restart nginx
# EOT
# )
#     # Optional but recommended tags
#   tags = {
#     Environment = "dev"
#     CreatedBy   = "Terraform"
#   }
# }





# # Assume Key Vault already exists
# data "azurerm_key_vault" "kv" {
#   for_each            = var.virtual_machine
#   name                = each.value.keyvault_name # existing KV name
#   resource_group_name = each.value.rg_name
# }


# # Data block to read secrets from existing Key Vault
# data "azurerm_key_vault_secret" "vm_username" {
#   for_each     = var.virtual_machine
#   name         = each.value.username_secret_name  # secret name in KV
#   key_vault_id = data.azurerm_key_vault.kv[each.key].id
# }

# data "azurerm_key_vault_secret" "vm_password" {
#   for_each     = var.virtual_machine
#   name         = each.value.password_secret_name  # secret name in KV
#   key_vault_id = data.azurerm_key_vault.kv[each.key].id
# }
