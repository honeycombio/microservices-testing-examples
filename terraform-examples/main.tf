terraform {
  required_providers {
    honeycombio = {
      source = "honeycombio/honeycombio"
      version = "~> 0.10.0"
    }
  }
}

locals {
  dataset = "buildevents"
  time_range = 86400 # 24 hours in seconds
}

data "honeycombio_query_specification" "duration_heatmap" {
  calculation {
    op     = "HEATMAP"
    column = "duration_ms"
  }

  filter {
    column = "job.status"
    op     = "="
    value  = "success"
  }

  filter {
    column = "trace.parent_id"
    op     = "does-not-exist"
  }

  time_range = local.time_range
}

resource "honeycombio_query" "duration_heatmap" {
  dataset    = local.dataset
  query_json = data.honeycombio_query_specification.duration_heatmap.json
}

data "honeycombio_query_specification" "success_failure_breakdown" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "trace.parent_id"
    op     = "does-not-exist"
  }

  breakdowns = ["job.status"]
  time_range = local.time_range
}

resource "honeycombio_query" "success_failure_breakdown" {
  dataset    = local.dataset
  query_json = data.honeycombio_query_specification.success_failure_breakdown.json
}

data "honeycombio_query_specification" "build_times_over_15_min" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "job.status"
    op     = "="
    value  = "success"
  }

  filter {
    column = "trace.parent_id"
    op     = "does-not-exist"
  }

  filter {
    column = "duration_ms"
    op = ">"
    value = 900000
  }

  time_range = local.time_range
}

resource "honeycombio_query" "build_times_over_15_min" {
  dataset    = local.dataset
  query_json = data.honeycombio_query_specification.build_times_over_15_min.json
}

resource "honeycombio_board" "buildevents_board" {
  name        = "Buildevents Board"
  style       = "visual"

  query {
    caption = "Duration Heatmap"
    query_id = honeycombio_query.duration_heatmap.id
  }

  query {
    caption = "Breakdown by Success/Failure"
    query_id = honeycombio_query.success_failure_breakdown.id
  }

  query {
    caption = "Build Times > 15 min"
    query_id = honeycombio_query.build_times_over_15_min.id
  }
}
