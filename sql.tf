module "postgresql-db" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 18.0"

  name                 = var.db_name
  random_instance_name = true
  additional_databases = [{name: "package_details", charset: "UTF8", collation: "en_US.UTF8"}]
  additional_users     = [{name: "evolution", password: "evolution", random_password: false}]
  database_version     = "POSTGRES_15"
  project_id           = var.project_id
  zone                 = "us-central1-c"
  region               = "us-central1"
  edition              = "ENTERPRISE_PLUS"
  tier                 = "db-perf-optimized-N-2"
  data_cache_enabled   = true

  deletion_protection = false
}

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  project_id    = var.project_id
  prefix        = var.prefix
  names         = ["cloudsqlsa"]
  project_roles = ["${var.project_id}=>roles/cloudsql.client"]
  display_name  = "CloudSQL SA"
  description   = "CloudSQL SA"
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${module.service_accounts.service_account.email}"
  role = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/default]"
  ]
}