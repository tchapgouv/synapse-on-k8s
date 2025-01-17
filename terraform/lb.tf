resource "openstack_lb_loadbalancer_v2" "k8s_lb" {
  name                  = "${var.env_name}-load-balancer"
  loadbalancer_provider = "amphora"
  vip_subnet_id         = openstack_networking_subnet_v2.subnet.id
  vip_address           = var.app_vlan_lb_ip
  depends_on = [
    ovh_cloud_project_kube_nodepool.node_pool
  ]
}

resource "openstack_lb_listener_v2" "websecure_listener" {
  name            = "${var.env_name}-websecure-listener"
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_listener_v2" "web_listener" {
  name            = "${var.env_name}-web-listener"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_pool_v2" "k8s_websecure_pool" {
  name        = "${var.env_name}-k8s-websecure-pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.websecure_listener.id
}

resource "openstack_lb_pool_v2" "k8s_web_pool" {
  name        = "${var.env_name}-k8s-web-pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.web_listener.id
}

resource "openstack_lb_monitor_v2" "k8s_web_monitor" {
  name        = "${var.env_name}-monitor-for-k8s-web-pool"
  pool_id     = openstack_lb_pool_v2.k8s_web_pool.id
  type        = "TCP"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_lb_monitor_v2" "k8s_websecure_monitor" {
  name        = "${var.env_name}-monitor-for-k8s-websecure-pool"
  pool_id     = openstack_lb_pool_v2.k8s_websecure_pool.id
  type        = "TCP"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  count       = var.env_name != "production" ? 1 : 0
  pool        = "Ext-Net"
  description = "${var.env_name} floating IP"
}

resource "openstack_networking_floatingip_associate_v2" "lb_fip_association" {
  count       = var.env_name != "production" ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.lb_fip[0].address
  port_id     = openstack_lb_loadbalancer_v2.k8s_lb.vip_port_id
}

resource "openstack_lb_member_v2" "k8s_member_websecure" {
  count         = length(terraform_data.nodes_ips.output)
  name          = "k8s-websecure-member-${count.index}"
  pool_id       = openstack_lb_pool_v2.k8s_websecure_pool.id
  address       = terraform_data.nodes_ips.output[count.index]
  protocol_port = var.ingress_service_port_websecure
  depends_on    = [data.openstack_compute_instance_v2.instance]
}

resource "openstack_lb_member_v2" "k8s_member_web" {
  count         = length(terraform_data.nodes_ips.output)
  name          = "k8s-web-member-${count.index}"
  pool_id       = openstack_lb_pool_v2.k8s_web_pool.id
  address       = terraform_data.nodes_ips.output[count.index]
  protocol_port = var.ingress_service_port_web
  depends_on    = [data.openstack_compute_instance_v2.instance]
}

locals {
  external_lb_ip = var.env_name != "production" ? openstack_networking_floatingip_v2.lb_fip[0].address : openstack_lb_loadbalancer_v2.k8s_lb.vip_address
}
