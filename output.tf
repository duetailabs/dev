output "instance_name" {
  value       = module.postgresql-db.instance_name
  description = "The instance name for the master instance"
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = module.postgresql-db.public_ip_address
}

output "psql_connection_name" {
  value       = module.postgresql-db.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}


output "psql_user_password" {
  description = "The auto generated default user password if not input password was provided"
  value       = module.postgresql-db.generated_user_password
  sensitive   = true
}

output "psql_additional_users" {
  description = "List of maps of additional users and passwords"
  value = [for r in module.postgresql-db.additional_users :
    {
      name     = r.name
      password = r.password
    }
  ]
  sensitive = true
}

output "gke_service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.gke.service_account
}