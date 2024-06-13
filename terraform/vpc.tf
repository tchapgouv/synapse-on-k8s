data "openstack_networking_network_v2" "ext_net" {
  name   = "Ext-Net"
  region = var.os_region_name
}

###### APP network ######
resource "ovh_cloud_project_network_private" "app_network" {
  service_name = var.service_name
  name         = var.app_vlan_name
  regions      = [var.os_region_name]
  vlan_id      = var.app_vlan_id
}

resource "ovh_cloud_project_network_private_subnet" "app_subnet" {
  service_name = var.service_name
  network_id   = ovh_cloud_project_network_private.app_network.id
  region       = var.os_region_name
  start        = var.app_vlan_ip_start
  end          = var.app_vlan_ip_end
  network      = var.app_vlan_cidr
  dhcp         = true
  no_gateway   = var.env_name != "production" ? false : true
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
  subnet_id = ovh_cloud_project_network_private_subnet.app_subnet.id
}

###### ADMIN network ######
resource "ovh_cloud_project_network_private" "admin_network" {
  service_name = var.service_name
  name         = var.admin_vlan_name
  regions      = [var.os_region_name]
  vlan_id      = var.admin_vlan_id
}

resource "ovh_cloud_project_network_private_subnet" "admin_subnet" {
  service_name = var.service_name
  network_id   = ovh_cloud_project_network_private.admin_network.id
  region       = var.os_region_name
  start        = var.admin_vlan_ip_start
  end          = var.admin_vlan_ip_end
  network      = var.admin_vlan_cidr
  dhcp         = true
  no_gateway   = var.env_name != "production" ? false : true
}

resource "openstack_networking_router_v2" "admin_router" {
  count               = var.env_name != "production" ? 1 : 0
  region              = var.os_region_name
  name                = "${var.env_name}-admin-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "admin_router_interface" {
  count     = var.env_name != "production" ? 1 : 0
  router_id = openstack_networking_router_v2.admin_router[0].id
  region    = var.os_region_name
  subnet_id = ovh_cloud_project_network_private_subnet.admin_subnet.id
}
