resource "google_sourcerepo_repository" "shipping-repo" {
  name = "shipping"
  project = var.project_id
}