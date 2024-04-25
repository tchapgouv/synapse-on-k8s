resource "ovh_cloud_project_database" "pg_keycloak_database" {
  depends_on   = [openstack_networking_subnet_v2.subnet]
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
      network_id = openstack_networking_network_v2.private_network.id
      subnet_id  = openstack_networking_subnet_v2.subnet.id
    }
  }
    ip_restrictions {
      description = "Ip access restricted to ${var.env_name} app network"
      ip = var.app_vlan_cidr
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
