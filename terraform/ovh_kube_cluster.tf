resource "ovh_cloud_project_kube" "k8s_element_cluster" {
  depends_on         = [openstack_networking_subnet_v2.subnet]
  service_name       = var.service_name
  name               = "synapse_${var.env_name}_cluster"
  region             = var.os_region_name
  version            = var.cluster_version
  private_network_id = openstack_networking_network_v2.private_network.id

  private_network_configuration {
    default_vrack_gateway              = ""
    private_network_routing_as_default = true
  }
  timeouts {
    update = "45m"
  }
}

resource "ovh_cloud_project_kube_nodepool" "node_pool" {
  service_name  = var.service_name
  kube_id       = ovh_cloud_project_kube.k8s_element_cluster.id
  name          = "synapse-${var.env_name}-nodes"
  flavor_name   = var.nodepool_flavor
  desired_nodes = var.desired_nodes
  max_nodes     = var.max_nodes
  min_nodes     = var.min_nodes
}
