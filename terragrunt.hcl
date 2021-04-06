locals {
  config = jsondecode(file("platformconfig.json"))
}

inputs = local.config


remote_state {
  backend = "gcs"
  config = {
    bucket   = "${local.config["project"]}-state"
    prefix   = "terraform/state"
    project  = "${local.config["project"]}"
    location = "${local.config["region"]}"
  }
}

terraform {
  source = ".//terraform"
}