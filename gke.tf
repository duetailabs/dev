locals {
  cluster_type           = "gke1"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  version = "~> 29.0"

  project_id                      = var.project_id
  name                            = "${local.cluster_type}"
  regional                        = true
  region                          = var.gcp_region
  network                         = module.gcp-network.network_name
  subnetwork                      = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                   = local.pods_range_name
  ip_range_services               = local.svc_range_name
  release_channel                 = "REGULAR"
  enable_vertical_pod_autoscaling = true
  network_tags                    = [local.cluster_type]
  deletion_protection             = false
}

resource "google_project_iam_member" "gke_sa_artifact_registry_reader" {
  project     = var.project_id
  role = "roles/artifactregistry.reader"
  member = "serviceAccount:${module.gke.service_account}"
}