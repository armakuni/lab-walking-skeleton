terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.62.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
  }

  backend "gcs" {}
}

provider "google" {
  project = "bt-lab-walking-skeleton"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}
