resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}
resource "google_project_service" "projectcontainerregistry" {
  service = "containerregistry.googleapis.com"
}
resource "google_project_service" "run" {
  service = "run.googleapis.com"
}
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}


resource "null_resource" "installwaypoint" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${module.gke.name} --region ${module.gke.region} && waypoint server install -platform=kubernetes -accept-tos"
    interpreter = [ "bash", "-c"]
  }
  depends_on = [google_project_service.cloudresourcemanager, google_project_service.projectcontainerregistry, google_project_service.run, google_project_service.compute, module.gke]
}
