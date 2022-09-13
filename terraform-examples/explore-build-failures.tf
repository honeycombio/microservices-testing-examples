data "honeycombio_query_specification" "success_failure_breakdown" {
  calculation {
    op     = "HEATMAP"
    column = "duration_ms"
  }

  filter {
    column = "trace.parent_id"
    op     = "does-not-exist"
  }

  filter {
    column = "status"
    op     = "!="
    value  = "success"
  }

  breakdowns = ["status", "branch", "ci_provider"]
  time_range = local.time_range
}

resource "honeycombio_query" "success_failure_breakdown" {
  dataset    = local.dataset
  query_json = data.honeycombio_query_specification.success_failure_breakdown.json
}

resource "honeycombio_query_annotation" "success_failure_breakdown_annotation" {
  dataset     = local.dataset
  query_id    = honeycombio_query.success_failure_breakdown.id
  name        = "Why are my Builds failing?"
  description = "Explore patterns in build failures"
}