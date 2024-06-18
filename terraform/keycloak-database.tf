resource "ovh_cloud_project_database" "pg_keycloak_database" {
  depends_on   = [ovh_cloud_project_network_private_subnet.app_subnet]
  service_name = var.service_name
  description  = "PostGreSQL keycloak database for ${var.env_name}"
  engine       = "postgresql"
  version      = var.database_version
  plan         = var.database_plan
  flavor       = var.database_flavor
  disk_size    = var.database_disk

  dynamic "nodes" {
    for_each = toset(local.nodes_set)
    content {
      region     = var.global_region
      network_id = one(ovh_cloud_project_network_private.app_network.regions_attributes[*].openstackid)
      subnet_id  = ovh_cloud_project_network_private_subnet.app_subnet.id
    }
  }
  ip_restrictions {
    description = "Ip access restricted to ${var.env_name} app network"
    ip          = var.app_vlan_cidr
  }
}

resource "ovh_cloud_project_database_postgresql_user" "keycloak" {
  service_name = ovh_cloud_project_database.pg_keycloak_database.service_name
  cluster_id   = ovh_cloud_project_database.pg_keycloak_database.id
  name         = "keycloak"
}

resource "ovh_cloud_project_database_postgresql_user" "avnadmin_keycloak" {
  service_name = ovh_cloud_project_database.pg_keycloak_database.service_name
  cluster_id   = ovh_cloud_project_database.pg_keycloak_database.id
  name         = "avnadmin"
}
