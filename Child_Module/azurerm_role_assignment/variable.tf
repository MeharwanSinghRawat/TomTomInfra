variable "custom_roles" {
  description = "Map of Custom Role Definitions to create"
  type = map(object({
    name        = string
    scope       = string
    description = optional(string)
    permissions = object({
      actions          = optional(list(string), [])
      not_actions      = optional(list(string), [])
      data_actions     = optional(list(string), [])
      not_data_actions = optional(list(string), [])
    })
    assignable_scopes = optional(list(string))
  }))
  default = {}
}

variable "role_assignments" {
  description = "Map of Role Assignments to create"
  type = map(object({
    scope                            = string
    role_definition_name             = optional(string)
    role_definition_id               = optional(string)
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, false)
    description                      = optional(string)
  }))
  default = {}
}
