module "http-endpoint" {
  source = "./modules/http-endpoint"

  for_each = local.endpoints

  env     = local.env
  team    = local.team
  service = local.service.id

  priority      = each.value.priority
  notifications = local.notifications

  id                 = each.key
  monitor_thresholds = each.value.monitor_thresholds
  resource_names     = each.value.resource_names
  slo_thresholds     = each.value.slo_thresholds
  latency_targets    = each.value.latency_targets

  base_metric    = "trace.netty.request"
  monitor_window = "last_5m"
}

module "container" {
  source = "./modules/container"

  env     = local.env
  team    = local.team
  service = local.service.id

  priority      = 1
  notifications = local.notifications

  thresholds = {
    cpu      = { critical = 0.90 }
    ram      = { critical = 0.90 }
    restarts = { critical = 3, warning = 1 }
  }
}

module "service-dashboard" {
  source    = "./modules/service-dashboard"
  env       = local.env
  team      = local.team
  service   = local.service
  endpoints = [
    for endpoint_id, endpoint in local.endpoints : merge({
      id              = endpoint_id
      base_metric     = "trace.netty.request"
      resource_names  = endpoint.resource_names
      latency_targets = endpoint.latency_targets
    }, endpoint)
  ]
}
