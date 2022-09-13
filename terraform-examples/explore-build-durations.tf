data "honeycombio_query_specification" "build_times_over_2_min" {
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
    value = 120000
  }

  time_range = local.time_range
}

resource "honeycombio_query" "build_times_over_2_min" {
  dataset    = local.dataset
  query_json = data.honeycombio_query_specification.build_times_over_2_min.json
}

resource "honeycombio_query_annotation" "build_times_over_2_min_annotation" {
    dataset     = local.dataset
    query_id    = honeycombio_query.build_times_over_2_min.id
    name        = "Slow Builds?"
    description = "Explore builds that are taking longer than ideal - 2 minutes"
}