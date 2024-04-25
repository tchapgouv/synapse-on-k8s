locals {
  nodes_iterator = {
    essential  = ["1"],
    business   = ["1", "2"],
    entreprise = ["1", "2", "3"]
  }
  nodes_set = lookup(local.nodes_iterator, var.database_plan, ["0"])
}

resource "ovh_cloud_project_database" "pg_database" {
  depends_on   = [openstack_networking_subnet_v2.subnet]
  service_name = var.service_name
  description  = "PostGreSQL Synapse database for ${var.env_name}"
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

resource "ovh_cloud_project_database_postgresql_user" "synapse" {
  service_name = ovh_cloud_project_database.pg_database.service_name
  cluster_id   = ovh_cloud_project_database.pg_database.id
  name         = var.synapse_db_user
  roles = [
    "replication"
  ]
  # Arbitrary string to change to trigger a password update.
  # Use 'terraform refresh' after 'terraform apply' to update the output with the new password.
  password_reset = "password-reset-on-18-01-2022"
}

resource "ovh_cloud_project_database_postgresql_user" "avnadmin" {
  service_name   = ovh_cloud_project_database.pg_database.service_name
  cluster_id     = ovh_cloud_project_database.pg_database.id
  name           = "avnadmin"
  password_reset = "password-reset-on-18-01-2022"
}
