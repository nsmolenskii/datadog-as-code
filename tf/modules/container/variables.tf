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

variable "monitor_window" {
  type        = string
  description = "Monitor window to use, e.g.: last_5m, last_1h, etc."
  default     = "last_5m"
}

variable "notifications" {
  type        = string
  description = "Notification handles to use, e.g.: @slack-checkout-alerts"
}

variable "priority" {
  type        = number
  description = "Service priority"
}

variable "thresholds" {
  description = "Thresholds to use for different use-cases"

  type = object({
    cpu = object({
      critical          = number
      critical_recovery = optional(number)
      warning           = optional(number)
      warning_recovery  = optional(number)
      ok                = optional(number)
      unknown           = optional(number)
    })
    ram = object({
      critical          = number
      critical_recovery = optional(number)
      warning           = optional(number)
      warning_recovery  = optional(number)
      ok                = optional(number)
      unknown           = optional(number)
    })
    restarts = object({
      critical          = number
      critical_recovery = optional(number)
      warning           = optional(number)
      warning_recovery  = optional(number)
      ok                = optional(number)
      unknown           = optional(number)
    })
  })
}
