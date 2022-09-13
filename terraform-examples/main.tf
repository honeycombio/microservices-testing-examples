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