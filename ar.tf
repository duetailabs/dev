resource "google_artifact_registry_repository" "shipping-repo" {
  location      = var.gcp_region
  repository_id = "shipping"
  description   = "Shipping repository"
  format        = "DOCKER"
  project       = var.project_id
}