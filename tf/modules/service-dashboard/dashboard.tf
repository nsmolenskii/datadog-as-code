resource "datadog_dashboard" "service_overview" {
  layout_type = "ordered"
  reflow_type = "fixed"
  title       = "[${var.env}:${var.service.id}]: Service overview"
  tags        = ["team:${var.team}"]

  widget {
    widget_layout {
      height = 7
      width  = 12
      x      = 0
      y      = 0
    }

    group_definition {
      layout_type      = "ordered"
      title            = "Service: ${var.service.id}"
      background_color = "vivid_blue"

      # Service Monitors
      widget {
        widget_layout {
          height = 2
          width  = 2
          x      = 0
          y      = 0
        }
        manage_status_definition {
          title            = "Service Monitors"
          color_preference = "background"
          display_format   = "counts"
          hide_zero_counts = true
          query            = join(" AND ", [
            "env:${var.env}",
            "service:${var.service.id}",
            "tag:\"actionable:true\"",
          ])
          sort                = "status,asc"
          summary_type        = "monitors"
          show_priority       = false
          show_last_triggered = false
        }
      }

      # Service SLOs
      widget {
        widget_layout {
          height = 2
          width  = 10
          x      = 2
          y      = 0
        }
        slo_list_definition {
          title = "Service SLOs"
          request {
            request_type = "slo_list"
            query {
              query_string = join(" AND ", [
                "env:${var.env}",
                "service:${var.service.id}",
              ])
              limit = 100
              sort {
                column = "status.error_budget_remaining"
                order  = "asc"
              }
            }
          }
        }
      }

      # Container CPU Usage
      widget {
        widget_layout {
          height = 2
          width  = 4
          x      = 0
          y      = 2
        }

        timeseries_definition {
          title = "CPU Usage"

          legend_size   = "auto"
          legend_layout = "horizontal"
          show_legend   = true

          # avg
          request {
            display_type = "line"

            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }

            formula {
              formula_expression = "avg_query"
              alias              = "avg"
            }

            query {
              metric_query {
                name  = "avg_query"
                query = "avg:container.cpu.usage{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          # min/max
          request {
            display_type = "line"

            style {
              palette    = "grey"
              line_type  = "dotted"
              line_width = "normal"
            }

            formula {
              formula_expression = "min_query"
              alias              = "min"
            }

            formula {
              formula_expression = "max_query"
              alias              = "max"
            }

            query {
              metric_query {
                name  = "min_query"
                query = "min:container.cpu.usage{env:${var.env},service:${var.service.id}}"
              }
            }

            query {
              metric_query {
                name  = "max_query"
                query = "max:container.cpu.usage{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          # Requests/limits
          request {
            display_type = "line"

            style {
              palette    = "warm"
              line_type  = "dashed"
              line_width = "normal"
            }

            formula {
              formula_expression = "requests_query"
              alias              = "requests"
              style {
                palette       = "orange"
                palette_index = 3
              }
            }

            formula {
              formula_expression = "limits_query"
              alias              = "limits"
              style {
                palette       = "warm"
                palette_index = 5
              }
            }

            query {
              metric_query {
                name  = "requests_query"
                query = "max:kubernetes.cpu.requests{env:${var.env},service:${var.service.id}}"
              }
            }
            query {
              metric_query {
                name  = "limits_query"
                query = "max:kubernetes.cpu.limits{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          yaxis {
            scale        = "sqrt"
            include_zero = true
          }
        }
      }

      # Container RAM Usage
      widget {
        widget_layout {
          height = 2
          width  = 4
          x      = 4
          y      = 2
        }

        timeseries_definition {
          title = "RAM Usage"

          legend_size   = "auto"
          legend_layout = "horizontal"
          show_legend   = true

          # avg
          request {
            display_type = "line"

            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }

            formula {
              formula_expression = "avg_query"
              alias              = "avg"
            }

            query {
              metric_query {
                name  = "avg_query"
                query = "avg:container.memory.usage{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          # min/max
          request {
            display_type = "line"

            style {
              palette    = "grey"
              line_type  = "dotted"
              line_width = "normal"
            }

            formula {
              formula_expression = "min_query"
              alias              = "min"
            }

            formula {
              formula_expression = "max_query"
              alias              = "max"
            }

            query {
              metric_query {
                name  = "min_query"
                query = "min:container.memory.usage{env:${var.env},service:${var.service.id}}"
              }
            }

            query {
              metric_query {
                name  = "max_query"
                query = "max:container.memory.usage{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          # requests/limits
          request {
            display_type = "line"

            style {
              palette    = "warm"
              line_type  = "dashed"
              line_width = "normal"
            }

            formula {
              formula_expression = "requests_query"
              alias              = "requests"
              style {
                palette       = "orange"
                palette_index = 3
              }
            }

            formula {
              formula_expression = "limits_query"
              alias              = "limits"
              style {
                palette       = "warm"
                palette_index = 5
              }
            }

            query {
              metric_query {
                name  = "requests_query"
                query = "max:kubernetes.memory.requests{env:${var.env},service:${var.service.id}}"
              }
            }
            query {
              metric_query {
                name  = "limits_query"
                query = "max:kubernetes.memory.limits{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          yaxis {
            scale        = "sqrt"
            include_zero = true
          }
        }
      }

      # Containers running
      widget {
        widget_layout {
          height = 2
          width  = 4
          x      = 8
          y      = 2
        }

        timeseries_definition {
          title = "Containers running"

          legend_size   = "auto"
          legend_layout = "horizontal"
          show_legend   = true

          request {
            display_type = "line"

            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }


            formula {
              formula_expression = "median_3(running_query)"
              alias              = "running"
            }

            query {
              metric_query {
                name  = "running_query"
                query = "sum:kubernetes.containers.running{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          request {
            display_type = "bars"

            style {
              palette    = "red"
              line_type  = "solid"
              line_width = "normal"
            }

            formula {
              formula_expression = "monotonic_diff(restarts_query)"
              alias              = "restarts"
            }

            query {
              metric_query {
                name  = "restarts_query"
                query = "sum:kubernetes.containers.restarts{env:${var.env},service:${var.service.id}}"
              }
            }
          }

          yaxis {
            include_zero = true
          }
        }
      }

      # JVM CPU
      dynamic "widget" {
        for_each = var.service.type == "jvm" ? ["jvm"] : []

        content {
          widget_layout {
            height = 2
            width  = 4
            x      = 0
            y      = 4
          }

          timeseries_definition {
            title = "JVM CPU Usage"

            legend_size   = "auto"
            legend_layout = "horizontal"
            show_legend   = true

            # avg
            request {
              display_type = "line"

              style {
                palette    = "dog_classic"
                line_type  = "solid"
                line_width = "normal"
              }

              formula {
                formula_expression = "avg_query"
                alias              = "avg"
              }

              query {
                metric_query {
                  name  = "avg_query"
                  query = "avg:jvm.cpu_load.process{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            # min/max
            request {
              display_type = "line"

              style {
                palette    = "grey"
                line_type  = "dotted"
                line_width = "normal"
              }

              formula {
                formula_expression = "min_query"
                alias              = "min"
              }

              formula {
                formula_expression = "max_query"
                alias              = "max"
              }

              query {
                metric_query {
                  name  = "min_query"
                  query = "min:jvm.cpu_load.process{env:${var.env},service:${var.service.id}}"
                }
              }

              query {
                metric_query {
                  name  = "max_query"
                  query = "max:jvm.cpu_load.process{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            yaxis {
              scale        = "sqrt"
              include_zero = true
            }
          }
        }

      }

      # JVM Heap Usage
      dynamic "widget" {
        for_each = var.service.type == "jvm" ? ["jvm"] : []

        content {
          widget_layout {
            height = 2
            width  = 4
            x      = 4
            y      = 4
          }

          timeseries_definition {
            title = "JVM Heap Usage"

            legend_size   = "auto"
            legend_layout = "horizontal"
            show_legend   = true

            # avg
            request {
              display_type = "line"

              style {
                palette    = "dog_classic"
                line_type  = "solid"
                line_width = "normal"
              }

              formula {
                formula_expression = "avg_query"
                alias              = "avg"
              }

              query {
                metric_query {
                  name  = "avg_query"
                  query = "avg:jvm.heap_memory{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            # min/max
            request {
              display_type = "line"

              style {
                palette    = "grey"
                line_type  = "dotted"
                line_width = "normal"
              }

              formula {
                formula_expression = "min_query"
                alias              = "min"
              }

              formula {
                formula_expression = "max_query"
                alias              = "max"
              }

              query {
                metric_query {
                  name  = "min_query"
                  query = "min:jvm.heap_memory{env:${var.env},service:${var.service.id}}"
                }
              }

              query {
                metric_query {
                  name  = "max_query"
                  query = "max:jvm.heap_memory{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            # limits
            request {
              display_type = "line"

              style {
                palette    = "warm"
                line_type  = "dashed"
                line_width = "normal"
              }

              formula {
                formula_expression = "limits_query"
                alias              = "limits"
                style {
                  palette       = "warm"
                  palette_index = 5
                }
              }

              query {
                metric_query {
                  name  = "limits_query"
                  query = "max:jvm.heap_memory_max{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            yaxis {
              scale        = "sqrt"
              include_zero = true
            }
          }
        }
      }

      # JVM Non-Heap Usage
      dynamic "widget" {
        for_each = var.service.type == "jvm" ? ["jvm"] : []
        content {
          widget_layout {
            height = 2
            width  = 4
            x      = 8
            y      = 4
          }

          timeseries_definition {
            title = "JVM Non-Heap Usage"

            legend_size   = "auto"
            legend_layout = "horizontal"
            show_legend   = true

            # avg
            request {
              display_type = "line"

              style {
                palette    = "dog_classic"
                line_type  = "solid"
                line_width = "normal"
              }

              formula {
                formula_expression = "avg_query"
                alias              = "avg"
              }

              query {
                metric_query {
                  name  = "avg_query"
                  query = "avg:jvm.non_heap_memory{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            # min/max
            request {
              display_type = "line"

              style {
                palette    = "grey"
                line_type  = "dotted"
                line_width = "normal"
              }

              formula {
                formula_expression = "min_query"
                alias              = "min"
              }

              formula {
                formula_expression = "max_query"
                alias              = "max"
              }

              query {
                metric_query {
                  name  = "min_query"
                  query = "min:jvm.non_heap_memory{env:${var.env},service:${var.service.id}}"
                }
              }

              query {
                metric_query {
                  name  = "max_query"
                  query = "max:jvm.non_heap_memory{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            # limits
            request {
              display_type = "line"

              style {
                palette    = "warm"
                line_type  = "dashed"
                line_width = "normal"
              }

              formula {
                formula_expression = "limits_query"
                alias              = "limits"
                style {
                  palette       = "warm"
                  palette_index = 5
                }
              }

              query {
                metric_query {
                  name  = "limits_query"
                  query = "max:jvm.non_heap_memory_max{env:${var.env},service:${var.service.id}}"
                }
              }
            }

            yaxis {
              scale        = "sqrt"
              include_zero = true
            }
          }
        }
      }
    }
  }

  dynamic "widget" {
    for_each = {
      for endpoint in var.endpoints : endpoint.id => merge({
        metric_query = join(" AND ", [
          "env:${var.env}",
          "service:${var.service.id}",
          format("resource_name IN (%s)", join(",", [
            for resource_name in endpoint.resource_names :
            replace(replace(replace(replace(replace(lower(resource_name), " ", "_"), "{*", "_"), "{", "_"), "}/", "_/"), "}", "")
          ]))
        ])
        apm_query = join(" ", [
          "env:${var.env}",
          "service:${var.service.id}",
          format("resource_name:(%s)", join(" OR ", [
            for resource_name in endpoint.resource_names :
            format("\"%s\"", resource_name)
          ]))
        ])
      }, endpoint)
    }

    content {
      widget_layout {
        height = 5
        width  = 12
        x      = 0
        y      = 0
      }

      group_definition {
        layout_type      = "ordered"
        title            = "Endpoint: ${widget.value.id}"
        background_color = "blue"

        # Endpoint Monitors
        widget {
          widget_layout {
            height = 2
            width  = 2
            x      = 0
            y      = 0
          }
          manage_status_definition {
            title            = "Endpoint Monitors"
            color_preference = "background"
            display_format   = "counts"
            hide_zero_counts = true
            query            = join(" AND ", [
              "env:${var.env}",
              "service:${var.service.id}",
              "tag:\"actionable:true\"",
              "tag:\"scope:endpoint\"",
              "tag:\"endpoint:${widget.value.id}\"",
            ])
            sort                = "status,asc"
            summary_type        = "monitors"
            show_priority       = false
            show_last_triggered = false
          }
        }

        # Endpoint SLOs
        widget {
          widget_layout {
            height = 2
            width  = 10
            x      = 2
            y      = 0
          }
          slo_list_definition {
            title = "Endpoint SLOs"

            request {
              request_type = "slo_list"
              query {
                query_string = join(" AND ", [
                  "env:${var.env}",
                  "service:${var.service.id}",
                  "scope:endpoint",
                  "endpoint:${widget.value.id}",
                ])
                limit = 100
                sort {
                  column = "status.error_budget_remaining"
                  order  = "asc"
                }
              }
            }
          }
        }


        # latency
        widget {
          widget_layout {
            height = 2
            width  = 3
            x      = 0
            y      = 2
          }

          timeseries_definition {
            title = "Latency"

            legend_size   = "auto"
            legend_layout = "horizontal"
            show_legend   = true

            custom_link {
              override_label = "traces"
              link           = "/apm/traces?query=${widget.value.apm_query}&start={{timestamp_start}}&end={{timestamp_end}}&paused=true&metricQuery=true&historicalData=true&spanType=all"
            }

            request {
              display_type = "line"

              style {
                palette    = "dog_classic"
                line_type  = "solid"
                line_width = "normal"
              }

              dynamic "formula" {
                for_each = widget.value.latency_targets

                content {
                  formula_expression = "autosmooth(${formula.key}_latency_query)"
                  alias              = formula.key
                }
              }

              dynamic "query" {
                for_each = widget.value.latency_targets

                content {
                  metric_query {
                    name  = "${query.key}_latency_query"
                    query = "${query.key}:${widget.value.base_metric}{${widget.value.metric_query}}"
                  }
                }
              }
            }

            dynamic "marker" {
              for_each = widget.value.latency_targets

              content {
                label        = " ${marker.key} "
                value        = "y = ${marker.value}"
                display_type = "error dashed"
              }
            }

            yaxis {
              scale        = "sqrt"
              include_zero = true
            }
          }
        }

        # 2xx hits
        widget {
          widget_layout {
            height = 2
            width  = 3
            x      = 3
            y      = 2
          }

          timeseries_definition {
            title = "2xx hits"

            legend_size   = "auto"
            legend_layout = "horizontal"
            show_legend   = true

            custom_link {
              override_label = "traces"
              link           = "/apm/traces?query=${widget.value.apm_query} @http.status_code:2**&start={{timestamp_start}}&end={{timestamp_end}}&paused=true&metricQuery=true&historicalData=true&spanType=all"
            }

            request {
              display_type = "line"

              style {
                palette    = "dog_classic"
                line_type  = "solid"
                line_width = "normal"
              }

              formula {
                formula_expression = "autosmooth(default_zero(hits_2xx_query))"
                alias              = "now"
              }

              query {
                metric_query {
                  name  = "hits_2xx_query"
                  query = "sum:${widget.value.base_metric}.hits.by_http_status{${widget.value.metric_query} AND http.status_class:2xx}.as_count()"
                }
              }
            }

            request {
              display_type = "line"

              style {
                palette    = "grey"
                line_type  = "dashed"
                line_width = "normal"
              }

              formula {
                formula_expression = "day_before(autosmooth(default_zero(hits_2xx_query)))"
                alias              = "day before"
              }

              formula {
                formula_expression = "week_before(clamp_max(autosmooth(default_zero(hits_2xx_query)), 100))"
                alias              = "week before"
              }

              query {
                metric_query {
                  name  = "hits_2xx_query"
                  query = "sum:${widget.value.base_metric}.hits.by_http_status{${widget.value.metric_query} AND http.status_class:2xx}.as_count()"
                }
              }
            }

            yaxis {
              include_zero = true
            }
          }
        }

        # 4xx hits
        widget {
          widget_layout {
            height = 2
            width  = 3
            x      = 6
            y      = 2
          }

          timeseries_definition {
            title = "4xx hits"

            custom_link {
              override_label = "traces"
              link           = "/apm/traces?query=${widget.value.apm_query} @http.status_code:4**&start={{timestamp_start}}&end={{timestamp_end}}&paused=true&metricQuery=true&historicalData=true&spanType=all"
            }

            request {
              display_type = "bars"

              style {
                palette    = "orange"
                line_type  = "solid"
                line_width = "normal"
              }

              formula {
                formula_expression = "hits_4xx_query"
                alias              = "4xx"
              }

              query {
                metric_query {
                  name  = "hits_4xx_query"
                  query = "sum:${widget.value.base_metric}.hits.by_http_status{${widget.value.metric_query} AND http.status_class:4xx}.as_count()"
                }
              }
            }
          }
        }

        # 5xx hits
        widget {
          widget_layout {
            height = 2
            width  = 3
            x      = 9
            y      = 4
          }

          timeseries_definition {
            title = "5xx hits"

            custom_link {
              override_label = "traces"
              link           = "/apm/traces?query=${widget.value.apm_query} @http.status_code:5**&start={{timestamp_start}}&end={{timestamp_end}}&paused=true&metricQuery=true&historicalData=true&spanType=all"
            }

            request {
              display_type = "bars"

              style {
                palette    = "warm"
                line_type  = "solid"
                line_width = "normal"
              }

              formula {
                formula_expression = "hits_5xx_query"
                alias              = "5xx"
              }

              query {
                metric_query {
                  name  = "hits_5xx_query"
                  query = "sum:${widget.value.base_metric}.hits.by_http_status{${widget.value.metric_query} AND http.status_class:5xx}.as_count()"
                }
              }
            }
          }
        }
      }
    }
  }
}