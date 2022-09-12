terraform {
  required_providers {
    honeycombio = {
      source = "honeycombio/honeycombio"
      version = "~> 0.10.0"
    }
  }
}

# Configure provider
provider "honeycombio" {}

# Create a marker
resource "honeycombio_marker" "hello" {
  message = "Hello world!"
  dataset = "buildevents"
}
