
project = "lab-walking-skeleton"

app "web" {
  config {
    env = {
      ROCKET_SECRET_KEY = jsondecode(file(abspath("platformconfig.json")))["session_key"]
    }
  }

  build {
    use "docker" {}

    registry {
      use "docker" {
        image = "eu.gcr.io/${jsondecode(file(abspath("platformconfig.json")))["project"]}/lab-walking-skeleton"
        tag   = "latest"
      }
    }

  }

  deploy {
    use "google-cloud-run" {
      project  = jsondecode(file(abspath("platformconfig.json")))["project"]
      location = jsondecode(file(abspath("platformconfig.json")))["region"]

      port = 8000
    }
  }

  release {
    use "google-cloud-run" {}
  }
}
