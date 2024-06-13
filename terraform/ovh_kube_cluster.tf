resource "ovh_cloud_project_kube" "k8s_element_cluster" {
  depends_on         = [ovh_cloud_project_network_private_subnet.app_subnet]
  service_name       = var.service_name
  name               = "synapse_${var.env_name}_cluster"
  region             = var.os_region_name
  version            = var.cluster_version
  private_network_id = ovh_cloud_project_network_private.app_network.id

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

/** Get information data on created nodes **/
data "ovh_cloud_project_kube_nodepool_nodes" "nodes" {
  service_name = var.service_name
  kube_id      = ovh_cloud_project_kube.k8s_element_cluster.id
  name         = ovh_cloud_project_kube_nodepool.node_pool.name
}

data "openstack_compute_instance_v2" "instance" {
  //FIXME may not work properly when Kubernetes increase or decrease the number of nodes
  count = var.desired_nodes
  id    = data.ovh_cloud_project_kube_nodepool_nodes.nodes.nodes[count.index].instance_id
}

locals {
  // List of each node IP on the app network
  nodes_ips = flatten([
    for instances in data.openstack_compute_instance_v2.instance : [
      for n in instances.network : n.fixed_ip_v4 if n.name != "Ext-Net"
    ]
  ])
}
