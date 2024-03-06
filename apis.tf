module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.4"

  project_id                  = var.project_id

  activate_apis = [
    "workstations.googleapis.com",
  ]
}