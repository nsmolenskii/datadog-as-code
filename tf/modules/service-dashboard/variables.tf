variable "env" {
  type        = string
  description = "Environment tag to use, e.g.: dev, prod, etc"
}

variable "team" {
  type        = string
  description = "Team tag to use, e.g.: catalog, basket, payments, etc."
}

variable "service" {
  type = object({
    id   = string
    type = string
  })
  description = "Service tag (e.g.: card, order, etc) and type (e.g.: jvm, php, etc) to use"
}

variable "endpoints" {
  type = list(object({
    id              = string
    base_metric     = string
    resource_names  = list(string)
    latency_targets = map(number)
  }))
}
