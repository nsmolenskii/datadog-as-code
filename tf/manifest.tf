locals {
  env     = "local"
  team    = "rnd"
  service = {
    id   = "service-a"
    type = "jvm"
  }

  notifications = "Notify: @slack-test-team"

  slo_thresholds = [
    for timeframe in ["7d", "30d", "90d"] :
    { timeframe = timeframe, target = 99.9, warning = 99.99 }
  ]

  endpoints = {
    greeting = {
      priority           = 1
      resource_names     = ["GET /greeting"]
      latency_targets    = { p95 = 0.100, p75 = 0.075, p50 = 0.050, }
      monitor_thresholds = {
        error_rate = { critical = 0.01 },
        latency    = { p95 = { critical = 0.2 } }
      }
      slo_thresholds = local.slo_thresholds
    }
    health = {
      priority           = 1
      resource_names     = ["GET /actuator/health/{*path}"]
      latency_targets    = { p95 = 0.100, p75 = 0.075, p50 = 0.050, }
      monitor_thresholds = {
        error_rate = { critical = 0.01 },
        latency    = { p95 = { critical = 0.100 } }
      }
      slo_thresholds = local.slo_thresholds
    }
  }
}
