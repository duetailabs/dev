variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "user" {
  description = "The user's email in the form abc@example.com"
}

variable "region" {
  description = "The region the cluster in"
  default     = "us-central1"
}

# For Cloud SQL
variable "authorized_networks" {
  default = [{
    name  = "sample-gcp-health-checkers-range"
    value = "130.211.0.0/28"
  }]
  type        = list(map(string))
  description = "List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs"
}

variable "db_name" {
  description = "The name of the SQL Database instance"
  default     = "postgres"
}

# For SQL SA
variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = ""
}

# For Cloud Workstations
variable "workstation_cluster_id" {
  type        = string
  default     = "gemini-workstation-cluster"
}

variable "workstation_config_id" {
  type        = string
  default     = "gemini-workstation-config"
}

variable "workstation_id" {
  type        = string
  default     = "gemini-workstation"
}