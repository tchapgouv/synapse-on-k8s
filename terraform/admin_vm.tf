locals {
  create_fip = var.env_name != "production" ? true : false
}

resource "openstack_compute_keypair_v2" "vm_admin_keypair" {
  name = "${var.env_name}_vm_admin_keypair"
}

resource "openstack_networking_floatingip_v2" "vm_admin_fip" {
  count       = local.create_fip ? 1 : 0
  pool        = "Ext-Net"
  description = "${var.env_name} Admin VM floating IP"
}

resource "openstack_compute_floatingip_associate_v2" "vm_admin_ip_association" {
  count       = local.create_fip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.vm_admin_fip[0].address
  instance_id = openstack_compute_instance_v2.vm_admin[0].id
  fixed_ip    = openstack_compute_instance_v2.vm_admin[0].network[0].fixed_ip_v4
}

locals {
  external_vm_admin_ip = local.create_fip ? openstack_networking_floatingip_v2.vm_admin_fip[0].address : ""
  internal_vm_admin_ip = var.env_name != "production" ? openstack_compute_instance_v2.vm_admin[0].access_ip_v4 : ""
}

resource "openstack_compute_instance_v2" "vm_admin" {
  count           = var.env_name != "production" ? 1 : 0
  name            = "${var.env_name}_vm_admin"
  image_name      = "Debian 12"
  flavor_id       = "906e8259-0340-4856-95b5-4ea2d26fe377"
  key_pair        = openstack_compute_keypair_v2.vm_admin_keypair.name
  security_groups = ["default"]

  metadata = {
    this = "that"
  }

  network {
    name = openstack_networking_network_v2.admin_network.name
  }
}