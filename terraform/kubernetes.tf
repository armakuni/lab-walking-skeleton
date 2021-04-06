locals {
  prefix = "${var.project}-wp"
  pod_secondary_range_name = "${local.prefix}-cluster-pods"
  service_secondary_range_name = "${local.prefix}-cluster-services"
}

data "google_client_config" "default" {}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}


module "network" {
  source  = "terraform-google-modules/network/google"
  version = "3.2.0"

  project_id   = var.project
  network_name = "${local.prefix}-vpc"

  subnets = [
    {
      subnet_name   = "${local.prefix}-subnet"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    "${local.prefix}-subnet" = [
      {
        range_name    = local.pod_secondary_range_name
        ip_cidr_range = "10.11.0.0/16"
      },
      {
        range_name    = local.service_secondary_range_name
        ip_cidr_range = "10.12.0.0/16"
      },
    ]
  }
  depends_on = [google_project_service.container]
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "14.0.1"


  project_id = var.project
  name       = "${local.prefix}-cluster"
  regional   = true
  region     = var.region

  ip_range_pods     = local.pod_secondary_range_name
  ip_range_services = local.service_secondary_range_name
  network           = module.network.network_name
  subnetwork        = module.network.subnets_names[0]
  depends_on        = [google_project_service.container]
}
