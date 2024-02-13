resource "datadog_monitor" "container_cpu" {
  type    = "metric alert"
  name    = "${local.monitor_prefix}: Container CPU usage increased"
  message = <<-EOT
    Monitored continer CPU % observes increased usage.

    ---

    ${var.notifications}
  EOT

  query = "avg(${var.monitor_window}):avg:container.cpu.usage{${local.metric_tags.all}} / avg:container.cpu.limit{${local.metric_tags.all}} >= ${var.thresholds.cpu.critical}"

  priority = var.priority

  monitor_thresholds {
    critical          = var.thresholds.cpu.critical
    critical_recovery = var.thresholds.cpu.critical_recovery
    warning           = var.thresholds.cpu.warning
    warning_recovery  = var.thresholds.cpu.warning_recovery
    ok                = var.thresholds.cpu.ok
    unknown           = var.thresholds.cpu.unknown
  }

  tags = concat(local.provisioned_tags, [
    "actionable:true",
    "kind:container-cpu",
    "scope:service",
  ])
}

resource "datadog_monitor" "container_ram" {
  type    = "metric alert"
  name    = "${local.monitor_prefix}: Container RAM usage increased"
  message = <<-EOT
    Monitored continer RAM % observes increased usage.

    ---

    ${var.notifications}
  EOT

  query = "avg(${var.monitor_window}):avg:container.memory.usage{${local.metric_tags.all}} / avg:container.memory.limit{${local.metric_tags.all}} >= ${var.thresholds.ram.critical}"

  priority = var.priority

  monitor_thresholds {
    critical          = var.thresholds.ram.critical
    critical_recovery = var.thresholds.ram.critical_recovery
    warning           = var.thresholds.ram.warning
    warning_recovery  = var.thresholds.ram.warning_recovery
    ok                = var.thresholds.ram.ok
    unknown           = var.thresholds.ram.unknown
  }

  tags = concat(local.provisioned_tags, [
    "actionable:true",
    "kind:container-ram",
    "scope:service",
  ])
}

resource "datadog_monitor" "container_restarts" {
  type    = "metric alert"
  name    = "${local.monitor_prefix}: Container restarts icnreased"
  message = <<-EOT
    Monitored continer restarts appears.

    ---

    ${var.notifications}
  EOT

  query = "sum(${var.monitor_window}):monotonic_diff(sum:kubernetes.containers.restarts{${local.metric_tags.all}}) >= ${var.thresholds.restarts.critical}"

  priority = var.priority

  monitor_thresholds {
    critical          = var.thresholds.restarts.critical
    critical_recovery = var.thresholds.restarts.critical_recovery
    warning           = var.thresholds.restarts.warning
    warning_recovery  = var.thresholds.restarts.warning_recovery
    ok                = var.thresholds.restarts.ok
    unknown           = var.thresholds.restarts.unknown
  }

  tags = concat(local.provisioned_tags, [
    "actionable:true",
    "kind:container-restarts",
    "scope:service",
  ])
}
