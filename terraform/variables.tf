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

variable "vlan_cidr" {
  description = "Range of IP for the private network"
  type        = string
}

variable "s3_media_repo_endpoint" {
  description = "S3 endpoint for media repo"
  type        = string
}

variable "ingress_service_port" {
  description = "Port of the ingress service. Entrypoint of the cluster for the octavia LB"
  type        = string
}
