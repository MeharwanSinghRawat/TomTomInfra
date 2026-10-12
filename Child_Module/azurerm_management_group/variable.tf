variable "management_groups" {
  description = "Map of Azure Management Groups to create"
  type = map(object({
    name                       = string
    display_name               = optional(string)
    parent_management_group_id = optional(string)
    subscription_ids           = optional(list(string), [])
  }))
  default = {}
}
