resource "datadog_monitor" "error_rate" {
  type    = "metric alert"
  name    = "${local.monitor_prefix}: Eror rate increase"
  message = <<-EOT
    Monitored resource `${local.resource_names_string}` observes increased error rate.

    ---

    ${var.notifications}
  EOT

  query = "sum(${var.monitor_window}):default_zero(sum:${var.base_metric}.hits.by_http_status{${local.metric_tags.failure}}.as_count() / sum:${var.base_metric}.hits.by_http_status{${local.metric_tags.all}}.as_count()) >= ${var.monitor_thresholds.error_rate.critical}"

  priority = var.priority

  monitor_thresholds {
    critical          = var.monitor_thresholds.error_rate.critical
    critical_recovery = var.monitor_thresholds.error_rate.critical_recovery
    warning           = var.monitor_thresholds.error_rate.warning
    warning_recovery  = var.monitor_thresholds.error_rate.warning_recovery
    ok                = var.monitor_thresholds.error_rate.ok
    unknown           = var.monitor_thresholds.error_rate.unknown
  }

  tags = concat(local.provisioned_tags, [
    "actionable:true",
    "kind:error-rate",
    "scope:endpoint",
    "endpoint:${var.id}",
  ])
}

resource "datadog_monitor" "latency" {
  for_each = var.monitor_thresholds.latency

  type    = "metric alert"
  name    = "${local.monitor_prefix}: Latency increase"
  message = <<-EOT
    Monitored resource `${local.resource_names_string}` observes increased latency.

    ---

    ${var.notifications}
  EOT

  query = "percentile(${var.monitor_window}):${each.key}:${var.base_metric}{${local.metric_tags.all}} >= ${each.value.critical}"

  priority = var.priority

  monitor_thresholds {
    critical          = each.value.critical
    critical_recovery = each.value.critical_recovery
    warning           = each.value.warning
    warning_recovery  = each.value.warning_recovery
    ok                = each.value.ok
    unknown           = each.value.unknown
  }

  tags = concat(local.provisioned_tags, [
    "actionable:true",
    "kind:latency",
    "scope:endpoint",
    "endpoint:${var.id}",
  ])
}