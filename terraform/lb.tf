resource "openstack_lb_loadbalancer_v2" "k8s_lb" {
  name          = "${var.env_name} load balancer"
  vip_subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_lb_listener_v2" "websecure_listener" {
  name            = "${var.env_name} websecure listener"
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_listener_v2" "web_listener" {
  name            = "${var.env_name} web listener"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
}

resource "openstack_lb_pool_v2" "websecure_pool" {
  name        = "${var.env_name} websecure pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.websecure_listener.id
}

resource "openstack_lb_pool_v2" "web_pool" {
  name        = "${var.env_name} web pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.web_listener.id
}

resource "openstack_lb_monitor_v2" "monitor" {
  name        = "${var.env_name} Api Monitor"
  pool_id     = openstack_lb_pool_v2.websecure_pool.id
  type        = "TCP"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  pool        = "Ext-Net"
  description = "${var.env_name} floating IP"

  depends_on = [
    openstack_lb_loadbalancer_v2.k8s_lb
  ]
}

resource "openstack_networking_floatingip_associate_v2" "lb1" {
  floating_ip = openstack_networking_floatingip_v2.lb_fip.address
  port_id     = openstack_lb_loadbalancer_v2.k8s_lb.vip_port_id
}

resource "openstack_lb_member_v2" "lb_member_websecure" {
  count         = length(local.nodes_ips)
  name          = "websecure-member-${count.index}"
  pool_id       = openstack_lb_pool_v2.websecure_pool.id
  address       = local.nodes_ips[count.index]
  protocol_port = var.ingress_service_port_websecure
}

resource "openstack_lb_member_v2" "lb_member_web" {
  count         = length(local.nodes_ips)
  name          = "web-member-${count.index}"
  pool_id       = openstack_lb_pool_v2.web_pool.id
  address       = local.nodes_ips[count.index]
  protocol_port = var.ingress_service_port_web
}
