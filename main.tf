resource "oci_monitoring_alarm_suppression" "monitoring_alarm_suppressions" {
  for_each = var.monitoring_alarm_suppressions

  display_name        = each.value.display_name
  time_suppress_from  = each.value.time_suppress_from
  time_suppress_until = each.value.time_suppress_until
  defined_tags        = each.value.defined_tags
  description         = each.value.description
  dimensions          = each.value.dimensions
  freeform_tags       = each.value.freeform_tags
  level               = each.value.level

  alarm_suppression_target {
    alarm_id                  = each.value.alarm_suppression_target.alarm_id
    compartment_id            = each.value.alarm_suppression_target.compartment_id
    compartment_id_in_subtree = each.value.alarm_suppression_target.compartment_id_in_subtree
    target_type               = each.value.alarm_suppression_target.target_type
  }

  dynamic "suppression_conditions" {
    for_each = each.value.suppression_conditions != null ? each.value.suppression_conditions : []
    content {
      condition_type         = suppression_conditions.value.condition_type
      suppression_duration   = suppression_conditions.value.suppression_duration
      suppression_recurrence = suppression_conditions.value.suppression_recurrence
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

