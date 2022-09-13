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
  time_range = 604800 # 7 days in seconds
}