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