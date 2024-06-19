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
  protocol        = "HTTPS"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_listener_v2" "web_listener" {
  name            = "${var.env_name}-web-listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_pool_v2" "websecure_pool" {
  name        = "${var.env_name}-k8s-websecure-pool"
  protocol    = "HTTPS"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.websecure_listener.id
}

resource "openstack_lb_pool_v2" "web_pool" {
  name        = "${var.env_name}-k8s-web-pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.web_listener.id
}

resource "openstack_lb_monitor_v2" "web_monitor" {
  name        = "${var.env_name}-monitor-for-k8s-web-pool"
  pool_id     = openstack_lb_pool_v2.web_pool.id
  type        = "HTTP"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_lb_monitor_v2" "websecure_monitor" {
  name        = "${var.env_name}-monitor-for-k8s-websecure-pool"
  pool_id     = openstack_lb_pool_v2.websecure_pool.id
  type        = "HTTPS"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  count       = var.env_name != "production" ? 1 : 0
  pool        = "Ext-Net"
  description = "${var.env_name} floating IP"
}

resource "openstack_networking_floatingip_associate_v2" "lb1" {
  count       = var.env_name != "production" ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.lb_fip[0].address
  port_id     = openstack_lb_loadbalancer_v2.k8s_lb.vip_port_id
}

resource "openstack_lb_member_v2" "lb_member_websecure" {
  count = length(local.nodes_ips)
  name          = "k8s-websecure-member-${count.index}"
  pool_id       = openstack_lb_pool_v2.websecure_pool.id
  address       = local.nodes_ips[count.index]
  protocol_port = var.ingress_service_port_websecure
  depends_on = [data.openstack_compute_instance_v2.instance]
}

resource "openstack_lb_member_v2" "lb_member_web" {
  count = length(local.nodes_ips)
  name          = "k8s-web-member-${count.index}"
  pool_id       = openstack_lb_pool_v2.web_pool.id
  address       = local.nodes_ips[count.index]
  protocol_port = var.ingress_service_port_web
  depends_on = [data.openstack_compute_instance_v2.instance]
}

### Specific to the admin VM hosting zabbix ###

resource "openstack_lb_pool_v2" "admin_websecure_pool" {
  count       = var.env_name != "production" ? 1 : 0
  name        = "${var.env_name}-admin-websecure-pool"
  protocol    = "HTTPS"
  lb_method   = "ROUND_ROBIN"
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_pool_v2" "admin_web_pool" {
  count       = var.env_name != "production" ? 1 : 0
  name        = "${var.env_name}-admin-web-pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_monitor_v2" "admin_websecure_pool_monitor" {
  name        = "${var.env_name}-monitor-for-admin-websecure-pool"
  pool_id     = openstack_lb_pool_v2.admin_websecure_pool[0].id
  type        = "HTTPS"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_lb_monitor_v2" "admin_web_pool_monitor" {
  name        = "${var.env_name}-monitor-for-admin-web-pool"
  pool_id     = openstack_lb_pool_v2.admin_web_pool[0].id
  type        = "HTTP"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_lb_member_v2" "lb_admin_member_websecure" {
  count         = var.env_name != "production" ? 1 : 0
  name          = "admin-websecure-member"
  pool_id       = openstack_lb_pool_v2.admin_websecure_pool[0].id
  address       = local.internal_vm_admin_ip
  protocol_port = 80
}

resource "openstack_lb_member_v2" "lb_admin_member_web" {
  count         = var.env_name != "production" ? 1 : 0
  name          = "admin-web-member"
  pool_id       = openstack_lb_pool_v2.admin_web_pool[0].id
  address       = local.internal_vm_admin_ip
  protocol_port = 80
}

resource "openstack_lb_l7policy_v2" "l7policy_admin" {
  count            = var.env_name != "production" ? 1 : 0
  name             = "${var.env_name} l7policy for admin VM"
  action           = "REDIRECT_TO_POOL"
  description      = "redirect-to-admin-pool-policy"
  position         = 1
  listener_id      = openstack_lb_listener_v2.web_listener.id
  redirect_pool_id = openstack_lb_pool_v2.admin_web_pool[0].id
}

resource "openstack_lb_l7rule_v2" "l7rule_admin" {
  count        = var.env_name != "production" ? 1 : 0
  l7policy_id  = openstack_lb_l7policy_v2.l7policy_admin[0].id
  type         = "HOST_NAME"
  compare_type = "STARTS_WITH"
  value        = "zabbix"
}

locals {
  external_lb_ip = var.env_name != "production" ? openstack_networking_floatingip_v2.lb_fip[0].address :    openstack_lb_loadbalancer_v2.k8s_lb.vip_address
}
