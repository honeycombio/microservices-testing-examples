resource "honeycombio_board" "buildevents_board" {
  name        = "Buildevents Board"
  style       = "visual"

  query {
    caption = "Breakdown by Success/Failure"
    query_id = honeycombio_query.success_failure_breakdown.id
  }

  query {
    caption = "Build Times > 15 min"
    query_id = honeycombio_query.build_times_over_2_min.id
  }
}