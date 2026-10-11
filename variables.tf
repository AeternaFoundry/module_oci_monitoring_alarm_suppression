variable "monitoring_alarm_suppressions" {
  description = <<EOT
Map of monitoring_alarm_suppressions, attributes below
Required:
    - display_name
    - time_suppress_from
    - time_suppress_until
    - alarm_suppression_target (block):
        - alarm_id (optional)
        - compartment_id (optional)
        - compartment_id_in_subtree (optional)
        - target_type (required)
Optional:
    - defined_tags
    - description
    - dimensions
    - freeform_tags
    - level
    - suppression_conditions (block):
        - condition_type (required)
        - suppression_duration (required)
        - suppression_recurrence (required)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    display_name        = string
    time_suppress_from  = string
    time_suppress_until = string
    defined_tags        = optional(map(string))
    description         = optional(string)
    dimensions          = optional(map(string))
    freeform_tags       = optional(map(string))
    level               = optional(string)
    alarm_suppression_target = object({
      alarm_id                  = optional(string)
      compartment_id            = optional(string)
      compartment_id_in_subtree = optional(bool)
      target_type               = string
    })
    suppression_conditions = optional(list(object({
      condition_type         = string
      suppression_duration   = string
      suppression_recurrence = string
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.monitoring_alarm_suppressions : (
        contains([for v in ["ALARM", "COMPARTMENT"] : lower(v)], lower(v.alarm_suppression_target.target_type))
      )
    ])
    error_message = "must be one of: \"ALARM\", \"COMPARTMENT\""
  }
  validation {
    condition = alltrue([
      for k, v in var.monitoring_alarm_suppressions : (
        v.suppression_conditions == null || alltrue([for item in v.suppression_conditions : (contains([for v in ["RECURRENCE"] : lower(v)], lower(item.condition_type)))])
      )
    ])
    error_message = "must be one of: \"RECURRENCE\""
  }
}

