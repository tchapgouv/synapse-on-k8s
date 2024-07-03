data "openstack_networking_network_v2" "ext_net" {
  name   = "Ext-Net"
  region = var.os_region_name
}

###### APP network ######
resource "openstack_networking_network_v2" "private_network" {
  name           = var.app_vlan_name
  region         = var.os_region_name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  network_id      = openstack_networking_network_v2.private_network.id
  region          = var.os_region_name
  name            = "${var.app_vlan_name} subnet"
  cidr            = var.app_vlan_cidr
  enable_dhcp     = true
  gateway_ip      = var.app_vlan_gateway
  dns_nameservers = var.app_vlan_dns
}

resource "openstack_networking_router_v2" "router" {
  count               = var.env_name != "production" ? 1 : 0
  region              = var.os_region_name
  name                = "${var.env_name}-app-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  count     = var.env_name != "production" ? 1 : 0
  router_id = openstack_networking_router_v2.router[0].id
  region    = var.os_region_name
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

###### ADMIN network ######
resource "openstack_networking_network_v2" "admin_network" {
  name           = var.admin_vlan_name
  region         = var.os_region_name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "admin_subnet" {
  network_id      = openstack_networking_network_v2.admin_network.id
  region          = var.os_region_name
  name            = "${var.admin_vlan_name} subnet"
  cidr            = var.admin_vlan_cidr
  enable_dhcp     = true
  gateway_ip      = var.admin_vlan_gateway
  dns_nameservers = var.admin_vlan_dns
}

resource "openstack_networking_router_interface_v2" "admin_router_interface" {
  router_id = openstack_networking_router_v2.router[0].id
  region    = var.os_region_name
  subnet_id = openstack_networking_subnet_v2.admin_subnet.id
}
