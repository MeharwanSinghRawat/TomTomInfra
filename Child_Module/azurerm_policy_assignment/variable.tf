variable "management_group_assignments" {
  description = "Map of Policy Assignments at Management Group scope"
  type = map(object({
    name                    = string
    management_group_id     = string
    policy_definition_id    = string
    display_name            = optional(string)
    description             = optional(string)
    enforce                 = optional(bool, true)
    parameters              = optional(string)
    location                = optional(string)
    identity_type           = optional(string)
    non_compliance_messages = optional(list(string), [])
  }))
  default = {}
}

variable "subscription_assignments" {
  description = "Map of Policy Assignments at Subscription scope"
  type = map(object({
    name                    = string
    subscription_id         = string
    policy_definition_id    = string
    display_name            = optional(string)
    description             = optional(string)
    enforce                 = optional(bool, true)
    parameters              = optional(string)
    location                = optional(string)
    identity_type           = optional(string)
    non_compliance_messages = optional(list(string), [])
  }))
  default = {}
}
