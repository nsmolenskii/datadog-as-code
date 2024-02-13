resource "datadog_service_level_objective" "availability" {
  name = "${local.monitor_prefix}: Availability"
  type = "metric"

  query {
    numerator   = "sum:${var.base_metric}.hits.by_http_status{${local.metric_tags.success}}.as_count()"
    denominator = "sum:${var.base_metric}.hits.by_http_status{${local.metric_tags.all}}.as_count()"
  }

  dynamic "thresholds" {
    for_each = var.slo_thresholds
    content {
      timeframe = thresholds.value["timeframe"]
      target    = thresholds.value["target"]
      warning   = thresholds.value["warning"]
    }
  }

  tags = concat(local.provisioned_tags, [
    "kind:availability",
    "scope:endpoint",
    "endpoint:${var.id}",
  ])
}

resource "datadog_monitor" "latency_slo_base" {
  for_each = var.latency_targets

  name    = "${local.monitor_prefix}: SLO-base for ${each.key} latency"
  type    = "metric alert"
  message = <<-EOT
    Technical monitor to build Latency SLO for `${local.resource_names_string}` on ${each.key}"

    ---

    @ignore-slo-base-notifications
  EOT
  query = "percentile(${var.monitor_window}):default_zero(${each.key}:${var.base_metric}{${local.metric_tags.all}}) > ${each.value}"

  monitor_thresholds {
    critical = each.value
  }

  notify_audit        = true
  require_full_window = false
  include_tags        = true

  tags = concat(local.provisioned_tags, [
    "actionable:false",
    "kind:latency-slo-base",
    "scope:endpoint",
    "endpoint:${var.id}",
  ])
}

resource "datadog_service_level_objective" "latency" {
  for_each     = toset([join(", ", sort(keys(var.latency_targets)))])
  force_delete = true

  name = "${local.monitor_prefix}: Latency for ${each.key}"
  type = "monitor"

  monitor_ids = [for monitor in datadog_monitor.latency_slo_base : monitor.id]

  dynamic "thresholds" {
    for_each = var.slo_thresholds

    content {
      timeframe = thresholds.value.timeframe
      target    = thresholds.value.target
      warning   = thresholds.value.warning
    }
  }

  tags = concat(local.provisioned_tags, [
    "kind:latency",
    "scope:endpoint",
    "endpoint:${var.id}",
  ])
}
