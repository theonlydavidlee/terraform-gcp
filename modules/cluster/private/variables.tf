variable "project_id" {
  description = "GCP Project ID"
  type = string
}

variable "cluster_name" {
  type = string
}

variable "min_master_version" {
  type = string
}

variable "region" {
  type = string
}

variable "network" {
  description = "Network name"
  type = string
}

variable "subnetwork" {
  description = "subnetwork name"
  type = string
}

variable "node_locations" {
  description = "GKE Cluster node zones"
  type = list(string)
}

variable "enable_private_nodes" {
  type = bool
  default = false
}

variable "enable_private_endpoint" {
  type = bool
  default = false
}

variable "master_authorized_networks" {
  type = list(map(string))
  description = "Whitelist of all CIDR blockes allowed to access the cluster master"
  default = []
}

variable "master_ipv4_cidr_block" {
  type = string
  description = "Internal CIDR block required to setup vpc peering on private clusters"
  default = null
}

variable "pods_secondary_range" {
  type = string
}

variable "services_secondary_range" {
  type = string
}

variable "default_max_pods_per_node" {
  type = number
  default = 110
}

variable "http_load_balancing" {
  type = bool
  default = true
}

variable "horizontal_pod_autoscaling" {
  type = bool
  default = true
}

variable "dns_cache" {
  type = bool
  default = true
}

variable "network_policy" {
  type = bool
  default = false
}
