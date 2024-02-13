locals {
  monitor_prefix = "[${var.env}:${var.service}:${var.id}]"

  service_tags = [
    "env:${var.env}",
    "service:${var.service}"
  ]

  provisioned_tags = tolist(toset(concat(var.provisioned_tags, [
    "env:${var.env}",
    "team:${var.team}",
    "service:${var.service}",
    "created_by:terraform"
  ])))

  resource_names_string = join(", ", var.resource_names)

  resource_tags = [
    for resource_name in var.resource_names :
    replace(replace(replace(replace(replace(lower(resource_name), " ", "_"), "{*", "_"), "{", "_"), "}/", "_/"), "}", "")
  ]

  endpoint_tags = [
    "resource_name IN (${join(",", local.resource_tags)})"
  ]

  status_tags = {
    success = ["http.status_class IN (2xx,4xx)"]
    failure = ["http.status_class IN (5xx)"]
  }

  metric_tags = {
    all     = join(" AND ", concat(local.service_tags, local.endpoint_tags))
    success = join(" AND ", concat(local.service_tags, local.endpoint_tags, local.status_tags.success))
    failure = join(" AND ", concat(local.service_tags, local.endpoint_tags, local.status_tags.failure))
  }
}