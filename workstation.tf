# Create the cluster for the workstation.
# Workstation clusters can take about 15 minutes to create.
resource "google_workstations_workstation_cluster" "workstation_cluster" {
  provider               = google-beta
  project                = var.project_id
  workstation_cluster_id = var.workstation_cluster_id
  network                = module.gcp-network.network_id
  subnetwork             = module.gcp-network.subnets_ids[0]
  location               = var.region
}

module "workstations_service_account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  project_id    = var.project_id
  prefix        = var.prefix
  names         = ["workstationsa"]
  project_roles = ["${var.project_id}=>roles/cloudsql.client"]
  display_name  = "Workstation SA"
  description   = "Workstation SA"
}

# Create the config for the workstation.
# Workstation configs can take about 1 minute to create.
resource "google_workstations_workstation_config" "workstation_config" {
  provider               = google-beta
  project                = var.project_id
  workstation_config_id  = var.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id
  location               = var.region
  running_timeout        = "3600s"
  host {
    gce_instance {
      machine_type                = "e2-standard-4" # e2-standard-4 has 4 vCPUs, 2 cores, & 16GB RAM.
      boot_disk_size_gb           = 35
      disable_public_ip_addresses = false
      service_account             = module.workstations_service_account.service_account.email
      service_account_scopes      = ["https://www.googleapis.com/auth/sqlservice.admin"]
    }
  }
  persistent_directories {
    mount_path = "/home"
    gce_pd {
      size_gb        = 200
      fs_type        = "ext4"
      disk_type      = "pd-standard"
      reclaim_policy = "DELETE"
    }
  }
}

# Create the workstation.
resource "google_workstations_workstation" "workstation" {
  provider               = google-beta
  project                = var.project_id
  workstation_id         = var.workstation_id
  workstation_config_id  = google_workstations_workstation_config.workstation_config.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.workstation_cluster.workstation_cluster_id
  location               = var.region
}

resource "google_workstations_workstation_iam_member" "member" {
  provider = google-beta
  project = google_workstations_workstation.workstation.project
  location = google_workstations_workstation.workstation.location
  workstation_cluster_id = google_workstations_workstation.workstation.workstation_cluster_id
  workstation_config_id = google_workstations_workstation.workstation.workstation_config_id
  workstation_id = google_workstations_workstation.workstation.workstation_id
  role = "roles/workstations.user"
  member = "user:${var.user}"
}

resource "google_service_account_iam_binding" "google_workstations_workstation_act_as_iam" {
  service_account_id = "projects/${var.project_id}/serviceAccounts/${module.workstations_service_account.service_account.email}"
  role = "roles/iam.serviceAccountUser"
  members = [
    "user:${var.user}"
  ]
}