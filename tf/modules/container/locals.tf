locals {
  monitor_prefix = "[${var.env}:${var.service}]"

  service_tags = [
    "env:${var.env}",
    "service:${var.service}"
  ]

  provisioned_tags = tolist(toset(concat(local.service_tags, var.provisioned_tags, [
    "env:${var.env}",
    "service:${var.service}",
    "created_by:terraform"
  ])))

  metric_tags = {
    all = join(" AND ", concat(local.service_tags))
  }
}