# variable "virtual_machine" {
#   description = "Map of Linux Virtual Machines"
#   type = map(object({
#     vm_name              = string
#     rg_name              = string
#     location             = string
#     vm_size              = string
#     nic_name             = string
#     keyvault_name        = string
#     username_secret_name = string
#     password_secret_name = string
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