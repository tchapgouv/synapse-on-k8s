output "kubeconfig" {
  value     = ovh_cloud_project_kube.k8s_element_cluster.kubeconfig
  sensitive = true
}

output "app_subnet_id" {
  value = openstack_networking_subnet_v2.subnet.id
}

output "floating_network_id" {
  value = data.openstack_networking_network_v2.ext_net.id
}

output "external_lb_ip" {
  description = "the external ip of the load balancer, depending on the environment"
  value       = local.external_lb_ip
}

output "clusterid" {
  value = ovh_cloud_project_kube.k8s_element_cluster.id
}

output "cluster_name" {
  value = ovh_cloud_project_kube.k8s_element_cluster.name
}

output "synapse_db_password" {
  value     = ovh_cloud_project_database_postgresql_user.synapse.password
  sensitive = true
}

output "avnadmin_db_password" {
  value     = ovh_cloud_project_database_postgresql_user.avnadmin.password
  sensitive = true
}

output "synapse_db_host" {
  value     = ovh_cloud_project_database.pg_database.endpoints[0].domain
  sensitive = true
}

output "synapse_db_port" {
  value     = ovh_cloud_project_database.pg_database.endpoints[0].port
  sensitive = true
}

output "avnadmin_keycloak_db_password" {
  description = "keycloak database admin password"
  value       = ovh_cloud_project_database_postgresql_user.avnadmin_keycloak.password
  sensitive   = true
}

output "keycloak_db_password" {
  description = "keycloak database user password"
  value       = ovh_cloud_project_database_postgresql_user.keycloak.password
  sensitive   = true
}

output "keycloak_db_host" {
  description = "the keycloak database url given by ovh"
  value       = ovh_cloud_project_database.pg_keycloak_database.endpoints[0].domain
  sensitive   = true
}

output "keycloak_db_port" {
  description = "the port of the keycloak database"
  value       = ovh_cloud_project_database.pg_keycloak_database.endpoints[0].port
  sensitive   = true
}

output "synapse_databse_uri" {
  value = join("", [
    "postgres://", ovh_cloud_project_database_postgresql_user.synapse.name, ":",
    ovh_cloud_project_database_postgresql_user.synapse.password, "@",
    ovh_cloud_project_database.pg_database.endpoints[0].domain, ":",
    ovh_cloud_project_database.pg_database.endpoints[0].port, "/defaultdb?sslmode=require"
  ])
  sensitive = true
}

output "s3_media_repo_access_key" {
  description = "the access key that have been created by the terraform script"
  value       = ovh_cloud_project_user_s3_credential.s3_admin_cred.access_key_id
}

output "s3_media_repo_secret_key" {
  description = "the secret key that have been created by the terraform script"
  value       = ovh_cloud_project_user_s3_credential.s3_admin_cred.secret_access_key
  sensitive   = true
}

output "s3_media_repo_bucket_name" {
  description = "bucket name of the s3 media repo"
  value       = aws_s3_bucket.media_repo_bucket.bucket
}

output "s3_media_repo_url" {
  description = "the url of the s3 media repo"
  value       = "https://${aws_s3_bucket.media_repo_bucket.bucket}.${var.s3_media_repo_endpoint}/"
}
