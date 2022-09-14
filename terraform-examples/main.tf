terraform {
  cloud {
    organization = "mj-test"

    workspaces {
      name = "guide-testing"
    }
  }
}

module "explore-buildevents-starter-kit" {
  source = "./modules/explore-buildevents-starter-kit"

  dataset = "buildevents" #optional
  time_range = 604800 # 7 days in seconds
  ideal_build_duration = 120000 # 2 mins in milliseconds
}