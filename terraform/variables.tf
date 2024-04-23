variable "env_name" {
  type        = string
  description = "Name of the environment being used"
}

variable "service_name" {
  type        = string
  description = "the ID of the project on the OVH project web page"
}

variable "os_region_name" {
  type        = string
  description = "OVH region for the cluster (from https://www.ovhcloud.com/en/public-cloud/regions-availability/): GRA1, GRA7 ..."
}

variable "app_vlan_name" {
  description = "Name of the private network dedicated to applications, aka Neutron resource within OVH OpenStack"
  type        = string
}

variable "app_vlan_gateway" {
  description = "Default gateway ip used by devices in the applications subnet"
  type        = string
}

variable "app_vlan_dns" {
  description = "Array of DNS name server names used by hosts in the applications subnet"
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "app_vlan_cidr" {
  description = "Range of IP for the private application network"
  type        = string
}

variable "admin_vlan_name" {
  description = "Name of the private network dedicated to administrators, aka Neutron resource within OVH OpenStack"
  type        = string
}

variable "admin_vlan_gateway" {
  description = "Default gateway ip used by devices in the administrators subnet"
  type        = string
}

variable "admin_vlan_dns" {
  description = "Array of DNS name server names used by hosts in the administrators subnet"
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "admin_vlan_cidr" {
  description = "Range of IP for the private administrators private network"
  type        = string
}

variable "cluster_version" {
  type        = string
  description = "kubernetes version of the cluster"
}

variable "nodepool_flavor" {
  type        = string
  description = "flavor set to each node : b2-7, b2-15, R2-30, ..."
}

variable "desired_nodes" {
  type        = number
  description = "desired number of nodes"
}

variable "max_nodes" {
  type        = number
  description = "maximum number of nodes"
}

variable "min_nodes" {
  type        = number
  description = "minimum number of nodes"
}

variable "global_region" {
  description = "OVH global location for PostGreSQL and VPC"
  type        = string
}

variable "database_version" {
  description = "Version of postgresql"
  type        = string
}

variable "database_plan" {
  description = "OVH plan for database : essential = 1 nodes, business = 2 nodes, enterprise = 3 nodes"
  type        = string
}

variable "database_flavor" {
  description = "OVH flavor of the VM on which the database is installed : db1-4, db1-7, db1-15, db1-30, ..."
  type        = string
}

variable "database_disk" {
  description = "Size of the disk for the database VM"
  type        = string
}

variable "synapse_db_user" {
  description = "username for synapse database"
  type        = string
}

variable "s3_media_repo_endpoint" {
  description = "S3 endpoint for media repo"
  type        = string
}

variable "ingress_service_port_web" {
  description = "Port of the ingress service 80 Entrypoint of the cluster for the octavia LB"
  type        = string
}
variable "ingress_service_port_websecure" {
  description = "Port of the ingress service 443 Entrypoint of the cluster for the octavia LB"
  type        = string
}

variable "nodes_ips" {
  description = "List of the nodes IPs"
  type        = list(string)
  default     = []
}
