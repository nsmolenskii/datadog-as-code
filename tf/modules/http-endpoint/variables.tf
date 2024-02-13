variable "env" {
  type        = string
  description = "Environment tag to use, e.g.: dev, prod, etc"
}

variable "team" {
  type        = string
  description = "Team tag to use, e.g.: catalog, basket, payments, etc."
}

variable "service" {
  type        = string
  description = "Service tag to use, e.g.: card, order, etc"
}

variable "provisioned_tags" {
  type        = list(string)
  description = "Tags to apply on created objects, e.g.: [team:checkout, department:technology, system:shop, etc]"
  default     = []
}

variable "base_metric" {
  type        = string
  description = "Base http datadog metric to use, e.g.: trace.netty.request, trace.servlet.request, etc"
}

variable "monitor_window" {
  type        = string
  description = "Monitor window to use, e.g.: last_5m, last_1h, etc."
  default     = "last_5m"
}

variable "notifications" {
  type        = string
  description = "Notification handles to use, e.g.: @slack-checkout-alerts"
}

variable "id" {
  type        = string
  description = "Endpoint id to use in tags and titles, e.g.: catalog-search, basket-show, etc"
}

variable "priority" {
  type        = number
  description = "Service priority"
}

variable "resource_names" {
  type        = list(string)
  description = "Resource names to filter endpoint, e.g.: POST /customers/{customer-id}/orders, GET /customers/{customer-id}/orders, etc"
}

variable "monitor_thresholds" {
  description = "Monitor"
  type        = object({
    error_rate = object({
      critical          = number
      critical_recovery = optional(number)
      warning           = optional(number)
      warning_recovery  = optional(number)
      ok                = optional(number)
      unknown           = optional(number)
    })
    latency = map(object({
      critical          = number
      critical_recovery = optional(number)
      warning           = optional(number)
      warning_recovery  = optional(number)
      ok                = optional(number)
      unknown           = optional(number)
    }))
  })
}

variable "latency_targets" {
  description = "Target latency to use, e.g.: {p95 = 0.100, p75 = 0.075}"
  type        = map(number)
}

variable "slo_thresholds" {
  description = "SLO thresholds ot use, e.g.: [{timeframe = '7d', target = 99.9, warning = 99.99}]"
  type        = list(object({
    timeframe = string
    target    = number
    warning   = number
  }))
}