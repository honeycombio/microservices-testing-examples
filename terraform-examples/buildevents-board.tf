resource "honeycombio_board" "buildevents_board" {
  name        = "Buildevents Board"
  style       = "visual"

  query {
    caption = "Explore build failures"
    query_id = honeycombio_query.success_failure_breakdown.id
  }

  query {
    caption = "Slow Builds? Build Times > 2 min"
    query_annotation_id = honeycombio_query_annotation.build_times_over_2_min_annotation.id
    query_id = honeycombio_query.build_times_over_2_min.id
  }
}