resource "openstack_lb_loadbalancer_v2" "k8s_lb" {
  name          = "lagraulet-api-loadbalancer"
  vip_subnet_id = openstack_networking_subnet_v2.subnet.id
}

resource "openstack_lb_listener_v2" "api_listener" {
  name            = "api-listener"
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = openstack_lb_loadbalancer_v2.k8s_lb.id
  depends_on      = [openstack_lb_loadbalancer_v2.k8s_lb]
}

resource "openstack_lb_pool_v2" "api_pool" {
  name        = "api-pool"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.api_listener.id
  depends_on  = [openstack_lb_listener_v2.api_listener]
}

resource "openstack_lb_member_v2" "lb_member" {
  count             = var.desired_nodes
  name              = "lb-main-pool"
  pool_id           = openstack_lb_pool_v2.api_pool.id
  # node private ip
  address           = "192.168.40.200"
  # service node port (after ingress controller service creation)
  protocol_port     = "30695"
  depends_on        = [ openstack_lb_pool_v2.api_pool ]
}

resource "openstack_lb_monitor_v2" "monitor" {
  name        = "Api Monitor"
  pool_id     = openstack_lb_pool_v2.api_pool.id
  type        = "TCP"
  delay       = 10
  timeout     = 5
  max_retries = 5
}

resource "openstack_networking_floatingip_v2" "lb_fip" {
  pool = "Ext-Net"

  depends_on = [
    openstack_lb_loadbalancer_v2.k8s_lb
  ]
}

resource "openstack_networking_floatingip_associate_v2" "lb1" {
  floating_ip = openstack_networking_floatingip_v2.lb_fip.address
  port_id     = openstack_lb_loadbalancer_v2.k8s_lb.vip_port_id
  depends_on  = [openstack_lb_loadbalancer_v2.k8s_lb]
}
